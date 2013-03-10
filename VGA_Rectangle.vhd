library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_Rectangle is
	Generic (
		v_wid: natural := 11;
		h_wid: natural := 11
	);

    Port ( 
				-- Position, Height and Width
			  x : in  STD_LOGIC_VECTOR(h_wid downto 1);
			  y : in  STD_LOGIC_VECTOR(v_wid downto 1);
			  w : in  STD_LOGIC_VECTOR(h_wid downto 1);
           h : in  STD_LOGIC_VECTOR(v_wid downto 1);
			  xborder : in STD_LOGIC_VECTOR(h_wid downto 1);
			  yborder : in STD_LOGIC_VECTOR(v_wid downto 1);
			  
				-- Current pixel position
			  xcur : in  STD_LOGIC_vector(h_wid downto 1);
			  ycur : in  STD_LOGIC_vector(v_wid downto 1);
			  
				-- Control signals
           enable : in  STD_LOGIC;
			  clk : in STD_LOGIC;
			  
			   -- Display signal
			  RGBin : in STD_LOGIC_VECTOR(8 downto 1);
			  RGBout : out  STD_LOGIC_vector(8 downto 1);
			  -- We could use an alpha channel but this'd be so annoying..
			  Displayed : out  STD_LOGIC 
		);
end VGA_Rectangle;

-- Filled Rectangle, positions refering to NW(Top-Left) border
architecture NWFilled of VGA_Rectangle is
	signal Displayed_int : std_logic;
begin
	Displayed_int <= '1' when
		(unsigned(xcur) >= unsigned(x)) and (unsigned(xcur) <= (unsigned(x) + unsigned(w))) and
		(unsigned(ycur) >= unsigned(y)) and (unsigned(ycur) <= (unsigned(y) + unsigned(y))) 
		and enable='1'
		else '0';
	RGBout <= RGBin when Displayed_int = '1' else (others=>'0');
	
	Displayed <= Displayed_int;
end NWFilled;

