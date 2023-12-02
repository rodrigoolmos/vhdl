library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simon_dice_logic_tb is
end entity simon_dice_logic_tb;

architecture rtl of simon_dice_logic_tb is
    
    constant period_time : time      := 83333 ps;
    constant clk_config_sim : natural:= 120;
    signal   finished    : std_logic := '0';
    
    signal CLK                  : std_logic;
    signal NRST                 : std_logic;
    signal random               : std_logic_vector(3 downto 0);
    signal bottons_conformed    : std_logic_vector(3 downto 0);
    signal game_over            : std_logic;
    signal game_completed       : std_logic;
    signal cuadrant_on          : std_logic_vector(3 downto 0);
    signal tone_buzz            : std_logic_vector(3 downto 0);
    signal leds                 : std_logic_vector(7 downto 0);
    
    component simon_dice_logic is
        generic(
            clk_config : natural := 120
        );
        port(
            CLK                     : in    std_logic;
            NRST                    : in    std_logic;
            random                  : in    std_logic_vector(3 downto 0);
            bottons_conformed       : in    std_logic_vector(3 downto 0);
            game_over               : out   std_logic;
            game_completed          : out   std_logic;
            cuadrant_on             : out   std_logic_vector(3 downto 0);
            tone_buzz               : out   std_logic_vector(3 downto 0);
            leds                    : out   std_logic_vector(7 downto 0)
        );
    end component simon_dice_logic;
    
    procedure pres_button(
        constant data              : in std_logic_vector(3 downto 0);
        signal bottons_conformed   : out std_logic_vector(3 downto 0)
    ) is
    begin
        wait for clk_config_sim*period_time/2;
        bottons_conformed <= data;
        wait until rising_edge(CLK);
        bottons_conformed <= "0000";
    end procedure;
    
    procedure write_random(
        constant data              : in std_logic_vector(3 downto 0);
        signal random              : out std_logic_vector(3 downto 0)
    ) is
    begin
        wait until rising_edge(CLK);
        random <= data;
        wait for clk_config_sim*period_time;

    end procedure;
begin

    sim_time_proc: process
    begin
        NRST <= '0';
        bottons_conformed <= "0000";
        random <= "0000";
        wait for period_time;
        wait until rising_edge(CLK);
        NRST <= '1';
        
        --lvl 1
        write_random("0001",random);
        pres_button("0001", bottons_conformed);
        
        --lvl 2
        write_random("0010",random);
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        
        --lvl 3
        write_random("0100",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        
        --lvl 4
        write_random("1000",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);

        
        --lvl 5
        write_random("0100",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0100", bottons_conformed);

        --lvl 6
        write_random("0001",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("0001", bottons_conformed);

        
        --lvl 7
        write_random("0100",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("0100", bottons_conformed);

        
        --lvl 8
        write_random("1000",random);
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        wait for clk_config_sim*period_time;
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);

        
        
        
        
        
        wait for 10*clk_config_sim*period_time;
        
         --lvl 1
        write_random("0010",random);
        pres_button("0010", bottons_conformed);
        
        --lvl 2
        write_random("0100",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        
        --lvl 3
        write_random("1000",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        
        --lvl 4
        write_random("0001",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);

        
        --lvl 5
        write_random("1000",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("1000", bottons_conformed);

        --lvl 6
        write_random("0010",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0010", bottons_conformed);

        
        --lvl 7
        write_random("1000",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("1000", bottons_conformed);

        
        --lvl 8
        write_random("0001",random);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("1000", bottons_conformed);
        pres_button("0001", bottons_conformed);
        
        
        wait for 10*clk_config_sim*period_time;
        
        
        write_random("0100",random);
        pres_button("1000", bottons_conformed);
        
        
        wait for 10*clk_config_sim*period_time;
        
                --lvl 1
        write_random("0001",random);
        pres_button("0001", bottons_conformed);
        
        --lvl 2
        write_random("0010",random);
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        
        --lvl 3
        write_random("0100",random);
        pres_button("0001", bottons_conformed);
        pres_button("0010", bottons_conformed);
        pres_button("0100", bottons_conformed);
        
        wait for 10*clk_config_sim*period_time;
        
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
    
    u1: simon_dice_logic
    port map
    (
        CLK                 => CLK           ,
        NRST                => NRST          ,
        random              => random        ,
        bottons_conformed   => bottons_conformed       ,
        game_over           => game_over     ,
        game_completed      => game_completed,
        cuadrant_on         => cuadrant_on   ,
        tone_buzz           => tone_buzz ,
        leds                => leds
    );

end architecture rtl;