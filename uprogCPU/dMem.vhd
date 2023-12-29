library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- dMem interface
entity dMem is
  port(
    dAddr : in unsigned(3 downto 0);
    dData : out unsigned(10 downto 0));
end dMem;

architecture Behavioral of dMem is

type d_mem_t is array (0 to 6) of unsigned(10 downto 0);
  constant d_mem_c : d_mem_t :=
    (
     b"01001_0110_00",
     b"01000_0110_01",
     b"00111_0110_01",
     b"00110_0110_01",
     b"00101_0110_01",
     b"00100_0110_01",
     b"00000_0000_10"
  
    );

signal d_mem : d_mem_t := d_mem_c;


begin  -- pMem
  dData <= d_mem(to_integer(dAddr));

end Behavioral;


--quit -sim; vcom ../*.vhd; vsim -voptargs=+acc work.uprogcpu_tb; do ../cpu_wave.do
--0000
--1: OP
--2: GRx+K2 adr
--3: TF reg / const
--4: TF reg / const
