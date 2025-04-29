library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce_tb is 
end entity;

architecture sim of debounce_tb is

    -- clk parameters
    constant CLK_HZ : integer := 12e6; 
    constant CLK_PERIOD : time := 1000 ms / CLK_HZ;

    -- constants for generics
    constant STABLE_TIME_MILLIS : integer := 20;  -- time (ms) required for switch to be in stable state before output update
  
    -- DUT ports
    signal clk   : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal din   : std_logic := '0';
    signal dout  : std_logic;
  
begin 

  -- DUT
  DUT : entity work.debounce(rtl)
    generic map(
      STABLE_TIME_MILLIS => STABLE_TIME_MILLIS,
      SYS_CLK_HZ         => CLK_HZ
    )
    port map(
      clk   => clk,
      n_rst => n_rst,
      din   => din,
      dout  => dout
    );

  CLK_PROC : process is 
  begin 
    wait for CLK_PERIOD / 2;
    clk <= not clk;
  end process CLK_PROC;

  STIM_PROC : process is 
  begin 
    wait for 15 ms;
    n_rst <= '1';
    wait for 20 ms;

    -- switch bounce when during low-to-high transition
    wait for 1.4 ms;
    din <= '1';
    wait for 3.5 ms;
    din <= '0';
    wait for 2.9 ms;
    din <= '1';
    wait for 3.3 ms;
    din <= '0';
    wait for 1.2 ms;
    din <= '1';

    -- switch high time
    wait for 45 ms;

    -- switch bounce when during high-to-low transition
    wait for 1.4 ms;
    din <= '0';
    wait for 3.5 ms;
    din <= '1';
    wait for 2.9 ms;
    din <= '0';
    wait for 3.3 ms;
    din <= '1';
    wait for 1.2 ms;
    din <= '0';

    -- switch low time
    wait for 45 ms;
    

    wait;
  end process STIM_PROC;

end architecture;