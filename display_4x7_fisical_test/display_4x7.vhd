library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_4x7 is
    port(
        CLK : in     std_logic;
        mutiplex : buffer std_logic_vector(3 downto 0);
        digitu : in std_logic_vector(3 downto 0);
        digitd : in std_logic_vector(3 downto 0);
        digitc : in std_logic_vector(3 downto 0);
        digitm : in std_logic_vector(3 downto 0);
        display : buffer std_logic_vector(6 downto 0)
    );
end entity display_4x7;

architecture rtl of display_4x7 is
    signal mux_counter : integer range 0 to 12000 := 0;
    signal number : std_logic_vector(3 downto 0);
    signal mutiplex_reg : std_logic_vector(3 downto 0):="0001";

begin
    
    mux: process(clk)
    begin
        if rising_edge(clk) then
            if mux_counter < 12000 then
                mux_counter <= mux_counter + 1;
            else
                mutiplex_reg <= mutiplex_reg(2 downto 0)&mutiplex_reg(3);
                mux_counter <= 0;
            end if;
        end if;
    end process mux;
    
    number <= digitu when mutiplex_reg = "0001" else
    digitd when mutiplex_reg = "0010" else
    digitc when mutiplex_reg = "0100" else
    digitm when mutiplex_reg = "1000";
    
    mutiplex <= mutiplex_reg;
    
    display <=
        "0111111" when number = x"0" else
        "0000110" when number = x"1" else
        "1011011" when number = x"2" else
        "1001111" when number = x"3" else
        "1100110" when number = x"4" else
        "1101101" when number = x"5" else
        "1111101" when number = x"6" else
        "0000111" when number = x"7" else
        "1111111" when number = x"8" else
        "1100111" when number = x"9" else
        "1110111" when number = x"A" else
        "1111100" when number = x"B" else
        "0111001" when number = x"C" else
        "1011110" when number = x"D" else
        "1111001" when number = x"E" else
        "1110001" when number = x"F" else
        "0000000";

end architecture rtl;