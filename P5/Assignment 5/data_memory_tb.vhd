--Tested to make sure data memory initializes to all zero
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY data_memory_tb IS
END data_memory_tb;

ARCHITECTURE behaviour OF data_memory_tb IS

--Declare the component that you are testing:
    COMPONENT data_memory IS
        GENERIC(
            ram_size : INTEGER := 32768/4;
            mem_delay : time := 1 ns;
            clock_period : time := 1 ns
        );
        PORT (
            clock: IN STD_LOGIC;
            writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            address: IN INTEGER RANGE 0 TO ram_size-1;
            memwrite: IN STD_LOGIC := '0';
            memread: IN STD_LOGIC := '0';
            readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            waitrequest: OUT STD_LOGIC
        );
    END COMPONENT;

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
    signal writedata: std_logic_vector(31 downto 0);
    signal address: INTEGER RANGE 0 TO 32768/4-1;
    signal memwrite: STD_LOGIC := '0';
    signal memread: STD_LOGIC := '0';
    signal readdata: STD_LOGIC_VECTOR (31 DOWNTO 0);
    signal waitrequest: STD_LOGIC;

BEGIN

    --dut => Device Under Test
    dut: data_memory GENERIC MAP(
            ram_size => 15
                )
                PORT MAP(
                    clk,
                    writedata,
                    address,
                    memwrite,
                    memread,
                    readdata,
                    waitrequest
                );

    clk_process : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    END PROCESS;

    test_process : process
    BEGIN
        wait for clk_period;
        address <= 14; 
        writedata <= "10000000000000000000000000000001";
        memwrite <= '1';
        
        --waits are NOT synthesizable and should not be used in a hardware design
        wait until rising_edge(waitrequest);
        memwrite <= '0';
        memread <= '1';
        wait until rising_edge(waitrequest);
        assert readdata = "10000000000000000000000000000001" report "write unsuccessful" severity error;
        memread <= '0';
        wait for clk_period;
        address <= 12;memread <= '1';
        wait until rising_edge(waitrequest);
        assert readdata = "00000000000000000000000000000000" report "write unsuccessful" severity error;
        REPORT "If no error, memory was initialized to zero properly";
        memread <= '0';
        wait;

    END PROCESS;

 
END;
