library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;


entity ExecuteStage is
port (
        -- inputs
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
    ) ;
end ExecuteStage;

architecture behavioral of ExecuteStage is
--component declaration
component ALU port (
	clk : in std_logic;
      	inputOne, inputTwo : in word_type;
      	ALU_function : in std_logic_vector(4 downto 0);
      	output : out word_type
); end component;

component ALU_Input_MUX port (

      clk : in std_logic;
      executeForward, memForward, wbForward, registerValue : in word_type;
      outputSelect : in std_logic_vector(1 downto 0);
      output : out word_type

); end component;

component imm_mux port (
	clk : in std_logic;
     	registerValue, immediateValue : in word_type;
      	outputSelect : in std_logic;
      	output : out word_type
); end component;

--signal declaration
signal firstInput : word_type;
signal secondInput : word_type;
signal immediateMuxOutput : word_type;

begin 

aluInputOne : ALU_Input_MUX port map(
	clk => clk,
	executeForward => executeForward,
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
	executeForward => executeForward,
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


end architecture; 
