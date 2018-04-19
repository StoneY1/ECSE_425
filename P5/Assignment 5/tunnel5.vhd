library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity tunnel5 is 
port(
		bits_IN : in std_logic_vector (4 downto 0);
		bits_OUT : out std_logic_vector (4 downto 0)
); end tunnel5;

architecture behavioral of tunnel5 is
begin 

extend : process (bits_IN)
begin

	bits_OUT <= bits_IN;

end process;



end behavioral;