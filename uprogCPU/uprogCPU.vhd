library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--CPU interface
entity uprogCPU is
  port(clk      : in std_logic;                         -- system clock
       rst      : in std_logic;                         -- reset
       Hsync    : out std_logic;                        -- horizontal sync
       Vsync    : out std_logic;                        -- vertical sync
       vgaRed   : out std_logic_vector(2 downto 0);     -- VGA red
       vgaGreen : out std_logic_vector(2 downto 0);     -- VGA green
       vgaBlue  : out std_logic_vector(2 downto 1)     -- VGA blue
       --SS : out std_logic;
       --MISO : in std_logic;
       --MOSI : out std_logic;
       --SCLK : out std_logic
  );
       
      
end entity;

architecture func of uprogCPU is

    signal SS : std_logic;
    signal MISO : std_logic;
    signal MOSI : std_logic;
    signal SCLK : std_logic;

  -- micro Memory component
  component uMem
    port(uAddr : in unsigned(12 downto 0);
         uData : out unsigned(31 downto 0));
  end component;

  -- program Memory component
  component pMem
    port( clk   : in std_logic; 
          pMem_we1       : in std_logic;
          pMem_data_in1  : in unsigned(15 downto 0);
          pMem_data_out1 : out unsigned(15 downto 0);
          pMem_addr1     : in unsigned(9 downto 0);
          -- port 2 (VGA_MOTOR)
          pMem_we2       : in std_logic;
          pMem_data_in2  : in unsigned(15 downto 0);
          pMem_data_out2 : out unsigned(15 downto 0);
          pMem_addr2     : in unsigned(9 downto 0));
  end component;

   

  -- K1 memory component
  component K1
    port(operand: in unsigned(3 downto 0);
         K1_adress: out unsigned(12 downto 0));
  end component;

  -- K1 memory component
  component K2
    port(modifier: in unsigned(1 downto 0);
         K2_adress: out unsigned(12 downto 0));
  end component;

  -- VGA_lab compnent
  component VGA_lab is
    port(
      clk      : in std_logic;                         -- system clock
      rst      : in std_logic;                         -- reset
      Hsync    : out std_logic;                        -- horizontal sync
      Vsync    : out std_logic;                        -- vertical sync
      vgaRed   : out std_logic_vector(2 downto 0);     -- VGA red
      vgaGreen : out std_logic_vector(2 downto 0);     -- VGA green
      vgaBlue  : out std_logic_vector(2 downto 1);  
      vga_lab_motor_addr : out unsigned(9 downto 0);
			vga_lab_motor_data : in unsigned(15 downto 0));
  end component;

  -- ALU component
  component ALU is
    port(clk : in std_logic;
         rst : in std_logic;
         --A : in unsigned(7 downto 0);
         B : in unsigned(15 downto 0);
         op : in unsigned(2 downto 0);
         AR : out unsigned(15 downto 0);
         --Low : out unsigned(7 downto 0);
         --High : out unsigned(7 downto 0);
         Z_out : out std_logic;
         N_out : out std_logic;
         C_out : out std_logic;
         V_out : out std_logic);
  end component;

  component jstk is
    port(clk, rst : in std_logic;
        --read_en : in std_logic;
        -- User signals:
        --do_start : in std_logic;
        set_LEDs : in std_logic_vector(2 downto 1);
        --output_valid : out std_logic;
        --X : out unsigned(9 downto 0);
        --Y : out unsigned(9 downto 0);
        --buttons : out std_logic_vector(2 downto 0); -- buttons(0) = Joystick
        -- JSTK signals:
        SS : out std_logic;
        MISO : in std_logic;
        MOSI : out std_logic;
        SCLK : out std_logic;
        reg_out : out unsigned(9 downto 0);
        addr : in unsigned(1 downto 0));
  end component;


 
  --ALU-TB-FB-S-P-LC-SEQ-myADR
  signal IR : unsigned(15 downto 0);
  -- micro memory signals
  signal uM : unsigned(31 downto 0); -- micro Memory output
  alias ALU_op : unsigned(2 downto 0) is uM(31 downto 29);
  alias TB : unsigned(3 downto 0) is uM(28 downto 25);
  alias FB : unsigned(3 downto 0) is uM(24 downto 21);
  alias S: std_logic is uM(20);
  alias P: std_logic is uM(19);
  alias LC: unsigned(1 downto 0) is uM(18 downto 17);
  alias SEQ: unsigned (3 downto 0) is uM(16 downto 13);
  alias uAddr : unsigned(12 downto 0) is uM(12 downto 0);
 
  -- program memory signals
  signal PM : unsigned(15 downto 0); -- Program Memory output
  signal pData_in: unsigned(15 downto 0);
  signal pStore : std_logic := '0';
  signal pAddr_store: unsigned(8 downto 0);
  --K2 memory signals
  signal K2_reg : unsigned(12 downto 0); --K2 memory output


  signal adr: unsigned(7 downto 0) ;

  -- K1 memory signals
  signal K1_reg : unsigned(12 downto 0);  -- K1 memory output


  -- ALU signals
  signal AR :unsigned (15 downto 0);
  signal A : unsigned(7 downto 0);
  signal B : unsigned(7 downto 0);
  signal L, Z, N, C, V : std_logic;


  -- local registers
  signal uPC : unsigned(12 downto 0) := "0000000000000"; -- micro Program Counter
  signal PC : unsigned(15 downto 0); -- Program Counter
 -- Instruction Register
  signal ASR : unsigned(15 downto 0); -- Address Register

  -- local combinatorials
  signal DATA_BUS : unsigned(15 downto 0); -- Data Bus
  signal HALT: std_logic := '1';
  signal LC_reg: unsigned(7 downto 0);

  -- MUX signals
  signal GRx : unsigned(1 downto 0);
  signal GR0 : unsigned(15 downto 0);
  signal GR1 : unsigned(15 downto 0);
  signal GR2 : unsigned(15 downto 0);
  signal GR3 : unsigned(15 downto 0);

  signal sign_extention: unsigned(15 downto 0);

   -- jstk signals
  signal do_start : std_logic;
  signal do_start_clk : unsigned(9 downto 0);
  signal set_LEDs : std_logic_vector(2 downto 1);
  signal output_valid : std_logic;
  signal reg_out : unsigned(9 downto 0);
  signal jstk_addr : unsigned(1 downto 0);
  signal direction : unsigned(1 downto 0);
  signal timed_direction : unsigned(15 downto 0);


  -- vga_motor minnes signaler
  signal vga_motor_addr : unsigned(9 downto 0);
  signal vga_motor_data : unsigned(15 downto 0);


