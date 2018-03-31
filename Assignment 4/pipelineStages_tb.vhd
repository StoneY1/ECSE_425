library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.definitions.all;

entity pipelineStages_tb is
end;

architecture behavioral of pipelineStages_tb is
component pipelineStages
port (
		--inputs
		reset : in std_logic;
		clk : in std_logic
	
);  end component;

signal clock : std_logic;
signal reset : std_logic := '0';

begin

pipeline : pipelineStages port map(	
							--INPUT PORTS
							reset => reset,
							clk => clock);



end architecture;