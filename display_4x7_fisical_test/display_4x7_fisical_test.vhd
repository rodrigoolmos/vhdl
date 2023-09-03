library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_4x7_fisical_test is
    port(
        CLK : in     std_logic;
        mutiplex : buffer std_logic_vector(3 downto 0);
        display  : buffer std_logic_vector(6 downto 0)
    );
end entity display_4x7_fisical_test;

architecture rtl of display_4x7_fisical_test is
    
    signal digitu : std_logic_vector(3 downto 0) := x"1";
    signal digitd : std_logic_vector(3 downto 0) := x"2";
    signal digitc : std_logic_vector(3 downto 0) := x"3";
    signal digitm : std_logic_vector(3 downto 0) := x"4";
    
    COMPONENT display_4x7 IS
        port (
            CLK      : in std_logic;
            mutiplex : buffer std_logic_vector(3 downto 0);
            digitu   : in std_logic_vector(3 downto 0);
            digitd   : in std_logic_vector(3 downto 0);
            digitc   : in std_logic_vector(3 downto 0);
            digitm   : in std_logic_vector(3 downto 0);
            display  : buffer std_logic_vector(6 downto 0)
        );
    end component display_4x7;
begin

    u1 : display_4x7
    port map (
        CLK      => CLK ,
        mutiplex => mutiplex ,
        digitu   => digitu ,
        digitd   => digitd ,
        digitc   => digitc ,
        digitm   => digitm ,
        display  => display
    );

end architecture rtl;