library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_lcd_diver_tb is
end entity top_lcd_diver_tb;

architecture rtl of top_lcd_diver_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK :    std_logic;
    signal nrst :   std_logic;
    signal e:       std_logic;
    signal rs:      std_logic;
    signal bit_8:   STD_LOGIC_VECTOR(7 downto 0);
    
    component top_lcd_diver is
        port(
            CLK :                   in          std_logic;
            nrst :                  in          std_logic;
            e:                      out         std_logic;
            rs:                     out         std_logic;
            bit_8:                  out         STD_LOGIC_VECTOR(7 downto 0)
        );
    end component top_lcd_diver;
    
begin

    sim_time_proc: process
    begin
        nrst <= '1';
        wait for 200 us;
        nrst <= '0';
        wait for 200 us;
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
    
    u1 : top_lcd_diver
    port map (
        CLK              =>  CLK,
        nrst             =>  nrst,
        e                =>  e,
        rs               =>  rs,
        bit_8            =>  bit_8
    );

end architecture rtl;