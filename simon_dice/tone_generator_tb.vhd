library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tone_generator_tb is
end entity tone_generator_tb;

architecture rtl of tone_generator_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK         : std_logic;
    signal NRST        : std_logic;
    signal tone_type   : std_logic_vector(3 downto 0);
    signal pwm         : std_logic := '0';
    
    component tone_generator is
        generic(
            max_tono : natural := 12000
        );
        port(
            CLK         : in     std_logic;
            NRST        : in     std_logic;
            tone_type   : in     std_logic_vector(3 downto 0);
            pwm         : out    std_logic := '0'
        );
    end component tone_generator;
    
begin

    sim_time_proc: process
    begin
        NRST <= '0';
        wait for 1 ms;
        NRST <= '1';
        tone_type <= "0001";
        wait for 100 ms;
        tone_type <= "0010";
        wait for 100 ms;
        tone_type <= "0100";
        wait for 100 ms;
        tone_type <= "1000";
        wait for 100 ms;
        tone_type <= "0000";
        wait for 100 ms;
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
    
    u1: tone_generator
    port map
    (
        CLK        =>  CLK      ,
        NRST       =>  NRST     ,
        tone_type  =>  tone_type,
        pwm        =>  pwm
    );

end architecture rtl;