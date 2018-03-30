library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity sign_zero_extend is 
port(
		immediate_IN : in word_type;
		imm_out : out word_type
); end sign_zero_extend;

architecture behavioral of sign_zero_extend is
begin 

extend : process (immediate_IN)
begin

	imm_out <= immediate_IN;

end process;



end behavioral;
