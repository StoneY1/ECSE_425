library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.definitions.all;

entity ExecuteStage_tb is
end;

architecture behavioral of ExecuteStage_tb is

	component ExecuteStage port (
    reset : in std_logic
    ; clk : in std_logic
    ; memAddr, wbAddr : in register_type
	; memForward, wbForward : in word_type
	; register1_address_in : in register_type
	; register2_address_in : in register_type
	; ALU_code_in   : in    std_logic_vector(4 downto 0)
	; register1_value_in : in word_type
	; register2_value_in : in word_type
	; immediate_value_in : in word_type
    ; store_in      : in    std_logic
	; load_in	: in std_logic
	; dest_register_in : in register_type
	; immediate_operation_in : in std_logic
	; write_back_in : in std_logic
	; ALU_value_out : out word_type
); end component;

signal clk : std_logic;
signal reset : std_logic;
signal memAddr : register_type;
signal wbAddr : register_type;
signal memForward, wbForward : word_type;
signal register1_address_in : register_type;
signal register2_address_in : register_type;
signal ALU_code_in   : std_logic_vector(4 downto 0);
signal register1_value_in : word_type;
signal register2_value_in : word_type;
signal immediate_value_in : word_type;
signal store_in : std_logic;
signal load_in	: std_logic;
signal dest_register_in : register_type;
signal immediate_operation_in : std_logic;
signal write_back_in : std_logic;
signal ALU_value_out : word_type;

constant clock_period : time := 100 ps;

begin

exec : ExecuteStage port map(
						clk => clk,
						reset => reset,
						memAddr => memAddr,
						wbAddr => wbAddr,
						memForward => memForward,
						wbForward => wbForward,
						register1_address_in => register1_address_in,
						register2_address_in => register2_address_in,
						ALU_code_in => ALU_code_in,
						register1_value_in => register1_value_in,
						register2_value_in => register2_value_in,
						immediate_value_in => immediate_value_in,
						store_in => store_in,
						load_in => load_in,
						dest_register_in => dest_register_in,
						immediate_operation_in => immediate_operation_in,
						write_back_in => write_back_in,
						ALU_value_out => ALU_value_out
						);



  simulate: process
  begin
  
    -- Put initialisation code here
    clk <= '0';
    reset <= '0';
	memAddr <= "00001";
	wbAddr <= "00010";
	memForward <= "00000000000000000000000000000011";
	wbForward <= "00000000000000000000000000000100";
	register1_address_in <= "00000";
	register2_address_in <= "00000";
	ALU_code_in <= "00001";
	register1_value_in <= "00000000000000000000000000000001";
	register2_value_in <= "00000000000000000000000000000001";
	immediate_value_in <= "00000000000000000000000000001000";
	store_in <= '0';
	load_in <= '0';
	dest_register_in <= "00000";
	immediate_operation_in <= '0';
	write_back_in <= '0';

	wait for clock_period;

	register1_address_in <= "00001";

	wait for clock_period;

	register2_address_in <= "00010";

	wait for clock_period;

	register1_address_in <= "00011";
	register2_address_in <= "00011";

	wait;
  end process;

  clocking: process
  begin
      clk <= '0';
      wait for clock_period/2;
	  clk <= '1';
	  wait for clock_period/2;
  end process;

end architecture;