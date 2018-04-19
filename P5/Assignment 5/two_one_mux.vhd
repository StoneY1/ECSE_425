library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_one_mux is
	port (
      		sel : in std_logic;
      		in1, in2 : in std_logic_vector(31 downto 0);
      		outputMux : out std_logic_vector(31 downto 0)
  	);
end two_one_mux;

architecture behavioural of two_one_mux is
	begin
	outputMux <= in1 when sel = '0' else in2;
end behavioural;

