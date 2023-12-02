library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_simon_dice_tb is
end entity top_simon_dice_tb;

architecture rtl of top_simon_dice_tb is
    
    constant period_time : time      := 8000 ps;
    constant prescaler  : NATURAL     := 5000;
    signal   finished    : std_logic := '0';
    
    signal CLK      :  std_logic;
    signal BTN0     :  STD_LOGIC;
    signal BTN1     :  STD_LOGIC;
    signal BTN2     :  STD_LOGIC;
    signal BTN3     :  STD_LOGIC;
    signal NRST     :  STD_LOGIC;
    signal buzz     :  STD_LOGIC;
    signal display  :  STD_LOGIC_VECTOR ( 6 downto 0 );
    signal leds     :  STD_LOGIC_VECTOR ( 7 downto 0 );
    signal mutiplex :  STD_LOGIC_VECTOR ( 3 downto 0 );
    
    component top_simon_dice is
        generic(
            multiplex_clk_cicles : natural := 125000/prescaler;
            oscilator_frequency : natural := 125000000/prescaler;
            max_tono_clk_cicles : natural := 1200000/prescaler;
            clk_tic_skip_debouncer : natural := 5000000/prescaler
        );
        port(
            BTN0     : in STD_LOGIC;
            BTN1     : in STD_LOGIC;
            BTN2     : in STD_LOGIC;
            BTN3     : in STD_LOGIC;
            CLK      : in STD_LOGIC;
            NRST     : in STD_LOGIC;
            buzz     : out STD_LOGIC;
            display  : out STD_LOGIC_VECTOR ( 6 downto 0 );
            leds     : out STD_LOGIC_VECTOR ( 7 downto 0 );
            mutiplex : out STD_LOGIC_VECTOR ( 3 downto 0 )
        );
    end component top_simon_dice;
    
    procedure win(
        signal BTN : out std_logic
    ) is
    begin
        
    end procedure;
    
    
    procedure pulsar_boton(
        signal BTN : out std_logic
    ) is
    begin
        BTN <= '0';
        wait until rising_edge(clk);
        BTN <= '1';
        wait until rising_edge(clk);
        BTN <= '0';
        wait until rising_edge(clk);
        BTN <= '1';
        wait until rising_edge(clk);
        BTN <= '0';
        wait until rising_edge(clk);
        BTN <= '1';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        BTN <= '0';
        wait until rising_edge(clk);
        BTN <= '1';
        wait until rising_edge(clk);
        BTN <= '0';
        wait until rising_edge(clk);
        BTN <= '1';
        wait until rising_edge(clk);
        BTN <= '0';
        wait until rising_edge(clk);
        wait for 50 us;
        
    end procedure;
    
    
begin

    sim_time_proc: process
    begin
        BTN0 <= '0';
        BTN1 <= '0';
        BTN2 <= '0';
        BTN3 <= '0';
        NRST <= '0';
        wait for 1 us;
        NRST <= '1';
        wait for 200 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        wait for 400 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        wait for 600 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        wait for 800 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        wait for 1000 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        wait for 1200 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        wait for 1400 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        wait for 1600 us;
        wait for 50 us;
        pulsar_boton(BTN2);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        pulsar_boton(BTN0);
        pulsar_boton(BTN1);
        wait for 2000 us;
        wait for 50 us;
        wait for 200 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        wait for 400 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        wait for 600 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        wait for 800 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        wait for 1000 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        wait for 1200 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        wait for 1400 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        wait for 1600 us;
        wait for 50 us;
        pulsar_boton(BTN1);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        pulsar_boton(BTN2);
        pulsar_boton(BTN3);
        wait for 2000 us;
        wait for 50 us;
        wait for 200 us;
        wait for 50 us;
        pulsar_boton(BTN3);
        wait for 400 us;
        wait for 50 us;
        pulsar_boton(BTN3);
        pulsar_boton(BTN1);
        wait for 3000 us;
        wait for 500 us;
        pulsar_boton(BTN3);
        wait for 400 us;
        wait for 50 us;
        pulsar_boton(BTN3);
        pulsar_boton(BTN3);
        wait for 600 us;
        wait for 50 us;
        
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
    
    u1: top_simon_dice
    port map
    (
        BTN0     =>  BTN0     ,
        BTN1      => BTN1     ,
        BTN2      => BTN2     ,
        BTN3      => BTN3     ,
        CLK       => CLK      ,
        NRST      => NRST     ,
        buzz      => buzz     ,
        display   => display  ,
        leds      => leds     ,
        mutiplex  => mutiplex
    );

end architecture rtl;