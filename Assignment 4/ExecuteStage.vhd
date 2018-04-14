library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity ExecuteStage is
port (
        -- inputs
          reset : in std_logic
        ; clk : in std_logic
	; memAddr, wbAddr : in register_type
	; memForward, wbForward : in word_type
	; ALU_code_in   : in std_logic_vector(4 downto 0)
	; register1_address_in : in register_type
	; register2_address_in : in register_type
	; register1_value_in : in word_type
	; register2_value_in : in word_type
	; immediate_value_in : in word_type
    ; store_in      : in std_logic
	; load_in	: in std_logic
	; dest_register_in : in register_type
	; immediate_operation_in : in std_logic
	; write_back_in : in std_logic
	; ALU_value_out : out word_type
	; store_out      : out std_logic
	; load_out	: out std_logic
	; dest_register_out : out register_type
	; write_back_out : out std_logic
    ) ;
end ExecuteStage;

architecture behavioral of ExecuteStage is


-- Overlaying module for the execute stage, includes the ALU, ALU input mux's for forwarding and immediate muxMux for choosing the inputs to the ALU

--component declaration
component ALU port (
	clk : in std_logic;
      	inputOne, inputTwo : in word_type;
      	ALU_function : in std_logic_vector(4 downto 0);
      	output : out word_type
); end component;

component ALU_Input_MUX port (
      clk : in std_logic;
      memForward, wbForward, registerValue : in word_type;
      outputSelect : in std_logic_vector(1 downto 0);
      output : out word_type

); end component;

component imm_mux port (
	clk : in std_logic;
     	registerValue, immediateValue : in word_type;
      	outputSelect : in std_logic;
      	output : out word_type
); end component;

component forwardSelectOne port (
      inputAddress, memAddress, wbAddress : in register_type;
      output : out std_logic_vector(1 downto 0)
); end component;

component forwardSelectTwo port (
      inputAddress, memAddress, wbAddress : in register_type;
      use_imm : in std_logic;
      output : out std_logic_vector(1 downto 0)
); end component;

--signal declaration
signal firstInput : word_type;
signal secondInput : word_type;
signal immediateMuxOutput : word_type;
signal inputOneSelect : std_logic_vector (1 downto 0);
signal inputTwoSelect : std_logic_vector (1 downto 0);

begin 

store_out <= store_in;
load_out <= load_in;
dest_register_out <= dest_register_in;
write_back_out <= write_back_in;

aluInputOne : ALU_Input_MUX port map(
	clk => clk,
	memForward => memForward,
	wbForward => wbForward,
	registerValue => register1_value_in,
	outputSelect => inputOneSelect,
	output => firstInput);

immediateMux : imm_mux port map(
	clk => clk,
	registerValue => register2_value_in,
	immediateValue => immediate_value_in,
	outputSelect => immediate_operation_in,
	output => immediateMuxOutput);
	

aluInputTwo : ALU_Input_MUX port map(
	clk => clk,
	memForward => memForward,
	wbForward => wbForward,
	registerValue => immediateMuxOutput,
	outputSelect => inputTwoSelect,
	output => secondInput);


aluBlock : ALU port map( 
	clk => clk,
	inputOne => firstInput,
	inputTwo => secondInput,
	ALU_function => ALU_code_in,
	output => ALU_value_out);

forwardSelectFirst : forwardSelectOne port map(
	inputAddress => register1_address_in,
	memAddress => memAddr,
	wbAddress => wbAddr,
	output => inputOneSelect);

forwardSelectSecond : forwardSelectTwo port map(
	inputAddress => register2_address_in,
	memAddress => memAddr,
	wbAddress => wbAddr,
	use_imm => immediate_operation_in,
	output => inputTwoSelect);

end architecture; 
