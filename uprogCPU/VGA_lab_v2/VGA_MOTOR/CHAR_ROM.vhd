--------------------------------------------------------------------------------
-- CHAR_ROM
-- Version 2.0: 2023-07-12, Petter Kallstrom. ROM part of VGA_MOTOR.
-- Description:
-- * This is just a single-port ROM, that contains the images of all characters

-- https://www.pixilart.com/draw?ref=home-page

-- strawbarry evergreen colors

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity CHAR_ROM is
	port (
		clk      : in std_logic;
		addr     : in unsigned(10 downto 0);
		data     : out std_logic_vector(7 downto 0));
end CHAR_ROM;


-- architecture
architecture Behavioral of CHAR_ROM is
	type rom_t is array (0 to 255) of std_logic_vector(7 downto 0);
	signal ROM_DATA : rom_t;

begin

	-- Read from the ROM:
	process(clk)
	begin
		if rising_edge(clk) then
			data <= ROM_DATA(to_integer(addr));
		end if;
	end process;
	
	ROM_DATA <= (

		-- Head
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"00",x"00",x"00",x"00",x"08",x"08",
		x"08",x"00",x"FF",x"FF",x"FF",x"FF",x"00",x"08",
		x"08",x"00",x"FF",x"00",x"00",x"FF",x"00",x"08",
		x"08",x"00",x"FF",x"00",x"00",x"FF",x"00",x"08",
		x"08",x"00",x"FF",x"FF",x"FF",x"FF",x"00",x"08",
		x"08",x"08",x"00",x"00",x"00",x"00",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",

		-- Body
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",		
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",		
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",
		x"08",x"08",x"08",x"08",x"08",x"08",x"08",x"08",

		-- Ocean
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",		
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",		
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",

		-- fish
		x"07",x"07",x"07",x"07",x"07",x"07",x"07",x"07",
		x"07",x"07",x"a4",x"a4",x"a4",x"a4",x"a4",x"07",
		x"07",x"07",x"a4",x"a4",x"a4",x"00",x"a4",x"07",
		x"07",x"07",x"a4",x"a4",x"a4",x"a4",x"a4",x"07",
		x"07",x"07",x"a4",x"a4",x"a4",x"a4",x"a4",x"07",
		x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"07",
		x"a4",x"a4",x"a4",x"07",x"07",x"07",x"07",x"07",
		x"07",x"a4",x"a4",x"07",x"07",x"07",x"07",x"07"

	    
	);
	
end Behavioral;

