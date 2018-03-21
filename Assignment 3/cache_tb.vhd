library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_tb is
end cache_tb;

architecture behavior of cache_tb is

component cache is
generic(
    ram_size : INTEGER := 32768
);
port(
    clock : in std_logic;
    reset : in std_logic;

    -- Avalon interface --
    s_addr : in std_logic_vector (31 downto 0);
    s_read : in std_logic;
    s_readdata : out std_logic_vector (31 downto 0);
    s_write : in std_logic;
    s_writedata : in std_logic_vector (31 downto 0);
    s_waitrequest : out std_logic; 

    m_addr : out integer range 0 to ram_size-1;
    m_read : out std_logic;
    m_readdata : in std_logic_vector (7 downto 0);
    m_write : out std_logic;
    m_writedata : out std_logic_vector (7 downto 0);
    m_waitrequest : in std_logic

);
end component;

component memory is 
GENERIC(
    ram_size : INTEGER := 32768;
    mem_delay : time := 10 ns;
    clock_period : time := 1 ns
);
PORT (
    clock: IN STD_LOGIC;
    writedata: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    address: IN INTEGER RANGE 0 TO ram_size-1;
    memwrite: IN STD_LOGIC;
    memread: IN STD_LOGIC;
    readdata: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    waitrequest: OUT STD_LOGIC
);
end component;
	
-- test signals 
signal reset : std_logic := '0';
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;

signal s_addr : std_logic_vector (31 downto 0) := (others =>'0');
signal s_read : std_logic :='0';
signal s_readdata : std_logic_vector (31 downto 0):=(others =>'0');
signal s_write : std_logic:='0';
signal s_writedata : std_logic_vector (31 downto 0):=(others =>'0');
signal s_waitrequest : std_logic;

signal m_addr : integer range 0 to 2147483647;
signal m_read : std_logic;
signal m_readdata : std_logic_vector (7 downto 0);
signal m_write : std_logic;
signal m_writedata : std_logic_vector (7 downto 0);
signal m_waitrequest : std_logic; 


begin

-- Connect the components which we instantiated above to their
-- respective signals.
dut: cache 
port map(
    clock => clk,
    reset => reset,

    s_addr => s_addr,
    s_read => s_read,
    s_readdata => s_readdata,
    s_write => s_write,
    s_writedata => s_writedata,
    s_waitrequest => s_waitrequest,

    m_addr => m_addr,
    m_read => m_read,
    m_readdata => m_readdata,
    m_write => m_write,
    m_writedata => m_writedata,
    m_waitrequest => m_waitrequest
);

MEM : memory
port map (
    clock => clk,
    writedata => m_writedata,
    address => m_addr,
    memwrite => m_write,
    memread => m_read,
    readdata => m_readdata,
    waitrequest => m_waitrequest
);
				

clk_process : process
begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
end process;

test_process : process
begin

reset <= '1';
wait for 5 ns;

-- put your tests here
reset <= '0';
s_read <= '0';
s_write <= '0';
wait for 1 ns;



-- Writing to addr 0, block 0
s_addr <= "00000000000000000000000000000000";
s_writedata <= "00000000000000100100100100100100";
s_write <= '1';

wait for 40 ns;
s_read <= '0';
s_write <= '0';
wait for 20 ns;


-- Writing to addr 0, block 1
s_addr <= "00000000000000000000000000000001";
s_writedata <= "00000000000000011011011011011011";
s_write <= '1';

wait for 40 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;

-- Writing to addr 0, block 2
s_addr <= "00000000000000000000000000000010";
s_writedata <= "00000000000011111111111111111111";
s_write <= '1';

wait for 40 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;

-- Writing to addr 0, block 3
s_addr <= "00000000000000000000000000000011";
s_writedata <= "10000000000011111111110000000001";
s_write <= '1';

wait for 50 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;

-- Reading addr 0, block 1
s_addr <= "00000000000000000000000000000001";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;

-- Writing addr 152, block 0
s_addr <= "00000000000000000100110000000000";
s_writedata <= "11111111111111111111111111111111";
s_write <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;


-- Reading addr 152, block 0
s_addr <= "00000000000000000100110000000000";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 20 ns;

-- Reading addr 0, block 0
s_addr <= "00000000000000000000000000000000";
s_read <= '1';

wait for 75 ns;
s_read <= '0';
s_write <= '0';
wait for 100 ns;

-- Reading addr 0, block 1
s_addr <= "00000000000000000000000000000001";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 20 ns;

-- Reading addr 0, block 2
s_addr <= "00000000000000000000000000000010";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 20 ns;

-- Reading addr 0, block 3
s_addr <= "00000000000000000000000000000011";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 20 ns;

-- Reading addr 152, block 0
s_addr <= "00000000000000000100110000000000";
s_read <= '1';

wait for 55 ns;
s_read <= '0';
s_write <= '0';
wait for 10 ns;

wait;

end process;
	
end;

