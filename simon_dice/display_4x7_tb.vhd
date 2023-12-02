library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display_4x7_tb is
end entity display_4x7_tb;

architecture rtl of display_4x7_tb is
    
    constant period_time : time      := 83333 ps;
    signal   finished    : std_logic := '0';
    
    signal CLK                 : std_logic;
    signal NRST                : STD_LOGIC;
    signal mutiplex            : std_logic_vector(3 downto 0);
    signal active_display      : std_logic_vector(3 downto 0);
    signal digitu              : std_logic_vector(3 downto 0);
    signal digitd              : std_logic_vector(3 downto 0);
    signal digitc              : std_logic_vector(3 downto 0);
    signal digitm              : std_logic_vector(3 downto 0);
    signal display             : std_logic_vector(6 downto 0);
    
    
    component display_4x7 is
        generic(
            multiplex_clk_cicles : natural := 12
        );
        port(
            CLK                 : in std_logic;
            NRST                : in STD_LOGIC;
            mutiplex            : out std_logic_vector(3 downto 0);
            active_display      : in std_logic_vector(3 downto 0);
            digitu              : in std_logic_vector(3 downto 0);
            digitd              : in std_logic_vector(3 downto 0);
            digitc              : in std_logic_vector(3 downto 0);
            digitm              : in std_logic_vector(3 downto 0);
            display             : out std_logic_vector(6 downto 0)
        );
    end component display_4x7;
    
    procedure write_display(
        constant data              : in std_logic_vector(15 downto 0);
        signal digitu              : out std_logic_vector(3 downto 0);
        signal digitd              : out std_logic_vector(3 downto 0);
        signal digitc              : out std_logic_vector(3 downto 0);
        signal digitm              : out std_logic_vector(3 downto 0)
    ) is
    begin
        digitu <= data(3 downto 0);
        digitd <= data(7 downto 4);
        digitc <= data(11 downto 8);
        digitm <= data(15 downto 12);
        
    end procedure;
    
begin

    sim_time_proc: process
    begin
        NRST <= '0';
        wait for 200 us;
        NRST <= '1';
        active_display <= "1111";
        write_display(x"1234",digitu,digitd,digitc,digitm);
        wait for 200 us;
        active_display <= "0001";
        write_display(x"5678",digitu,digitd,digitc,digitm);
        wait for 200 us;
        active_display <= "0010";
        write_display(x"9ABC",digitu,digitd,digitc,digitm);
        wait for 200 us;
        active_display <= "0100";
        write_display(x"DEF0",digitu,digitd,digitc,digitm);
        wait for 200 us;
        active_display <= "1000";
        write_display(x"EEEE",digitu,digitd,digitc,digitm);
        wait for 200 us;
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
    
    u1: display_4x7
    port map
    (
        CLK                  => CLK             ,
        NRST                 => NRST            ,
        mutiplex             => mutiplex        ,
        active_display       => active_display  ,
        digitu               => digitu          ,
        digitd               => digitd          ,
        digitc               => digitc          ,
        digitm               => digitm          ,
        display              => display
    );

end architecture rtl;