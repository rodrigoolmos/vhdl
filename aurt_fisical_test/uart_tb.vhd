library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tb is
end entity uart_tb;

architecture rtl of uart_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK :            std_logic;
    signal nrst :           std_logic;
    signal rx :             std_logic;
    signal tx :             std_logic;
    signal data_ready_rx :  STD_LOGIC;
    signal ready_tx :       STD_LOGIC;
    signal start_tx :       STD_LOGIC;
    signal byte_tx :        std_logic_vector(7 downto 0);
    signal byte_rx :        std_logic_vector(7 downto 0);
    
    component uart is
        port(
            CLK : in                std_logic;
            nrst : in               std_logic;
            rx : in                 std_logic;
            tx : buffer             std_logic;
            data_ready_rx : buffer  STD_LOGIC;
            ready_tx : buffer       STD_LOGIC;
            start_tx : in           STD_LOGIC;
            byte_tx : in            std_logic_vector(7 downto 0);
            byte_rx : buffer        std_logic_vector(7 downto 0)
        );
    end component uart;
    
begin

    sim_time_proc: process
    begin
        nrst <= '0';
        wait for 1 ns;
        nrst <= '1';

        
        wait for 200 ms;
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
    
    
    data_transmision: process
    begin
        while finished /= '1' loop
            
            start_tx <= '0';
            rx <= '1';
            wait for 10400 us;
            
            -- start bit
            rx <= '0';
            wait for 104 us;
            
            -- data
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;

            -- stop bit
            rx <= '1';
            wait for 104 us;
            
            
            -- start bit
            rx <= '0';
            wait for 104 us;
            
            -- data
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;

            -- stop bit
            rx <= '1';
            wait for 104 us;
            
            
            -- start bit
            rx <= '0';
            wait for 104 us;
            
            -- data
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            rx <= '0';
            wait for 104 us;
            rx <= '1';
            wait for 104 us;
            
            -- stop bit
            rx <= '1';
            wait for 104 us;
            
            wait until rising_edge(clk);
            start_tx <= '1';
            byte_tx <= x"55";
            wait until ready_tx = '1';
            byte_tx <= x"aa";
            wait until ready_tx = '1';
            byte_tx <= x"22";
            wait until ready_tx = '1';
            start_tx <= '0';


        end loop;
        wait;
    end process data_transmision;
    
    u1: uart
    port map
    (
        CLK => CLK,
        nrst => nrst,
        rx => rx,
        tx => tx,
        data_ready_rx => data_ready_rx,
        ready_tx => ready_tx,
        start_tx => start_tx,
        byte_tx => byte_tx,
        byte_rx => byte_rx
    );

end architecture rtl;