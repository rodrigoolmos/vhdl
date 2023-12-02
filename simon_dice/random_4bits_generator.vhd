library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity random_4bits_generator is
    port(
        CLK             : in     std_logic;
        rand4_num       : out std_logic_vector(3 downto 0) 
    );
end entity random_4bits_generator;

architecture rtl of random_4bits_generator is
    signal counter : unsigned(1 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            counter <= counter + 1;
        end if;
    end process;

    rand4_num <=
        "0001" when counter = "00" else 
        "0010" when counter = "01" else
        "0100" when counter = "10" else
        "1000";

end architecture rtl;