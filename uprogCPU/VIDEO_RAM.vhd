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
		addr2     : in unsigned(10 downto 0);

		vga_motor_addr : out unsigned(9 downto 0);
		vga_motor_data : in unsigned(15 downto 0));


end VIDEO_RAM;


-- architecture
architecture Behavioral of VIDEO_RAM is
	-- data Memory component
	---component pMem is
		--port(clk   : in std_logic; 
			--pAddr : in unsigned(8 downto 0);
			--pAddr_store : in unsigned(8 downto 0);
			--pData : out unsigned(15 downto 0);
			--pStore: in std_logic;
			--pData_in: in unsigned(15 downto 0));
  	--end component;


	-- video RAM type
	type ram_t is array (0 to 2047) of std_logic_vector(1 downto 0);
	-- initiate video RAM to one cursor ("1F") followed by spaces ("00")
	signal VideoRAM : ram_t := (others => "11");


	signal pAddr_store : unsigned(8 downto 0);
	signal pStore : std_logic;
	signal pData_in : unsigned(15 downto 0);
	signal addr : unsigned(8 downto 0) := b"011010111" ;
	signal data : unsigned(15 downto 0);
	signal framePlace : unsigned(10 downto 0);
	signal lastPlace : unsigned(10 downto 0);

begin

	--
	-- Circle through memory untill '10' is found
	--
	process(clk)
	begin
		if rising_edge(clk) then
			addr <= addr + 1;
			if vga_motor_data(4 downto 0) = "00010" then
				addr <= b"011010011";
			end if;
			null;
		end if;
	end process;

	--
	-- Convert word from memory to VIDEO-RAM prosition
	--
	framePlace <= ("000" & vga_motor_data(10 downto 6)) + resize(("0000" & vga_motor_data(5 downto 2))*20, 11);
	
	--
	-- Memory reads and
	--
	process(clk)
	begin
		if rising_edge(clk) then
			--VideoRAM(to_integer(lastPlace)) <= std_logic_vector("00";
			
			if vga_motor_data(4 downto 0) /= "00010"  then
				VideoRAM(to_integer(framePlace)) <= std_logic_vector(vga_motor_data(1 downto 0));
			end if;
			data_out1 <= "000000" & VideoRAM(to_integer(framePlace));

			data_out2 <= "000000" & VideoRAM(to_integer(addr2));
		end if;
	end process;
	vga_motor_addr <= "0" & addr;  
	--lastPlace <= framePlace;

	--pMem_c : pMem port map(clk=>clk, pAddr=>addr, pAddr_store=>pAddr_store, pData=>data, pStore=>pStore, pData_in=>pData_in);

end Behavioral;
