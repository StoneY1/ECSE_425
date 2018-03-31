library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity EX_MEM_Stage is
    Port 
	--Check ALU code lengths
        ( ALU_value_in   : in    word_type
        ; ALU_value_out  : out   word_type
	; register2_value_in : in word_type
	; register2_value_out : out word_type
        ; store_in      : in    std_logic
        ; store_out     : out   std_logic
	; load_in	: in std_logic
	; load_out	: out std_logic
	; dest_register_in : in register_type
	; dest_register_out : out register_type
	; write_back_in : in std_logic
	; write_back_out : out std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic
        );
           
end EX_MEM_Stage;



architecture behavior of EX_MEM_Stage is 
-- Create signals here: last instruction, stall

begin

	-- handle stalling here

	process(reset,clk)
	begin 
		-- if reset is high
		if reset = '1' then
			ALU_value_out <= (others => '0');
			register2_value_out <= (others => '0');
			store_out <= '0';
			load_out <= '0';
			dest_register_out <= (others => '0');
			write_back_out <= '0';
			
		elsif rising_edge(clk) then
			ALU_value_out <= ALU_value_in;
			register2_value_out <= register2_value_in;
			store_out <= store_in;
			load_out <= load_in;
			dest_register_out <= dest_register_in;
			write_back_out <= write_back_in;
		end if;		
	end process;

end behavior;
