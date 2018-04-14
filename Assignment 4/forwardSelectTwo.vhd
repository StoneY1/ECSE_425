library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity forwardSelectTwo is
port (
      inputAddress, memAddress, wbAddress : in register_type;
      use_imm : in std_logic;
      output : out std_logic_vector(1 downto 0)
  );
end forwardSelectTwo;

architecture behavioral of forwardSelectTwo is

begin
process (inputAddress, memAddress, wbAddress, use_imm)
	begin
	if use_imm = '1' then
		output <= "00";
	elsif memAddress = inputAddress then
		output <= "01";
	elsif wbAddress = inputAddress then
		output <= "10";
	else
		output <= "00";
	end if;

	end process;

end behavioral;