begin

  -- mPC : micro Program Counter
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1' or SEQ = "0011") then
        uPC <= (others => '0');
      else
        case SEQ is
          when "0000" => uPC <= uPC + 1; 
          when "0001" => uPC <= K1_reg; 
          when "0010" => uPC <= K2_reg; 
          when "0100" => if (Z = '0') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "0101" => uPC <= uAddr;
          when "1000" => if (Z = '1') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "1001" => if (N = '1') then uPC <= uAddr; else uPC <= uPC + 1; end if; 
          when "1010" => if (C = '1') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "1100" => if (L = '1') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "1101" => if (C = '0') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "1011" => if (V = '1') then uPC <= uAddr; else uPC <= uPC + 1; end if;
          when "1111" => HALT <= '0';
          when others => uPC <= uPC+ 1;
        end case;
      end if;
    end if;
  end process;
	
  -- PC : Program Counter
  process(clk)
  begin
      if rising_edge(clk) then
        if(HALT = '1') then
          if (rst = '1') then
            PC <= (others => '0');
          elsif (FB = "0011") then
            PC <= DATA_BUS;
          elsif (P = '1') then
            PC <= PC + 1;
          end if;
      end if;
    end if;
  end process;

  --PM: Program Memory

  process(clk)
  begin 
    if rising_edge(clk) then
      if (FB = "0010") then
          pStore <= '1';
          pData_in <= DATA_BUS;
      else
          pStore <= '0';
      end if;
    end if;
  end process;
  

  -- IR : Instruction Register
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        IR <= (others => '0');
      elsif (FB = "0001") then
        IR <= DATA_BUS;
      end if;
    end if;
  end process;
	
  -- ASR : Address Register
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        ASR <= (others => '0');
      elsif (FB = "0100") then
        ASR <= DATA_BUS;
      end if;
    end if;
  end process;

  -- MUX
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        GR0 <= (others => '0');
        GR1 <= (others => '0');
        GR2 <= (others => '0');
        GR3 <= (others => '0');
      else
      if (FB = "0110") then  
        case GRx is
            when "00" => GR0 <= DATA_BUS; 
            when "01" => GR1 <= DATA_BUS; 
            when "10" => GR2 <= DATA_BUS; 
            when "11" => GR3 <= DATA_BUS; 
            when others => null;
          end case;
        end if;

      end if;
    end if;
  end process;

  GRx <= IR(11 downto 10);


  --LC
  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        LC_reg <= (others => '0');
      else
        case LC is
          when "01" => LC_reg <= LC_reg - 1; 
          when "10" => LC_reg <= DATA_BUS(7 downto 0); 
          when "11" => LC_reg <= uAddr(7 downto 0); 
          when others => null;
        end case;
      end if;
    end if;
  end process;

  L <= '1' when (LC_reg = 0) else '0';

  adr <= IR(7 downto 0);

  process(clk)
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        sign_extention <= (others => '0');
      else
        sign_extention(0) <= adr(0);
        sign_extention(1) <= adr(1);
        sign_extention(2) <= adr(2);
        sign_extention(3) <= adr(3);
        sign_extention(4) <= adr(4);
        sign_extention(5) <= adr(5);
        sign_extention(6) <= adr(6);
        sign_extention(7) <= adr(7);
        sign_extention(8) <= adr(7);
        sign_extention(9) <= adr(7);
        sign_extention(10) <= adr(7);
        sign_extention(11) <= adr(7);
        sign_extention(12) <= adr(7);
        sign_extention(13) <= adr(7);
        sign_extention(14) <= adr(7);
        sign_extention(15) <= adr(7);
      end if;
    end if;
  end process;

  -- jstk counter
  process(clk)
  begin 
    if rising_edge(clk) then
      if (rst = '1') or do_start_clk = 434 then
        do_start_clk <= (others => '0');
      else
        if do_start_clk = 434 then
          do_start_clk <= (others => '0');
          do_start <= '1';
        else
           do_start <= '0';
        do_start_clk <= do_start_clk + 1;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      if jstk_addr = 3 or rst = '1' then
        jstk_addr <= "00";
      else
        jstk_addr <= jstk_addr + 1;
      end if;
      
      if jstk_addr = 0 then
        if reg_out < 400 then
          direction <= "10";
        elsif reg_out > 620 then
          direction <= "00";
        end if;

      elsif jstk_addr = 1 then
        if reg_out < 400 then
          direction <= "01";
        elsif reg_out > 620 then
          direction <= "11";
        end if;
      end if;
    end if;
  end process;


  -- micro memory component connection
  uMem_c : uMem port map(uAddr=>uPC, uData=>uM);

  -- program memory component connection
  PM_c : pMem port map(
    clk => clk, 

    pMem_addr1=>ASR(9 downto 0), 
    pMem_data_in1=>pData_in,
    pMem_data_out1=>PM, 
    pMem_we1 => pStore, 


    pMem_addr2=>vga_motor_addr, 
    pMem_data_in2=> (others => '0'),
    pMem_data_out2=>vga_motor_data, 
    pMem_we2 => '0'  );

  -- K2 memory component connection
  K2_c : K2 port map (modifier => IR(9 downto 8), K2_adress => K2_reg);

  -- K1 memory component connection
  K1_c : K1 port map(operand => IR(15 downto 12), K1_adress => K1_reg);

  -- VGA motor component connection
  VGA_c : VGA_lab port map(
    clk=>clk, 
    rst=>rst, 
    Hsync=>Hsync,
    Vsync=>Vsync, 
   vgaRed=>vgaRed, 
   vgaGreen=>vgaGreen, 
   vgaBlue=>vgaBlue,    
   vga_lab_motor_addr => vga_motor_addr,
   vga_lab_motor_data => vga_motor_data);

  -- ALU componenet connection
  ALU_c : ALU port map(clk=>clk, rst=>rst, AR=>AR, B=>DATA_BUS, op=>ALU_op, Z_out => Z, N_out => N, C_out => C, V_out => V);

   -- jstk component connection
   jstk_c : jstk port map(clk=>clk, rst=>rst, set_LEDs=>set_LEDs, SS=>SS, MISO=>MISO, MOSI=>MOSI, SCLK=>SCLK, reg_out=>reg_out, addr=>jstk_addr);


  -- data buss assignment
  DATA_BUS <= IR when (TB = "0001") else
    PM when (TB = "0010") else
    PC when (TB = "0011") else
    ASR when (TB = "0100") else
    AR when (TB = "0111") else
    GR0 when (TB ="0110" and GRx = 0) else
    GR1 when (TB ="0110" and GRx = 1) else
    GR2 when (TB ="0110" and GRx = 2) else
    GR3 when (TB ="0110" and GRx = 3) else
    sign_extention when (TB = "1000") else
    --Timer is TB = "1001"

   (others => '0');
end func;
