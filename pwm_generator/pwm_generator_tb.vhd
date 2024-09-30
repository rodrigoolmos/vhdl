library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity pwm_generator_tb is
end;

architecture bench of pwm_generator_tb is
  constant end_cnt_size : NATURAL := 10;
  constant duty_cycle_size : NATURAL := 5;

  component pwm_generator
      generic(
          end_cnt_size : natural := end_cnt_size;
          duty_cycle_size : natural := duty_cycle_size
      );
      Port ( clk : in STD_LOGIC;
             nrst : in STD_LOGIC;
             pwm : out STD_LOGIC;
             duty_cycle : in STD_LOGIC_VECTOR (duty_cycle_size -1 downto 0);
             end_cnt : in STD_LOGIC_VECTOR (end_cnt_size -1 downto 0));
  end component;
  

  signal clk: STD_LOGIC;
  signal nrst: STD_LOGIC;
  signal pwm: STD_LOGIC;
  signal duty_cycle: STD_LOGIC_VECTOR (duty_cycle_size -1 downto 0);
  signal end_cnt: STD_LOGIC_VECTOR (end_cnt_size -1 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: pwm_generator generic map ( end_cnt_size =>  end_cnt_size,
                                   duty_cycle_size =>  duty_cycle_size)
                        port map ( clk          => clk,
                                   nrst         => nrst,
                                   pwm          => pwm,
                                   duty_cycle   => duty_cycle,
                                   end_cnt      => end_cnt );
  stimulus: process
  begin

    NRST <= '0';
    wait for 5 ns;
    NRST <= '1';
    wait for 5 ns;
    wait until rising_edge(clk);
    end_cnt <= std_logic_vector(to_unsigned(32, end_cnt'length));
    for i in 0 to 31 loop
        duty_cycle <= std_logic_vector(to_unsigned(i, duty_cycle'length));
        wait for 10 * clock_period * 32;
    end loop;
    for i in 1 to 2**end_cnt_size -1 loop
        end_cnt <= std_logic_vector(to_unsigned(i, end_cnt'length));
        for j in 0 to 2**duty_cycle_size -1 loop
            duty_cycle <= std_logic_vector(to_unsigned(j, duty_cycle'length));
            wait for 10 * clock_period * (2**i);
        end loop;
    end loop;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0';
      wait for clock_period / 2;
      clk <= '1';
      wait for clock_period / 2;      
    end loop;
    wait;
  end process;

end;