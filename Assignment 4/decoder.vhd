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
        register1_address : out address_type;
        register2_address : out address_type;
        ALU_function : out std_logic_vector (4 downto 0);
        shift_amount : out std_logic_vector(4 downto 0);

        mem_store : out std_logic; --flagged for mem Write
        mem_load : out std_logic; -- flagged for mem load
        output_register : out word_type;
        writeback_register : out word_type; --flaged when result needs to be saved back in registers

    ) ;
end entity ; -- decode

-- Similar ALU functions (ie same ALU_function): 
                            -- add = addi = lw = sw
                            -- slt = slti
                            -- and = andi
                            -- or = ori
                            -- xor = xori
                            -- mfhi = mflo


architecture arch of decoder is


begin

    decoding : process(clk)

    -- variables to hold decoded instruction
    variable opcode : std_logic_vector(5 downto 0);
    variable rs : std_logic_vector(4 downto 0);
    variable rt : std_logic_vector(4 downto 0);
    variable rd : std_logic_vector(4 downto 0);
    variable shamt : std_logic_vector(4 downto 0);-- only used for shift instructions
    variable function : std_logic_vector(5 downto 0);

    begin
        -- retreive opcode from Instruction
        opcode := instruction_in(31 downto 26);

        if opcode = "000000" then --compare function section to see what instruction it is
            rs := instruction_in(25 downto 21);
            rt := instruction_in(20 downto 16);
            rd := instruction_in(15 downto 11);
            shamt := instruction_in(10 downto 6);
            function := instruction_in(5 downto 0);
            mem_store <= '0';
            mem_load <= '0';
            writeback_register <= '1';
            case (function) is

                when "100000" => --add 
                    ALU_function <= "00001";

                when "100010" => --sub 
                    ALU_function <= "00010";

                when "011000" => --mult 
                    ALU_function <= "00011";

                when "011010" => --div 
                    ALU_function <= "00100";

                when "101010" => --stl 
                    ALU_function <= "00101";

                when "100100" => --and 
                    ALU_function <= "00110";

                when "100101" => --or 
                    ALU_function <= "00111";

                when "100111" => --nor 
                    ALU_function <= "01000";

                when "100110" => --xor 
                    ALU_function <= "01001";

                when "010000" => --mfhi
                    ALU_function <= "01011";

                when "010010" => --mflo
                    ALU_function <= "01011";

                when "000000" => --sll (shamt needed)
                    ALU_function <= "01100";

                when "000010" => --srl (shamt needed)
                    ALU_function <= "01101";

                when "000011" => --sra (shamt needed)
                    ALU_function <= "01110";

                when "001000" => --jr
                    ALU_function <= "01111";
                
                when others =>
                    ALU_function <= "00000";
                    register1_address <= "00000";
                    register2_address <= "00000";
                    output_register <= "00000";

            end case;

            --set register outputs
            register1_address <= rs;
            register2_address <= rt;
            output_register <= rd;
            shift_amount <= shamt;

        elsif opcode = "000010" then -- J type instruction



        else if  opcode = "000011" then -- J type



        else -- I type

            case (opcode) is

                when "001000" => -- addi
                    
                    ALU_function <= "00001";

                when "001100" => -- andi
                    ALU_function <= "00110";

                when "001101" => -- ori
                    ALU_function <= "00111";


                when "001110" => -- xori
                    ALU_function <= "01001";


                when "100011" => -- lw
                    ALU_function <= "00001";


                when "001111" => -- lui
                    ALU_function <= "10000";


                when "101011" => -- sw
                    ALU_function <= "00001";


                when "000100" => -- beq
                    ALU_function <= "10001";


                when "000101" => -- bne
                    ALU_function <= 10010";


                when others =>
                    ALU_function <= "00000";
                    register1_address <= "00000";
                    register2_address <= "00000";
                    output_register <= "00000";

            end case ;

        end if ;
    end process ; 

end architecture ; -- arch