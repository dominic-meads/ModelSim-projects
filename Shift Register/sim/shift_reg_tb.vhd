library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_tb is 
end entity;

architecture sim of shift_reg_tb is

  -- uut ports
  constant SR_WIDTH : integer := 8;
  signal clk     : std_logic := '0';
  signal rst_n   : std_logic := '0';
  signal en      : std_logic := '0';
  signal din     : std_logic := '0';
  signal dout_0  : std_logic;  -- output of for loop shift reg
  signal dout_1  : std_logic;   -- output of "shift_left" shift reg

begin

  uut : entity work.shift_reg(rtl) 
    generic map(
      SR_WIDTH => SR_WIDTH
    )
    port map(
      clk    => clk,
      rst_n  => rst_n,
      en     => en,
      din    => din,
      dout_0 => dout_0,
      dout_1 => dout_1
    );

  CLK_PROC : process is 
  begin 
    wait for 10 ns;
    clk <= not clk;
  end process CLK_PROC; 

  STIM_PROC : process is 
  begin 
    wait for 50 ns;
    rst_n <= '1';  -- release reset
    wait for 20 ns;
    din <= '1';
    en <= '1';
    wait until rising_edge(clk);  -- just hold din high for one positive clock edge
    wait for 10 ns;
    din <= '0';
    wait;
  end process STIM_PROC;
  
end architecture;