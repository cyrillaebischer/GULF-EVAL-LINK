----------------------------------------------------------------------------------
-- Company: IDLAB, Hawaii
-- Engineer: Salvador Ventura
-- 
-- Create Date: 29/06/2021
-- Design Name: 
-- Module Name: bytelink_tb - 
-- Project Name: WATCHMAN
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

use std.env.finish;

entity bytelink_tb is
end bytelink_tb; 


architecture sim of bytelink_tb is
component Bytelink_IN is
Port ( sstClk : in STD_LOGIC;
           sstRst : in STD_LOGIC;
           sstX5Clk : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           dataIn : in STD_LOGIC;
           rxData8b : out STD_LOGIC_VECTOR (7 downto 0);
           rxData8bValid : out STD_LOGIC;
            -- Outgoing true data
   		   txData8b      : in  slv(7 downto 0);
   		   txData8bValid : in  sl;
    	  -- Transmitted encoded data
    	  	txData10b     : out slv(9 downto 0)
           
           
           );
           end component;

  constant clock_period : time := 8 ns;
  constant clock_periodX5 : time := 10 ns;


  -- DUT signals
  signal sstClk : std_logic;
  signal sstRst : std_logic := '0';
  signal sstX5Clk : std_logic := '0';
  signal ssX5rst: std_logic := '0';
  signal dataIn : std_logic := '0';
  signal rxData8b:std_logic_vector(7 downto 0);
  signal rxData8bValid : STD_LOGIC;
   -- Outgoing true data
  signal txData8b      :  std_logic_vector(7 downto 0);
  signal txData8bValid :   std_logic;
    	  -- Transmitted encoded data
  signal txData10b     :  std_logic_vector(9 downto 0);
           
  
begin

  DUT : TopBytelink

    port map (
      sstClk => sstClk,
      sstRst => sstRst,
      sstX5Clk => sstX5Clk,
      ssX5rst => ssX5rst, 
      dataIn => dataIn,
      rxData8b => rxData8b,
      rxData8bValid=> rxData8bValid,
      txData8b => txData8b,
      txData8bValid => txData8bValid,
      txData10b => txData10b
    );

    sstClk <= not sstClk after clock_period / 2;
    sstX5Clk <= not sstClk after clock_periodX5 / 2;

    PROC_SEQUENCER : process
    begin
         sstRst <= '0';
         ssX5rst <= '0';

      wait for 5 * clock_period;
      sstRst <= '1';
      ssX5rst <= '1';

      wait for 5 * clock_period;
      
     dataIn<='0';      
     wait for 1 * clock_period;
          dataIn<='1';      
     wait for 1 * clock_period;
          dataIn<='1'; 
     wait for 1 * clock_period;
   dataIn<='0';      
     wait for 1 * clock_period;
          dataIn<='1';      
     wait for 1 * clock_period;
          dataIn<='1'; 
     wait for 1 * clock_period;
   dataIn<='0';      
     wait for 1 * clock_period;
          dataIn<='1';      


     
--      -- Start writing
--      wr_en <= '1';

--      -- Fill the FIFO
--      while full_next = '0' loop
--        wr_data <= std_logic_vector(unsigned(wr_data) + 1);
--        wait until rising_edge(clk);
--      end loop;
      
--      -- Stop writing
--      wr_en <= '0';

--      -- Empty the FIFO
--      rd_en <= '1';
--      wait until empty_next = '1';

--      wait for 10 * clock_period;
      
--      -- Stop reading
--      rd_en <= '0';
      
--      -- Start writing
--      wr_en <= '1';
      
--        -- Fill the FIFO
--          while full_next = '0' loop
--            wr_data <= std_logic_vector(unsigned(wr_data) + 2);
--            wait until rising_edge(clk);
--          end loop;
      
      
  --    finish;
    end process;

end architecture;