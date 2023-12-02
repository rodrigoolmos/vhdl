library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity deboundcer is
    generic(
        clk_tic_skip : natural := 5000000
    );
    port(
        CLK                         : in  std_logic;
        nsrt                        : in  std_logic;
        pulsation                   : in  std_logic;
        conformed_pulsation         : out std_logic
    );
end entity deboundcer;

architecture rtl of deboundcer is
    signal counter : unsigned(31 downto 0);
    signal pulsation_reg : std_logic_vector(2 downto 0);
    signal rising_pulsation : std_logic;
    signal falling_pulsation : std_logic;
    signal pulsation_with_out_rebound : std_logic;
    signal pulsation_with_out_rebound_t1 : std_logic;


begin

    process(CLK, nsrt)
    begin
        if nsrt = '0' then
            counter <= (others => '1');
        elsif rising_edge(CLK) then
            if rising_pulsation = '1' or falling_pulsation = '1' then
                counter <= (others => '0');
            elsif counter < clk_tic_skip then
                counter <= counter + 1;
            end if;

            
        end if;
    end process;


    process(CLK, nsrt)
    begin
        if nsrt = '0' then
            pulsation_reg <= (others =>'0');
        elsif rising_edge(CLK) then
            pulsation_reg <= pulsation_reg(1 downto 0) & pulsation;
        end if;
    end process;
    
    process(CLK, nsrt)
    begin
        if nsrt = '0' then
            pulsation_with_out_rebound_t1 <= '0';
        elsif rising_edge(CLK) then
            pulsation_with_out_rebound_t1 <= pulsation_with_out_rebound;
        end if;
    end process;


    rising_pulsation  <= pulsation_reg(1) and not pulsation_reg(2);
    falling_pulsation <= pulsation_reg(2) and not pulsation_reg(1);

    pulsation_with_out_rebound <= '1' when pulsation_reg(1) = '1' or counter < clk_tic_skip  or falling_pulsation = '1' else '0';
    
    conformed_pulsation <= pulsation_with_out_rebound and not pulsation_with_out_rebound_t1;


end architecture rtl;