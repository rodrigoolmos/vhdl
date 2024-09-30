library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_tb is
end entity fifo_tb;

architecture rtl of fifo_tb is
    
    constant period_time : time      := 83333 ps;
    constant data_width : natural := 8;
    signal   finished    : std_logic := '0';
    
    signal CLK :        std_logic;
    signal nrst :       std_logic;
    signal ena_write :  std_logic;
    signal ena_read :   std_logic;
    signal empty :      std_logic;
    signal full :       std_logic;
    signal next_empty :      std_logic;
    signal next_full :       std_logic;
    signal data_write : std_logic_vector(data_width -1 downto 0);
    signal data_read :  std_logic_vector(data_width -1 downto 0);
    
    component fifo is
        generic(
            data_width : natural := 8;
            addr_deep  :  natural := 16
        );
        port(
            CLK :           in     std_logic;
            nrst :          in     std_logic;
            ena_write :     in     std_logic;
            ena_read :      in     std_logic;
            empty :         out    std_logic;
            full :          out    std_logic;
            next_empty :    out    std_logic;
            next_full :     out    std_logic;
            data_write :    in     std_logic_vector(data_width -1 downto 0);
            data_read :     out    std_logic_vector(data_width -1 downto 0)
        );
    end component fifo;
    
begin

    sim_time_proc: process
    begin
        nrst <= '0';
        ena_write <= '0';
        ena_read <= '0';
        wait until rising_edge(CLK);
        nrst <= '1';
        wait until rising_edge(CLK);
        
        -- test write
        ena_write <= '1';
        for i in 0 to 15 loop
            data_write <= std_logic_vector(to_unsigned(i + 10, 8));
            wait until rising_edge(CLK);
        end loop;
        ena_write <= '0';
        wait until rising_edge(CLK);

        -- test read
        ena_read <= '1';
        wait for period_time*16;
        wait until rising_edge(CLK);
        ena_read <= '0';
        wait until rising_edge(CLK);

        
        -- test full
        ena_write <= '1';
        for i in 0 to 20 loop
            data_write <= std_logic_vector(to_unsigned(i, 8));
            wait until rising_edge(CLK);
        end loop;
        ena_write <= '0';
        wait until rising_edge(CLK);

        -- test empty
        ena_read <= '1';
        wait for period_time*20;
        wait until rising_edge(CLK);
        wait until rising_edge(CLK);
        ena_read <= '0';
        wait until rising_edge(CLK);

        -- test write read simultanius
        ena_write <= '1';
        for i in 0 to 15 loop
            data_write <= std_logic_vector(to_unsigned(i + 16, 8));
            wait until rising_edge(CLK);
        end loop;
        ena_read <= '1';
        for i in 0 to 31 loop
            data_write <= std_logic_vector(to_unsigned(i + 32, 8));
            wait until rising_edge(CLK);
        end loop;
        ena_write <= '0';
        wait for period_time*16;
        wait until rising_edge(CLK);
        ena_read <= '0';
        wait until rising_edge(CLK);

        -- test write 16
        ena_write <= '1';
        for i in 0 to 15 loop
            data_write <= std_logic_vector(to_unsigned(i + 64, 8));
            wait until rising_edge(CLK);
        end loop;
        ena_write <= '0';
        wait until rising_edge(CLK);

        -- test read 16
        ena_read <= '1';
        wait for period_time*16;
        wait until rising_edge(CLK);
        ena_read <= '0';
        wait until rising_edge(CLK);

        wait for period_time*15;
        wait until rising_edge(CLK);
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
    
    u1: fifo
    generic map(
        data_width => 8,
        addr_deep => 16
    )
    port map
    (
        CLK             => CLK ,
        nrst            => nrst ,
        ena_write       => ena_write ,
        ena_read        => ena_read ,
        empty           => empty ,
        full            => full ,
        next_empty      => next_empty ,
        next_full       => next_full ,
        data_write      => data_write ,
        data_read       => data_read
    );

end architecture rtl;
