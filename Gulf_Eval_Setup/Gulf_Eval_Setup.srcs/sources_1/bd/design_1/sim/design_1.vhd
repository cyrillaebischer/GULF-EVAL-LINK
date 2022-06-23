--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Fri Jun 17 12:58:18 2022
--Host        : LAPTOP-ISQIQK2U running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    dataOut : out STD_LOGIC;
    ssX5rst : in STD_LOGIC;
    sstClk : in STD_LOGIC;
    sstRst : in STD_LOGIC;
    sstX5Clk : in STD_LOGIC;
    txData8b : in STD_LOGIC_VECTOR ( 7 downto 0 );
    txData8bValid : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_ByteLinkGulfv2_0_0 is
  port (
    sstClk : in STD_LOGIC;
    sstRst : in STD_LOGIC;
    sstX5Clk : in STD_LOGIC;
    ssX5rst : in STD_LOGIC;
    dataOut : out STD_LOGIC;
    txData8b : in STD_LOGIC_VECTOR ( 7 downto 0 );
    txData8bValid : in STD_LOGIC
  );
  end component design_1_ByteLinkGulfv2_0_0;
  signal ByteLinkGulfv2_0_dataOut : STD_LOGIC;
  signal ssX5rst_1 : STD_LOGIC;
  signal sstClk_1 : STD_LOGIC;
  signal sstRst_1 : STD_LOGIC;
  signal sstX5Clk_1 : STD_LOGIC;
  signal txData8bValid_1 : STD_LOGIC;
  signal txData8b_1 : STD_LOGIC_VECTOR ( 7 downto 0 );
begin
  dataOut <= ByteLinkGulfv2_0_dataOut;
  ssX5rst_1 <= ssX5rst;
  sstClk_1 <= sstClk;
  sstRst_1 <= sstRst;
  sstX5Clk_1 <= sstX5Clk;
  txData8bValid_1 <= txData8bValid;
  txData8b_1(7 downto 0) <= txData8b(7 downto 0);
ByteLinkGulfv2_0: component design_1_ByteLinkGulfv2_0_0
     port map (
      dataOut => ByteLinkGulfv2_0_dataOut,
      ssX5rst => ssX5rst_1,
      sstClk => sstClk_1,
      sstRst => sstRst_1,
      sstX5Clk => sstX5Clk_1,
      txData8b(7 downto 0) => txData8b_1(7 downto 0),
      txData8bValid => txData8bValid_1
    );
end STRUCTURE;
