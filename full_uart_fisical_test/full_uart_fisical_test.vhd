library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_uart_fisical_test is
    port(
        CLK : in     std_logic;
        nrst : in std_logic := '0';
        rx : in     std_logic;      -- serial data rx
        tx : out     std_logic      -- serial data tx
    );
end entity full_uart_fisical_test;

architecture rtl of full_uart_fisical_test is
    
    component full_uart is
        generic(
            fifo_deep  :  natural := 512;
            frecuencia_oscilador : natural := 12000000; -- if you oscilator speed is diferent edit this parameter MHz
            baud_rate : natural := 115200 -- if what a diferent baud_rate edit this parameter baud rate
        );
        port(
            CLK : in     std_logic;
            nrst : in     std_logic;
            read_fifo_rx : in std_logic;
            fifo_empty_rx : out std_logic;
            fifo_full_rx  : out std_logic;
            byte_rx_fifo : out            std_logic_vector(7 downto 0);
            ena_write_fifo_tx :  in     std_logic;
            fifo_empty_tx : out std_logic;
            fifo_full_tx  : out std_logic;
            start_tx : in std_logic;
            byte_tx_fifo : in            std_logic_vector(7 downto 0);
            rx : in     std_logic;      -- serial data rx
            tx : out     std_logic  -- serial data tx
        );
    end component full_uart;
    
    signal read_fifo_rx :std_logic;
    signal fifo_empty_rx : std_logic;
    signal fifo_full_rx  : std_logic;
    signal ena_write_fifo_tx : std_logic;
    signal fifo_empty_tx : std_logic;
    signal fifo_full_tx  : std_logic;
    signal start_tx : std_logic;
    signal byte_tx_fifo : std_logic_vector(7 downto 0);
    signal byte_rx_fifo : std_logic_vector(7 downto 0);
    type estado is (espera,wait_1clk,coppiando,transmitiendo);
    signal estado_st: estado:=espera;


    
begin
    
    
    process(clk, nrst)
    begin
        if nrst = '0' then
            read_fifo_rx  <= '0';
            ena_write_fifo_tx <= '0';
            start_tx  <= '0';
            byte_tx_fifo <= (others => '0');
            estado_st <= espera;

        elsif rising_edge(clk) then
            
            case estado_st is
                when espera =>
                    if fifo_full_rx = '1' then
                        estado_st <= wait_1clk;
                        read_fifo_rx  <= '1';
                    end if;
                when wait_1clk => -- need 1 ckl to get the data from the rx fifo byte_rx_fifo
                    estado_st <= coppiando;

                when coppiando =>
                    ena_write_fifo_tx <= '1';
                    byte_tx_fifo <= byte_rx_fifo;
                    if fifo_full_tx = '1' then
                        ena_write_fifo_tx <= '0';
                        read_fifo_rx  <= '0';
                        read_fifo_rx <= '0';
                        ena_write_fifo_tx <= '0';
                        estado_st <= transmitiendo;
                    end if;
                when transmitiendo =>
                    start_tx <= '1';
                    if fifo_empty_tx = '1' then
                        start_tx <= '0';
                        estado_st <= espera;
                    end if;
                when others =>
                    
            end case;

            
            
            
        end if;
    end process;


    u1: full_uart
    port map
    (
        
        CLK => CLK ,
        nrst => nrst ,
        read_fifo_rx => read_fifo_rx ,
        fifo_empty_rx => fifo_empty_rx ,
        fifo_full_rx  => fifo_full_rx  ,
        byte_rx_fifo => byte_rx_fifo,
        ena_write_fifo_tx=> ena_write_fifo_tx,
        fifo_empty_tx => fifo_empty_tx ,
        fifo_full_tx  => fifo_full_tx  ,
        start_tx => start_tx ,
        byte_tx_fifo =>  byte_tx_fifo ,
        rx => rx ,
        tx => tx
        
    );

end architecture rtl;