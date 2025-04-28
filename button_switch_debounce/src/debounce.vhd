library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity debounce is 
  generic(
    STABLE_TIME_MILLIS : integer := 20;  -- time (ms) required for switch to be in stable state before output updates
    SYS_CLK_HZ         : integer := 12e6 -- system or input clock frequency
  );
  port(
    clk   : in  std_logic;
    n_rst : in  std_logic;
    din   : in  std_logic;
    dout  : out std_logic;
  );
end entity;

architecture rtl of debounce is
  
  constant CLK_CNTS_FOR_STABLE_TIME : integer := SYS_CLK_HZ / (1e3 * STABLE_TIME_MILLIS);
  constant CLK_CNTR_BITS : integer := integer( ceil( log2( real(CLK_CNTS_FOR_STABLE_TIME) ) ) );

  signal r_clk_cntr : unsigned(CLK_CNTR_BITS-1 downto 0) := (others => '0');
  signal r_cntr_en  : std_logic := '0';
  
begin 

end architecture;