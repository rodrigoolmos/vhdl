library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcd_diver is
    port(
        CLK :                   in          std_logic;
        nrst :                  in          std_logic;
        send_byte_to_lcd :      in          std_logic;
        n_cmd_data :            in          std_logic; -- cmd 0 data 1
        driver_available:       out         std_logic;
        byte_to_send:           in          STD_LOGIC_VECTOR(7 downto 0);
        e:                      out         std_logic;
        rs:                     out         std_logic;
        bit_8:                  out         STD_LOGIC_VECTOR(7 downto 0)
    );
end entity lcd_diver;

architecture rtl of lcd_diver is
    signal counter :unsigned(31 downto 0);

    type t_State is (off,config_8bit,line_4,enable_cursor,blink_cursor,
            idle,write_command,write_data);
        signal State : t_State;

    begin

        proc_name: process(clk, nrst)
        begin
            if nrst = '0' then
                State <= off;
                counter <= (others => '0');
                e <= '0';
                rs <= '0';
                bit_8 <= (others => '0');
                driver_available <= '0';

            elsif rising_edge(clk) then

                case State is
                    when off =>
                        State <= config_8bit;
                        e <= '0';
                        rs <= '0';
                        bit_8 <= (others => '0');
                    when config_8bit =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= "00110000";
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '0';
                            bit_8 <= "00110000";
                            counter <= (others => '0');
                            State <= line_4;
                        end if;

                    when line_4 =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= "00111000";
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '0';
                            bit_8 <= "00111000";
                            counter <= (others => '0');
                            State <= enable_cursor;
                        end if;

                    when enable_cursor =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= "00001110";
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '0';
                            bit_8 <= "00001110";
                            counter <= (others => '0');
                            State <= blink_cursor;
                        end if;
                    when blink_cursor =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= "00001111";
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '0';
                            bit_8 <= "00001111";
                            counter <= (others => '0');
                            driver_available <= '1';
                            State <= idle;
                        end if;
                        
                    when idle =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= (others => '0');
                        
                        if send_byte_to_lcd = '1' then
                            driver_available <= '0';
                            if n_cmd_data = '0' then
                                State <= write_command;
                            else
                                State <= write_data;
                            end if;
                            
                        end if;
                        
                    when write_data =>
                        e <= '0';
                        rs <= '1';
                        bit_8 <= byte_to_send;
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '1';
                            bit_8 <=  byte_to_send;
                            counter <= (others => '0');
                            driver_available <= '1';
                            State <= idle;
                        end if;
                    when write_command =>
                        e <= '0';
                        rs <= '0';
                        bit_8 <= byte_to_send;
                        if counter < 12000 then
                            counter <= counter + 1;
                            if counter > 10000 then
                                e <= '1';
                            else
                                e <= '0';
                            end if;
                        else
                            rs <= '0';
                            bit_8 <=  byte_to_send;
                            counter <= (others => '0');
                            driver_available <= '1';
                            State <= idle;
                        end if;
                    when others =>
                end case;

                
            end if;
        end process proc_name;

    end architecture rtl;