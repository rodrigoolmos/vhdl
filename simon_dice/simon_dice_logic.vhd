library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity simon_dice_logic is
    generic(
        clk_config : natural := 125000000
    );
    port(
        CLK                     : in    std_logic;
        NRST                    : in    std_logic;
        random                  : in    std_logic_vector(3 downto 0);
        bottons_conformed       : in    std_logic_vector(3 downto 0);
        game_over               : out   std_logic;
        game_completed          : out   std_logic;
        cuadrant_on             : out   std_logic_vector(3 downto 0);
        tone_buzz               : out   std_logic_vector(3 downto 0);
        leds                    : out   std_logic_vector(7 downto 0)
    );
end entity simon_dice_logic;

architecture rtl of simon_dice_logic is
    signal counter : unsigned(35 downto 0);
    signal counter_song : unsigned(31 downto 0);
    signal read_patern : std_logic;
    signal random_reg : std_logic_vector(3 downto 0);
    signal level : unsigned(2 downto 0);
    signal song_reg : std_logic_vector(3 downto 0);
    signal level_counter : unsigned(2 downto 0);
    type st_simon is (generate_patern, guess_patern, win ,lose);
    signal simon : st_simon;
    type solution_reg is array (0 to 7) of std_logic_vector(3 downto 0);
    signal solution : solution_reg := (x"3",x"3",x"3",x"3",x"3",x"3",x"3",x"3");
begin

    process(CLK,NRST)
    begin
        if NRST = '0' then
            simon <= generate_patern;
            level <= "000";
            random_reg <= "0000";
            level_counter <= "000";
            counter <= (others => '0');
            for i in solution'range loop
                solution(i) <= (others => '0');
            end loop;
        elsif rising_edge(CLK) then
            case simon is
                when generate_patern =>
                    
                    if counter < clk_config then
                        counter <= counter + 1;
                        if counter = 1 then
                            if level = level_counter then
                                solution(to_integer(level)) <= random;
                            end if;
                            
                            read_patern <= '1';
                        else
                            read_patern <= '0';
                        end if;
                        random_reg <= solution(to_integer(level));
                    elsif level < level_counter then
                        counter <= (others => '0');
                        level <= level + 1;
                    else
                        counter <= (others => '0');
                        simon <= guess_patern;
                        random_reg <= "0000";
                        level <= "000";
                    end if;
                when guess_patern =>
                    if counter < clk_config*2 then
                        counter <= counter + 1;
                    else
                        counter <= (others => '0');
                        simon <= lose;
                        level_counter <= "000";
                        level <= "000";
                    end if;
                    if bottons_conformed /= "0000" then
                        if bottons_conformed = solution(to_integer(level)) then
                            counter <= (others => '0');
                            level <= level + 1;
                            if level = level_counter and level = "111" then
                                simon <= win;
                            elsif level = level_counter then
                                simon <= generate_patern;
                                level <= "000";
                                level_counter <= level_counter + 1;
                            end if;
                        else
                            counter <= (others => '0');
                            simon <= lose;
                            level_counter <= "000";
                            level <= "000";
                        end if;
                    end if;
                when win =>
                    
                    if counter < clk_config*10 then
                        counter <= counter + 1;
                    else
                        simon <= generate_patern;
                        counter <= (others => '0');
                        level_counter <= "000";
                        level <= "000";
                    end if;
                when lose =>

                    if counter < clk_config*10 then
                        counter <= counter + 1;
                    else
                        simon <= generate_patern;
                        counter <= (others => '0');
                    end if;
                when others =>
                    
                    
            end case;
        end if;
    end process ;
    
    process(CLK,NRST)
    begin
        if NRST = '0' then
            counter_song <= (others => '0');
            song_reg <= "0001";
        elsif rising_edge(clk) then
            if counter_song < clk_config/5 then
                counter_song <= counter_song + 1;
            else
                if simon = lose then
                    song_reg <= song_reg(2 downto 0)&song_reg(3);
                elsif simon = win then
                    song_reg(1 downto 0) <= song_reg(0)&song_reg(1);
                else
                    song_reg <= "0001";
                end if;
                counter_song <= (others => '0');
            end if;
        end if;
    end process;

    game_completed <= '1' when simon = win else '0';
    game_over <= '1' when simon = lose else '0';
    cuadrant_on <=
    random_reg when simon = generate_patern else
                "1111" when simon = win or simon = lose else
                "0000";
    
    tone_buzz <= random_reg when (simon = generate_patern and counter > clk_config*1/4 and counter < clk_config*3/4) else
    song_reg when simon = lose OR simon = win else "0000";
    

    leds <=
    "11111110" when level_counter = "000" else
    "11111100" when level_counter = "001" else
    "11111000" when level_counter = "010" else
    "11110000" when level_counter = "011" else
    "11100000" when level_counter = "100" else
    "11000000" when level_counter = "101" else
    "10000000" when level_counter = "110" else
    "00000000";

end architecture rtl;