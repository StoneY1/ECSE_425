library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_one_mux is
port (clk : in std_logic;
      sel : in std_logic;
      in1, in2 : in std_logic_vector(31 downto 0);
      output : out std_logic_vector(31 downto 0)
  );
end two_one_mux;

architecture behavioural of two_one_mux is
 begin
  process(clk)
    begin
      if clk'event and clk = '1' then
        case sel is
          when '0' => output <= in1;
          when '1' => output <= in2;
	  when OTHERS => output <= in1;
        end case;
      end if;
  end process;
end behavioural;

