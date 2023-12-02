library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fullbridge_driver is
    generic(
        oscillator_frequency    : integer := 12000000;
        duty_cycle              : integer := 10;
        dead_time_clk_clicles   : integer := 6;
        driver_frequency        : integer := 100000
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
end entity fullbridge_driver;

architecture rtl of fullbridge_driver is
    constant period : integer := oscillator_frequency/driver_frequency - 1;
    constant scaler : integer := 1;
    signal counter : integer range 0 to period := 0;
    signal offset_clk_clicles : integer range 0 to period/2;
begin

    process(clk,nrst)
    begin
        if nrst = '0' then
            counter <= 0;
        elsif rising_edge(clk) then
            if counter < period then
                counter <= counter + 1;
            else
                counter <= 0;

            end if;
        end if;
    end process;
    
    process(clk,nrst)
    begin
        if nrst = '0' then
            offset_clk_clicles <= 0;
        elsif  rising_edge(clk) then
            if up = '1' and offset_clk_clicles < period/2 - scaler then
                offset_clk_clicles <= offset_clk_clicles + scaler;
            elsif down = '1' and offset_clk_clicles > scaler then
                offset_clk_clicles <= offset_clk_clicles - scaler;

            end if;
        end if;
    end process;
    
    
    signal1 <= '1' when counter <= period*duty_cycle/100 - dead_time_clk_clicles else '0';
    
    signal2 <= '1' when counter <= period*duty_cycle/100 - dead_time_clk_clicles + offset_clk_clicles and
    counter >= offset_clk_clicles else '0'; -- offset signal 1
    
    signal3 <= '1' when counter > period*duty_cycle/100 and counter <= period - dead_time_clk_clicles else '0' ; -- complementary signal1
    
    signal4 <= '1' when (counter > period*duty_cycle/100 + offset_clk_clicles and  counter <= period + offset_clk_clicles - dead_time_clk_clicles) or
    (counter < offset_clk_clicles - dead_time_clk_clicles) else '0'; -- complementary signal2 -- offset signal 3


end architecture rtl;