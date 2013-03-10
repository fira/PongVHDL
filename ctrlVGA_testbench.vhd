LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY ctrlVGA_testbench IS
END ctrlVGA_testbench;
 
ARCHITECTURE behavior OF ctrlVGA_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ctrlVGA
    PORT(
         clk : IN  std_logic;
         enable : IN  std_logic;
         resetn : IN  std_logic;
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
			R : IN std_logic_vector(2 downto 0);
			G : IN std_logic_vector(2 downto 0);
			B : IN std_logic_vector(2 downto 1);
         Rout : OUT  std_logic_vector(2 downto 0);
         Gout : OUT  std_logic_vector(2 downto 0);
         Bout : OUT  std_logic_vector(2 downto 1);
         lineCounter : OUT  std_logic_vector(9 downto 0);
         columnCounter : OUT  std_logic_vector(9 downto 0);
         Blank : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal enable : std_logic := '0';
   signal resetn : std_logic := '0';
	signal R : std_logic_vector(2 downto 0) := (others=>'0');
	signal G : std_logic_vector(2 downto 0) := (others=>'0');
   signal B : std_logic_vector(2 downto 1) := (others=>'0');

 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal lineCounter : std_logic_vector(9 downto 0);
   signal columnCounter : std_logic_vector(9 downto 0);
   signal Blank : std_logic;
	signal Rout : std_logic_vector(2 downto 0);
	signal Gout : std_logic_vector(2 downto 0);
   signal Bout : std_logic_vector(2 downto 1);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ctrlVGA PORT MAP (
          clk => clk,
          enable => enable,
          resetn => resetn,
          HSync => HSync,
          VSync => VSync,
          Rout => Rout,
          Gout => Gout,
          Bout => Bout,
			 R => R,
			 G => G,
			 B => B,
          lineCounter => lineCounter,
          columnCounter => columnCounter,
          Blank => Blank
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin	
		resetn <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;
		resetn <= '1';
		
		enable <= '1';
		R <= "000";
		G <= "000";
		B <= "00";
		
      wait;
   end process;

END;
