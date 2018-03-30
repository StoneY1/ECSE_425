library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity sign_zero_extend is 
port(
		shift_amount : in std_logic_vector(4 downto 0);
		imm_out : word_type
);

architecture behavioral of sign_zero_extend is
begin 

extend : process (shift_amount)
begin

	imm_out <= "00000000000000000000000000000000";

end process;



end behavioral;
