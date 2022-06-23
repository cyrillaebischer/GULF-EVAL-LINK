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


entity HMB_link is
    Port ( sstClk : in STD_LOGIC;
           sstRst : in STD_LOGIC;
           sstX5Clk : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           dataIn : in STD_LOGIC;
           dataOut : out STD_LOGIC;
           rxData8b : out STD_LOGIC_VECTOR (7 downto 0);
           rxData8bValid : out STD_LOGIC;
            -- Outgoing true data
   		   txData8b      : in  std_logic_vector(7 downto 0);
   		   txData8bValid : in  std_logic 
--    	  -- Transmitted encoded data
--    	  	txData10b     : out std_logic_vector(9 downto 0)
           
           
           );
           
end HMB_link;

architecture rtl of HMB_link is
signal rxData10b_intl : slv(9 downto 0); 
signal txData10b_intl : slv(9 downto 0); 

signal aligned_intl : sl; 

begin

U_bytelink : entity work.ByteLink
generic map (
     ALIGN_CYCLES_G  => 1,
      GATE_DELAY_G    => 1 ns
   )
  port map ( 
      -- User clock and reset
      clk        =>  sstClk,
      rst        =>  sstRst,
      -- Incoming encoded data
      rxData10b  =>  rxData10b_intl,
      -- Received true data
      rxData8b    => rxData8b,
      rxData8bValid => rxData8bValid,
      -- Align signal
      aligned      => aligned_intl,
      -- Outgoing true data
      txData8b     =>  txData8b,
      txData8bValid => txData8bValid,
      -- Transmitted encoded data
      txData10b     => txData10b_intl
   ); 
   
U_K7SerialInterfaceIn : entity  work.K7SerialInterfaceIn
generic map (
GATE_DELAY_G   => 1 ns,
      BITSLIP_WAIT_G =>25*8
   )
   
    port map ( 
      -- Parallel clock and reset
      sstClk    =>  sstClk,
      sstRst    =>  sstRst,
      -- Aligned indicator
      aligned  => aligned_intl,
      -- Parallel data out
      dataOut  =>  rxData10b_intl, 
      -- Serial clock in
      sstX5Clk  =>  sstX5Clk,
      sstX5Rst =>  ssX5rst,
      -- Serial data in
      dataIn   => dataIn
   );
 
  
  U_K7SerialInterfaceOut: entity  work.K7SerialInterfaceOut
generic map (
GATE_DELAY_G   => 1 ns
--      BITSLIP_WAIT_G =>25*8
   )
   
    port map ( 
      -- Parallel clock and reset
      sstClk    =>  sstClk,
      sstRst    =>  sstRst,
 
      -- Serial data out
      dataOut  =>  dataOut, 
      -- Serial clock in
      sstX5Clk  =>  sstX5Clk,
      sstX5Rst =>  ssX5rst,
      -- Parallel data in
      data10bIn=> txData10b_intl
   );
 
  
   
   
end rtl;
