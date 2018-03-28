library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity pipelineStages is
port (
		--inputs
		reset : in std_logic;
		clk : in std_logic;
		
		write_enable : in std_logic;
		register_write_address : in std_logic_vector(4 downto 0);
		write_data : in word_type;
		
		--outputs
		--mem_store : out std_logic; --flagged for mem Write
        --mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic --flaged when result needs to be saved back in registers

);

end pipelineStages;



architecture behavioral of pipelineStages is

--declaring components
component InstructionFetchStage port (

	clock : in std_logic;
	instruction : out std_logic_vector(31 downto 0)

); end component;

component IF_ID_Stage port (
		PC_in   : in    address_type
        ; PC_out  : out   address_type
        ; inst_in      : in    word_type
        ; inst_out     : out   word_type
        ; insert_stall        : in    std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic

); end component;


component DecodeStage port (
	-- inputs
    reset : in std_logic;
    clk : in std_logic;

    instruction_in : in word_type;

    write_enable : in std_logic;
    register_write_address : in std_logic_vector(4 downto 0);
    write_data : in word_type;


    -- outputs to EX stage
    R1 : out word_type;
    R2 : out word_type;
    ALU_function : out std_logic_vector (4 downto 0);
    shift_amount : out std_logic_vector(4 downto 0);

    mem_store : out std_logic; --flagged for mem Write
    mem_load : out std_logic; -- flagged for mem load
    output_register : out std_logic_vector (4 downto 0);
    writeback_register : out std_logic --flaged when result needs to be saved back in registers

); end component;

component ID_EX_Stage port (
	ALU_code_in   : in    std_logic_vector(4 downto 0);
    ALU_code_out  : out   std_logic_vector(4 downto 0);
	register1_value_in : in word_type;
	register1_value_out : out word_type;
	register2_value_in : in word_type;
	register2_value_out : out word_type;
	immediate_value_in : in word_type;
	immediate_value_out : out word_type;
    store_in      : in    std_logic;
    store_out     : out   std_logic;
	load_in	: in std_logic;
	load_out	: out std_logic;
	dest_register_in : in word_type;
	dest_register_out : out word_type;
	immediate_operation_in : in std_logic;
	immediate_operation_out : out std_logic;
	write_back_in : in std_logic;
	write_back_out : out std_logic;
    reset               : in    std_logic;
    clk                 : in    std_logic
); end component;

component ExecuteStage port (
          reset : in std_logic
        ; clk : in std_logic
	; executeForward, memForward, wbForward : in word_type
	; inputOneSelect : in std_logic_vector(1 downto 0)
	; inputTwoSelect : in std_logic_vector(1 downto 0)
	; ALU_code_in   : in    std_logic_vector(4 downto 0)
	; register1_value_in : in word_type
	; register2_value_in : in word_type
	; immediate_value_in : in word_type
        ; store_in      : in    std_logic
	; load_in	: in std_logic
	; dest_register_in : in address_type
	; immediate_operation_in : in std_logic
	; write_back_in : in std_logic
	; ALU_value_out : out word_type
); end component;


component EX_MEM_Stage port (
	--Check ALU code lengths
        ALU_value_in   : in    word_type
        ; ALU_value_out  : out   word_type
	; register2_value_in : in word_type
	; register2_value_out : out word_type
        ; store_in      : in    std_logic
        ; store_out     : out   std_logic
	; load_in	: in std_logic
	; load_out	: out std_logic
	; dest_register_in : in address_type
	; dest_register_out : out address_type
	; write_back_in : in std_logic
	; write_back_out : out std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic

); end component;

component MemoryStage port (
    clk : in std_logic;
    ALU_value_out : in word_type;
    store_enable, load_enable, write_back_enable_in : in std_logic;
    dest_register_in : in register_type;
    mem_data_in : in word_type;

    ALU_value_forwarded : out word_type;
    dest_register_out : out register_type;
    write_back_enable_out : out std_logic;
    mem_out: out word_type
); end component;


component EX_MEM_Stage port (
		MEM_value_in   : in    word_type
	; MEM_value_out  : out   word_type
	; dest_register_in : in address_type
	; dest_register_out : out address_type
	; write_back_in : in std_logic
	; write_back_out : out std_logic
    ; reset               : in    std_logic
    ; clk                 : in    std_logic


); end component;



