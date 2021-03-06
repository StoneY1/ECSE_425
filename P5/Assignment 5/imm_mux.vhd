library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity imm_mux is
port (clk : in std_logic;
      registerValue, immediateValue : in word_type;
      outputSelect : in std_logic;
      output : out word_type
  );
end imm_mux;

architecture behavioral of imm_mux is


begin
process (registerValue, immediateValue, outputSelect)
	begin
	
	if outputSelect = '0' then
		output <= registerValue;
	elsif outputSelect = '1' then
		output <= immediateValue;
	end if;
	end process;

end behavioral;