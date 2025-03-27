-- simple switch sequence detection module. 
-- the green LED only lights up if the correct password (switch sequence) is input
-- otherwise, the red led lights up
-- the correct password is 1011 (switch_3 high, switch_2 low, switch_1 high, switch_0 low)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity switch_sequence_detect is 
  generic(
    CLK_HZ     : integer := 100e6; -- clock frequency
    LED_MILLIS : integer := 10     -- amount of milliseconds to light up the LEDS for
  );
  port(
    clk      : in  std_logic;
    rst_n    : in  std_logic;
    switch_0 : in  std_logic;
    switch_1 : in  std_logic;
    switch_2 : in  std_logic;
    switch_3 : in  std_logic;
    led_g    : out std_logic;
    led_r    : out std_logic;
  );
end entity;

architecture rtl of switch_sequence is 

  -- output registers
  signal r_led_g : std_logic := '0';
  signal r_led_r : std_logic := '0';

  -- counter register and enable to light up LEDs for a specified period of time
  constant LED_CLK_CNTS = (CLK_HZ / 1000) * LED_MILLIS;  -- amount of clock counts to keep LEDs high
  signal r_counter    : unsigned(31 downto 0) := (others => '0'); -- ADD $clog2 FUNCTION FOR THIS SIZE
  signal r_counter_en : std_logic := '0';

  -- state signals
  type t_state is (GET_FIRST_PRESS, GET_SECOND_PRESS, GET_THIRD_PRESS, GET_FOURTH_PRESS, COMPARE);
  signal r_current_state : t_state := GET_FIRST_PRESS;
  signal r_next_state    : t_state := GET_FIRST_PRESS;

  -- sequence compare register
  signal r_sequence_compare : std_logic_vector(3 downto 0) := (others => '0');

begin

  -- next state logic
  NEXT_STATE_PROC : process(r_current_state, switch_0, switch_1, switch_2, switch_3, r_counter) is 
  begin 
    case r_current_state is 

      when GET_FIRST_PRESS => 
        if switch_0 or switch_1 or switch_2 or switch_3 then -- if any switches are pressed, move to next state
          r_next_state <= GET_SECOND_PRESS;
        else 
          r_next_state <= r_current_state;
        end if;

        when GET_SECOND_PRESS => 
          if switch_0 or switch_1 or switch_2 or switch_3 then -- if any switches are pressed, move to next state
            r_next_state <= GET_THIRD_PRESS;
          else 
            r_next_state <= r_current_state;
          end if;

        when GET_THIRD_PRESS => 
          if switch_0 or switch_1 or switch_2 or switch_3 then -- if any switches are pressed, move to next state
            r_next_state <= GET_FOURTH_PRESS;
          else 
            r_next_state <= r_current_state;
          end if;

        when GET_FOURTH_PRESS => 
          if switch_0 or switch_1 or switch_2 or switch_3 then -- if any switches are pressed, move to next state
            r_next_state <= COMPARE;
          else 
            r_next_state <= r_current_state;
          end if;

        when COMPARE => 
          if r_counter = to_unsigned(LED_CLK_CNTS-1) then -- wait for specified LED light up time before changing states
            r_next_state <= GET_FIRST_PRESS;
          else 
            r_next_state <= r_current_state;
          end if;
        
        when others => 
          r_next_state <= GET_FIRST_PRESS;

    end case;
  end process NEXT_STATE_PROC;

  STATE_UPDATE_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if rst_n = '0' then 
        r_current_state <= GET_FIRST_PRESS;
      else 
        r_current_state <= r_next_state;
      end if;
    end if;
  end process STATE_UPDATE_PROC;

  STATE_OUTPUT_LOGIC_PROC : process(r_current_state) is 
  begin
    if r_current_state = GET_FIRST_PRESS then
      r_led_g      <= '0';
      r_led_r      <= '0';
      r_counter_en <= '0';
    elsif r_current_state = GET_SECOND_PRESS then
      r_led_g      <= '0';
      r_led_r      <= '0';
      r_counter_en <= '0'; 
    elsif r_current_state = GET_THIRD_PRESS then 
      r_led_g      <= '0';
      r_led_r      <= '0';
      r_counter_en <= '0';
    elsif r_current_state = GET_FOURTH_PRESS then
      r_led_g      <= '0';
      r_led_r      <= '0';
      r_counter_en <= '0'; 
    elsif r_current_state = COMPARE then
      r_counter_en <= '1';
      if r_sequence_compare = "1011" then 
        r_led_g <= '1';
        r_led_r <= '0';
      else
        r_led_g <= '0';
        r_led_r <= '1'; 
      end if;
    else
      r_led_g      <= '0';
      r_led_r      <= '0';
      r_counter_en <= '0';
    end if;
  end process STATE_OUTPUT_LOGIC_PROC;

  -- add output assignments
  -- add counter process

end architecture;