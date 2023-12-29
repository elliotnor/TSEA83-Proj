library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port(clk : in std_logic;
         rst : in std_logic; 
         --A : in unsigned(7 downto 0);
         B : in unsigned(15 downto 0);
         op : in unsigned(2 downto 0);
         --Low : out unsigned(7 downto 0);
         --High : out unsigned(7 downto 0);
         AR: out unsigned(15 downto 0);
         Z_out : out std_logic;
         N_out : out std_logic;
         C_out : out std_logic;
         V_out : out std_logic);

end ALU;

architecture Behavioral of ALU is
    signal R : unsigned(16 downto 0);
    signal Z, N, C, V : std_logic;
    signal Zc, Nc, Cc, Vc : std_logic;
    signal A : unsigned(15 downto 0) := "0000000000000000";

begin
-- Beräkning av resultat


process(clk)              
begin 
    if rising_edge(clk) then

        A <= R(15 downto 0);
        R <= (others => '0');  --default value
        case op is
            when "000" => R <= R;                                     -- No op              OK
            when "001" => R(15 downto 0) <= B;                        -- B                  OK
            when "010" => R <= (R) + ('0'&B);                         -- A+B                OK
            when "011" => R <= (R) - ('0'&B);                         -- A-B                OK
            when "100" => R(15 downto 0) <= R(15 downto 0) and B;     -- A & B              OK
            when "101" => R(15 downto 0) <= R(15 downto 0) or B;      -- AR | Buss          OK
            when "110" => R(15 downto 0) <= R(15 downto 0) srl 1;     -- AR >> 1 (logisk)   OK
            when others => null;
        end case;
    end if;
end process;

AR <= R(15 downto 0);


-- Beräkning av flaggor

Z_out <= '1' when R(15 downto 0)=0 else '0';

N_out <= R(15);
      
C_out <= R(16) ;

V_out <= (not A(15) and not B(15) and R(15)) or                     --when ...
      (A(15) and B(15) and not R(15)) when (op = "010") else     -- ... add
      (not A(15) and B(15) and R(15)) or                         -- when ...
      (A(15) and not B(15) and not R(15)) when (op = "011") else -- .. sub
      '0'; 



            
end Behavioral;
