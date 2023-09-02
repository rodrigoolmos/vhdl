-- test fisico realizado con una orange pi 5 plus y una max1000
-- los bytes inviados con la orange pi 5 se representan en los leds de la max1000
-- la max1000 tambien contesta con el ultimo byte recivido cada vez que recive uno nuevo
-- funciona tanto en rafaga como de byte en byte

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_slave_fisical_test is
    port(
        CLK : in     std_logic;
        leds : buffer STD_LOGIC_VECTOR(7 downto 0);
        nrst : in        std_logic;
        mosi : in       STD_LOGIC;
        miso : buffer   STD_LOGIC;
        cs : in         STD_LOGIC;
        sclk : in       STD_LOGIC
    );
end entity spi_slave_fisical_test;

architecture rtl of spi_slave_fisical_test is
    
    signal byte_recived : std_logic_vector(7 downto 0);
    signal byte_recived_ready : std_logic;
    signal byte_2_send : std_logic_vector(7 downto 0) := "01000010";
    signal send_byte :      STD_LOGIC;
    signal ready_2_send_byte :    STD_LOGIC;
    type estado_spi is (waiting,pointing,transmiting);
    signal est_actual: estado_spi:=waiting;
    
    component spi_slave is
        port(
            CLK : in        std_logic;
            nrst : in        std_logic;
            byte_recived : buffer STD_LOGIC_VECTOR(7 downto 0);
            byte_recived_ready : buffer STD_LOGIC;
            byte_2_send : in STD_LOGIC_VECTOR(7 downto 0);
            send_byte : in       STD_LOGIC;
            ready_2_send_byte : buffer   STD_LOGIC;
            mosi : in       STD_LOGIC;
            miso : buffer   STD_LOGIC;
            cs : in         STD_LOGIC;
            sclk : in       STD_LOGIC
        );
    end component spi_slave;
begin
    
    
    process(clk,nrst)
    begin
        if nrst = '0' then
            est_actual <=  waiting;
        elsif rising_edge(clk) then
            if byte_recived_ready = '1' then
                byte_2_send <= leds;
                send_byte <= '1';
            end if;
        end if;
    end process;
    

    leds <= byte_recived;
    
    u1: spi_slave
    port map
    (
        CLK => CLK,
        nrst => nrst,
        byte_recived => byte_recived,
        byte_recived_ready => byte_recived_ready,
        byte_2_send => byte_2_send,
        send_byte => send_byte,
        ready_2_send_byte => ready_2_send_byte,
        mosi => mosi,
        miso => miso,
        cs => cs,
        sclk => sclk
    );
end architecture rtl;