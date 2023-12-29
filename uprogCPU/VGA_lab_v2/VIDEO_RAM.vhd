--------------------------------------------------------------------------------
-- PICT MEM
-- Anders Nilsson
-- 16-feb-2016
-- Version 1.1


-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity VIDEO_RAM is
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
end VIDEO_RAM;


-- architecture
architecture Behavioral of VIDEO_RAM is
	-- data Memory component
	component dMem is
		port(dAddr : in unsigned(3 downto 0);
			dData : out unsigned(10 downto 0));
  	end component;


	-- video RAM type
	type ram_t is array (0 to 2047) of std_logic_vector(7 downto 0);
	-- initiate video RAM to one cursor ("1F") followed by spaces ("00")
	signal VideoRAM : ram_t := (others => (x"02"));

	signal addr : unsigned(3 downto 0);
	signal data : unsigned(10 downto 0);
	signal framePlace : unsigned(10 downto 0);

begin

	--
	-- Circle through memory untill '10' is found
	--
	process(clk)
	begin
		if rising_edge(clk) then
			addr <= addr + 1;
			if data(1 downto 0) = "10" then
				addr <= (others => '0');
			end if;
		end if;
	end process;

	--
	-- Convert word from memory to VIDEO-RAM prosition
	--
	framePlace <= ("000" & data(10 downto 6)) + resize(("0000" & data(5 downto 2))*20, 11);
	
	--
	-- Memory reads and
	--
	process(clk)
	begin
		if rising_edge(clk) then
			if data(1 downto 0) /= "10" then
				
				VideoRAM(to_integer(framePlace)) <= std_logic_vector(b"000000" & data(1 downto 0));
			end if;
			data_out1 <= VideoRAM(to_integer(framePlace));

			--if (we2 = '1') then
			--	VideoRAM(to_integer(addr2)) <= data_in2;
			--end if;
			data_out2 <= VideoRAM(to_integer(addr2));
		end if;
	end process;


	pMem_c : dMem port map(dAddr=>addr, dData=>data);

end Behavioral;
