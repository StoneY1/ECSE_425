library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
  port (
    clock : in std_logic;
    reset : in std_logic;
    PC_in : in std_logic_vector(31 downto 0);
    PC_out : out std_logic_vector(31 downto 0);
    enable : in std_logic
  ) ;
end PC;



architecture behavior of PC is

begin

	process (clock,reset)
	begin
	
		if (reset = '1' or (now < 1 ps)) then
			PC_out <= (others => '0');
		elsif (rising_edge(clock) and clock = '1') then 	
			PC_out <= PC_in;
		end if;
	
	
	end process;

end behavior;