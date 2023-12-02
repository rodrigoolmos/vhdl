library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_uart_fisical_test_tb is
end entity full_uart_fisical_test_tb;

architecture rtl of full_uart_fisical_test_tb is
    
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------
    constant frecuencia_oscilador : natural := 12000000; -- hz-- 1/period_time
    constant period_time : time      := 83333 ps;
    constant baud_rate : natural := 9600;
    constant bite_time : time := 1000000/baud_rate * 1 us; -- 104 us;
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------------------------------------
    signal   finished    : std_logic := '0';
    
    signal CLK : std_logic;
    signal nrst : std_logic;
    signal rx   : std_logic;
    signal tx   : std_logic;
    
    component full_uart_fisical_test is
        port(
            CLK : in     std_logic;
            nrst : in std_logic := '0';
            rx : in     std_logic;      -- serial data rx
            tx : out     std_logic      -- serial data tx
        );
    end component full_uart_fisical_test;


    procedure rx_data(
        constant data         : in std_logic_vector(7 downto 0);
        signal rx             : out std_logic
    ) is
    begin
        -- start bit
        rx <= '0';
        -- data
        wait for bite_time ;
        for i in 0 to 7 loop
            rx <= data(i);
            wait for bite_time ;
        end loop;
        -- stop bit
        rx <= '1';
        wait for bite_time ;
    end procedure;
    
begin

    sim_time_proc: process
    begin
        nrst <= '0';
        wait for 1 ns;
        nrst <= '1';
        wait for 10 ns;
        rx_data(x"05",rx);
        rx_data(x"15",rx);
        rx_data(x"25",rx);
        rx_data(x"35",rx);
        rx_data(x"45",rx);
        rx_data(x"55",rx);
        rx_data(x"65",rx);
        rx_data(x"75",rx);
        rx_data(x"85",rx);
        rx_data(x"95",rx);
        rx_data(x"05",rx);
        rx_data(x"15",rx);
        rx_data(x"25",rx);
        rx_data(x"35",rx);
        rx_data(x"45",rx);
        rx_data(x"55",rx);
        rx_data(x"65",rx);
        rx_data(x"75",rx);
        rx_data(x"85",rx);
        rx_data(x"95",rx);
        rx_data(x"95",rx);
        
        wait for 20 ms;
        
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
    
    u1: full_uart_fisical_test
    port map
    (
        CLK => CLK,
        nrst => nrst,
        rx   => rx  ,
        tx   => tx
    );

end architecture rtl;