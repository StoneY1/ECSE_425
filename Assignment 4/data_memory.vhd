--Adapted from Example 12-15 of Quartus Design and Synthesis handbook. Modified for 32-bit processing, changed delay to single clock cycle, intialized to zeroes
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY data_memory IS
	GENERIC(
		ram_size : INTEGER := 32768/4; --modified size of ram so that each entry of array is a 32-bit word while preserving size at 32768 bytes
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Processor will read and write 32-bits at a time.
		address: IN INTEGER;
		memwrite: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END data_memory;

ARCHITECTURE rtl OF data_memory IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';
BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			For i in 0 to ram_size-1 LOOP
				ram_block(i) <= std_logic_vector(to_unsigned(0,32));
			END LOOP;
		end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (address < 0 or address > ram_size-1) THEN
				read_address_reg <= 0;
			ELSE
				IF (memwrite = '1') THEN
					ram_block(address) <= writedata;
				END IF;
				read_address_reg <= address;
			END IF;
		END IF;
	END PROCESS;
	readdata <= ram_block(read_address_reg);


END rtl;
