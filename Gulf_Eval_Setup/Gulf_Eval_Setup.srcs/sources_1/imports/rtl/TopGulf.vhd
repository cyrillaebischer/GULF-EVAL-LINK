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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.UtilityPkg.all;
Library UNISIM;
use UNISIM.vcomponents.all;


entity TopGulf is
    Port ( sstClk : in STD_LOGIC;
           sstClkDiv: in std_logic;
           sstRst : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           fileIn  : in std_logic;
           dataOut : out STD_LOGIC;
           clkOut  : out STD_LOGIC;
            -- Outgoing true data
   		   txData10b      : in  std_logic_vector(9 downto 0);
   		   txData10bValid : in  std_logic  
           );
           
end TopGulf;

architecture rtl of TopGulf is

    
signal rxData10b_intl : slv(9 downto 0); 
signal txData10b_intl : slv(9 downto 0); 

signal sstX5Clk_s, sstX10Clk_s, sstClk_s, clk_inv_s   : sl;

signal aligned_intl : sl; 

signal shiftO1_s, shiftO2_s, data_oserdes_out_s : sl;

begin

dataOut <= fileIn;
        
--U_bytelink : entity work.ByteLinkGulf
--generic map (
--     ALIGN_CYCLES_G  => 1,
--      GATE_DELAY_G    => 1 ns
--   )
--  port map ( 
--      -- User clock and reset
--      clk        =>  sstClk,
--      rst        =>  sstRst,
--      -- Incoming encoded data
--      rxData10b  =>  rxData10b_intl,
--      -- Align signal
--      aligned      => aligned_intl,
--      -- Outgoing true data
--      txData8b     =>  txData8b,
--      txData8bValid => txData8bValid,
--      -- Transmitted encoded data
--      txData10b     => txData10b_intl
--   ); 
--OSERDES_MASTER_data : OSERDESE2 generic map(
--                    DATA_WIDTH             => 10,             -- SERDES word width
--                    TRISTATE_WIDTH         => 1, 
--                    DATA_RATE_OQ          => "DDR",         -- <SDR>, DDR
--                    DATA_RATE_TQ          => "SDR",         -- <SDR>, DDR
--                    SERDES_MODE            => "MASTER")          -- <DEFAULT>, MASTER, SLAVE
--                port map (                     
--                    OQ               => dataOut,
--                    OCE             => '1',
--                    CLK             => sstClk,
--                    RST             => sstRst,
--                    CLKDIV          => sstClkDiv,
--                    D8              => txData10b(2),                 -- 2
--                    D7              => txData10b(3),                 -- 3
--                    D6              => txData10b(4),
--                    D5              => txData10b(5),
--                    D4              => txData10b(6),
--                    D3              => txData10b(7),
--                    D2              => txData10b(8),
--                    D1              => txData10b(9),
--                    TQ              => open,
--                    T1             => '0',
--                    T2             => '0',
--                    T3             => '0',
--                    T4             => '0',
--                    TCE             => '0',
--                    TBYTEIN            => '0',
--                    TBYTEOUT        => open,
--                    OFB             => open,
--                    TFB             => open,
--                    SHIFTOUT1       => open,            
--                    SHIFTOUT2       => open,            
--                    SHIFTIN1        => shiftO1_s,    
--                    SHIFTIN2        => shiftO2_s) ;
                    
--OSERDES_SLAVE_data : OSERDESE2 generic map(
--                   DATA_WIDTH             => 10,             -- SERDES word width
--                   TRISTATE_WIDTH         => 1, 
--                   DATA_RATE_OQ          => "DDR",         -- <SDR>, DDR
--                   DATA_RATE_TQ          => "SDR",         -- <SDR>, DDR
--                   SERDES_MODE            => "SLAVE")          -- <DEFAULT>, MASTER, SLAVE
--                   port map (                     
--                   OQ               => open,
--                   OCE             => '1',
--                   CLK             => sstClk,
--                   RST             => sstRst,
--                   CLKDIV          => sstClkDiv,
--                   D8              => '0',
--                   D7              => '0',
--                   D6              => '0',
--                   D5              => '0',
--                   D4              => txData10b(0),      -- 0
--                   D3              => txData10b(1),      -- 1
--                   D2              => '0',
--                   D1              => '0',
--                   TQ              => open,
--                   T1             => '0',
--                   T2             => '0',
--                   T3             => '0',
--                   T4             => '0',
--                   TCE             => '0',
--                   TBYTEIN            => '0',
--                   TBYTEOUT        => open,
--                   OFB             => open,
--                   TFB             => open,
--                   SHIFTOUT1         => shiftO1_s,            
--                   SHIFTOUT2         => shiftO2_s,            
--                   SHIFTIN1         => '0',    
--                   SHIFTIN2         => '0') ;

  
--U_K7SerialInterfaceOut: entity  work.K7SerialInterfaceOut
--generic map (
--GATE_DELAY_G   => 1 ns
----      BITSLIP_WAIT_G =>25*8
--   )
   
--    port map ( 
--      -- Parallel clock and reset
--      sstClk    =>  sstClk,
--      sstRst    =>  sstRst,
 
--      -- Serial data out
--      dataOut  =>  dataOut, 
--      -- Serial clock in
--      sstX5Clk  =>  sstClkDiv,
--      sstX5Rst =>  ssX5rst,
--      -- Parallel data in
--      data10bIn=> "0010111100"
--   );
    
end rtl;
