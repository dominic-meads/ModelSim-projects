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
    dout  : out std_logic
  );
end entity;

architecture rtl of debounce is
  
  -- constants for counter
  constant CLK_CNTS_FOR_STABLE_TIME : real := real(SYS_CLK_HZ) * 1.0e-3 * real(STABLE_TIME_MILLIS);
  constant CLK_CNTR_BITS : integer := integer( ceil( log2(CLK_CNTS_FOR_STABLE_TIME) ) );

  -- counter signals
  signal r_clk_cntr : unsigned(CLK_CNTR_BITS-1 downto 0) := (others => '0');
  signal r_cntr_en  : std_logic := '0';

  -- output register
  signal r_dout : std_logic := '0';
  
begin 

  COUNTER_EN_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then
      if n_rst = '0' then 
        r_cntr_en <= '0';
      else
        if din /= r_dout then   -- enable counter if input does not match output
          r_cntr_en <= '1';
        else 
          r_cntr_en <= '0'; 
        end if;
      end if;
    end if;
  end process COUNTER_EN_PROC;

  COUNT_UP_DURING_STABLE_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if n_rst = '0' then 
        r_clk_cntr <= (others => '0');
      else 
        if r_cntr_en = '1' then 
          if r_clk_cntr < integer(CLK_CNTS_FOR_STABLE_TIME) then 
            r_clk_cntr <= r_clk_cntr + 1;
          else 
            r_clk_cntr <= (others => '0');
          end if;
        else
          r_clk_cntr <= (others => '0');
        end if;
      end if;
    end if;
  end process COUNT_UP_DURING_STABLE_PROC;

  DOUT_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if n_rst = '0' then 
        r_dout <= '0';
      else 
        if r_clk_cntr = integer(CLK_CNTS_FOR_STABLE_TIME) then  -- only update output if input has been stable
          r_dout <= din;
        end if;
      end if;
    end if;
  end process DOUT_PROC;

  -- output assignment
  dout <= r_dout;

end architecture;