library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_uart is
    generic(
        fifo_deep  :  natural := 16;
        frecuencia_oscilador : natural := 12000000; -- if you oscilator speed is diferent edit this parameter MHz
        baud_rate : natural := 9600 -- if what a diferent baud_rate edit this parameter baud rate
    );
    port(
        CLK : in     std_logic;
        nrst : in     std_logic;
        -- rx stuff
        read_fifo_rx : in std_logic;                                -- enable to read de data stored ein the fifo throught byte_rx_fifo
        fifo_empty_rx : out std_logic;                              -- set to 1 when the rx fifo is empty no data recived or all data readed
        fifo_full_rx  : out std_logic;                              -- set to 1 when the rx fifo is full
        byte_rx_fifo : out            std_logic_vector(7 downto 0); -- here I read the rx data stored in the fifo
        -- tx stuff
        ena_write_fifo_tx :  in     std_logic;                      -- enable the fifo tx to stored 1 byte each rising_edge(clk)
        fifo_empty_tx : out std_logic;                              -- set to 1 when all data have been send
        fifo_full_tx  : out std_logic;                              -- set to 1 when fifo is full
        start_tx : in std_logic;                                    -- enables the uart to star transmiting transmits until the fifo is empty if you keep it stuck at 1
        byte_tx_fifo : in            std_logic_vector(7 downto 0);  -- byte to be stored in the fifo en the rising_edge(clk) to be sended throught tx
        -- serial wire
        rx : in     std_logic;      -- serial data rx
        tx : out     std_logic      -- serial data tx
    );
end entity full_uart;

architecture rtl of full_uart is

    component uart is
        generic(
            frecuencia_oscilador : natural := frecuencia_oscilador; -- if you oscilator speed is diferent edit this parameter MHz
            baud_rate : natural := baud_rate -- if what a diferent baud_rate edit this parameter baud rate
        );
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


    component fifo is
        generic(
            data_width : natural := 8;
            addr_deep  :  natural := fifo_deep
        );
        port(
            CLK :        in     std_logic;
            nrst :       in     std_logic;
            ena_write :  in     std_logic;
            ena_read :   in     std_logic;
            empty :      out    std_logic;
            full :       out    std_logic;
            data_write : in     std_logic_vector(data_width -1 downto 0);
            data_read :  out    std_logic_vector(data_width -1 downto 0)
        );
    end component fifo;

    signal data_ready_rx : std_logic;
    signal byte_rx : std_logic_vector(7 downto 0);
    signal byte_tx : std_logic_vector(7 downto 0);
    signal ready_tx : std_logic;
    signal reg_start_tx : STD_LOGIC;
    signal ena_read_fifo_tx : std_logic;
    signal sig_fifo_empty_tx : std_logic;



begin
    
    process(clk, nrst)
    begin
        if nrst = '0' then
            reg_start_tx <= '0';
        elsif rising_edge(clk) then
            if sig_fifo_empty_tx = '1' then
                reg_start_tx <= '0';
            else
                reg_start_tx <= start_tx;
            end if;
        end if;
    end process;
    
    fifo_empty_tx <= sig_fifo_empty_tx;
    

    ena_read_fifo_tx <= ready_tx and  reg_start_tx;

    fifo_tx: fifo
    port map
    (
        CLK        => CLK ,
        nrst       => nrst ,
        ena_write  => ena_write_fifo_tx ,
        ena_read   => ena_read_fifo_tx,
        empty      => sig_fifo_empty_tx ,
        full       => fifo_full_tx ,
        data_write => byte_tx_fifo ,
        data_read  => byte_tx
    );

    fifo_rx: fifo
    port map
    (
        CLK        => CLK ,
        nrst       => nrst ,
        ena_write  => data_ready_rx ,
        ena_read   => read_fifo_rx ,
        empty      => fifo_empty_rx ,
        full       => fifo_full_rx ,
        data_write => byte_rx ,
        data_read  => byte_rx_fifo
    );


    u1: uart
    port map
    (
        CLK => CLK,
        nrst => nrst,
        rx => rx,
        tx => tx,
        data_ready_rx => data_ready_rx,
        ready_tx => ready_tx,
        start_tx => reg_start_tx,
        byte_tx => byte_tx,
        byte_rx => byte_rx
    );

end architecture rtl;