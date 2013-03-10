library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ClockDiv is
	Generic (
		n : natural := 5000;
		vect_wid : natural := 13
	);
	
    Port ( 
			  enable : in STD_LOGIC;
			  resetn : in STD_LOGIC;
			  
			  clk : in  STD_LOGIC;
           clkdiv : out  STD_LOGIC
			  );
			  
end ClockDiv;

architecture Behavioral of ClockDiv is
signal value : std_logic_vector(vect_wid downto 1);
begin

clkcounter : entity work.Counter
		generic map (max => n, width => vect_wid) 
		port map (clk => clk, enable => enable, value => value , resetn => resetn);

clkdiv <= '1' when unsigned(value) = to_unsigned(n, vect_wid) and enable = '1'
	else '0';

end Behavioral;
