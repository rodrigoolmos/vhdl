-- little endian
-- el byte se envia mientras que la señal send_byte esta a 1 y cs a 0 si si se baja la señal send_byte se cancela la transferencia del byte

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_slave is
    port(
        CLK : in        std_logic;
        nrst : in        std_logic;
        -- signals tu rx
        byte_recived : buffer STD_LOGIC_VECTOR(7 downto 0);
        byte_recived_ready : buffer STD_LOGIC;
        -- signals tu tx
        byte_2_send : in STD_LOGIC_VECTOR(7 downto 0);
        send_byte : in       STD_LOGIC;
        ready_2_send_byte : buffer   STD_LOGIC;
        -- external interface signals
        mosi : in       STD_LOGIC;
        miso : buffer   STD_LOGIC;
        cs : in         STD_LOGIC;
        sclk : in       STD_LOGIC
    );
end entity spi_slave;

architecture rtl of spi_slave is
    signal sclk_t1 : STD_LOGIC;
    signal read_data : STD_LOGIC;
    signal write_data : STD_LOGIC;


    signal counter_bits_send : integer range 0 to 15 := 0;
    signal counter_bits_recived : integer range 0 to 15 := 0;

begin
    
    process(clk,nrst)
    begin
        if nrst = '0' then
            sclk_t1 <= '0';
        elsif rising_edge(clk) then
            sclk_t1 <= sclk;
        end if;
    end process;

    process(clk,nrst)
    begin
        if nrst = '0' then
            byte_recived <= (others => '0');
        elsif rising_edge(clk) then
            
            if cs = '0' then
                
                if read_data = '1' and counter_bits_recived < 8 then
                    byte_recived(0) <= mosi;
                    byte_recived(7 downto 1) <= byte_recived(6 downto 0);

                    counter_bits_recived <= counter_bits_recived + 1;
                    byte_recived_ready <= '0';
                elsif counter_bits_recived = 8  then
                    counter_bits_recived <= 0;
                    byte_recived_ready <= '1';
                else
                    byte_recived_ready <= '0';
                end if;
            else
                counter_bits_recived <= 0;
            end if;

        end if;
    end process;
    
    
    process(clk,nrst)
    begin
        if nrst = '0' then
            counter_bits_send <= 1;
        elsif rising_edge(clk) then
            if cs = '1' then
                counter_bits_send <= 0;
            elsif send_byte = '0' and counter_bits_send = 8 and write_data = '1' then
                counter_bits_send <= 0;
            elsif send_byte = '1' and cs = '0' and counter_bits_send = 0 then
                counter_bits_send <= 1;
            elsif send_byte = '1' and cs = '0' and counter_bits_send < 8 and write_data = '1' then
                counter_bits_send <= counter_bits_send + 1;
            elsif send_byte = '1' and cs = '0' and counter_bits_send = 8 and write_data = '1' then
                counter_bits_send <= 1;
            end if;
        end if;
    end process;
    
    ready_2_send_byte <= '1' when (counter_bits_send = 8 and write_data = '1') or counter_bits_send = 0 else  '0';

    miso <=
    byte_2_send(0) when counter_bits_send = 8 else
    byte_2_send(1) when counter_bits_send = 7 else
    byte_2_send(2) when counter_bits_send = 6 else
    byte_2_send(3) when counter_bits_send = 5 else
    byte_2_send(4) when counter_bits_send = 4 else
    byte_2_send(5) when counter_bits_send = 3 else
    byte_2_send(6) when counter_bits_send = 2 else
    byte_2_send(7) when counter_bits_send = 1 else
    '0';
    
    read_data <= '1' when sclk_t1 = '0' and sclk = '1' else '0';
    write_data <= '1' when sclk_t1 = '1' and sclk = '0' else '0';

end architecture rtl;