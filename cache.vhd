library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
generic(
	ram_size : INTEGER := 32768
);
port(
	clock : in std_logic;
	reset : in std_logic;
	
	-- Avalon interface --
	s_addr : in std_logic_vector (31 downto 0);
	s_read : in std_logic;
	s_readdata : out std_logic_vector (31 downto 0);
	s_write : in std_logic;
	s_writedata : in std_logic_vector (31 downto 0);
	s_waitrequest : out std_logic; 
    
	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (7 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (7 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is

TYPE STATE_TYPE IS (startState, readState, saveMemReadState, loadMemReadState, readFromCache, writeState, saveMemWriteState, loadMemWriteState, writeToCache);
SIGNAL state   : STATE_TYPE;
TYPE Cache IS ARRAY(31 downto 0) OF STD_LOGIC_VECTOR(144 DOWNTO 0); -- 1 valid bit + 1 dirtyBit + 15 tag bits + 4 blocks of 32 bits each = 144 bits per row in cache
SIGNAL cache_block: Cache;
SIGNAL valid: STD_LOGIC;
SIGNAL dirtyBit: STD_LOGIC;
SIGNAL tagMatch: integer;
SIGNAL row: integer range 0 to 31;
SIGNAL cacheTag: STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL addrTag: STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL offset: integer range 0 to 3;
SIGNAL MEMsaveIteration: integer range 0 to 17;
SIGNAL MEMloadIteration: integer range 0 to 17;



begin

PROCESS (clock, reset)
BEGIN
	IF reset = '1' THEN
    		state <= startState;
   	 ELSIF (clock'EVENT AND clock = '1') THEN
        
	CASE state IS
		WHEN startState=>
			s_waitrequest <= '1';
           	s_readdata <= std_logic_vector(to_unsigned(0,s_readdata'length));
            MEMsaveIteration <= 0;
          	MEMloadIteration <= 0;

			IF s_read = '1' THEN
				state <= readState;
			ELSIF s_write = '1' THEN
				state <= writeState;
			ELSE
				state <= startState;
			END IF;

		WHEN readState=>
            s_waitrequest <= '1';
            s_readdata <= std_logic_vector(to_unsigned(0,s_readdata'length));

            --checking validity, get index from s_adr[] and check V bit (mod32 needed?)
            row <= to_integer(unsigned(s_addr(6 DOWNTO 2)));
           	offset <= to_integer(unsigned(s_addr(1 DOWNTO 0)));
           	valid <= cache_block(row)(144);
           	dirtyBit <= cache_block(row)(143);
          	cacheTag <= cache_block(row)(142 DOWNTO 128);
           	addrTag <= s_addr(21 DOWNTO 7);
            --See if tags match...
           	IF addrTag = cacheTag THEN
            	tagMatch <= 1;
           	ELSE
            	tagMatch <= 0;
           	END IF;

			IF valid = '0' THEN
				state <= loadMemReadState;
			ELSIF tagMatch = 1 THEN
				state <= readFromCache;
			ELSIF dirtyBit = '1' THEN
				state <= saveMemReadState;
			ELSE 
				state <= readFromCache;
			END IF;

		WHEN writeState=>
            		s_waitrequest <= '1';
           		 s_readdata <= std_logic_vector(to_unsigned(0,s_readdata'length));

           		 --checking validity, get index from s_adr[] and check V bit
           		 row <= to_integer(unsigned(s_addr(6 DOWNTO 2)));
           		 valid <= cache_block(row)(144);
           		 dirtyBit <= cache_block(row)(143);
           		 cacheTag <= cache_block(row)(142 DOWNTO 128);
           		 addrTag <= s_addr(21 DOWNTO 7);

           		 --See if tags match...
          		  IF addrTag = cacheTag THEN
          		  	tagMatch <= 1;
           		 ELSE
           		 	tagMatch <= 0;
         		   END IF;

			IF valid = '0' THEN
				state <= loadMemWriteState;
			ELSIF tagMatch = 1 THEN
				state <= writeToCache;
			ELSIF dirtyBit = '1' THEN
				state <= saveMemWriteState;
			ELSE
				state <= loadMemWriteState;
			END IF;

		WHEN saveMemReadState=>
			m_write <= '1';
			m_read <= '0';
			-- We need to write 128 bits to mem, only a byte can be saved at a time, need to do 16 save operations per load and save to MM
			m_addr <= to_integer(unsigned(cacheTag)) + MEMsaveIteration;
			m_writedata <= cache_block(row)((MEMsaveIteration*8+7) DOWNTO (MEMsaveIteration*8));

			IF m_waitrequest = '0' THEN
				MEMsaveIteration <= MEMsaveIteration + 1;
			END IF;

			IF MEMsaveIteration = 16 THEN -- checking for MM done signal (low clock cycle)
				state <= loadMemReadState;
			ELSE 
				state <= saveMemReadState;
			END IF;

		WHEN loadMemReadState=>
			m_write <= '0';
			m_read <= '1';

			m_addr <= to_integer(unsigned(addrTag)) + MEMloadIteration;
			cache_block(row)((MEMloadIteration*8+7) DOWNTO (MEMloadIteration*8)) <= m_readdata;

			IF m_waitrequest = '0' THEN
				MEMloadIteration <= MEMloadIteration + 1;
			END IF;


			IF MEMloadIteration = 16 THEN -- checking for MM done signal (low clock cycle)
				cache_block(row)(143) <= '0'; --set dirtyBit to clean
				cache_block(row)(144) <= '1'; --set valid
				state <= readFromCache;
			ELSE
				state <= loadMemReadState;
			END IF;

		WHEN readFromCache=>
			s_waitrequest <= '0';
			s_readdata <= cache_block(row)((offset*32+31) DOWNTO (offset*32));

			IF s_read = '0' THEN
				state <= startState;
			ELSE
				state <= readFromCache;
			END IF;

		WHEN saveMemWriteState=>
			m_write <= '1';
			m_read <= '0';
			-- We need to write 128 bits to mem, only a byte can be saved at a time, need to do 16 save operations per load and save to MM
			m_addr <= to_integer(unsigned(cacheTag)) + MEMsaveIteration;
			m_writedata <= cache_block(row)((MEMsaveIteration*8+7) DOWNTO (MEMsaveIteration*8));

			IF m_waitrequest = '0' THEN
				MEMsaveIteration <= MEMsaveIteration + 1;
			END IF;

			IF MEMsaveIteration = 16 THEN -- checking for MM done signal (low clock cycle)
				state <= loadMemWriteState;
			ELSE 
				state <= saveMemWriteState;
			END IF;

		WHEN loadMemWriteState=>
			m_write <= '0';
			m_read <= '1';

			m_addr <= to_integer(unsigned(addrTag)) + MEMloadIteration;
			cache_block(row)((MEMloadIteration*8+7) DOWNTO (MEMloadIteration*8)) <= m_readdata;

			IF m_waitrequest = '0' THEN
				MEMloadIteration <= MEMloadIteration + 1;
			END IF;


			IF MEMloadIteration = 16 THEN
				cache_block(row)(143) <= '0'; --set dirtyBit to clean
				cache_block(row)(144) <= '1'; --set valid
				state <= writeToCache;
			ELSE
				state <= loadMemWriteState;
			END IF;

		WHEN writeToCache=>
			s_waitrequest <= '0';
			cache_block(row)((offset*32+31) DOWNTO (offset*32)) <= s_writedata;
			cache_block(row)(143) <= '1'; --set dirtyBit

			IF s_write = '0' THEN
				state <= startState;
			ELSE
				state <= writeToCache;
			END IF;
           
		END CASE;

		END IF;

END PROCESS;


end arch;