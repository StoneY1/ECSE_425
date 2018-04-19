library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity tunnel32 is 
port(
		word_in : in word_type;
		word_out : out word_type
); end entity;

architecture behavioral of tunnel32 is
begin 

extend : process (word_in)
begin

	word_out <= word_in;

end process;



end behavioral;
