--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY fetchInstr IS
	GENERIC(
		ram_size : integer := 1024;
		mem_delay : time := 0 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: in std_logic;
		writedata: in std_logic_vector (31 downto 0);
		address: in integer range 0 to ram_size-1;
		memwrite: in std_logic;
		memread: in std_logic;
		readdata: out std_logic_vector (31 downto 0);
		waitrequest: out std_logic
	);
END fetchInstr;

ARCHITECTURE rtl OF fetchInstr IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
BEGIN
	--main section of the SRAM model
	mem_process: PROCESS (clock)
	
	file f : text;
	variable row : line;
	variable rowData : std_logic_vector(31 downto 0);
	variable rowCnt : integer := 0;
	
	BEGIN
		IF(now < 1 ps)THEN
			file_open(f, "programTest.txt", read_mode);
			while (not endfile(f)) loop
				readline(f, row);
				read(row, rowData);
				ram_block(rowCnt) <= rowData;
				rowCnt := rowCnt + 1;
			end loop;
		end if;
		file_close(f);

		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata;
			END IF;
		read_address_reg <= address;
		END IF;
	END PROCESS;
	readdata <= ram_block(read_address_reg);


	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;


END rtl;