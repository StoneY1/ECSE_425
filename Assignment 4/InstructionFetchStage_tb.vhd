library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity InstructionFetchStage_tb is
end InstructionFetchStage_tb;

architecture behaviour of InstructionFetchStage_tb is

component InstructionFetchStage is 
	Port {
		clock : in std_logic;
		branch_taken : in std_logic;
		dest_address : in std_logic_vector(31 downto 0);
		instruction : out std_logic_vector(31 downto 0)
	};
end component;

constant clock_period : time := 100 ps;
signal clock : std_logic;
signal branch_taken : in std_logic;
signal dest_address : in std_logic_vector(31 downto 0);
signal instruction : out std_logic_vector(31 downto 0);

begin


end behaviour;