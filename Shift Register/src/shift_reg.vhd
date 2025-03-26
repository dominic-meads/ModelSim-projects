-- shift register implementation two ways
-- 1). using a for loop for a std_logic_vector
-- 2). using the shift_left function on an unsigned vector
--
-- 8-bit wide shift register that left shifts

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg is 
  generic(
    SR_WIDTH : integer := 8
  );
  port(
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    en      : in  std_logic;
    din     : in  std_logic;
    dout_0  : out std_logic;  -- output of for loop shift reg
    dout_1  : out std_logic   -- output of "shift_left" shift reg
  );
end entity;

architecture rtl of shift_reg is 

  -- signal for the for loop
  signal r_sr_std_logic : std_logic_vector(SR_WIDTH-1 downto 0) := (others => '0');

  -- signal for the "shift_left" function
  signal r_sr_unsigned : unsigned(SR_WIDTH-1 downto 0) := (others => '0');

begin
  
  FOR_LOOP_SHIFT_PROC : process(clk) is 
  begin 
    if rising_edge(clk) then 
      if rst_n = '0' then 
        r_sr_std_logic <= (others => '0');
      else 
        if en = '1' then 
          r_sr_std_logic(0) <= din;

          -- for loop 
          for i in 1 to SR_WIDTH-1 loop
            r_sr_std_logic(i) <= r_sr_std_logic(i-1);
          end loop;
        end if;
      end if;
    end if;
  end process FOR_LOOP_SHIFT_PROC;

  LEFT_SHIFT_FUNC_PROC : process(clk) is 
  begin
    if rising_edge(clk) then 
      if rst_n = '0' then 
        r_sr_unsigned <= (others => '0');
      else 
        if en = '1' then 
          r_sr_unsigned <= shift_left(r_sr_unsigned,1); -- can only use shift left with unsigned types
          r_sr_unsigned(0) <= din;  -- must come after "shift_left"
        end if;
      end if;
    end if;
  end process LEFT_SHIFT_FUNC_PROC;

  dout_0 <= r_sr_std_logic(r_sr_std_logic'high);
  dout_1 <= std_logic(r_sr_unsigned(r_sr_unsigned'high));

end architecture;