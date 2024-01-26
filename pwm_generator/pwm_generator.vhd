library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity pwm_generator is
    generic(
        end_cnt_size : natural := 10;
        duty_cycle_size : natural := 5
    );
    Port ( clk : in STD_LOGIC;
           nrst : in STD_LOGIC;
           pwm : out STD_LOGIC;
           duty_cycle : in STD_LOGIC_VECTOR (duty_cycle_size -1 downto 0);
           end_cnt : in STD_LOGIC_VECTOR (end_cnt_size -1 downto 0));
end pwm_generator;

architecture Behavioral of pwm_generator is
    signal counter : unsigned(end_cnt_size downto 0) := (others => '0');
begin


    counter_pwm: process(CLK, NRST)
    begin
        if NRST = '0' then
            counter <= (others => '0');
        elsif rising_edge(CLK) then
            if counter < unsigned(end_cnt) - 1 then
                counter <= counter + 1;
            else
                counter <= (others => '0');
            end if;
        end if;
    end process counter_pwm;
    
    pwm <= '1' when counter < unsigned(duty_cycle)*unsigned(end_cnt)/(2**duty_cycle_size -1) else '0';

end Behavioral;
