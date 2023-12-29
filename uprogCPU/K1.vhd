library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity K1 is
  port (
    operand : in unsigned(3 downto 0);
    K1_adress : out unsigned(12 downto 0));
end K1;

architecture Behavioral of K1 is

type K1_mem_t is array (0 to 15) of unsigned(12 downto 0);
constant K1_mem_c : K1_mem_t :=
  (b"0000000001010",                               --:0 LOAD 
   b"0000000001011",                               --:1 STORE 
   b"0000000001100",                               --:2 ADDI 
   b"0000000001111",                               --:3 SUBi 
   b"0000000010010",                               --:4 ANDI 
   b"0000000100110",                               --:5 BEQ
   b"0000000010110",                               --:6 BRA 
   b"0000000011001",                               --:7 BNE 
   b"0000000101000",                               --:8 ORI 
   b"0000000011100",                               --:9 CMPI 
   b"0000000011110",                               --:A BMI 
   b"0000000010101",                               --:B GET_JOYSTICK    
   b"0000000011011",                               --:C HALT
   b"0000000100000",                               --:D BGE 
   b"0000000101111",                               --:E EMPTY xxx
   b"0000000100101"                                --:F GET_RANDOM

   );

begin

  K1_adress <= K1_mem_c(to_integer(operand));

end Behavioral;
