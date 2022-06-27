----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/02/2021 01:07:41 PM
-- Design Name: 
-- Module Name: TopBytelink - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;

use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use work.UtilityPkg.all;
Library UNISIM;
use UNISIM.vcomponents.all;


entity TopEval is
    Port ( sstClk : in STD_LOGIC;
           sstClkDiv : in STD_LOGIC;
           sstClkB : in std_logic;
           clkOut : out std_logic;
           sstRst : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           dataIn : in STD_LOGIC;
           rxData8b : out STD_LOGIC_VECTOR (7 downto 0);
           rxData8bValid : out STD_LOGIC
           );
           
end TopEval;

architecture rtl of TopEval is
    component bitslip_fsm is
        port ( 
            clk_i   : in std_logic;
            rst_i : in std_logic;
            
            aligned_i : in std_logic;
            align_wip_i   : in std_logic;
            
            bitslip_o  : out std_logic
        );
    end component;

signal rxData10b_intl : slv(9 downto 0); 
signal txData10b_intl : slv(9 downto 0); 

signal shiftI1_s, shiftI2_s : sl;

signal aligned_intl, bitslip_s, align_wip_s: sl; 
signal count_ones, count_zeros : std_logic_vector(4 downto 0);
signal RD_s                    : std_logic_vector(4 downto 0);

begin

   -- RD calculator
   process(rxData10b_intl)
       variable count : unsigned(4 downto 0) := "00000";
       variable zeros : unsigned(4 downto 0) := "00000";
       variable RD    : signed(4 downto 0)   := "00000";
       begin
        if sstRst = '1' then
            count := "00000";
            zeros := "00000";
            RD_s  <= "00000";
        else
           count := "00000";   --initialize count variable.
           for i in 0 to 9 loop   --for all the bits.
               count := count + ("0000" & rxData10b_intl(i));   --Add the bit to the count.
           end loop;
           count_ones <= std_logic_vector(count);    --assign the count to output.
           zeros := 10 - count;
           count_zeros <= std_logic_vector(zeros);
           RD_s <= std_logic_vector(count) - std_logic_vector(zeros);
       end if;
   end process;
   
Bitslipstatemachine: bitslip_fsm
    port map (
        clk_i       => sstClkDiv,
        rst_i       => sstRSt,
        aligned_i   => aligned_intl,
        align_wip_i     => align_wip_s,
        bitslip_o   => bitslip_s
        );
  
U_bytelink : entity work.ByteLinkEval
generic map (
     ALIGN_CYCLES_G  => 20,
      GATE_DELAY_G    => 1 ns
   )
  port map ( 
      -- User clock and reset
      clk           =>  sstClk,  
      rst           =>  sstRst,
      -- Incoming encoded data
      rxData10b  =>  rxData10b_intl,
      -- Align signal
      aligned       => aligned_intl,  
      align_wip_o      => align_wip_s,
      -- Outgoing true data
      rxData8b      => rxData8b,
      rxData8bValid => rxData8bValid
   ); 
   


