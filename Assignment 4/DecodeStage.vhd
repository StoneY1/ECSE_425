library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity DecodeStage is
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
        R1 : out word_type;
        R2 : out word_type;
        ALU_function : out std_logic_vector (4 downto 0);
        imm_out : out word_type;

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic; --flaged when result needs to be saved back in registers
		use_imm : out std_logic

    ) ;
end DecodeStage;

architecture behavioral of DecodeStage is
--component declaration
component register_file port (
		clock: IN STD_LOGIC;
		r1, r2, write_address: IN STD_LOGIC_VECTOR (4 DOWNTO 0); --register addresses taken from instruction decoder and write info from WB stage
		write_data : IN word_type;
		write_enable: IN STD_LOGIC;

		r1_out, r2_out: OUT word_type --contents retrieved from register for execution stage
); end component;

component decoder port (
        -- inputs
        reset : in std_logic;
        clk : in std_logic;
        instruction_in : in word_type;


        -- outputs
        register1_address : out std_logic_vector (4 downto 0);
        register2_address : out std_logic_vector (4 downto 0);
        ALU_function : out std_logic_vector (4 downto 0);
        shift_amount : out std_logic_vector(4 downto 0);
		use_immediate : out std_logic;

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic; --flaged when result needs to be saved back in registers
		
		branch_control : out std_logic_vector(1 downto 0);
		offset : out std_logic

); end component;

component branch_comparator port (
	--inputs
	register1 : in word_type;
	register2 : in word_type;
	control : in std_logic_vector(1 downto 0);
	--outputs
	taken : out std_logic
);  end component;

component adder port (
    	input1 : in word_type;
	input2 : in word_type;
    	result : out word_type
);  end component;

component two_one_mux port (
      	sel : in std_logic;
      	in1 : in std_logic_vector(31 downto 0);
		in2 : in std_logic_vector(31 downto 0);
      	output : out std_logic_vector(31 downto 0)
);  end component;

component sign_zero_extend port (
		shift_amount : in std_logic_vector(4 downto 0);
		imm_out : out word_type
);  end component;

component tunnel32 port(
		word_in : in word_type;
		word_out : out word_type
); end component;

component tunnel5 port(
		bits_IN : in std_logic_vector(4 downto 0);
		bits_OUT : out std_logic_vector(4 downto 0)
); end component;

component tunnel_1 port(
		bit_IN : in std_logic;
		bit_OUT : out std_logic
); end component;

--signal declaration
signal regAdd_r1 : std_logic_vector(4 downto 0);
signal regAdd_r2 : std_logic_vector(4 downto 0);
signal R1_comp : word_type;
signal R2_comp : word_type;
signal branch_control : std_logic_vector(1 downto 0);
signal offset_link : std_logic;
--signal branch_control : std_logic;
signal offset_mux_OUT : word_type;
signal adder_OUT : word_type;
signal shift_amount_OUT : std_logic_vector(4 downto 0);
signal imm_Tunnel_IN : word_type;
signal branch_taken_tunnel : std_logic;
signal ALU_func_tunnel : std_logic_vector(4 downto 0);
--signal use_imm : std_logic;

begin 

tunnel_branchTaken : tunnel_1 port map(
						bit_IN => branch_taken_tunnel,
						bit_OUT => branch_taken
);

ALU_function_Tunnel : tunnel5 port map (
						bits_IN => ALU_func_tunnel,
						bits_OUT=> ALU_function
);

tunnel_imm : tunnel32 port map(
						word_in => imm_Tunnel_IN,
						word_out => imm_out
);

tunnel_R1 : tunnel32 port map(
						word_in => R1_comp,
						word_out => R1
);

tunnel_R2 : tunnel32 port map(
						word_in => R2_comp,
						word_out => R2
);

signZeroExt : sign_zero_extend port map(
						shift_amount => shift_amount_OUT,
						imm_out => imm_Tunnel_IN);

address_mux : two_one_mux port map(
						sel => branch_taken_tunnel,
						in1 => PC_in,
						in2 => adder_OUT,
						output => branch_address);

offset_mux : two_one_mux port map(
						sel => offset_link,
						in1 => R1_comp,
						in2 => imm_Tunnel_IN,
						output => offset_mux_OUT);

PC_jump_adder : adder port map(
						input1 => PC_in,
						input2 => offset_mux_OUT,
						result => adder_OUT);

ID_stage_register : register_file port map(	clock => clk,
						write_enable =>	write_enable,
						r1 => regAdd_r1,
						r2 => regAdd_r2,
						write_address => register_write_address,
						write_data => write_data,
						r1_out => R1_comp,
						r2_out => R2_comp);

decoderComp : decoder port map(			reset => reset,
						clk =>	clk,
						instruction_in => instruction_in,
						register1_address => regAdd_r1,
						register2_address => regAdd_r2,
						ALU_function => ALU_func_tunnel,
						shift_amount => shift_amount_OUT,
						mem_store => mem_store,
						mem_load => mem_load,
						output_register => output_register,
						writeback_register => writeback_register,
						offset => offset_link,
						use_immediate => use_imm,
						branch_control => branch_control );

comparator : branch_comparator port map(
						register1 => R1_comp,
						register2 => R2_comp,
						control => branch_control,
						taken => branch_taken_tunnel

);


end architecture; 
