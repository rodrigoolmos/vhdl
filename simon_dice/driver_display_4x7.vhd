library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity driver_display_4x7 is
    Port (
        CLK                     : in STD_LOGIC;
        NRST                    : in STD_LOGIC;
        game_over               : in std_logic;
        game_completed          : in std_logic;
        cuadrant_on             : in std_logic_vector(3 downto 0);
        active_display          : out std_logic_vector(3 downto 0);
        digitu                  : out std_logic_vector(3 downto 0);
        digitd                  : out std_logic_vector(3 downto 0);
        digitc                  : out std_logic_vector(3 downto 0);
        digitm                  : out std_logic_vector(3 downto 0)
    );
end driver_display_4x7;

architecture rtl of driver_display_4x7 is
    signal data_value :  std_logic_vector(3 downto 0);
begin

    process(clk, NRST)
    begin
        if NRST = '0' then

            data_value <= "0000";
        elsif rising_edge(clk) then

            if game_over = '1' then
                active_display     <= (others => '1');
                data_value <= x"0";
            elsif game_completed = '1' then
                active_display     <= (others => '1');
                data_value <= x"E";
            else
                active_display     <= cuadrant_on;
                data_value <= x"8";
            end if;
            
        end if;
    end process;

    digitu <= data_value;
    digitd <= data_value;
    digitc <= data_value;
    digitm <= data_value;


end rtl;