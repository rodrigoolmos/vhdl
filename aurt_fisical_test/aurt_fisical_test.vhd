library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity aurt_fisical_test is
    port(
        CLK : in     std_logic;
        nrst : in     std_logic;
        rx : in     std_logic;
        tx : buffer     std_logic;
        data_ready_rx : buffer STD_LOGIC;
        ready : buffer STD_LOGIC;
        byte_rx : buffer std_logic_vector(7 downto 0)
    );
end entity aurt_fisical_test;

architecture rtl of aurt_fisical_test is
    signal counter : integer range 0 to 1000000 := 0;
    signal increment : integer range 0 to 255 := 31;
    signal start_tx : STD_LOGIC := '0';
    signal byte_tx : std_logic_vector(7 downto 0) := x"00";
    signal ready_tx : STD_LOGIC;


    
    component uart is
        port(
            CLK : in                std_logic;
            nrst : in               std_logic;
            rx : in                 std_logic;
            tx : buffer             std_logic;
            data_ready_rx : buffer  STD_LOGIC;
            ready_tx : buffer       STD_LOGIC;
            start_tx : in           STD_LOGIC;
            byte_tx : in            std_logic_vector(7 downto 0);
            byte_rx : buffer        std_logic_vector(7 downto 0)
        );
    end component uart;
    
begin
    
    u1: uart
    port map
    (
        CLK => CLK,
        nrst => nrst,
        rx => rx,
        tx => tx,
        data_ready_rx => data_ready_rx,
        ready_tx => ready_tx,
        start_tx => start_tx,
        byte_tx => byte_tx,
        byte_rx => byte_rx
    );

    blink: process(clk)
    begin
        if rising_edge(clk) then
            if ready_tx = '1' then
                start_tx <= '1';
                increment <= increment + 1;
            end if;
        end if;
    end process blink;
    
    ready <= ready_tx;
    
    byte_tx <= std_logic_vector(to_unsigned(increment, byte_tx'length));

end architecture rtl;