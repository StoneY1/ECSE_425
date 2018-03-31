library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.definitions.all;

entity register_file_tb is
end;

architecture behavioral of register_file_tb is

	component register_file
	PORT (
		clock: IN STD_LOGIC;
		r1, r2, write_address: IN STD_LOGIC_VECTOR (4 DOWNTO 0); --register addresses taken from instruction decoder and write info from WB stage
		write_data : IN word_type;
		write_enable: IN STD_LOGIC;

		r1_out, r2_out: OUT word_type --contents retrieved from register for execution stage
	
);  end component;

signal clock : std_logic;
signal r1: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal r2: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal write_address: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal write_data : word_type;
signal write_enable: STD_LOGIC;
signal r1_out: word_type;
signal r2_out: word_type;

constant clock_period : time := 100 ps;

begin

reg : register_file port map(	clock => clock,
						write_enable =>	write_enable,
						r1 => r1,
						r2 => r2,
						write_address => write_address,
						write_data => write_data,
						r1_out => r1_out,
						r2_out => r2_out);


  simulate: process
  begin
  
    -- Put initialisation code here
	r1 <= "00001";
	r2 <= "00010";
	write_address <= "00001";
	write_data <= "11000000000000000000000000011111";
	write_enable <= '0';
	wait for 3.5*clock_period;
    	write_enable <= '1';
	wait for clock_period;
	write_data <= "11000000000000000000000000000001";
	write_enable <= '1';
	write_address <= "00010";
	wait for clock_period;
	write_enable <= '1';
	write_address <= "00001";
	write_data <= "11000000000001110000000000000001";
	wait for clock_period;

	wait for clock_period;

	wait for clock_period;

    -- Put test bench stimulus code here

	wait for 5 ns;
	wait;
  end process;

  clocking: process
  begin
      clock <= '0';
      wait for clock_period/2;
	  clock <= '1';
	  wait for clock_period/2;
  end process;

end architecture; 