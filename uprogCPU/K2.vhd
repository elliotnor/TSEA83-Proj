library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity K2 is
  port (
    modifier : in unsigned(1 downto 0);
    K2_adress : out unsigned(12 downto 0));
end K2;

architecture Behavioral of K2 is

type K2_mem_t is array (0 to 3) of unsigned(12 downto 0);
constant K2_mem_c : K2_mem_t :=
  (b"0000000000011",                               --:0 Direct
   b"0000000000100",                               --:1 Immediate
   b"0000000000101",                               --:2 Indirect
   b"0000000000111"                                --:3 Index
   );

--signal K2_sig : K2_mem_t := K2_mem_c;

begin

  K2_adress <= K2_mem_c(to_integer(modifier));

end Behavioral;
