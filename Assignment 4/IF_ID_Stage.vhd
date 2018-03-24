library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity IF_ID_Stage is
    Port 
        ( PC_in   : in    address_type
        ; PC_out  : out   address_type
        ; inst_in      : in    word_type
        ; inst_out     : out   word_type
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
