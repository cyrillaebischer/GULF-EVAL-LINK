--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Fri Jun 17 12:58:18 2022
--Host        : LAPTOP-ISQIQK2U running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    dataOut : out STD_LOGIC;
    ssX5rst : in STD_LOGIC;
    sstClk : in STD_LOGIC;
    sstRst : in STD_LOGIC;
    sstX5Clk : in STD_LOGIC;
    txData8b : in STD_LOGIC_VECTOR ( 7 downto 0 );
    txData8bValid : in STD_LOGIC
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    sstClk : in STD_LOGIC;
    sstRst : in STD_LOGIC;
    sstX5Clk : in STD_LOGIC;
    ssX5rst : in STD_LOGIC;
    txData8b : in STD_LOGIC_VECTOR ( 7 downto 0 );
    txData8bValid : in STD_LOGIC;
    dataOut : out STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      dataOut => dataOut,
      ssX5rst => ssX5rst,
      sstClk => sstClk,
      sstRst => sstRst,
      sstX5Clk => sstX5Clk,
      txData8b(7 downto 0) => txData8b(7 downto 0),
      txData8bValid => txData8bValid
    );
end STRUCTURE;
