library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
end entity ALU_tb;

architecture test of ALU_tb is
--Test addition funtionality of ALU
    component ALU is
        port(
            clk: in std_logic;
            rst : in std_logic; 
            A : in unsigned(7 downto 0);
            B : in unsigned(7 downto 0);
            op : in unsigned(2 downto 0);
            Low : out unsigned(7 downto 0);
            High : out unsigned(7 downto 0);
            Z_out : out std_logic;
            N_out : out std_logic;
            C_out : out std_logic;
            V_out : out std_logic);
    end component ALU;

    signal A: unsigned(7 downto 0);
    signal B: unsigned(7 downto 0);
    signal rst: std_logic;
    signal Low:unsigned(7 downto 0) := "00000000";
    signal High:unsigned(7 downto 0) := "00000000";
    signal op: unsigned(2 downto 0);
    signal N_out: std_logic;
    signal Z_out : std_logic;
    signal C_out : std_logic;
    signal V_out : std_logic;
    signal clk: std_logic := '0';

    --test bench signals:
    signal AR : unsigned(7 downto 0);
    signal Buss : unsigned(7 downto 0);
    signal done : boolean := false;

begin

INIT:
   ALU port map(
    clk => clk,
    A => A,
    B => B,
    rst =>rst,
    op => op,
    Low => Low,
    High => High,
    Z_out => Z_out,
    N_out => N_out,
    C_out => C_out,
    V_out => V_out);

    clk <= not clk after 1 ns when not done;
    rst <= '1', '0' after 5 ns;

    process begin
        report "### Test Addition" severity note;
        --Test basic addition
        op <= "010";

        A <= "00000000"; 
        B <= "00000001";
        wait for 1 us; assert Low = "00000001" and 
        High = "00000000" report "1.xxxx: Low should be 1. :-(" severity error;


        --Test 1.1 - General addition
        A <= "00000000"; 
        B <= "00000001";
        wait for 1 us; assert Low = "00000001" and 
        High = "00000000" report "1.1: Low should be 1. :-(" severity error;

        --Test 1.2 - General addition
        A <= "00000010";
        B <= "00000001";
        wait for 1 us; assert Low = "00000011" and 
        High = "00000000" report "1.2: Low should be 3. :-(" severity error;

        --Test 1.3 - ZERO addition
        A <= "00000000";
        B <= "00000000";
        wait for 1 us; assert Low = "00000000" and 
        High = "00000000" report "1.3: Low should be 0. :-(" severity error;



        report "### Test Subtracion" severity note;
        --Test basic subtraction
        op <= "011";
        --Test 2.1 - General subtraction
        A <= "00000010";
        B <= "00000001";
        wait for 1 us; assert Low = "00000001" and 
        High = "00000000" report "2.1: Low should be 1. :-(" severity error;

        --Test 2.2 - Test subtraction with negative result
        AR <= "00000001";
        Buss <= "00000010";
        wait for 1 us; assert Low = "00000001" and 
        High = "00000000" and N_out = '1' report "2.2: Low should be 1, N_out should be true. :-(" severity error;



        --Test 2.3 - ZERO subtraction
        A <= "10100000"; --80 in decimal
        B <= "10100000";
        wait for 1 us; assert Low = "00000000" and 
        High = "00000000" report "2.3: Low should be 0. :-(" severity error;

        --Test 2.4 - General subtraction
        A <= "00100000";
        B <= "00010000";
        wait for 1 us; assert Low = "00010000" and 
        High = "00000000" report "2.4: Low should be 16. :-(" severity error;



        report "### Test AND-Function" severity note;
        --Test AND
        op <= "100";
        --Test 3.1 - Masking function
        A <= "11111111";
        B <= "01000000";
        wait for 1 us; assert Low = "01000000" and 
        High = "00000000" report "3.1: Low should be 64. :-(" severity error;

        --Test 3.2 - ZERO masking
        A <= "11111111";
        B <= "00000000";
        wait for 1 us; assert Low = "00000000" and 
        High = "00000000" report "3.2: Low should be 0. :-(" severity error;

        --Test 3.3 - FULL masking
        A <= "10010110";
        B <= "10000001";
        wait for 1 us; assert Low = "10000000" and 
        High = "00000000" report "3.3: Low should be 128. :-(" severity error;



        report "### Test OR-Function" severity note;
        --Test OR
        op <= "101";

        --Test 4.1 - OR capability
        A <= "10010110";
        B <= "10000001";
        wait for 1 us; assert Low = "10010111" and 
        High = "00000000" report "4.1: Low should be 151. :-(" severity error;


        report "### Test LSR-Function" severity note;
        --Test OR
        op <= "110";

        --Test 5.1 - LSR test 1
        A <= "10000000";
        wait for 1 us; assert Low = "01000000" and 
        High = "00000000" report "5.1: Low should be 64. :-(" severity error;

        --Test 5.2 - LSR test 2 
        A <= "10000001";
        wait for 1 us; assert Low = "01000000" and 
        High = "00000000" report "5.2: Low should be 64. :-(" severity error;

        report "### Test NOP-Function" severity note;
        op <= "000";
        
        wait for 1 us; assert Low = "10000001" and 
        High = "00000000" report "6.1: Low should be 64. :-(" severity error;

        report "### Test BUSS-Function" severity note;
        op <= "001";
        B <= "10101010";
        
        wait for 1 us; assert Low = "10101010" and 
        High = "00000000" report "7.1: Low should be 64. :-(" severity error;






        report "### TEST BENCH DONE. Did you get any error message?" severity note;
        done <= true;
        wait;

    end process;
end architecture;


