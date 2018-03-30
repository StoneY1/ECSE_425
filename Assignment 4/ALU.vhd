library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.definitions.all;

entity ALU is
port (clk : in std_logic;
      inputOne, inputTwo : in word_type;
      ALU_function : in std_logic_vector(4 downto 0);
      output : out word_type
  );
end ALU;

architecture behavioral of ALU is

signal temp : integer := 0;
signal LO : word_type;
signal HI : word_type;

begin
process (inputOne, inputTwo, ALU_function)
	begin
	

	-- add, addi
	if ALU_function = "00001" then
		output <= std_logic_vector(signed(inputOne) + signed(inputTwo));

	-- sub
	elsif ALU_function = "00010" then
		output <= std_logic_vector(signed(inputOne) - signed(inputTwo));

	--mult
	elsif ALU_function = "00011" then
		LO <= std_logic_vector(to_signed(to_integer(signed(inputOne)) * to_integer(signed(inputTwo)),32));
		
	--div
	elsif ALU_function = "00100" then
		LO <= std_logic_vector(signed(inputOne) / signed(inputTwo));
		HI <= std_logic_vector(signed(inputOne) rem signed(inputTwo));

	--slt, slti
	elsif ALU_function = "00101" then
		if signed(inputOne) < signed(inputTwo) then
			output <= std_logic_vector(to_signed(1, 32));
		else
			output <= std_logic_vector(to_signed(0, 32));
		end if;
		
	--and, andi
	elsif ALU_function = "00110" then
		output <= inputOne and inputTwo;

	--or, ori
	elsif ALU_function = "00111" then
		output <= inputOne or inputTwo;

	--nor
	elsif ALU_function = "01000" then
		output <= inputOne nor inputTwo;
		
	--xor, xori
	elsif ALU_function = "01001" then
		output <= inputOne xor inputTwo;

	--mfhi
	elsif ALU_function = "01011" then
		output <= HI;
	
	--mflo
	elsif ALU_function = "11011" then
		output <= LO;

	-- sll
	elsif ALU_function = "01100" then
		output <= std_logic_vector(shift_left(signed(inputOne), to_integer(signed(inputTwo))));
		
	--srl
	elsif ALU_function = "01101" then
		output <= std_logic_vector(shift_right(signed(inputOne), to_integer(signed(inputTwo))));

	--sra
	elsif ALU_function = "01110" then
		output <= to_stdlogicvector(to_bitvector(inputOne) sra to_integer(signed(inputTwo)));

	-- lw,sw
	elsif ALU_function = "01111" then
		output <= std_logic_vector(signed(inputOne) - signed(inputTwo));


	-- lui
	elsif ALU_function = "10000" then
		output <=  std_logic_vector(shift_left(signed(inputTwo), 16));

	-- no OP code
	elsif ALU_function = "00000" then
		output <= std_logic_vector(to_signed(0, 32));

	end if;

end process;

end behavioral;