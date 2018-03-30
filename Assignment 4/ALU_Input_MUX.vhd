library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity ALU_Input_MUX is
port (clk : in std_logic;
      memForward, wbForward, registerValue : in word_type;
      outputSelect : in std_logic_vector(1 downto 0);
      output : out word_type
  );
end ALU_Input_MUX;

architecture behavioral of ALU_Input_MUX is
--Mux for choosing the inputs to the ALU
-- 00 => Register Value, 01 => executeForward
-- 10 => memForward, 11 => wbForward

begin
process (memForward, wbForward, registerValue, outputSelect)
	begin
	
	if outputSelect = "00" then
		output <= registerValue;
	elsif outputSelect = "01" then
		output <= memForward;
	elsif outputSelect = "10" then
		output <= wbForward;
	end if;
	end process;

end behavioral;