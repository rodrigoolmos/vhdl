library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity driver_display_4x7_tb is
end entity driver_display_4x7_tb;

architecture rtl of driver_display_4x7_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK                     : STD_LOGIC;
    signal NRST                    : STD_LOGIC;
    signal game_over               : std_logic;
    signal game_completed          : std_logic;
    signal cuadrant_on             : std_logic_vector(3 downto 0);
    signal active_display          : std_logic_vector(3 downto 0);
    signal digitu                  : std_logic_vector(3 downto 0);
    signal digitd                  : std_logic_vector(3 downto 0);
    signal digitc                  : std_logic_vector(3 downto 0);
    signal digitm                  : std_logic_vector(3 downto 0);
    
    component driver_display_4x7 is
        port(
            CLK                     : in STD_LOGIC;
            NRST                    : in STD_LOGIC;
            game_over               : in std_logic;
            game_completed          : in std_logic;
            cuadrant_on             : in std_logic_vector(3 downto 0);
            active_display          : out std_logic_vector(3 downto 0);
            digitu                  : out std_logic_vector(3 downto 0);
            digitd                  : out std_logic_vector(3 downto 0);
            digitc                  : out std_logic_vector(3 downto 0);
            digitm                  : out std_logic_vector(3 downto 0)
        );
    end component driver_display_4x7;
    
begin

    sim_time_proc: process
    begin
        game_over <= '0';
        game_completed <= '0';
        cuadrant_on <= "0000";
        NRST <= '0';
        wait for 20 us;
        NRST <= '1';
        wait for 20 us;
        game_over <= '0';
        game_completed <= '0';
        cuadrant_on <= "0001";
        wait for 200 us;
        game_over <= '0';
        game_completed <= '0';
        cuadrant_on <= "0010";
        wait for 200 us;
        game_over <= '0';
        game_completed <= '0';
        cuadrant_on <= "0100";
        wait for 200 us;
        game_over <= '0';
        game_completed <= '0';
        cuadrant_on <= "1000";
        wait for 200 us;
        game_over <= '0';
        game_completed <= '1';
        cuadrant_on <= "0001";
        wait for 200 us;
        game_over <= '1';
        game_completed <= '0';
        cuadrant_on <= "0001";
        wait for 200 us;
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
    
    u1: driver_display_4x7
    port map
    (
        CLK            => CLK           ,
        NRST           => NRST          ,
        game_over      => game_over     ,
        game_completed => game_completed,
        cuadrant_on    => cuadrant_on   ,
        active_display => active_display,
        digitu         => digitu        ,
        digitd         => digitd        ,
        digitc         => digitc        ,
        digitm         => digitm        
    );

end architecture rtl; 