library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is 
end entity;

architecture sim of ram_tb is

  constant WIDTH_BITS : integer := 8;
  constant ADDR_BITS  : integer := 8;

  signal clk    : std_logic := '0';
  signal rst_n  : std_logic := '0';
  signal wr_en  : std_logic := '0';
  signal re_en  : std_logic := '0';
  signal waddr  : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal raddr  : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
  signal wdata  : std_logic_vector(WIDTH_BITS-1 downto 0) := (others => '0');
  signal rdata  : std_logic_vector(WIDTH_BITS-1 downto 0);
  signal err    : std_logic;

begin

  uut : entity work.ram(rtl) 
    generic map(
      WIDTH_BITS => WIDTH_BITS,
      ADDR_BITS => ADDR_BITS
    )
    port map(
      clk   => clk,
      rst_n => rst_n,
      wr_en => wr_en,
      re_en => re_en,
      waddr => waddr,
      raddr => raddr,
      wdata => wdata,
      rdata => rdata,
      err   => err
    );

  CLK_PROC : process is
  begin 
    wait for 10 ns;
    clk <= not clk;
  end process CLK_PROC;

  ERR_PROC : process(err) is
  begin 
    if err = '1' then 
      report "ERROR CANNOT READ AND WRITE TO SAME ADDRESS SIMULTANEOUSLY";
    end if;
  end process ERR_PROC;

  STIM_PROC : process is 
  begin
    report "Simulating RAM with size of " & integer'image(2**ADDR_BITS) & 
            " addresses deep by " & integer'image(WIDTH_BITS) & "-bits wide";
    wait for 40 ns;
    rst_n <= '1';  -- release reset

    -- write to a few addresses
    wait for 30 ns;
    waddr <= x"01";
    wr_en <= '1';
    wdata <= x"FF";
    wait for 30 ns;
    waddr <= x"02";
    wr_en <= '1';
    wdata <= x"FF";
    wait for 30 ns;
    waddr <= x"03";
    wr_en <= '1';
    wdata <= x"FF";

    wait for 20 ns;
    wr_en <= '0';

    -- read from a few addresses
    wait for 30 ns;
    raddr <= x"01";
    re_en <= '1';
    wait for 30 ns;
    raddr <= x"02";
    re_en <= '1';
    wait for 30 ns;
    raddr <= x"03";
    re_en <= '1';

    -- attempt to read and write to same address at same time
    wait for 20 ns;
    raddr <= x"FF";
    waddr <= x"FF";
    wr_en <= '1';
    re_en <= '1';

    wait;
  end process STIM_PROC;

end sim ;