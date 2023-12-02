library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tone_generator is
    generic(
        max_tono : natural := 1200000
    );
    port(
        CLK         : in     std_logic;
        NRST        : in     std_logic;
        tone_type   : in     std_logic_vector(3 downto 0);
        pwm         : out    std_logic := '0'
    );
end entity tone_generator;

architecture rtl of tone_generator is
    signal counter : natural range 0 to max_tono := 0;
begin

    blink: process(clk)
    begin
        if rising_edge(clk) then
            case tone_type is
                when "0001" =>
                    if counter < max_tono then
                        counter <= counter + 1;
                        if counter < max_tono/2 then
                            pwm <= '1';
                        else
                            pwm <= '0';
                        end if;
                    else
                        counter <= 0;
                    end if;
                when "0010" =>
                    if counter < 2*max_tono/8 then
                        counter <= counter + 1;
                        if counter < max_tono/8 then
                            pwm <= '1';
                        else
                            pwm <= '0';
                        end if;
                    else
                        counter <= 0;
                    end if;
                when "0100" =>
                    if counter < 3*max_tono/8 then
                        counter <= counter + 1;
                        if counter < 3*max_tono/16 then
                            pwm <= '1';
                        else
                            pwm <= '0';
                        end if;
                    else
                        counter <= 0;
                    end if;
                when "1000" =>
                    if counter < 4*max_tono/8 then
                        counter <= counter + 1;
                        if counter < 2*max_tono/8 then
                            pwm <= '1';
                        else
                            pwm <= '0';
                        end if;
                    else
                        counter <= 0;
                    end if;
                when others =>
                    pwm <= '0';
            end case;

        end if;
    end process blink;

end architecture rtl;