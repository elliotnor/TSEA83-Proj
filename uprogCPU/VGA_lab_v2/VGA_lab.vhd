--------------------------------------------------------------------------------
-- VGA lab
-- Version 1.0: 2015-12-16. Anders Nilsson
-- Version 2.0: 2023-01-12. Petter Kallstrom. Changelog: Splitting KBD_ENC into KBD_ENC + PRETENDED_CPU


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations

-- entity
entity VGA_lab is
	port (
		clk      : in std_logic;                         -- system clock
		rst      : in std_logic;                         -- reset
		Hsync    : out std_logic;                        -- horizontal sync
		Vsync    : out std_logic;                        -- vertical sync
		vgaRed   : out std_logic_vector(2 downto 0);     -- VGA red
		vgaGreen : out std_logic_vector(2 downto 0);     -- VGA green
		vgaBlue  : out std_logic_vector(2 downto 1);     -- VGA blue
		PS2KeyboardCLK  : in std_logic;                  -- PS2 clock
		PS2KeyboardData : in std_logic);                 -- PS2 data
end VGA_lab;


-- architecture
architecture Behavioral of VGA_lab is
	
	-- PS2 keyboard encoder component
	component KBD_ENC
		port (
			clk             : in std_logic;   -- system clock (100 MHz)
			rst             : in std_logic;   -- reset signal
			PS2KeyboardCLK  : in std_logic;   -- USB keyboard PS2 clock
			PS2KeyboardData : in std_logic;   -- USB keyboard PS2 data
			ScanCode        : out std_logic_vector(7 downto 0); -- scancode byte
			make_op         : out std_logic);                   -- one-pulsed scancode-enable
	end component;
	
        -- pretended CPU
	component PRET_CPU is
		port (
			clk      : in std_logic;   -- system clock (100 MHz)
			rst      : in std_logic;   -- reset signal
			ScanCode : in std_logic_vector(7 downto 0);   -- scancode byte
			make_op  : in std_logic;                      -- one-pulsed scancode-enable
			data     : out std_logic_vector(7 downto 0);  -- tile data
			addr     : out unsigned(10 downto 0);         -- tile address
			we       : out std_logic);                    -- write enable
	end component;
	
	-- picture memory component
	component VIDEO_RAM
		port (
			clk       : in std_logic;
			-- port 1
			we1       : in std_logic;
			data_in1  : in std_logic_vector(7 downto 0);
			data_out1 : out std_logic_vector(7 downto 0);
			addr1     : in unsigned(10 downto 0);
			-- port 2
			we2       : in std_logic;
			data_in2  : in std_logic_vector(7 downto 0);
			data_out2 : out std_logic_vector(7 downto 0);
			addr2     : in unsigned(10 downto 0));
	end component;
	
	-- VGA motor component
	component VGA_MOTOR
		port (
			clk      : in std_logic;
			VR_data  : in std_logic_vector(7 downto 0);
			VR_addr  : out unsigned(10 downto 0);
			rst      : in std_logic;
			vgaRed   : out std_logic_vector(2 downto 0);
			vgaGreen : out std_logic_vector(2 downto 0);
			vgaBlue  : out std_logic_vector(2 downto 1);
			Hsync    : out std_logic;
			Vsync    : out std_logic);
	end component;
	
	-- intermediate signals between KBD_ENC and PRETENDED_CPU
	signal ScanCode : std_logic_vector(7 downto 0);
	signal make_op : std_logic;
	
	-- intermediate signals between PRETENDED_CPU and VIDEO_RAM
	signal data_s : std_logic_vector(7 downto 0); -- data
	signal addr_s : unsigned(10 downto 0);        -- address
	signal we_s   : std_logic;                    -- write enable
	
	-- intermediate signals between VIDEO_RAM and VGA_MOTOR
	signal data_out2_s : std_logic_vector(7 downto 0); -- data
	signal addr2_s     : unsigned(10 downto 0);        -- address
	
begin
	
	-- keyboard encoder component connection
	U0 : KBD_ENC port map(clk=>clk, rst=>rst, PS2KeyboardCLK=>PS2KeyboardCLK, PS2KeyboardData=>PS2KeyboardData, ScanCode=>ScanCode, make_op=>make_op);
	
	-- pretended cpu component connection
	U1 : PRET_CPU port map(clk=>clk, rst=>rst, ScanCode=>ScanCode, make_op=>make_op, data=>data_s, addr=>addr_s, we=>we_s);
	
	-- picture memory component connection
	U2 : VIDEO_RAM port map(clk=>clk, we1=>we_s, data_in1=>data_s, addr1=>addr_s, we2=>'0', data_in2=>"00000000", data_out2=>data_out2_s, addr2=>addr2_s);
	
	-- VGA motor component connection
	U3 : VGA_MOTOR port map(clk=>clk, rst=>rst, VR_data=>data_out2_s, VR_addr=>addr2_s, vgaRed=>vgaRed, vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, Hsync=>Hsync, Vsync=>Vsync);
	
end Behavioral;

