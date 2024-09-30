library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RGB_matrix is
    port(
        CLK     : in    std_logic;
        NRST    : in    std_logic;
        RGB0    : out   std_logic_vector(2 downto 0);
        RGB1    : out   std_logic_vector(2 downto 0);
        ADDR    : out   std_logic_vector(4 downto 0);
        LAT     : out   std_logic;
        CLOCK_O : out   std_logic;
        OE      : out   std_logic
    );
end entity RGB_matrix;

architecture rtl of RGB_matrix is
    constant max_cnt     : natural := 4;
    signal clk_div       : unsigned(31 downto 0);
    signal clock_o_s     : std_logic;
    signal end_cnt       : std_logic;
    signal end_h_cnt     : std_logic;
    signal h_cnt         : unsigned(6 downto 0);
    signal v_cnt         : unsigned(5 downto 0);



    signal clk_seg       : unsigned(31 downto 0);
    signal index         : integer range 0 to 31;
    signal direction     : std_logic;

    type NaturalArray is array (0 to 31) of natural;
        signal MyArrayV1 : NaturalArray := (31, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 
                                            19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30);

        signal MyArrayV2 : NaturalArray := (30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 
                                            20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 
                                            10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 31);

        signal MyArrayH1 : NaturalArray := (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 
                                            19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31);

        signal MyArrayH2 : NaturalArray := (31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 
                                            20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 
                                            10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
       

begin

    process(clk, NRST)
    begin
        if NRST = '0' then
            clk_div <= (others => '0');
        elsif rising_edge(clk) then
            if clk_div < max_cnt - 1 then
                clk_div <= clk_div + 1;
            else
                clk_div <= (others => '0');
            end if;
        end if;
    end process;

    end_cnt <= '1' when clk_div = max_cnt - 1 else '0';

    process(clk, NRST)
    begin
        if NRST = '0' then
            h_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if end_cnt = '1' then
                if h_cnt < 64 then
                    h_cnt <= h_cnt + 1;
                else
                    h_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    end_h_cnt <= '1' when h_cnt = 64 and end_cnt = '1' else '0';

    process(clk, NRST)
    begin
        if NRST = '0' then
            v_cnt <= (others => '0');
        elsif rising_edge(clk) then
            if end_h_cnt = '1' then
                if v_cnt < 32 then
                    v_cnt <= v_cnt + 1;
                else
                    v_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    clock_o_s <= '0' when clk_div < max_cnt / 2 else '1';
    
    CLOCK_O <= clock_o_s when h_cnt < 64 else '0';
    OE <= '0' when h_cnt < 64 else '1';
    LAT <= '1' when h_cnt = 64 else '0';
    ADDR <= STD_LOGIC_VECTOR(v_cnt(4 downto 0));
    
    --RGB0 <= STD_LOGIC_VECTOR(h_cnt(2 downto 0) or h_cnt(2 downto 0));
    --RGB1 <= STD_LOGIC_VECTOR(h_cnt(2 downto 0) or h_cnt(2 downto 0));

    RGB0    <= "100" when v_cnt = MyArrayV1(index) and h_cnt = MyArrayH1(index) else 
               "001" when v_cnt = MyArrayV1(index) and h_cnt = MyArrayH2(index) + 32 else 
               "000";

    RGB1    <= "010" when v_cnt = MyArrayV2(index) and h_cnt = MyArrayH1(index) else
               "101" when v_cnt = MyArrayV2(index) and h_cnt = MyArrayH2(index) + 32 else 
               "000";


    process(clk, NRST)
    begin
        if NRST = '0' then
            clk_seg <= (others => '0');
            index <= 0;
            direction <= '0';
        elsif rising_edge(clk) then
            if clk_seg < 120000 then
                clk_seg <= clk_seg + 1;
            else
                clk_seg <= (others => '0');
                if (index < 31 and direction = '0') then
                    index <= index + 1;

                elsif (index > 0 and direction = '1') then
                    index <= index - 1;
                else
                    direction <= not direction;
                end if;
            end if;
        end if;
    end process;

end architecture rtl;