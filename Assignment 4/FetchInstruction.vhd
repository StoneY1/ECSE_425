--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;
USE ieee.std_logic_textio.all;

ENTITY fetchInstr IS
	GENERIC(
		ram_size : integer := 1024
	);
	PORT (
		clock: in std_logic;
		address: in integer range 0 to ram_size-1;
		readdata: out std_logic_vector (31 downto 0)
	);
END fetchInstr;

ARCHITECTURE rtl OF fetchInstr IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to ram_size-1;
BEGIN
	--main section of the SRAM model
	mem_process: PROCESS (clock)
	
	file f : text;
	variable row : line;
	variable rowData : std_logic_vector(31 downto 0);
	variable rowCnt : integer := 0;
	
	BEGIN
		IF(now < 1 ps)THEN
			file_open(f, "program.txt", read_mode);
			while (not endfile(f)) loop
				readline(f, row);
				read(row, rowData);
				ram_block(rowCnt) <= rowData;
				rowCnt := rowCnt + 1;
			end loop;
		end if;
		file_close(f);

		IF (clock'event AND clock = '1') THEN
			read_address_reg <= address;
		END IF;
	END PROCESS;
	readdata <= ram_block(read_address_reg);

END rtl;
