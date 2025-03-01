-- en el ciclo de reloj de subida que se llena la fifo activa el flag de full
-- en el ciclo de reloj de subida que se vacia la fifo activa el flag de empty

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo is
    generic(
        data_width : natural := 8;
        addr_deep  : natural := 128
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
end entity fifo;

architecture rtl of fifo is
    
    function clogb2 (bit_depth : natural) return natural is
        variable depth  : natural := bit_depth;
        variable count  : natural := 1;
    begin
        for index in 1 to bit_depth loop  -- Works for up to 32 bit integers
            if (bit_depth <= 2) then
                count := 1;
            else
                if(depth <= 1) then
                    count := count;
                else
                    depth := depth / 2;
                    count := count + 1;
                end if;
            end if;
        end loop;
        return(count);
    end;
    
    type type_memory is array (0 to addr_deep - 1) of std_logic_vector(data_width -1 downto 0);
    signal memory : type_memory;
    
    signal write_addres   : unsigned(clogb2(addr_deep - 1) - 1 downto 0);
    signal read_addres    : unsigned(clogb2(addr_deep - 1) - 1 downto 0);
    signal fifo_size      : unsigned(clogb2(addr_deep - 1) downto 0);
    
    signal r_empty :         std_logic;
    signal r_full :           std_logic;
    
begin
    
    process(clk, nrst)
    begin
        if nrst = '0' then
            write_addres <= (others => '0');
        elsif rising_edge(clk) then
            if (ena_write = '1' and r_full = '0') or ( ena_write = '1' and ena_read = '1') then
                if write_addres < addr_deep -1 then
                    write_addres <= write_addres + 1;
                else
                    write_addres <= (others => '0');
                end if;
                memory(to_integer(write_addres)) <= data_write;
            end if;
        end if;
    end process;
    
    process(clk, nrst)
    begin
        if nrst = '0' then
            read_addres  <= (others => '0');
        elsif rising_edge(clk) then
            if (ena_read = '1' and r_empty = '0') or ( ena_write = '1' and ena_read = '1') then
                if read_addres < addr_deep -1 then
                    read_addres <= read_addres + 1;
                else
                    read_addres <= (others => '0');
                end if;
            end if;
        end if;
    end process;
    
    process(clk, nrst)
    begin
        if nrst = '0' then
            fifo_size  <= to_unsigned(addr_deep, fifo_size'length);
        elsif rising_edge(clk) then
            if (ena_write = '1' and ena_read = '1') then
                fifo_size <= fifo_size;
            elsif (ena_read = '1' and r_empty = '0') then
                fifo_size <= fifo_size + 1;
            elsif (ena_write = '1' and r_full = '0') then
                fifo_size <= fifo_size - 1;
            end if;
        end if;
    end process;
    
    data_read <= memory(to_integer(read_addres));
    
    r_full <= '1' when fifo_size = 0 else '0';
    next_full <= '1' when fifo_size = 1 else '0';
    next_empty <= '1' when fifo_size = addr_deep - 1 else '0';
    r_empty <= '1' when fifo_size = addr_deep else '0';
    
    full <= r_full;
    empty <= r_empty;
    
    
end architecture rtl;
