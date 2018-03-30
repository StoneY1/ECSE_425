--Implement 32 registers. Each register holding 32-bit vectors
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.definitions.all;

ENTITY register_file IS
	GENERIC (
		register_size : integer := 32
	);
	PORT (
		clock: IN STD_LOGIC;
		r1, r2, write_address: IN STD_LOGIC_VECTOR (4 DOWNTO 0); --register addresses taken from instruction decoder and write info from WB stage
		write_data : IN word_type;
		write_enable: IN STD_LOGIC;

		r1_out, r2_out: OUT word_type --contents retrieved from register for execution stage
	);
END register_file;

ARCHITECTURE behaviour of register_file IS
TYPE REG IS ARRAY(31 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0); --There are 32 registers, each holding 32-bit words. Therefore we have a 32x32 array
SIGNAL registers : REG;
SIGNAL r1_addr : INTEGER := 0;
SIGNAL r2_addr : INTEGER := 0;
SIGNAL w_addr: INTEGER := 0;
BEGIN
process(clock) begin
	if(now < 1 ps)then
		For i in 0 to register_size-1 loop
			registers(i) <= std_logic_vector(to_unsigned(0,32));
		end loop;
	end if;
	if (rising_edge(clock)) then
		r1_addr <= to_integer(unsigned(r1));
		r2_addr <= to_integer(unsigned(r2));
		w_addr <= to_integer(unsigned(write_address));
		if (write_enable = '1') then --TODO need to add protection for R0
			registers(w_addr) <= write_data;
		end if;
		r1_out <= registers(r1_addr);
		r2_out <= registers(r2_addr);
	end if;
end process;
end behaviour;