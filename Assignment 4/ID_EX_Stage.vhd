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
        ; insert_stall        : in    std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic
        );
           
end IF_ID_Stage;



architecture behavior of IF_ID_Stage is 
-- Create signals here: last instruction, stall

begin

	-- handle stalling here

	process(reset,clk)
	begin 
		-- if reset is high
		if reset = '1' then
			PC_out <= (others => '0');
			inst_out <= (others => '0');
			
		elsif rising_edge(clk) then
			PC_out <= PC_in;
			inst_out <= inst_in;
		end if;		
		--else inputs = outputs
	end process;

end behavior;