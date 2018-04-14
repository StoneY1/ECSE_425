library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity forwardSelectOne is
port (
      inputAddress, memAddress, wbAddress : in register_type;
      output : out std_logic_vector(1 downto 0)
  );
end forwardSelectOne;

architecture behavioral of forwardSelectOne is

begin
process (inputAddress, memAddress, wbAddress)
	begin
	
	if memAddress = inputAddress then
		output <= "01";
	elsif wbAddress = inputAddress then
		output <= "10";
	else
		output <= "00";
	end if;

	end process;

end behavioral;