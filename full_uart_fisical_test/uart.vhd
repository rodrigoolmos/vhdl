-- 12 MHz oscilator

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart is
    generic(
        frecuencia_oscilador : natural := 12000000; -- if you oscilator speed is diferent edit this parameter MHz
        baud_rate : natural := 9600 -- if what a diferent baud_rate edit this parameter baud rate
    );
    port(
        CLK : in     std_logic;
        nrst : in     std_logic;
        rx : in     std_logic;      -- seria ldata rx
        tx : buffer     std_logic;  -- seria ldata tx
        data_ready_rx : buffer STD_LOGIC;  -- one clock cicle when I have data ready
        ready_tx : buffer STD_LOGIC;       -- stuc at 1 when I can tx data
        start_tx : in STD_LOGIC;            -- triggers the transmision
        byte_tx : in std_logic_vector(7 downto 0) := x"00"; -- paralele data tx
        byte_rx : buffer std_logic_vector(7 downto 0)       -- paralele data tx
    );
end entity uart;

architecture rtl of uart is
    
    constant bit_cicles : natural := frecuencia_oscilador/baud_rate;
    
    
    
    type estado_uart_rx is (idle_rx,str_rx,b0_rx,b1_rx,b2_rx,b3_rx,b4_rx,b5_rx,b6_rx,b7_rx,stop_rx);
    signal est_actual_rx: estado_uart_rx:=idle_rx;
    signal counter_rx : natural range 0 to 3*bit_cicles/2 := 0;
    
    type estado_uart_tx is (idle_tx,str_tx,b0_tx,b1_tx,b2_tx,b3_tx,b4_tx,b5_tx,b6_tx,b7_tx,stop_tx);
    signal est_actual_tx: estado_uart_tx:=idle_tx;
    signal counter_tx : natural range 0 to 3*bit_cicles/2 := 0;

    

begin
    
    
    tx_uart: process(clk,nrst)
    begin
        if nrst = '0' then
            ready_tx <= '1';
            tx <= '1';
            counter_tx <= 0;
        elsif rising_edge(clk) then

            case est_actual_tx is
                when idle_tx =>
                    tx <= '1';
                    if start_tx = '1' then
                        est_actual_tx <= str_tx;
                        ready_tx <= '0';
                    end if;
                when str_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= '0';
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b0_tx;

                    end if;
                    
                when b0_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(0);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b1_tx;
                    end if;
                    
                when b1_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(1);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b2_tx;
                    end if;
                    
                when b2_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(2);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b3_tx;
                    end if;
                    
                when b3_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(3);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b4_tx;
                    end if;
                    
                when b4_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(4);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b5_tx;
                    end if;
                    
                when b5_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(5);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b6_tx;
                    end if;
                when b6_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(6);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= b7_tx;
                    end if;
                when b7_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= byte_tx(7);
                    else
                        counter_tx <= 0;
                        est_actual_tx <= stop_tx;
                    end if;
                    
                when stop_tx =>
                    if counter_tx < bit_cicles then
                        counter_tx <= counter_tx + 1;
                        tx <= '1';
                    else
                        counter_tx <= 0;
                        ready_tx <= '1';
                        est_actual_tx <= idle_tx;
                    end if;
                when others =>
            end case;
        end if;
    end process tx_uart;
    



    rx_uart: process(clk,nrst)
    begin
        if nrst = '0' then
            data_ready_rx <= '0';
            byte_rx <= (others => '0');
            counter_rx <= 0;
        elsif rising_edge(clk) then
            
            case est_actual_rx is
                when idle_rx =>
                    data_ready_rx <= '0';
                    if rx = '0' then
                        est_actual_rx <= str_rx;
                    end if;
                when str_rx =>
                    if counter_rx < bit_cicles/2 then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b0_rx;
                        counter_rx <= 0;
                    end if;
                when b0_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b1_rx;
                        counter_rx <= 0;
                        byte_rx(0) <= rx;
                    end if;
                when b1_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b2_rx;
                        counter_rx <= 0;
                        byte_rx(1) <= rx;
                    end if;
                when b2_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b3_rx;
                        counter_rx <= 0;
                        byte_rx(2) <= rx;
                    end if;
                when b3_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b4_rx;
                        counter_rx <= 0;
                        byte_rx(3) <= rx;
                    end if;
                when b4_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b5_rx;
                        counter_rx <= 0;
                        byte_rx(4) <= rx;
                    end if;
                when b5_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b6_rx;
                        counter_rx <= 0;
                        byte_rx(5) <= rx;
                    end if;
                when b6_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= b7_rx;
                        counter_rx <= 0;
                        byte_rx(6) <= rx;
                    end if;
                    
                when b7_rx =>
                    if counter_rx < bit_cicles then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= stop_rx;
                        counter_rx <= 0;
                        byte_rx(7) <= rx;
                    end if;
                when stop_rx =>
                    if counter_rx < 3*bit_cicles/2 then
                        counter_rx <= counter_rx + 1;
                    else
                        est_actual_rx <= idle_rx;
                        counter_rx <= 0;
                        data_ready_rx <= '1';
                    end if;
                when others =>
            end case;
        end if;
    end process rx_uart;
    

end architecture rtl;