-- declaring signals
signal R1_ID : word_type;
signal R2_ID : word_type;
signal R1_EX : word_type;
signal R2_EX : word_type;
signal ALU_function_id : std_logic_vector(4 downto 0);
signal ALU_function_ex : std_logic_vector(4 downto 0);
signal mem_store_id : std_logic;
signal mem_load_id : std_logic;
signal output_register_id : std_logic_vector(4 downto 0); 
signal instruction_IN : word_type;
signal instruction_OUT : word_type;
signal ALU_result_IN : word_type;
signal ALU_result_OUT : word_type;
signal mem_store_ID_EX_IN : std_logic;
signal mem_store_ID_EX_OUT : std_logic;
signal mem_load_ID_EX_IN : std_logic;
signal mem_load_ID_EX_OUT : std_logic;
signal output_register_ID_EX_IN : std_logic_vector (4 downto 0);
signal output_register_ID_EX_OUT : std_logic_vector (4 downto 0);
signal output_register_EX_MEM_IN : std_logic_vector (4 downto 0);
signal output_register_EX_MEM_OUT : std_logic_vector (4 downto 0);
signal output_register_MEM_WB_IN : std_logic_vector (4 downto 0);
signal output_register_MEM_WB_OUT : std_logic_vector (4 downto 0);
signal writeback_register_ID_EX_IN :  std_logic; --flaged when result needs to be saved back in registers
signal writeback_register_ID_EX_OUT :  std_logic; --flaged when result needs to be saved back in registers
signal writeback_register_EX_MEM_IN :  std_logic; --flaged when result needs to be saved back in registers
signal writeback_register_EX_MEM_OUT :  std_logic; --flaged when result needs to be saved back in registers
signal writeback_register_MEM_WB_IN  :  std_logic; --flaged when result needs to be saved back in registers
signal writeback_register_MEM_WB_OUT :  std_logic; --flaged when result needs to be saved back in registers

begin 

IF_Stage : InstructionFetchStage port map(
							clock => clk,
							instruction => instruction_IN
								);

IF_ID : IF_ID_Stage port map(
							inst_in => instruction_IN,
							inst_out => instruction_OUT,
							reset => reset,
							clk => clk
							);
								
								
ID_Stage : DecodeStage port map(
							reset => reset,
							clk => clk,
							instruction_in => instruction_OUT,

							write_enable => write_enable,
							register_write_address => register_write_address,
							write_data => write_data,


							-- outputs to EX stage
							R1 => R1_ID,
							R2 => R2_ID,
							ALU_function => ALU_function_id,
							
							mem_store => mem_store_ID_EX_IN,--flagged for mem Write
							mem_load => mem_load_ID_EX_IN,-- flagged for mem load
							output_register => output_register_ID_EX_IN,
							writeback_register => writeback_register_ID_EX_IN--flaged when result needs to be saved back in registers
								);
								
ID_EX : ID_EX_Stage port map(
							ALU_code_in => ALU_function_id,
							ALU_code_out => ALU_function_ex,
							register1_value_in => R1_ID,
							register1_value_out => R1_EX,
							register2_value_in => R2_ID,
							register2_value_out => R2_EX,
							immediate_value_in => (others => '0'),
							store_in => mem_store_ID_EX_IN,
							store_out => mem_store_ID_EX_OUT,
							load_in => mem_load_ID_EX_IN,
							load_out => mem_load_ID_EX_OUT,
							dest_register_in => (others => '0'),
							immediate_operation_in => '0',
							write_back_in => '0',
							reset => '0',
							clk => clk
							
								);
								
EX_Stage : ExecuteStage port map(
							reset => reset,
							clk => clk,
							executeForward => (others => '0'),
							memForward => (others => '0'),
							wbForward => (others => '0'),
							ALU_code_in => ALU_function_ex,
							register1_value_in => R1_EX,
							register2_value_in => R2_EX,
							immediate_value_in => (others => '0'),
							store_in => '0',
							load_in => '0',
							dest_register_in => (others => '0'),
							immediate_operation_in => '0',
							write_back_in =>'0',
							inputOneSelect => "00",
							inputTwoSelect => "00",
							ALU_value_out => ALU_result_IN
								);
								
								
EX_MEM : EX_MEM_Stage port map(
							ALU_value_in => ALU_result_IN,
							ALU_value_out => ALU_result_OUT,
							register2_value_in => R2_EX,
							register2_value_out =>
							store_in =>
							store_out =>
	 						load_in =>
							load_out =>
							dest_register_in =>
							dest_register_out =>
							write_back_in =>
							write_back_out =>
							reset => reset,
							clk => clk
								);

memory_Stage : MemoryStage port map(
							clk  => clk,
							ALU_value_out => ,
							store_enable => ,
							load_enable => ,
							write_back_enable_in => ,
							dest_register_in => ,
							mem_data_in => ,

							ALU_value_forwarded => ,
							dest_register_out => ,
							write_back_enable_out => ,
							mem_out => 

								);
								
MEM_WB : MEM_WB_Stage port map(
							MEM_value_in => ,
							MEM_value_out => ,
							dest_register_in => ,
							dest_register_out => ,
							write_back_in => ,
							write_back_out => ,
							reset => reset,
							clk => clk
								);
								

end architecture;