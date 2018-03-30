library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity sign_zero_extend is 
port(
		immediate_IN : in std_logic_vector(15 downto 0);
		ALU_function : in std_logic_vector(4 downto 0);
		imm_out : out word_type
); end sign_zero_extend;

architecture behavioral of sign_zero_extend is
begin 

extend : process (shift_amount)
begin
	case(ALU_function) is 
		
		when "00000" =>
			imm_out <= "00000000000000000000000000000000";
		
		
		when others =>
			imm_out <= "00000000000000000000000000000000";
	
	
	end case;
	

end process;



end behavioral;
