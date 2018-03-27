library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity pipelineStages is
port (
		--inputs
		reset : in std_logic;
		clk : in std_logic;
		instruction_in : in word_type;
		
		write_enable : in std_logic;
		register_write_address : in std_logic_vector(4 downto 0);
		write_data : in word_type;
		
		--outputs
		ALU_result : out word_type;
		memory_in : out word_type;
		mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic --flaged when result needs to be saved back in registers

);

end pipelineStages;



architecture behavioral of pipelineStages is

--declaring components
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

begin 

ID_Stage : DecodeStage port map(
							reset => reset,
							clk => clk,
							instruction_in => instruction_in,

							write_enable => write_enable,
							register_write_address => register_write_address,
							write_data => write_data,


							-- outputs to EX stage
							R1 => R1_ID,
							R2 => R2_ID,
							ALU_function => ALU_function_id
								);
								
ID_EX : ID_EX_Stage port map(
							ALU_code_in => ALU_function_id,
							ALU_code_out => ALU_function_ex,
							register1_value_in => R1_ID,
							register1_value_out => R1_EX,
							register2_value_in => R2_ID,
							register2_value_out => R2_EX,
							immediate_value_in => (others => '0'),
							store_in => '0',
							load_in => '0',
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
							ALU_value_out => ALU_result
								);


end architecture;