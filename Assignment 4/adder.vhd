library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

 
entity adder is
  port (
    	input1 : in std_logic_vector(31 downto 0);
	input2 : in std_logic_vector(31 downto 0);
    	result : out std_logic_vector(31 downto 0)
  );
end adder;
 
architecture behavior of adder is
 
begin
	result <= std_logic_vector(unsigned(input1) + unsigned(input2));
 
end behavior;