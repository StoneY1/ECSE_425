library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity branch_comparator is 
port(

	register1 : in word_type;
	register2 : in word_type;
	control : in std_logic_vector(1 downto 0);
	taken : out std_logic

);
end entity;

architecture behavioral of branch_comparator is
begin 

compare : process (register1,register2,control)
begin
	if control = "11" then --taken
		taken <= '1';
	
	elsif control = "10" then --bne
		if register1 = register2 then
			taken <= '0';
		else
			taken <= '1';
		end if;
	
	elsif control = "01" then --beq
		if register1 = register2 then
			taken <= '1';
		else
			taken <= '0';
		end if;
	else --not taken
		taken <= '0';
	end if;

end process;

end behavioral;