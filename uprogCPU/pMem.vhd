library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- pMem interface
entity pMem is
  port(
     clk   : in std_logic; 
     --pAddr : in unsigned(8 downto 0);
     --pData : out unsigned(15 downto 0);
     --pStore: in std_logic;
     --pData_in: in unsigned(15 downto 0));
 
      -- port 1 (CPU)
      pMem_we1       : in std_logic;
      pMem_data_in1  : in unsigned(15 downto 0);
      pMem_data_out1 : out unsigned(15 downto 0);
      pMem_addr1     : in unsigned(9 downto 0);
      -- port 2 (VGA_MOTOR)
      pMem_we2       : in std_logic;
      pMem_data_in2  : in unsigned(15 downto 0);
      pMem_data_out2 : out unsigned(15 downto 0);
      pMem_addr2     : in unsigned(9 downto 0));
end pMem;

architecture Behavioral of pMem is

-- program Memory
type p_mem_t is array (0 to 1023) of unsigned(15 downto 0);
constant p_mem_c : p_mem_t :=
( --DELAY_TIMER 0
x"0000", --NOP
x"0500", --LOAD, Gr1, 01, 0
x"005F", --FFFF

x"0100", --LOAD, Gr0, 01, 0
x"FFFF", --FFFF
x"3100", --SUBI, Gr0, 01, 0 
x"0001", --0001
x"9100", --CMPI, Gr0, 01, 0
x"0000", --0000
x"70FB", --BNE, Gr0, 00, $DELAY_TIMER ($2) (Hoppa -5)  --ok 


x"3500", --SUBI, Gr1, 01, 0 
x"0001", --0001
x"9500", --CMPI, Gr1, 01, 0
x"0000", --0000
x"70F4", --BNE, Gr0, 00, $DELAY_TIMER ($2) (Hoppa -12)  --ok 


--GAME_LOOP 8
x"00CB", --LOAD, GR0, 00, $direction ($BC)        --Game loop start 
x"90CE", --CMPI, Gr0, 00, $value rep up ($C0)     
x"5006", --BEQ, Gr0,00,$CASE_UP ($10)
x"90CF", --CMPI, Gr0, 00, $value rep down ($C1)
x"5013", --BEQ, Gr0,00,$CASE_Down ($23)
x"90D0", --CMPI, Gr0, 00, $value rep left ($C2)
x"502F", --BEQ, Gr0, 00, $CASE_Left ($4B)s
x"90D1", --CMPI, GR0, 00, $value rep right ($C3)
x"501E", --BEQ, Gr0, 00, $CASE_Right ($37) -- ok
--CASE_UP 17
x"04CF", --LOAD, GR1, 00, $value for down ($C1)
x"94CB", --CMPI, GR1, 00, $last direction ($BD)
x"500C", --BEQ, Gr0, 00, $CASE_DOWN ($23)
x"10CB", --STORE, gr0, 00, $last_direction ($BD)   --STORE VAL FOR UP
x"00C8", --LOAD, Gr0, 00, $headpos ($BA)  
x"04C8", --LOAD, GR1, 00, $headpos ($BA)  
x"4500", --ANDI, Gr1, 01, 0         
x"003C", --003C
x"9505", --CMPI, Gr1, 01, 0                   Läser av nollor!!!
x"0000", --0000
x"5046", --BEQ, Gr0, 00, $END ($B8)    
x"3100", --SUBI, Gr0, 01, 0
x"0004", --0004
x"10C8", --STORE, Gr0, 00, $headpos ($BA)
x"602C", --BRA COLLISION_CONTROL ($5F) --ok

--CASE_DOWN 32
x"04CE", --LOAD, GR1, 00, $value for up ($C0)
x"94CB", --CMPI, GR1, 00, $last_direction ($BD)
x"50EE", --BEQ, Gr0, 00, $CASE_UP ($10)
x"10CB", --STORE, gr0, 00, $last_direction($BE)   --STORE VAL FOR DOWN 
x"00C8", --LOAD, Gr0, 00, $headpos ($BA)      
x"04C8", --LOAD, GR1, 00, $headpos ($BA)      
x"4500", --ANDI, Gr1, 01, 0         
x"003C", --003C
x"9505", --CMPI, Gr1, 01, 0  
x"0038", --0038
x"5038", --BEQ, Gr0, 00, $END ($B8)    
x"2100", --ADDI, Gr0, 01, 0
x"0004", --0004
x"10C8", --STORE, Gr0, 00, $headpos ($BA)
x"601D", --BRA COLLISION_CONTROL ($5F) --ok

--CASE_RIGHT 47
x"04D0", --LOAD, GR1, 00, $value for left ($C2)
x"94CB", --CMPI, GR1, 00, $last_direction ($BD)
x"500C", --BEQ, Gr0, 00, $CASE_LEFT ($4B)
x"10CB", --STORE, gr0, 00, $last_direction ($BD)     --STORE VAL FOR RIGHT
x"00C8", --LOAD, Gr0, 00, $headpos ($BA)     ----
x"04C8", --LOAD, GR1, 00, $headpos ($BA)     ----
x"4500", --ANDI, Gr1, 01, 0         
x"07C0", --07C0
x"9505", --CMPI, Gr1, 01, 0 
x"04C0", --4C0
x"501F", --BEQ, Gr0, 00, $END ($B8)
x"2100", --ADDI, Gr0, 01, 0
x"0040", --0040
x"10C8", --STORE, Gr0, 00, $headpos ($BA)
x"600E", --BRA COLLISION_CONTROL ($5F) -- ok

--CASE_LEFT 62
x"04D1", --LOAD, GR1, 00, $value for right ($C3)
x"94CB", --CMPI, GR1, 00, $last_direction ($BD)
x"50EE", --BEQ, Gr0, 00, $CASE_RIGHT ($37)
x"10CB", --STORE, gr0, 00, $last_direction ($BD)    --STORE VAL FOR LEFT
x"00C8", --LOAD, Gr0, 00, $headpos ($BA)    
x"04C8", --LOAD, GR1, 00, $headpos ($BA)     
x"4500", --ANDI, Gr1, 01, 0         
x"07C0", --07C0
x"9505", --CMPI, Gr1, 01, 0 
x"0000", --0000
x"501A", --BEQ, Gr0, 00, $END ($B8)
x"3100", --SUBI, Gr0, 01, 0
x"0040", --0040
x"10C8", --STORE, Gr0, 00, $headpos ($BA)  


--COLLISION_CONTROL 76
    --CMP IF HEAD == FISH 
x"00C8", --LOAD, Gr0, 00, $headpos ($BA)
x"90C7", --CMPI, Gr0, 00, $FISHPOS
x"501B", --BEQ, Gr0, 00, $INC_1023
x"0100", --LOAD, Gr0, 01, 0
x"00D5", --INDEX
x"10CC", --STORE, Gr0, 00, $index ($BE)

    --CMP COORDS 
x"02CC", --LOAD, Gr0, 10, $INDEX ($BF)
x"4100", --ANDI, Gr0, 01, 0
x"03FC", --03FC
x"90C8", --CMPI, Gr0, 00, $HEADPOS ($BF)
x"500C",  --BEQ, Gr0, 00, $END
x"6002", --BRA, Gr0, 00, $COLLISION_CONTROL_2 ($6D) 
x"60A0", --BRA, Gr0, 00, $DELAY_TIMER ($00)
X"6063", --BRA, Gr0, 00, $END

--COLLISION_CONTROL_2 90

    --INC INDEX
x"00CC", --LOAD, Gr0, 00, $index ($BE)
x"2100", --ADDI, Gr0, 01, 0
x"0001", --0001
x"10CC", --STORE, Gr0, 00, $index ($BE)


x"06CC", --LOAD, Gr1, 10, $index ($BE)
X"0ACC", --LOAD, GR2, 10, $index ($BE) ----XXXXXXXXXX-----
x"4900",--ANDI, Gr2, 01, 0
x"0003",
x"9900", --CMPI, Gr2, 01, 0
x"0002", --0002
x"5027", --BEQ, Gr0, 00, $MOVE_AL ($96) 
x"4500", --ANDI, Gr1, 01, 0
x"03FC",  --03FC  
x"94C8", --CMPI, Gr1, 00, $HEADPOS ($BF)
x"50F6", --BEQ, Gr0, 00, $END ($96) 
    --JMP BACK AND DO NEXT COORD
x"60F0", --BRA, Gr0, 00, $COLLISION_CONTROL_2 ($6D) 



--INC_AL 103
x"08C8", --LOAD, Gr2, 00, $headpos ($BA)

    --RESET INDEX 
x"0100", --LOAD, Gr0, 01, 0 
x"00D5", --00C6 VAL FOR INDEX 
x"10CC", --STORE, Gr0, 00, $index ($BE)

      --STORE HEAD 
x"06CC", --LOAD, Gr1, 10, $index ($BE)
x"1ACC", --STORE, Gr2, 10, $index ($BE)
x"2500", --ADDI, Gr1, 01, 0
x"0001", --0001    -- CHANGE FROM HEAD TO BODY

--INC_AL_2 111
      --INC INDEX 
x"08CC", --LOAD, Gr2, 00, $index ($BE)
x"2900", --ADDI, Gr2, 01, 0
x"0001", --0001
x"18CC", --STORE, Gr2, 00, $index ($BE)


x"02CC", --LOAD, Gr0, 10, $index  ($BE)
x"16CC", --STORE, Gr1, 10, $index ($BE)
x"9100", --CMPI, Gr0, 01, 0
x"0002", --0002
x"500A", --BEQ, Gr0, 00, $ADD_aL_END ($AF) 


    --INC INDEX
x"08CC", --LOAD, Gr2, 00, $index ($BE)
x"2900", --ADDI, Gr2, 01, 0
x"0001", --0001
x"18CC", --STORE, Gr2, 00, $index ($BE)


x"06CC", --LOAD, Gr1, 10, $index ($BE)
x"12CC", --STORE, Gr0, 10, $index ($BE)
x"9500", --CMPI, Gr1, 01, 0
x"0002", --0002
x"5001", --BEQ, Gr0, 00, $ADD_aL_END ($AF)
x"60ED", --BRA, Gr0, 00, $INC_AL_2 ($83)


--ADD_aL_END 130
    --INC INDEX
x"08CC", --LOAD, Gr2, 00, $index ($BE)
x"2900", --ADDI, Gr2, 01, 0
x"0001", --0001
x"18CC", --STORE, Gr2, 00, $index ($BE)

    --ADD THE END
x"0100", --LOAD, Gr0, 01, 0
x"0002", --0002
x"12CC", --STORE, Gr0, 10, $INDEX


--MOVE_AL 137

    --LOAD INDEX
x"0D00", --LOAD, Gr3, 01, 0
x"00D5", --00C6 --
x"1CCC", --STORE, Gr3, 00, $index ($BE)


x"08C8", --LOAD, Gr2, 00, $headpos ($BA)
x"02CC", --LOAD, Gr0, 10, $index ($BE)
x"1ACC", --STORE, Gr2, 10, $index ($BE)
x"2100", --ADDI, Gr0, 01, 0
x"0001", --0001    


--MOVE_AL_2 145

    --INC INDEX
x"0CCC", --LOAD, Gr3, 00, $index ($BE)    
x"2D00", --ADDI, Gr3, 01, 0
x"0001", --0001
x"1CCC", --STORE, Gr3, 00, $index ($BE)

    --MOVE MEGA
x"06CC", --LOAD, Gr1, 10, $index ($BE)
x"0ECC", --LOAD, Gr3, 10, $index ++    --------------------------XXXXXXXXXXXXXXXXXX-----------------
x"2CD2", --ADDI, GR3, 00, $const
x"1CD3", --STORE, Gr3, 00, $tail
x"9500", --CMPI, Gr1, 01, 0
x"0002", --0002
x"50B9", --BEQ, Gr0, 00, $DELAY_TIMER ($00) 
x"12CC", --STORE, Gr0, 10, $index ($BE)

    --INC INDEX
x"08CC", --LOAD, Gr2, 00, $index ($BE)S
x"2900", --ADDI, Gr2, 01, 0
x"0001", --0001
x"18CC", --STORE, Gr2, 00, $index ($BE)

    --MOVE
x"02CC", --LOAD, Gr0, 10, $index ($BE)
x"0ECC", --LOAD, Gr3, 10, $index ++
x"2CD2", --ADDI, GR3, 00, $const
x"1CD3", --STORE, Gr3, 00, $tail
x"9100", --CMPI, Gr0, 01, 0
x"0002", --0002
x"50AD", --BEQ, Gr0, 00, $DELAY_TIMER 
x"16CC", --STORE, Gr1, 10, $index ($BE)  
x"60E7", --BRA, Gr0, 00, $MOVE_AL_2 ($00)



--NEW_FISH_POS 164
x"F800", --GET_RANDOM, Gr2, 00, 0
x"28C6", --ADDI, Gr2, 00, $RANDOM_VALUE
x"18C6", --STORE, GR2, 00, $RANDOM_VALUE
x"04C5", --LOAD, Gr1, 00, $COUNTER
x"24CF", --ADDI, Gr1, 00, $val for down = 1
x"14C5", --STORE, Gr1, 00, $COUNTER
x"9500", --CMPI, GR1, 01, 0
x"0050", --50
x"70F7", --BNE, Gr0, 00, $NEW_FISH_POS


--NEW_FISH_POS_173
x"4900", --ANDI, GR2, 01, 0
x"07FC", --07FC
x"18C7", --STORE, GR2, 00, $FISHPOS
x"2900", --ADDI, Gr2, 01, 0 
x"0002", --2
x"18D4", --STORE, Gr2, 00, $LOCATION WHERE FISH IS DISPLAYED ON SCREEN, D4 
x"60A5", --BRA, Gr0, 00, $DELAY_TIMER ($00)


--END 180
X"C000", --HALT
x"0000", --COUNTER  -C5
x"0000", --RANDOM_VALUE -C6
x"0318", --$fishpos C7 
x"0258", --$headpos C8
x"0000", --$lastpos C9
x"0000", --$direction CA
x"0000", --$last_direction CB
x"00D5", --$index CC
x"0001", --$FISH NEW COORD CD
x"0003", --$value for up CE
x"0001", --$value for down CF
x"0002", --$value for left D0
x"0000", --$value for right D1
x"0002", --const   D2


x"0011", -- tail D3 

x"031A", --$THE FISH D4   

--Vmem
b"00000_01001_0110_00", -- D5
b"00000_01000_0110_01",
b"00000_00111_0110_01",
b"00000_00110_0110_01",
b"00000_00101_0110_01", 
b"00000_00000_0000_10",
b"00000_00000_0000_10",
others => (others => '0')
);


signal p_mem : p_mem_t := p_mem_c;


begin  -- pMem
  pMem_data_out1 <= p_mem(to_integer(pMem_addr1(8 downto 0)));
  pMem_data_out2 <= p_mem(to_integer(pMem_addr2(8 downto 0)));

  process(clk)
  begin
      if rising_edge(clk) then
          if pMem_we1 = '1' then
               p_mem(to_integer(pMem_addr1(8 downto 0))) <= pMem_data_in1;
          end if;

      end if;
  end process;

end Behavioral;


--quit -sim; vcom ../*.vhd; vsim -voptargs=+acc work.uprogcpu_tb; do ../cpu_wave.do
--0000
--1: OP
--2: GRx+K2 adr
--3: TF reg / const
--4: TF reg / const