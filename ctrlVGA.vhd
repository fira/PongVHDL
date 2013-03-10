library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ctrlVGA is
	Generic (
		-- Default values for 800x600@75Hz
		h_pix: natural := 800;	-- Horizontal Display pixel width
		h_fp : natural := 16;	-- Horizontal Front Porch
		h_sp : natural := 80;	-- Horizontal Sync Pulse
		h_bp : natural := 160; 	-- Horizontal Back Porch
		h_wid: natural := 11;	-- Vector Width for Horizontal counter
		
		v_pix: natural := 600;
		v_fp : natural := 1;
		v_sp : natural := 3;		-- Same for vertical
		v_bp : natural := 21;
		v_wid: natural := 11;
		
		r_depth : natural := 3;	-- Color depth
		g_depth : natural := 3;
		b_depth : natural := 2
	);

	Port (
		-- Control signals
		clk : in STD_LOGIC;
		enable : in STD_LOGIC;
		R : in STD_LOGIC_VECTOR(r_depth downto 1);	-- Color input
		G : in STD_LOGIC_VECTOR(g_depth downto 1);	-- to be used by underlying
		B : in STD_LOGIC_VECTOR(b_depth downto 1);	-- application block
		resetn : in STD_LOGIC;	-- Active on low state

		-- VGA Output
		HSync : out STD_LOGIC;
		VSync : out STD_LOGIC;
		Rout	: out STD_LOGIC_VECTOR(r_depth downto 1); -- Color output
		Gout	: out STD_LOGIC_VECTOR(g_depth downto 1); -- to be forwarded to 
		Bout 	: out STD_LOGIC_VECTOR(b_depth downto 1); -- VGA port
	
		-- Status information
		lineCounter : out STD_LOGIC_VECTOR(v_wid downto 1);
		columnCounter : out STD_LOGIC_VECTOR(h_wid downto 1);
		Blank : out STD_LOGIC
	);
	
	constant h_max: natural := h_pix + h_fp + h_sp + h_bp;
	constant v_max: natural := v_pix + v_fp + v_sp + v_bp;
end ctrlVGA;

architecture Behavioral of ctrlVGA is
	signal lineCounter_int : STD_LOGIC_VECTOR(v_wid downto 1);
	signal columnCounter_int : STD_LOGIC_VECTOR(h_wid downto 1);
	
	signal lineTrigger : STD_LOGIC;
	signal Blank_int : STD_LOGIC;
begin
	-- Instanciate the column counter, running at the VGA's clock speed horizontally
	cc: entity work.Counter
		generic map (max => h_max, width => h_wid) 
		port map (clk => clk, enable => enable, value => columnCounter_int, resetn => resetn);
	
	-- Instanciate the line counter, running at the vertical frequency (approx 50 kHz)
	lc: entity work.Counter
		generic map (max => v_max, width => v_wid)
		port map (clk => clk, enable => lineTrigger, value => lineCounter_int, resetn => resetn);
	
	-- SYNCRONISATION
	-- Generate the next line trigger when we reach line end
	lineTrigger <= '1' when unsigned(columnCounter_int) = h_max-1 and enable = '1' else '0';
	-- Frame and Line synchronisation pulses
	HSync <= '1' when (unsigned(columnCounter_int) < h_fp+h_sp-1) and (unsigned(columnCounter_int) >= h_fp) and enable='1' else '0';
	VSync <= '1' when (unsigned(lineCounter_int) < v_fp+v_sp-1) and (unsigned(lineCounter_int) >= v_fp) and enable='1' else '0';
	
	-- FRAME CONTENTS
	-- Blank the screen when outside of display area
	Blank_int <= '1' when (unsigned(columnCounter_int) < h_fp+h_sp+h_bp-1) or (unsigned(lineCounter_int) < v_fp+v_sp+v_bp-1) else '0';
	-- Set actual pixel values from the instanciating entity if we're in the display area
	Rout <= (others => '0') when Blank_int = '1' else R;
	Gout <= (others => '0') when Blank_int = '1' else G;
	Bout <= (others => '0') when Blank_int = '1' else B;
	
	-- Set output pixel values
	columnCounter <= std_logic_vector(unsigned(columnCounter_int) - (h_fp+h_sp+h_bp)) when Blank_int = '0' else (others=>'1');
	lineCounter <= std_logic_vector(unsigned(lineCounter_int) - (v_fp+v_sp+v_bp)) when Blank_int = '0' else (others=>'1');
	Blank <= Blank_int;
end Behavioral;