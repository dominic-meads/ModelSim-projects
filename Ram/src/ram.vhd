library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is 
  generic(
    WIDTH_BITS : integer := 8; -- default is 256 address deep by 8 bits wide
    ADDR_BITS  : integer := 8
  );
  port(
    clk    : in  std_logic;
    rst_n  : in  std_logic;
    wr_en  : in  std_logic;
    re_en  : in  std_logic;
    waddr  : in  std_logic_vector(ADDR_BITS-1 downto 0);
    raddr  : in  std_logic_vector(ADDR_BITS-1 downto 0);
    wdata  : in  std_logic_vector(WIDTH_BITS-1 downto 0);
    rdata  : out std_logic_vector(WIDTH_BITS-1 downto 0);
    err    : out std_logic  -- error flag
  );
end entity;

architecture rtl of ram is 

  type ram_array is array (0 to 2**ADDR_BITS-1) of std_logic_vector(WIDTH_BITS-1 downto 0);
  signal r_ram : ram_array;

begin

  process(clk) is 
  begin
    if rising_edge(clk) then 
      if rst_n = '0' then 
        for i in 0 to 2**ADDR_BITS-1 loop
          r_ram(i) <= (others => '0');
        end loop;
      else
        if wr_en = '1' and re_en = '0' and waddr /= raddr then 
          r_ram(to_integer(unsigned(waddr))) <= wdata;
          err <= '0';
        elsif wr_en = '0' and re_en = '1' and waddr /= raddr then 
          rdata <= r_ram(to_integer(unsigned(raddr)));
          err <= '0';
        elsif wr_en = '1' and re_en = '1' and waddr = raddr then
          rdata <= (others => '0');
          err <= '1';
        else
          rdata <= (others => '0');
          err <= '0';
        end if;
      end if;
    end if;
  end process;

end architecture;