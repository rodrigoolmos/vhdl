library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity deboundcer_tb is
end entity deboundcer_tb;

architecture rtl of deboundcer_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK                          : std_logic;
    signal nsrt                         : std_logic;
    signal pulsation                    : std_logic;
    signal conformed_pulsation          : std_logic;
    
    component deboundcer is
        generic(
            clk_tic_skip : natural := 120000
        );
        port(
            CLK                         : in  std_logic;
            nsrt                        : in  std_logic;
            pulsation                   : in  std_logic;
            conformed_pulsation         : out std_logic := '0'
        );
    end component deboundcer;
    
begin

    sim_proc: process
    begin
        pulsation <= '0';
        nsrt <= '0';
        wait for 200 us;
        nsrt <= '1';
        wait for 100 ms;
        pulsation <= '1';
        wait for 500 us;
        pulsation <= '0';
        wait for 200 us;
        pulsation <= '1';
        wait for 200 us;
        pulsation <= '0';
        wait for 2   ms;
        pulsation <= '1';
        wait for 200 us;
        pulsation <= '0';
        wait for 200 us;
        pulsation <= '1';
        wait for 200 ms;
        pulsation <= '1';
        wait for 200 us;
        pulsation <= '0';
        wait for  1  ms;
        pulsation <= '1';
        wait for 500 us;
        pulsation <= '0';
        wait for  2  ms;
        pulsation <= '1';
        wait for 200 us;
        pulsation <= '0';
        wait for 100 ms;
        
        finished <= '1';
        wait;
    end process sim_proc;

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
    
    u1: deboundcer
    port map
    (
        CLK                        => CLK                       ,
        nsrt                       => nsrt                      ,
        pulsation                  => pulsation                 ,
        conformed_pulsation => conformed_pulsation
    );

end architecture rtl;