--------------------------------------------------------------------------------
-- KBD ENC
-- Version 1.1: 2016-02-16. Anders Nilsson
-- Version 2.0: 2023-01-12. Petter Kallstrom. Changelog: Remove everything that interprets the scancode
-- Description:
-- * Read bytes from a PS2 bus
-- * Encode bytes into scancodes
-- * Limitation: Does not handle scancodes containing "E0" or "E1" bytes.

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type
                                        -- and various arithmetic operations

-- entity
entity KBD_ENC is
	port (
		clk             : in std_logic;   -- system clock (100 MHz)
		rst             : in std_logic;   -- reset signal
		PS2KeyboardCLK  : in std_logic;   -- USB keyboard PS2 clock
		PS2KeyboardData : in std_logic;   -- USB keyboard PS2 data
		ScanCode        : out std_logic_vector(7 downto 0); -- scancode byte
		MAKE_op         : out std_logic);                   -- one-pulsed scancode-enable
end KBD_ENC;

-- architecture
architecture behavioral of KBD_ENC is
	signal PS2Clk  : std_logic;              -- Synchronized PS2 clock
	signal PS2Data : std_logic;              -- Synchronized PS2 data
	signal PS2Clk_Q1, PS2Clk_Q2 : std_logic; -- PS2 clock one pulse flip flop
	signal PS2Clk_op : std_logic;            -- PS2 clock one pulse 
	
	signal PS2Data_sr : std_logic_vector(10 downto 0);-- PS2 data shift register
	signal ScanCode_int : std_logic_vector(7 downto 0); -- internal version of ScanCode
	
	signal PS2BitCounter : unsigned(3 downto 0); -- PS2 bit counter
	signal BC11 : std_logic;                     -- '1' when PS2BitCounter = 11
	
	type state_type is (IDLE, MAKE, BREAK); -- declare state types for PS2
	signal PS2state : state_type;           -- PS2 state
	
begin
	
	-- Synchronize PS2-KBD signals
	process(clk)
	begin
		if rising_edge(clk) then
			PS2Clk <= PS2KeyboardCLK;
			PS2Data <= PS2KeyboardData;
		end if;
	end process;
	
        
	-- Generate one cycle pulse from PS2 clock, negative edge
	
	process(clk)
	begin
		if rising_edge(clk) then
			if rst='1' then
				PS2Clk_Q1 <= '1';
				PS2Clk_Q2 <= '0';
			else
				PS2Clk_Q1 <= PS2Clk;
				PS2Clk_Q2 <= not PS2Clk_Q1;
			end if;
		end if;
	end process;
	
	PS2Clk_op <= (not PS2Clk_Q1) and (not PS2Clk_Q2);
	



	-- PS2 data shift register
	-- ***********************************
	-- *                                 *
	-- *  VHDL for :                     *
	-- *  PS2Data_sr                     *
	-- *                                 *
	-- ***********************************
process(clk)
	begin 
	if rising_edge(clk) then
		if rst = '1' then
			PS2Data_sr <= "00000000000";
		elsif PS2Clk_op = '1' then
			PS2Data_sr <= PS2Data & PS2Data_sr(10 downto 1);
			
		end if;
	end if;
end process;
	
	
	ScanCode_int <= PS2Data_sr(8 downto 1); -- To be used internally
	ScanCode <= ScanCode_int;  -- Not allowed to read from out signal



	-- PS2 bit counter
	-- ***********************************
	-- *                                 *
	-- *  VHDL for :                     *
	-- *  PS2BitCounter & BC11           *
	-- *                                 *
	-- ***********************************




process(clk)
begin 
  if rising_edge(clk) then
	if rst = '1' then
		PS2BitCounter <= "0000";
	elsif PS2BitCounter = 11 then
		PS2BitCounter <= "0000";
	elsif PS2Clk_op = '1' then
		PS2BitCounter <= PS2BitCounter + 1;
    end if;
  end if;
end process;

BC11 <= '1' when PS2BitCounter = 11 else '0';


	
	-- PS2 state
	-- Either MAKE or BREAK state is identified from the scancode
	-- Only single character scan codes are identified
	-- The behavior of multiple character scan codes is undefined
	-- ***********************************
	-- *                                 *
	-- *  VHDL for :                     *
	-- *  PS2State                       *
	-- *                                 *
	-- ***********************************
process(clk)
begin 
	if rising_edge(clk) then
	
		case PS2state is
			when IDLE => if (BC11 = '1' and ScanCode_int /= "11110000") then 
							PS2state <= MAKE;
						elsif (BC11 = '1' and ScanCode_int = "11110000") then
							PS2state <= BREAK;
						end if;
			when MAKE => PS2state <= IDLE ;

			when BREAK => if (BC11 = '1') then
							PS2state <= IDLE;
						end if;
		end case;
	end if;
end process;
	
	MAKE_op <= '1' when PS2state = MAKE else '0';
	
end behavioral;
