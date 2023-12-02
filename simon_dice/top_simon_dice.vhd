library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_simon_dice is
    generic(
        multiplex_clk_cicles : natural := 125000;
        oscilator_frequency : natural := 125000000;
        max_tono_clk_cicles : natural := 1200000;
        clk_tic_skip_debouncer : natural := 5000000
    );
    port(
        BTN0 : in STD_LOGIC;
        BTN1 : in STD_LOGIC;
        BTN2 : in STD_LOGIC;
        BTN3 : in STD_LOGIC;
        CLK : in STD_LOGIC;
        NRST : in STD_LOGIC;
        buzz : out STD_LOGIC;
        display : out STD_LOGIC_VECTOR ( 6 downto 0 );
        leds : out STD_LOGIC_VECTOR ( 7 downto 0 );
        mutiplex : out STD_LOGIC_VECTOR ( 3 downto 0 )
    );
end entity top_simon_dice;

architecture structural of top_simon_dice is
    component display_4x7 is
        generic(
            multiplex_clk_cicles : natural := multiplex_clk_cicles
        );
        port (
            CLK : in STD_LOGIC;
            NRST : in STD_LOGIC;
            mutiplex : out STD_LOGIC_VECTOR ( 3 downto 0 );
            active_display : in STD_LOGIC_VECTOR ( 3 downto 0 );
            digitu : in STD_LOGIC_VECTOR ( 3 downto 0 );
            digitd : in STD_LOGIC_VECTOR ( 3 downto 0 );
            digitc : in STD_LOGIC_VECTOR ( 3 downto 0 );
            digitm : in STD_LOGIC_VECTOR ( 3 downto 0 );
            display : out STD_LOGIC_VECTOR ( 6 downto 0 )
        );
    end component display_4x7;
    component driver_display_4x7 is
        port (
            CLK : in STD_LOGIC;
            NRST : in STD_LOGIC;
            game_over : in STD_LOGIC;
            game_completed : in STD_LOGIC;
            cuadrant_on : in STD_LOGIC_VECTOR ( 3 downto 0 );
            active_display : out STD_LOGIC_VECTOR ( 3 downto 0 );
            digitu : out STD_LOGIC_VECTOR ( 3 downto 0 );
            digitd : out STD_LOGIC_VECTOR ( 3 downto 0 );
            digitc : out STD_LOGIC_VECTOR ( 3 downto 0 );
            digitm : out STD_LOGIC_VECTOR ( 3 downto 0 )
        );
    end component driver_display_4x7;
    component tone_generator is
        generic(
            max_tono : natural := max_tono_clk_cicles
        );
        port (
            CLK : in STD_LOGIC;
            NRST : in STD_LOGIC;
            tone_type : in STD_LOGIC_VECTOR ( 3 downto 0 );
            pwm : out STD_LOGIC
        );
    end component tone_generator;
    component random_4bits_generator is
        port (
            CLK : in STD_LOGIC;
            rand4_num : out STD_LOGIC_VECTOR ( 3 downto 0 )
        );
    end component random_4bits_generator;
    component deboundcer is
        generic(
            clk_tic_skip : natural := clk_tic_skip_debouncer
        );
        port (
            CLK : in STD_LOGIC;
            nsrt : in STD_LOGIC;
            pulsation : in STD_LOGIC;
            conformed_pulsation : out STD_LOGIC
        );
    end component deboundcer;
    component simon_dice_logic is
        generic(
            clk_config : natural := oscilator_frequency
        );
        port (
            CLK : in STD_LOGIC;
            NRST : in STD_LOGIC;
            random : in STD_LOGIC_VECTOR ( 3 downto 0 );
            bottons_conformed : in STD_LOGIC_VECTOR ( 3 downto 0 );
            game_over : out STD_LOGIC;
            game_completed : out STD_LOGIC;
            cuadrant_on : out STD_LOGIC_VECTOR ( 3 downto 0 );
            tone_buzz : out STD_LOGIC_VECTOR ( 3 downto 0 );
            leds : out STD_LOGIC_VECTOR ( 7 downto 0 )
        );
    end component simon_dice_logic;
    signal deboundcer_0_conformed_pulsation : STD_LOGIC;
    signal deboundcer_1_conformed_pulsation : STD_LOGIC;
    signal deboundcer_2_conformed_pulsation : STD_LOGIC;
    signal deboundcer_3_conformed_pulsation : STD_LOGIC;
    signal driver_display_4x7_0_active_display : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal driver_display_4x7_0_digitc : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal driver_display_4x7_0_digitd : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal driver_display_4x7_0_digitm : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal driver_display_4x7_0_digitu : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal random_4bits_generat_0_rand4_num : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal simon_dice_logic_0_cuadrant_on : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal simon_dice_logic_0_game_completed : STD_LOGIC;
    signal simon_dice_logic_0_game_over : STD_LOGIC;
    signal simon_dice_logic_0_tone_buzz : STD_LOGIC_VECTOR ( 3 downto 0 );
    signal tone_generator_0_pwm : STD_LOGIC;
    signal xlconcat_0_dout : STD_LOGIC_VECTOR ( 3 downto 0 );

