-- simple switch sequence detection module. 
-- the green LED only lights up if the correct password (switch sequence) is input
-- otherwise, the red led lights up
-- the correct password is 1011 (switch_3 high, switch_2 low, switch_1 high, switch_0 low)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;