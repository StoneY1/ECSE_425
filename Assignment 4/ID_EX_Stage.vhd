library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity ID_EX_Stage is
    Port 
	--Check ALU code lengths
        ( ALU_code_in   : in    address_type
        ; ALU_code_out  : out   address_type
	; register1_value_in : in word_type
	; register1_value_out : out word_type
	; register2_value_in : in word_type
	; register2_value_out : out word_type
	; immediate_value_in : in word_type
	; immediate_value_out : out word_type
        ; store_in      : in    std_logic
        ; store_out     : out   std_logic
	; load_in	: in std_logic
	; load_out	: out std_logic
	; dest_register_in : in address_type
	; dest_register_out : out address_type
	; immediate_operation_in : in std_logic
	; immediate_operation_out : out std_logic
	; write_back_in : in std_logic
	; write_back_out : out std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic
        );
           
end ID_EX_Stage;



architecture behavior of ID_EX_Stage is 
-- Create signals here: last instruction, stall

begin

	-- handle stalling here

	process(reset,clk)
	begin 
		-- if reset is high
		if reset = '1' then
			ALU_code_out <= (others => '0');
			register1_value_out <= (others => '0');
			register2_value_out <= (others => '0');
			immediate_value_out <= (others => '0');
			store_out <= '0';
			load_out <= '0';
			dest_register_out <= (others => '0');
			immediate_operation_out <= '0';
			write_back_out <= '0';
			
		elsif rising_edge(clk) then
			ALU_code_out <= ALU_code_in;
			register1_value_out <= register1_value_in;
			register2_value_out <= register2_value_in;
			immediate_value_out <= immediate_value_in;
			store_out <= store_in;
			load_out <= load_in;
			dest_register_out <= dest_register_in;
			immediate_operation_out <= immediate_operation_in;
			write_back_out <= write_back_in;
		end if;		
	end process;

end behavior;