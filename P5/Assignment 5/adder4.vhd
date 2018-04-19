-- Adder
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder4 is
	Port ( 
		add_in : in std_logic_vector(31 downto 0);
		add_out : out std_logic_vector(31 downto 0)
	);
end adder4;

architecture behaviour of adder4 is

begin
	add_out <= std_logic_vector(to_unsigned(to_integer(unsigned(add_in)) + 4, add_out'length));
	--add_out <= std_logic_vector(unsigned(add_in) + 4);

end behaviour;