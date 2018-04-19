library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity tunnel_1 is 
port(
		bit_IN : in std_logic;
		bit_OUT : out std_logic
); end entity;

architecture behavioral of tunnel_1 is
begin 

extend : process (bit_IN)
begin

	bit_OUT <= bit_IN;

end process;



end behavioral;
