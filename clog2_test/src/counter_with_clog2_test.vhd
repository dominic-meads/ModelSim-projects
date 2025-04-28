library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_with_clog2_test is 
  generic (
    COUNT_MAX = 255
  );
  port (
    clk : in std_logic;
    rst_n : in std_logic;
    count : out unsigned(7 downto 0)
  );
end entity;

architecture rtl of counter_with_clog2_test is

  signal 

begin

end architecture