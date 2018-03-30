library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionFetchStage_tb is
end InstructionFetchStage_tb;

architecture behaviour of InstructionFetchStage_tb is

component InstructionFetchStage is 
	Port (
		clock : in std_logic;
		branch_taken : in std_logic;
		dest_address : in std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0)
	);
end component;

constant clock_period : time := 100 ps;
signal clock : std_logic;
signal branch_taken : std_logic;
signal dest_address : std_logic_vector(31 downto 0);
signal instruction : std_logic_vector(31 downto 0);

begin

IFStage : InstructionFetchStage
	port map (
		clock => clock,
		branch_taken => branch_taken,
		dest_address => dest_address,
		instruction => instruction
	);

simulate_process : process
begin

	branch_taken <= '0';
	dest_address <= "00000000000000000000000000000000";
	wait for clock_period;
	branch_taken <= '1';
	dest_address <= "00000000000000000000000000000101";
	wait for clock_period;
	wait for clock_period;
	wait for clock_period;
	
	wait;

end process;

clk_process : process
begin
	clock <= '0';
	wait for clock_period/2;
	clock <= '1';
	wait for clock_period/2;
end process;

end behaviour;