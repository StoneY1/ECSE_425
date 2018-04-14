library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.definitions.all;

entity DecodeStage_tb is
end;

architecture behavioral of DecodeStage_tb is
component DecodeStage
port (
        -- inputs
        reset : in std_logic;
        clk : in std_logic;

	PC_in : in word_type;
        instruction_in : in word_type;

	write_enable : in std_logic;
	register_write_address : in std_logic_vector(4 downto 0);
	write_data : in word_type;


	--output to IF stage
	branch_taken : out std_logic;
	branch_address : out word_type;
		
        -- outputs to EX stage
	R1_address : out std_logic_vector (4 downto 0);
	R2_address : out std_logic_vector (4 downto 0);
        R1 : out word_type;
        R2 : out word_type;
        ALU_function : out std_logic_vector (4 downto 0);
        imm_out : out word_type;

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic; --flaged when result needs to be saved back in registers
	use_imm : out std_logic
	
);  end component;

--inputs
signal clock : std_logic;
signal reset : std_logic;
signal PC_in : word_type;
signal instruction_in : word_type;
signal register_write_address: STD_LOGIC_VECTOR (4 DOWNTO 0);
signal write_data : word_type;
signal write_enable: STD_LOGIC;

--outputs
signal branch_taken : std_logic;
signal branch_address : word_type;
signal R1_address :  std_logic_vector (4 downto 0);
signal R2_address :  std_logic_vector (4 downto 0);
signal R1 :  word_type;
signal R2 :  word_type;
signal ALU_function :  std_logic_vector (4 downto 0);
signal imm_out :  word_type;

signal mem_store :  std_logic; --flagged for mem Write
signal mem_load :  std_logic; -- flagged for mem load
signal output_register :  std_logic_vector (4 downto 0);
signal writeback_register :  std_logic; --flaged when result needs to be saved back in registers
signal use_imm :  std_logic;

constant clock_period : time := 100 ps;

begin

decodeStageComp : DecodeStage port map(	
							--INPUT PORTS
							reset => reset,
							clk => clock,
							PC_in => PC_in,
							
							instruction_in => instruction_in,
							
							write_enable => write_enable,
							register_write_address => register_write_address,
							write_data => write_data,

							--OUTPUT PORTS
							branch_taken => branch_taken,
							branch_address => branch_address,
							R1_address => R1_address,
							R2_address => R2_address,
							
							R1 => R1,
							R2 => R2,
							ALU_function => ALU_function,
							imm_out => imm_out,
							
							
							mem_store => mem_store,--flagged for mem Write
							mem_load => mem_load,-- flagged for mem load
							output_register => output_register,
							writeback_register => writeback_register,--flaged when result needs to be saved back in registers
							use_imm => use_imm);


  simulate: process
  begin
  
    -- Put initialisation code here
	reset<= '0';
	--"000000 00000 00000 00000 00000 000111"
	PC_in <= "00000000000000000000000000000000";
	instruction_in <= "00000000001000100001100000111111"; --DO nothing
	--write_enable '0', inputs dont matter
	write_enable <= '0';
	register_write_address <= "00001";
	write_data <= "11111111111111111111111111111111";

	wait for 2*clock_period;
    	
	--PC_in <= "00000000000000000000000000000100";
	PC_in <= "00000000000000000000000000000100";
	instruction_in <= "00100000001000100000000000000101"; --add r1 + 5 -> r2
	--write_enable '0', inputs dont matter
	write_enable <= '0';
	register_write_address <= "00001";
	write_data <= "11111111111111111111111111111111";


	wait for 2*clock_period;

	instruction_in <= "00000000001000010001100000111111"; --DO nothing
	--write_enable '0', inputs dont matter
	write_enable <= '0';
	register_write_address <= "00001";
	write_data <= "11111111111111111111111111111111";

	wait for 2*clock_period;

	PC_in <= "00000000000000000000000000001000";
	instruction_in <= "00000000011000100010000000100000"; --add r3 + r2 -> r4
	--write_enable '0', inputs dont matter
	write_enable <= '1';
	register_write_address <= "00011";
	write_data <= "00111000111000111000111000111000";

	wait for 2*clock_period;

	PC_in <= "00000000000000000000000000001000";
	instruction_in <= "10101100001000110000000000000100"; --sw r1(mem row), imm(offset), value at R3
	--write_enable '0', inputs dont matter
	write_enable <= '0';
	register_write_address <= "00011";
	write_data <= "11111111111111111111111111111111";

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