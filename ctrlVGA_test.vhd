library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrlVGA_test is
	Port (
		-- Control signals
		clk : in STD_LOGIC;
		enable : in STD_LOGIC;
		resetn : in STD_LOGIC;

		-- VGA Output
		HSync : out STD_LOGIC;
		VSync : out STD_LOGIC;
		Rout	: out STD_LOGIC_VECTOR(2 downto 0);
		Gout	: out STD_LOGIC_VECTOR(2 downto 0);
		Bout 	: out STD_LOGIC_VECTOR(2 downto 1)
	);
end ctrlVGA_test;

architecture BlueScreen of ctrlVGA_test is
begin
	main: entity work.ctrlVGA(Behavioral) port map(clk => clk, enable => '1', 
		HSync => HSync, VSync => VSync,  Rout => Rout, Gout => Gout, Bout => Bout, resetn => '1', R => "000", G => "000", B => "11");
end BlueScreen;