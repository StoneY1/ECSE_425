library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity MEM_WB_Stage is
    Port 
	--Check ALU code lengths
        ( MEM_value_in   : in    word_type
        ; MEM_value_out  : out   word_type
	; dest_register_in : in register_type
	; dest_register_out : out register_type
	; write_back_in : in std_logic
	; write_back_out : out std_logic
        ; reset               : in    std_logic
        ; clk                 : in    std_logic
        );
           
end MEM_WB_Stage;



architecture behavior of MEM_WB_Stage is 
-- Create signals here: last instruction, stall

begin

	-- handle stalling here

	process(reset,clk)
	begin 
		-- if reset is high
		if reset = '1' then
			MEM_value_out <= (others => '0');
			dest_register_out <= (others => '0');
			write_back_out <= '0';
			
		elsif rising_edge(clk) then
			MEM_value_out <= MEM_value_in;
			dest_register_out <= dest_register_in;
			write_back_out <= write_back_in;
		end if;		
	end process;

end behavior;