library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is generic (width: natural :=10; max: natural := 525);
    Port ( clk : in  STD_LOGIC;
           resetn : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           value : out  STD_LOGIC_VECTOR(width-1 downto 0));
end Counter;

architecture Behavioral of Counter is
signal value_next, value_int: std_logic_vector(width-1 downto 0) := (others => '0');
begin
-- Set the next synchronous value depending on counter value and enable
value_next <= value_int when enable='0'
	else (others => '0') when (unsigned(value_int)) = max-1
	else std_logic_vector(unsigned(value_int)+1);
-- Update counter
value_int <= (others => '0') when resetn='0' else value_next when rising_edge(clk);
value <= value_int;
end Behavioral;