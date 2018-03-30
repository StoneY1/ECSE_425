library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity decoder is
port (
        -- inputs
        reset : in std_logic;
        clk : in std_logic;
        instruction_in : in word_type;


        -- outputs
        register1_address : out std_logic_vector (4 downto 0);
        register2_address : out std_logic_vector (4 downto 0);
        ALU_function : out std_logic_vector (4 downto 0);
        immediate : out word_type;
		use_immediate : out std_logic;

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out std_logic_vector (4 downto 0);
        writeback_register : out std_logic; --flaged when result needs to be saved back in registers
		
		branch_control : out std_logic_vector(1 downto 0);
		offset : out std_logic


    ) ;
end decoder ; -- decode

-- Similar ALU functions (ie same ALU_function): 
                            -- add = addi = lw = sw
                            -- slt = slti
                            -- and = andi
                            -- or = ori
                            -- xor = xori
                            -- mfhi = mflo


architecture behavioral of decoder is


begin

    decoding : process(clk)

    -- variables to hold decoded instruction
    variable opcode : std_logic_vector(5 downto 0);
    variable rs : std_logic_vector(4 downto 0);
    variable rt : std_logic_vector(4 downto 0);
    variable rd : std_logic_vector(4 downto 0);
    variable shamt : std_logic_vector(4 downto 0);-- only used for shift instructions
    variable I_function : std_logic_vector(5 downto 0);

    begin
        -- retreive opcode from Instruction
        opcode := instruction_in(31 downto 26);
	offset <= '1';
            mem_store <= '0';
            mem_load <= '0';
        if opcode = "000000" then --compare function section to see what instruction it is
            rs := instruction_in(25 downto 21);
            rt := instruction_in(20 downto 16);
            rd := instruction_in(15 downto 11);
            shamt := instruction_in(10 downto 6);
            I_function := instruction_in(5 downto 0);

            writeback_register <= '1';
			
			--set register outputs
            register1_address <= rs;
            register2_address <= rt;
            output_register <= rd;
            --shift_amount <= shamt;
			
            case (I_function) is

                when "100000" => --add 
                    ALU_function <= "00001";
			use_immediate <= '0';

                when "100010" => --sub 
                    ALU_function <= "00010";
			use_immediate <= '0';
                when "011000" => --mult 
                    ALU_function <= "00011";
			writeback_register <= '0';
			use_immediate <= '0';	
                when "011010" => --div 
                    ALU_function <= "00100";
			use_immediate <= '0';
			writeback_register <= '0';
                when "101010" => --slt 
                    ALU_function <= "00101";
			use_immediate <= '0';
                when "100100" => --and 
                    ALU_function <= "00110";
			use_immediate <= '0';
                when "100101" => --or 
                    ALU_function <= "00111";
			use_immediate <= '0';
                when "100111" => --nor 
                    ALU_function <= "01000";
			use_immediate <= '0';
                when "100110" => --xor 
                    ALU_function <= "01001";
			use_immediate <= '0';
                when "010000" => --mfhi
                    ALU_function <= "01011";
			use_immediate <= '0';
                when "010010" => --mflo
                    ALU_function <= "11011";
			use_immediate <= '0';
                when "000000" => --sll (shamt needed)
                    ALU_function <= "01100";
					use_immediate <= '1';
					register1_address <= rt;
					immediate <= std_logic_vector(resize(signed(shamt),immediate'length));
					
                when "000010" => --srl (shamt needed)
                    ALU_function <= "01101";
					use_immediate <= '1';
					register1_address <= rt;
					immediate <= std_logic_vector(resize(signed(shamt),immediate'length));

                when "000011" => --sra (shamt needed)
                    ALU_function <= "01110";
					use_immediate <= '1';
					register1_address <= rt;
					immediate <= std_logic_vector(resize(signed(shamt),immediate'length));

                when "001000" => --jr
                    ALU_function <= "00000";
					use_immediate <= '0';
					register1_address <= (others => '0');
					register2_address <= rs;
					branch_control <= "11";
					offset <= '0';
					immediate  <= (others => '0');
					writeback_register <= '0';
                
                when others =>
                    ALU_function <= "00000";
                    register1_address <= "00000";
                    register2_address <= "00000";
                    output_register <= "00000";
			writeback_register <= '0';

            end case;


        elsif opcode = "000010" then -- J type instruction
		--immediate <= To_StdLogicVector(to_bitvector(std_logic_vector(resize(signed(instruction_in(15 downto 0)),immediate'length))) s11 2);
		if (instruction_in(15) = '1') then
			immediate <= "1111111111111111" & instruction_in(15 downto 0);
		else 
			immediate <= "0000000000000000" & instruction_in(15 downto 0);
		end if;

		ALU_function <= "00000";
                register1_address <= "00000";
                register2_address <= "00000";
                output_register <= "00000";
		writeback_register <= '0';
		branch_control <= "11";
		offset <= '1';
		


        elsif  opcode = "000011" then -- J type
		if (instruction_in(15) = '1') then
			immediate <= "1111111111111111" & instruction_in(15 downto 0);
		else 
			immediate <= "0000000000000000" & instruction_in(15 downto 0);
		end if;

		ALU_function <= "00000";
                register1_address <= "00000";
                register2_address <= "00000";
                output_register <= "00000";
		writeback_register <= '0';
		branch_control <= "11";
		offset <= '1';


        else -- I type
		 	rs := instruction_in(25 downto 21);
            		rt := instruction_in(20 downto 16);
		if (instruction_in(15) = '1') then
			immediate <= "1111111111111111" & instruction_in(15 downto 0);
		else 
			immediate <= "0000000000000000" & instruction_in(15 downto 0);
		end if;
            case (opcode) is

                when "001000" => -- addi OK
                    ALU_function <= "00001";
			use_immediate <= '1';

					
                when "001100" => -- andi 
                    ALU_function <= "00110";
			use_immediate <= '1';

                when "001101" => -- ori
                    ALU_function <= "00111";
			use_immediate <= '1';

                when "001110" => -- xori
                    ALU_function <= "01001";
			use_immediate <= '1';


                when "100011" => -- lw
                    ALU_function <= "00000";
			use_immediate <= '1';
			mem_load <= '1';
			writeback_register <= '1';

                when "001111" => -- lui OK
                    ALU_function <= "10000"; --correct op code?
			use_immediate <= '1';
			writeback_register <= '1';

                when "101011" => -- sw
                    ALU_function <= "00001";
			mem_store <= '1';
			writeback_register <= '0';
			use_immediate <= '1';


                when "000100" => -- beq
                    ALU_function <= "00000";
			use_immediate <= '0';
			branch_control <= "01";

			writeback_register <= '0';


                when "000101" => -- bne
                    ALU_function <= "00000";
			use_immediate <= '0';
			branch_control <= "10";

			
			writeback_register <= '0';

                when others =>
                    ALU_function <= "00000";
                    register1_address <= "00000";
                    register2_address <= "00000";
                    output_register <= "00000";

            end case ;
	          register1_address <= rs;
		output_register <= rt;
        end if ;
    end process ; 




end architecture ; -- arch