begin

    deboundcer_0: component deboundcer
    port map (
        CLK => CLK,
        conformed_pulsation => deboundcer_0_conformed_pulsation,
        nsrt => NRST,
        pulsation => BTN0
    );
    deboundcer_1: component deboundcer
    port map (
        CLK => CLK,
        conformed_pulsation => deboundcer_1_conformed_pulsation,
        nsrt => NRST,
        pulsation => BTN1
    );
    deboundcer_2: component deboundcer
    port map (
        CLK => CLK,
        conformed_pulsation => deboundcer_2_conformed_pulsation,
        nsrt => NRST,
        pulsation => BTN2
    );
    deboundcer_3: component deboundcer
    port map (
        CLK => CLK,
        conformed_pulsation => deboundcer_3_conformed_pulsation,
        nsrt => NRST,
        pulsation => BTN3
    );
    display_4x7_0: component display_4x7
    port map (
        CLK => CLK,
        NRST => NRST,
        active_display(3 downto 0) => driver_display_4x7_0_active_display(3 downto 0),
        digitc(3 downto 0) => driver_display_4x7_0_digitc(3 downto 0),
        digitd(3 downto 0) => driver_display_4x7_0_digitd(3 downto 0),
        digitm(3 downto 0) => driver_display_4x7_0_digitm(3 downto 0),
        digitu(3 downto 0) => driver_display_4x7_0_digitu(3 downto 0),
        display(6 downto 0) => display(6 downto 0),
        mutiplex(3 downto 0) => mutiplex(3 downto 0)
    );
    driver_display_4x7_0: component driver_display_4x7
    port map (
        CLK => CLK,
        NRST => NRST,
        active_display(3 downto 0) => driver_display_4x7_0_active_display(3 downto 0),
        cuadrant_on(3 downto 0) => simon_dice_logic_0_cuadrant_on(3 downto 0),
        digitc(3 downto 0) => driver_display_4x7_0_digitc(3 downto 0),
        digitd(3 downto 0) => driver_display_4x7_0_digitd(3 downto 0),
        digitm(3 downto 0) => driver_display_4x7_0_digitm(3 downto 0),
        digitu(3 downto 0) => driver_display_4x7_0_digitu(3 downto 0),
        game_completed => simon_dice_logic_0_game_completed,
        game_over => simon_dice_logic_0_game_over
    );
    random_4bits_generat_0: component random_4bits_generator
    port map (
        CLK => CLK,
        rand4_num(3 downto 0) => random_4bits_generat_0_rand4_num(3 downto 0)
    );
    simon_dice_logic_0: component simon_dice_logic
    port map (
        CLK => CLK,
        NRST => NRST,
        bottons_conformed(3 downto 0) => xlconcat_0_dout(3 downto 0),
        cuadrant_on(3 downto 0) => simon_dice_logic_0_cuadrant_on(3 downto 0),
        game_completed => simon_dice_logic_0_game_completed,
        game_over => simon_dice_logic_0_game_over,
        leds(7 downto 0) => leds(7 downto 0),
        random(3 downto 0) => random_4bits_generat_0_rand4_num(3 downto 0),
        tone_buzz(3 downto 0) => simon_dice_logic_0_tone_buzz(3 downto 0)
    );
    tone_generator_0: component tone_generator
    port map (
        CLK => CLK,
        NRST => NRST,
        pwm => buzz,
        tone_type(3 downto 0) => simon_dice_logic_0_tone_buzz(3 downto 0)
    );

    
    xlconcat_0_dout(3 downto 0) <=
    deboundcer_3_conformed_pulsation
    & deboundcer_2_conformed_pulsation
    & deboundcer_1_conformed_pulsation
    & deboundcer_0_conformed_pulsation;
    

end structural;