ISERDESE2_MASTER_inst : ISERDESE2
                generic map (
                 DATA_RATE => "DDR", -- DDR, SDR
                 DATA_WIDTH => 10, -- Parallel data width (2-8,10,14)
                 DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
                 DYN_CLK_INV_EN => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
                 -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
                 INIT_Q1 => '0',
                 INIT_Q2 => '0',
                 INIT_Q3 => '0',
                 INIT_Q4 => '0',
                 INTERFACE_TYPE => "NETWORKING", -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
                 IOBDELAY => "NONE", -- NONE, BOTH, IBUF, IFD
                 NUM_CE => 1, -- Number of clock enables (1,2)
                 OFB_USED => "FALSE", -- Select OFB path (FALSE, TRUE)
                 SERDES_MODE => "MASTER", -- MASTER, SLAVE
                 -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
                 SRVAL_Q1 => '0',
                 SRVAL_Q2 => '0', 
                 SRVAL_Q3 => '0',
                 SRVAL_Q4 => '0'
                 )
                 port map (
                  O => open, -- 1-bit output: Combinatorial output
                  -- Q1 - Q8: 1-bit (each) output: Registered data outputs
                  Q1 => rxData10b_intl(0),
                  Q2 => rxData10b_intl(1),
                  Q3 => rxData10b_intl(2),
                  Q4 => rxData10b_intl(3),
                  Q5 => rxData10b_intl(4),
                  Q6 => rxData10b_intl(5),
                  Q7 => rxData10b_intl(6),
                  Q8 => rxData10b_intl(7),
                  -- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
                  SHIFTOUT1 => shiftI1_s,
                  SHIFTOUT2 => shiftI2_s,
                  BITSLIP => bitslip_s, -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                  -- CLKDIV when asserted (active High). Subsequently, the data seen on the
                  -- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
                  -- position every time Bitslip is invoked (DDR operation is different from
                  -- SDR).
                  -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
                  CE1 => '1',
                  CE2 => '0',
                  CLKDIVP => '0', -- 1-bit input: TBD
                  -- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
                  CLK => sstClk, -- 1-bit input: High-speed clock
                  CLKB => sstClkB, -- 1-bit input: High-speed secondary clock
                  CLKDIV => sstClkDiv, -- 1-bit input: Divided clock
                  OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
                  -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
                  DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                  DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
                  -- Input Data: 1-bit (each) input: ISERDESE2 data input ports
                  D => dataIn, -- 1-bit input: Data input
                  DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
                  OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
                  OCLKB => '0', -- 1-bit input: High speed negative edge output clock
                  RST => sstRst, -- 1-bit input: Active high asynchronous reset
                  -- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
                  SHIFTIN1 => '0',
                  SHIFTIN2 => '0'
                 ); 
                 
    ISERDESE2_SLAVE_inst : ISERDESE2
            generic map (
                  DATA_RATE => "DDR", -- DDR, SDR
                  DATA_WIDTH => 10, -- Parallel data width (2-8,10,14)
                  DYN_CLKDIV_INV_EN => "FALSE", -- Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
                  DYN_CLK_INV_EN => "FALSE", -- Enable DYNCLKINVSEL inversion (FALSE, TRUE)
                  -- INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
                  INIT_Q1 => '0',
                  INIT_Q2 => '0',
                  INIT_Q3 => '0',
                  INIT_Q4 => '0',
                  INTERFACE_TYPE => "NETWORKING", -- MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
                  IOBDELAY => "NONE", -- NONE, BOTH, IBUF, IFD
                  NUM_CE => 1, -- Number of clock enables (1,2)
                  OFB_USED => "FALSE", -- Select OFB path (FALSE, TRUE)
                  SERDES_MODE => "SLAVE", -- MASTER, SLAVE
                  -- SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
                  SRVAL_Q1 => '0',
                  SRVAL_Q2 => '0', 
                  SRVAL_Q3 => '0',
                  SRVAL_Q4 => '0'
                  )
                  port map (
                   O => open, -- 1-bit output: Combinatorial output
                   -- Q1 - Q8: 1-bit (each) output: Registered data outputs
                   Q1 => open,
                   Q2 => open,
                   Q3 => rxData10b_intl(8),
                   Q4 => rxData10b_intl(9),
                   Q5 => open,
                   Q6 => open,
                   Q7 => open,
                   Q8 => open,
                   -- SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
                   SHIFTOUT1 => open,
                   SHIFTOUT2 => open,
                   BITSLIP => bitslip_s, -- 1-bit input: The BITSLIP pin performs a Bitslip operation synchronous to
                   -- CLKDIV when asserted (active High). Subsequently, the data seen on the
                   -- Q1 to Q8 output ports will shift, as in a barrel-shifter operation, one
                   -- position every time Bitslip is invoked (DDR operation is different from
                   -- SDR).
                   -- CE1, CE2: 1-bit (each) input: Data register clock enable inputs
                   CE1 => '1',
                   CE2 => '0',
                   CLKDIVP => '0', -- 1-bit input: TBD
                   -- Clocks: 1-bit (each) input: ISERDESE2 clock input ports
                   CLK => sstClk, -- 1-bit input: High-speed clock
                   CLKB => sstClkB, -- 1-bit input: High-speed secondary clock
                   CLKDIV => sstClkDiv, -- 1-bit input: Divided clock
                   OCLK => '0', -- 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY"
                   -- Dynamic Clock Inversions: 1-bit (each) input: Dynamic clock inversion pins to switch clock polarity
                   DYNCLKDIVSEL => '0', -- 1-bit input: Dynamic CLKDIV inversion
                   DYNCLKSEL => '0', -- 1-bit input: Dynamic CLK/CLKB inversion
                   -- Input Data: 1-bit (each) input: ISERDESE2 data input ports
                   D => '0', -- 1-bit input: Data input
                   DDLY => '0', -- 1-bit input: Serial data from IDELAYE2
                   OFB => '0', -- 1-bit input: Data feedback from OSERDESE2
                   OCLKB => '0', -- 1-bit input: High speed negative edge output clock
                   RST => sstRst, -- 1-bit input: Active high asynchronous reset
                   -- SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
                   SHIFTIN1 => shiftI1_s,
                   SHIFTIN2 => shiftI2_s
                  );

   
--U_K7SerialInterfaceIn : entity  work.K7SerialInterfaceIn
--generic map (
--GATE_DELAY_G   => 1 ns,
--      BITSLIP_WAIT_G =>25*8
--   )
   
--    port map ( 
--      -- Parallel clock and reset
--      sstClk    =>  sstClk,
--      sstRst    =>  sstRst,
--      -- Aligned indicator
--      aligned  => aligned_intl,
--      -- Parallel data out
--      dataOut  =>  rxData10b_intl, 
--      -- Serial clock in
--      sstX5Clk  =>  sstX5Clk,
--      sstX5Rst =>  ssX5rst,
--      -- Serial data in
--      dataIn   => dataIn
--   );   
   
   -- clock output to GULF
   clkOut <= sstClk;
   
end rtl;
