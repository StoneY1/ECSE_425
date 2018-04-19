library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.definitions.all;

entity MemoryStage is

port(
    clk : in std_logic;
    ALU_value_out : in word_type;
    store_enable, load_enable, write_back_enable_in : in std_logic;
    dest_register_in : in register_type;
    mem_data_in : in word_type;

    ALU_value_forwarded : out word_type;
    dest_register_out : out register_type;
    write_back_enable_out : out std_logic;
    mem_out: out word_type
);

end MemoryStage;

architecture behaviour of MemoryStage is
component data_memory 
GENERIC(
		ram_size : INTEGER := 32768/4; --modified size of ram so that each entry of array is a 32-bit word while preserving size at 32768 bytes
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns
	);
port(
    clock: IN STD_LOGIC;
    writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0); --Processor will read and write 32-bits at a time.
    address: IN INTEGER;
    memwrite: IN STD_LOGIC;
    readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)      
);
end component;

component two_one_mux port(
    sel : in std_logic;
    in1, in2 : in std_logic_vector(31 downto 0);
    outputMux : out std_logic_vector(31 downto 0)
);
end component;
--signal declarations
signal mem_address : integer := 0;
signal read_out : word_type;

begin
mem_address <= to_integer(unsigned(ALU_value_out));
ALU_value_forwarded <= ALU_value_out;

main_memory : data_memory port map(
							clock => clk,
							address => mem_address,
							writedata => mem_data_in,
							memwrite => store_enable,
							readdata => read_out
								);
mux : two_one_mux port map(
							
							in1 => ALU_value_out,
							in2 => read_out,
							sel => load_enable,
							outputMux => mem_out
								);
dest_register_out <= dest_register_in;
write_back_enable_out <= write_back_enable_in;

end behaviour;
