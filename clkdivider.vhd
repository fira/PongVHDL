library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clkdiv2 is
    Port ( clkin : in  STD_LOGIC;
           clkout : out  STD_LOGIC);
end clkdiv2;

architecture Behavioral of clkdiv2 is
	signal clk_int : STD_LOGIC := '0';
begin
	clk_int <= not clk_int when rising_edge(clkin); 
	clkout <= clk_int;
end Behavioral;

