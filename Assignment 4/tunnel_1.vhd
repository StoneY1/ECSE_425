library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity tunnel_1 is 
port(
		word_in : in std_logic;
		word_out : out std_logic
); end entity;

architecture behavioral of tunnel_1 is
begin 

extend : process (word_in)
begin

	word_out <= word_in;

end process;



end behavioral;
