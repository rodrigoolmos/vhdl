library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity random_4bits_generator_tb is
end entity random_4bits_generator_tb;

architecture rtl of random_4bits_generator_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    signal   min    : std_logic := '0';
    
    signal CLK             :  std_logic;
    signal NRST            :  std_logic;
    signal rand4_num       :  std_logic_vector(3 downto 0); 
    
    component random_4bits_generator is
        port(
            CLK             : in     std_logic;
            NRST            : in     std_logic;
            rand4_num       : out std_logic_vector(3 downto 0) 
        );
    end component random_4bits_generator;
    
begin

    sim_time_proc: process
    begin
        NRST <= '0';
        wait for 1 ms;
        NRST <= '1';
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
        wait for 100 ms;
        min <= '1';
        wait for 100 ms;
        min <= '0';
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
    
    u1: random_4bits_generator
    port map
    (
        CLK       => CLK      ,
        NRST      => NRST     ,
        rand4_num => rand4_num
        
    );

end architecture rtl; 