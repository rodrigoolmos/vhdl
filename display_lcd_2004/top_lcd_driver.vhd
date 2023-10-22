library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_lcd_diver is
    port(
        CLK :                   in          std_logic;
        nrst :                  in          std_logic;
        e:                      out         std_logic;
        rs:                     out         std_logic;
        bit_8:                  out         STD_LOGIC_VECTOR(7 downto 0)
    );
end entity top_lcd_diver;

architecture rtl of top_lcd_diver is



    signal send_byte_to_lcd : std_logic;
    signal n_cmd_data :       std_logic;
    signal driver_available:  std_logic;
    signal byte_to_send:      STD_LOGIC_VECTOR(7 downto 0);
    signal counter :unsigned(7 downto 0);

    COMPONENT lcd_diver IS
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
    end component lcd_diver;

begin

    proc_name: process(clk, nrst)
    begin
        if nrst = '0' then
            send_byte_to_lcd <= '0';
            n_cmd_data <= '1';
            counter <= x"2F";
        elsif rising_edge(clk) then
        
            if driver_available = '1' and counter < 57 then
                counter <= counter + 1;
                byte_to_send <= STD_LOGIC_VECTOR(counter); 
                send_byte_to_lcd <= '1';
                n_cmd_data <= '1';
            elsif counter >= 57 then
                send_byte_to_lcd <= '0';
                n_cmd_data <= '1';
            end if;
        end if;
    end process proc_name;


    

    u1 : lcd_diver
    port map (
        CLK              =>  CLK,
        nrst             =>  nrst,
        send_byte_to_lcd =>  send_byte_to_lcd,
        n_cmd_data       =>  n_cmd_data,
        driver_available =>  driver_available,
        byte_to_send     =>  byte_to_send,
        e                =>  e,
        rs               =>  rs,
        bit_8            =>  bit_8
    );

end architecture rtl;