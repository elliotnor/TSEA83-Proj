--------------------------------------------------------------------------------
-- VGA lab testbench
-- Anders Nilsson
-- 26-feb-2020
-- Version 1.0


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations
entity VGA_lab_tb is
end entity;

architecture func of VGA_lab_tb is

	component VGA_lab
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
	end component;

	signal clk : std_logic;
	signal rst : std_logic;
	signal PS2KeyboardCLK : std_logic;
	signal PS2KeyboardData : std_logic;

	constant FPGA_clk_period : time := 10 ns;
	constant PS2_clk_period : time := 60 us;
	constant PS2_time : time := 1 ms;

begin

	uut: VGA_lab port map(
		clk => clk,
		rst => rst,
		PS2KeyboardCLK => PS2KeyboardCLK,
		PS2KeyboardData => PS2KeyboardData
	);

	PS2_stimuli : process
		type pattern_array is array(natural range <>) of unsigned(7 downto 0);
		constant patterns : pattern_array :=
			();
	begin
		PS2KeyboardData <= '1';											-- initial value
		PS2KeyboardCLK <= '1';
		wait for PS2_time;
		for i in patterns'range loop
			PS2KeyboardData <= '0';										-- start bit
			wait for PS2_clk_period/2;
			PS2KeyboardCLK <= '0';
			for j in 0 to 7 loop
				wait for PS2_clk_period/2;
				PS2KeyboardData <= patterns(i)(j);			-- data bit(s)
				PS2KeyboardCLK <= '1';
				wait for PS2_clk_period/2;
				PS2KeyboardCLK <= '0';									-- data valid on negative flank
			end loop;
			wait for PS2_clk_period/2;
			PS2KeyboardData <= '0';										-- parity bit (bogus value, always '0')
			PS2KeyboardCLK <= '1';
			wait for PS2_clk_period/2;
			PS2KeyboardCLK <= '0';
			wait for PS2_clk_period/2;
			PS2KeyboardData <= '1';										-- stop bit
			PS2KeyboardCLK <= '1';
			wait for PS2_clk_period/2;
			PS2KeyboardCLK <= '0';
			wait for PS2_clk_period/2;
			PS2KeyboardCLK <= '1';
			if (((i mod 3) = 0) or (((i+1) mod 3) = 0)) then
				wait for PS2_time;											-- wait between Make and Break
			else
				wait for PS2_clk_period/2;
			end if;
		end loop;
		wait; -- for ever
    end process;

--Change this and adapt to joystick movement instead of keyboard


	clk_process : process
	begin
		clk <= '0';
		wait for FPGA_clk_period/2;
		clk <= '1';
		wait for FPGA_clk_period/2;
	end process;

	rst <= '1', '0' after 25 ns;


end architecture;

