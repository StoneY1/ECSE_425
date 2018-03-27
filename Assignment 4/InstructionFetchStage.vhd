-- Instruction Fetch Stage
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity InstrFetchStage is
	Port ( 
		clock : in std_logic;
		instruction : out std_logic_vector(31 downto 0)
	);
end InstrFetchStage;


architecture behaviour of InstrFetchStage is

component pc is
	Port ( 
		clock : in std_logic;  
		reset : in std_logic;
		PC_in : in std_logic_vector(31 downto 0);
		PC_out : out std_logic_vector(31 downto 0);
		enable : in std_logic
	);
end component;

component adder4 is 
	Port ( 
		add_in : in std_logic_vector(31 downto 0);
		add_out : out std_logic_vector(31 downto 0)
	);
end component;

component fetchInstr is
	GENERIC(
		ram_size : integer := 1024
	);
	PORT (
		clock: in std_logic;
		address: in integer range 0 to ram_size-1;
		readdata: out std_logic_vector (31 downto 0)
	);
end component;

-- Set signals
signal reset : std_logic := '0';
signal pcIn : std_logic_vector(31 downto 0);
signal pcOut : std_logic_vector(31 downto 0);
signal en : std_logic := '1';

signal adderOut : std_logic_vector(31 downto 0);
signal addr : integer range 0 to 1024-1;

begin
pcIn <= adderOut;
addr <= to_integer(unsigned(adderOut(9 downto 0)))/4;

	programCounter : PC
	port map ( 
			clock => clock,
			reset => reset,
			PC_in => pcIn,
			PC_out => pcOut,
			enable => en
		);

	add : adder4
	port map ( 
			add_in => pcOut,
			add_out => adderOut
		);
			  
	getInstr : fetchInstr
	port map ( 
			clock => clock,
			address => addr,
			readdata => instruction
		);

end behaviour;