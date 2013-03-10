
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Pong is
	-- Display Width and Height in Bits
	Generic (
		v_wid: natural := 11;
		h_wid: natural := 11
	);

	Port (
			-- Control signals
			clk : in STD_LOGIC;
			enable : in STD_LOGIC;
			resetn : in STD_LOGIC;
			
			-- Push-button Inputs
			DPadUp1 : in STD_LOGIC;
			DPadDown1 : in STD_LOGIC;
			DPadUp2 : in STD_LOGIC;
			DPadDown2 : in STD_LOGIC;

			-- VGA Output
			HSync : out STD_LOGIC;
			VSync : out STD_LOGIC;
			Rout	: out STD_LOGIC_VECTOR(2 downto 0);
			Gout	: out STD_LOGIC_VECTOR(2 downto 0);
			Bout 	: out STD_LOGIC_VECTOR(2 downto 1)
		);
end Pong;

architecture Classic of Pong is
	signal lineCounter_int : STD_LOGIC_VECTOR(v_wid downto 1);
	signal columnCounter_int : STD_LOGIC_VECTOR(h_wid downto 1);
	signal Blank : STD_LOGIC;
	
	signal RGB : STD_LOGIC_VECTOR(8 downto 1);
	signal R : STD_LOGIC_VECTOR(2 downto 0);	
	signal G : STD_LOGIC_VECTOR(2 downto 0);	
	signal B : STD_LOGIC_VECTOR(2 downto 1);	

	signal DisplayedPad1 : STD_LOGIC;
	signal RGBPad1 : STD_LOGIC_VECTOR(8 downto 1);
	signal XPad1 : STD_LOGIC_VECTOR(h_wid downto 1) := std_logic_vector(to_unsigned(30, h_wid));
	signal YPad1 : STD_LOGIC_VECTOR(v_wid downto 1) := std_logic_vector(to_unsigned(100, v_wid));
	
	signal DisplayedPad2 : STD_LOGIC;
	signal RGBPad2: STD_LOGIC_VECTOR(8 downto 1);
	signal XPad2 : STD_LOGIC_VECTOR(h_wid downto 1) := std_logic_vector(to_unsigned(750, h_wid));
	signal YPad2 : STD_LOGIC_VECTOR(v_wid downto 1) := std_logic_vector(to_unsigned(100, v_wid));
	
	-- Internal Game Clock 10kHz
	signal clk_game : STD_LOGIC;
	-- Secondary Clock 100 Hz
	signal clk_10ms : STD_LOGIC;
	
begin
	-- Implement the VGA Module
	VGA: entity work.ctrlVGA(Behavioral) port map(clk => clk, enable => '1', lineCounter => lineCounter_int, columnCounter => columnCounter_int,
		HSync => HSync, VSync => VSync,  Blank => Blank, Rout => Rout, Gout => Gout, Bout => Bout, resetn => '1', R => R, G => G, B => B);
	
	-- Internal clock speed dividers
	divider10K: entity work.ClockDiv(Behavioral) generic map(n => 5000, vect_wid => 13) port map(enable =>'1', clk => clk, clkdiv => clk_game, resetn => resetn);
	divider100: entity work.ClockDiv generic map(n => 100, vect_wid => 7) port map(enable => clk_game, clk => clk, clkdiv => clk_10ms, resetn => resetn);
	
	-- User Input for pads movement
	YPad1 <= 
		std_logic_vector(unsigned(YPad1) + 1) when clk_10ms = '1' and DPadUp1 = '1' else -- + boundary constraint (TODO)
		std_logic_vector(unsigned(YPad1) - 1) when clk_10ms = '1' and DPadDown1 = '1' 	-- + boundary constraint (TODO)
		else YPad1;
		
	-- Player Pads Display
	Pad1: entity work.VGA_Rectangle(NWFilled) port map(
		enable => '1', RGBout => RGBPad1, Displayed => DisplayedPad1,
		x => XPad1, y => YPad1, 
		xcur => columnCounter_int, ycur => lineCounter_int, 
		w => std_logic_vector(to_unsigned(20, h_wid)), h => std_logic_vector(to_unsigned(200, v_wid)), 
		RGBin => "00000011");
	Pad2: entity work.VGA_Rectangle(NWFilled) port map(
		enable => '1', RGBout => RGBPad2, Displayed => DisplayedPad2,
		x => XPad2, y => YPad2, 
		xcur => columnCounter_int, ycur => lineCounter_int, 
		w => std_logic_vector(to_unsigned(20, h_wid)), h => std_logic_vector(to_unsigned(200, v_wid)), 
		RGBin => "10000000");
	
	-- Display Priority
	RGB <= RGBPad1 when DisplayedPad1 = '1'
	else   RGBPad2 when DisplayedPad2 = '1'
	else (others => '0');
	R <= RGB(8 downto 6);
	G <= RGB(5 downto 3);
	B <= RGB(2 downto 1);
end Classic;

