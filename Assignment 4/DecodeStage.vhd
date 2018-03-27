library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity DecodeStage is
port (
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

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic --flaged when result needs to be saved back in registers

); end component;

--signal declaration
signal regAdd_r1 : std_logic_vector(4 downto 0);
signal regAdd_r2 : std_logic_vector(4 downto 0);

begin 

ID_stage_register : register_file port map(	clock => clk,
						write_enable =>	write_enable,
						r1 => regAdd_r1,
						r2 => regAdd_r2,
						write_address => register_write_address,
						write_data => write_data,
						r1_out => R1,
						r2_out => R2);

decoderComp : decoder port map(			reset => reset,
						clk =>	clk,
						instruction_in => instruction_in,
						register1_address => regAdd_r1,
						register2_address => regAdd_r2,
						ALU_function => ALU_function,
						shift_amount => shift_amount,
						mem_store => mem_store,
						mem_load => mem_load,
						output_register => output_register,
						writeback_register => writeback_register);





end architecture; 