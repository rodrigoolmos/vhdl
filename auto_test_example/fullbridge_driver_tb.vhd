library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fullbridge_driver_tb is
end entity fullbridge_driver_tb;

architecture rtl of fullbridge_driver_tb is
    
    constant period_time : time      := 83333 ps;
    constant check_size  : NATURAL     := 19;
    constant security_ofset_clk_cicles : NATURAL     := 5;
    signal   finished    : std_logic := '0';
    
    signal CLK        :     std_logic;
    signal NRST       :     std_logic;
    signal up         :     std_logic;
    signal down       :     std_logic;
    signal signal1    :     std_logic;
    signal signal2    :     std_logic;
    signal signal3    :     std_logic;
    signal signal4    :     std_logic;
    signal signal1_t  :     std_logic_vector(check_size downto 0);
    signal signal2_t  :     std_logic_vector(check_size downto 0);
    signal signal3_t  :     std_logic_vector(check_size downto 0);
    signal signal4_t  :     std_logic_vector(check_size downto 0);
    
    component fullbridge_driver is
        generic(
            oscillator_frequency    : natural := 12000000;
            duty_cycle              : natural := 50;
            dead_time_clk_clicles   : natural := 6;
            driver_frequency        : natural := 100000
        );
        port(
            CLK                     : in     std_logic;
            NRST                    : in     std_logic;
            up                      : in     std_logic;
            down                    : in     std_logic;
            signal1                 : out    std_logic;
            signal2                 : out    std_logic;
            signal3                 : out    std_logic;
            signal4                 : out    std_logic
        );
    end component fullbridge_driver;
    
    procedure up_pulsation(
        signal up : out std_logic 
    ) is
    begin
        up <= '0';
        wait until rising_edge(clk);
        up <= '1';
        wait until rising_edge(clk);
        up <= '0';
    end procedure;
    
    procedure down_pulsation(
        signal down : out std_logic 
    ) is
    begin
        down <= '0';
        wait until rising_edge(clk);
        down <= '1';
        wait until rising_edge(clk);
        down <= '0';
    end procedure;
    
begin

    sim_time_proc: process
    begin
        NRST <= '0';
        up <= '0';
        down <= '0';
        wait for 2 us;
        NRST <= '1';
        for i in 1 to 70 loop
            wait until rising_edge(signal2);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal2);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal2);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal2);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal1);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal1);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal1);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal1);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal4);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal4);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal4);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal4);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal3);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until rising_edge(signal3);
            down_pulsation(down);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal3);
            up_pulsation(up);
        end loop;
        for i in 1 to 70 loop
            wait until falling_edge(signal3);
            down_pulsation(down);
        end loop;
        for time in 1000 to 2000 loop
            for i in 1 to 70 loop
                up_pulsation(up);
                wait for time * 1 us;
            end loop;
            for i in 1 to 70 loop
                down_pulsation(down);
                wait for time * 1 us;
            end loop;
        end loop;

        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            CLK <= '0';
            wait for period_time/2;
            CLK <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    
    process(clk)
    begin
        if nrst = '0' then
            signal1_t <= (others => '0');
            signal2_t <= (others => '0');
            signal3_t <= (others => '0');
            signal4_t <= (others => '0');
        elsif rising_edge(clk) then
            signal1_t <= signal1_t(check_size - 1 downto 0)&signal1;
            signal2_t <= signal2_t(check_size - 1 downto 0)&signal2;
            signal3_t <= signal3_t(check_size - 1 downto 0)&signal3;
            signal4_t <= signal4_t(check_size - 1 downto 0)&signal4;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to security_ofset_clk_cicles - 1 loop
                assert not (signal1_t(i) = '1' and signal3 = '1') report "ERROR signal1_t1 1 - 3 distance = " & integer'Image(i) severity warning;
                assert not (signal1 = '1' and signal3_t(i) = '1') report "ERROR signal3_t1 1 - 3 distance = " & integer'Image(i) severity warning;
                assert not (signal2_t(i) = '1' and signal4 = '1') report "ERROR signal2_t1 2 - 4 distance = " & integer'Image(i) severity warning;
                assert not (signal2 = '1' and signal4_t(i) = '1') report "ERROR signal4_t1 2 - 4 distance = " & integer'Image(i) severity warning;
            end loop;
            assert not (signal2 = '1' and signal4 = '1') report "ERROR SHORT CIRCUIT 2 - 4" severity ERROR;
            assert not (signal1 = '1' and signal3 = '1') report "ERROR SHORT CIRCUIT 1 - 3" severity ERROR;
        end if;
    end process;
    
    
    u1: fullbridge_driver
    port map
    (
        CLK => CLK,
        NRST =>  NRST,
        up => up,
        down => down,
        signal1 => signal1,
        signal2 => signal2,
        signal3 => signal3,
        signal4 => signal4
    );

end architecture rtl;