library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_slave_tb is
end entity spi_slave_tb;

architecture rtl of spi_slave_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK : std_logic;
    signal byte_recived : std_logic_vector(7 downto 0);
    signal byte_recived_ready : std_logic;
    signal byte_2_send : std_logic_vector(7 downto 0);
    signal send_byte :      STD_LOGIC;
    signal ready_2_send_byte :    STD_LOGIC;
    signal mosi : std_logic;
    signal miso : std_logic;
    signal cs : std_logic;
    signal nrst : std_logic;
    signal sclk : std_logic;
    
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

    sim_time_proc: process
    begin
        nrst <= '0';
        wait for 1 us;
        nrst <= '1';
        wait for 200 ms;
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
    
    
    data_transmision: process
    begin
        while finished /= '1' loop
            
            cs <= '1';
            send_byte <= '0';
            sclk <= '1';
            wait for 100 us;
            cs <= '0';

            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            
            -- bit 0
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            sclk <= '0';



            
            -- send bytes
            cs <= '1';
            wait for 1000 us;
            byte_2_send <= "11001100";
            cs <= '0';
            send_byte <= '1';

            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            sclk <= '0';

            
            cs <= '1';
            send_byte <= '0';
            
            
            
            
             -- send bytes
            wait for 900 us;
            send_byte <= '1';
            wait for 100 us;
            byte_2_send <= "01010101";
            cs <= '0';

            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;

            
            byte_2_send <= "11000011";

            
            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            sclk <= '0';

            
            cs <= '1';
            
            wait for 100 us;
            send_byte <= '0';
            
            wait for 900 us;
            
            cs <= '0';

            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '0';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- send after reciving
            send_byte <= '1';
            byte_2_send <= "11000011";

            
            -- bit 0
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 1
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 2
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 3
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 4
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 5
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 6
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            
            -- bit 7
            mosi <= '1';
            sclk <= '0';
            wait for 10 us;
            sclk <= '1';
            wait for 10 us;
            sclk <= '0';

            cs <= '1';
            send_byte <= '0';

            wait for 900 us;

            wait for 100 us;
            
            
        end loop;
        wait;
    end process data_transmision;
    
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