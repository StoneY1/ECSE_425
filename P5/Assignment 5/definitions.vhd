library ieee;
use ieee.std_logic_1164.all;

package definitions is
--    defined subtypes
    subtype word_type is std_logic_vector(31 downto 0); -- 32 bits
    subtype address_type is std_logic_vector(31 downto 0); -- 32 bits
    subtype register_type is std_logic_vector(4 downto 0); -- 5 bits
    

end package definitions;