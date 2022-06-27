----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2022 03:08:28 PM
-- Design Name: 
-- Module Name: qbl_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_signed.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_textio.ALL;
use STD.textio.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity qbl_tb is
--  Port ( );
end qbl_tb;

architecture Behavioral of qbl_tb is

component TopEval is
    Port ( sstClk : in STD_LOGIC;
           sstClkDiv : in STD_LOGIC;
           sstClkB : in std_logic;
           clkOut : out STD_LOGIC;
           sstRst : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           dataIn : in STD_LOGIC;
           rxData8b : out STD_LOGIC_VECTOR (7 downto 0);
           rxData8bValid : out STD_LOGIC
           );
    end component TopEval;
    

    
component TopGulf is
    Port ( sstClk : in STD_LOGIC;
           sstClkDiv: in std_logic;
           sstRst : in STD_LOGIC;
           ssX5rst : in STD_LOGIC;
           fileIn  : in std_logic;
           dataOut : out STD_LOGIC;
           clkOut  : out std_logic;
           txData10b      : in  std_logic_vector(9 downto 0);
           txData10bValid : in  std_logic  
           );              
end component;

constant clk_i_period : time := 0.78 ns;  -- 1/127 = 7.8740157
constant comma_char_s : std_logic_vector(9 downto 0) := "0010111100";
signal sstRst_s,ssX5rst_s, dataIn_s, dataOut_s, rxData8bValid_s,txData8bValid : std_logic;
signal rxData8b_eval, txData8b : std_logic_vector(7 downto 0);
signal clk_i, clk_div_i, clk_X2_i, rstX5_i, sstClkB, clkLink, Eval_clk_o_s, clk_doubl_X1_i, clk_doubl_X5_i: std_logic;
signal GulfEvalLink, txData10bValid_Gulf, rxData8bvalid_Eval: std_logic;

signal txData10b_Gulf : std_logic_vector(9 downto 0) := (others => '0');

signal xb : std_logic;
begin

sstClkB <= not(clk_i);
    
gulf_unit: TopGulf port map(
    sstClk      => clk_i,
    sstClkDiv   => clk_div_i,
    sstRst      => sstRst_s,
    ssX5rst     => ssX5rst_s,
    fileIn      => xb,
    dataOut     => GulfEvalLink,
    clkOut      => clkLink,
    txData10b    => txData10b_Gulf,
    txData10bValid => txData10bValid_Gulf
    );
eval_unit: TopEval port map (

    sstClk      => clk_i,
    sstCLkDiv    => clk_div_i,
    sstClkB => sstClkB,
    clkOut      => Eval_clk_o_s,
    sstRst      => sstRst_s,
    ssX5rst     => ssX5rst_s,
    dataIn      => GulfEvalLink, 
    rxData8b    => rxData8b_eval,
    rxData8bValid => rxData8bvalid_Eval
);

---- manual stim process ----
--stim_proc: process
--begin
--wait for 1 ns;
--txData10bValid_Gulf <= '1';
--txData10b_Gulf <= comma_char_s;

--wait for 45 us;
--txData10b_Gulf <= "00" & x"AB";
--txData10bValid_Gulf <= '1';
--end process; 

---- read from file process ----
-- variable training_stop : boolean := false;
-- file fp_comma : text is in "C:\Users\Cyrill\Documents\S6\BA-GULFstream\Gulf_Eval_Setup\Gulf_Eval_Setup\Kchar_Stream.dat";

rd_values: process(clk_X2_i)
    
    file fp_output : text is in "C:\Users\Cyrill\Documents\S6\BA-GULFstream\Gulf_Eval_Setup\Gulf_Eval_Setup\8chan_output.dat";
    variable ln     : line;
    variable x : std_logic;
    
    variable stop          : boolean := false;
    begin   
        if (rising_Edge(clk_X2_i))then
            if stop = false then
                        readline(fp_output,ln);
                        read(ln,x);
                        xb <= x;
                        if endfile(fp_output) = true then
                            stop := true;    
                        end if;
            end if;
        else
            xb <= xb;
        end if;
end process;
    
---- clock process ----
clkX1: process
begin 
    clk_i <= '0';
    wait for clk_i_period/2;
    clk_i <= '1';
    wait for clk_i_period/2;
end process;

clkDiv: process
begin 
    clk_div_i <= '0';
    wait for (clk_i_period*10)/2;
    clk_div_i <= '1';
    wait for (clk_i_period*10)/2;
end process;

clkX2: process
begin 
    clk_X2_i <= '0';
    wait for clk_i_period/4;
    clk_X2_i <= '1';
    wait for clk_i_period/4;
end process;

-- reset process
reset: process
begin
    sstRst_s <= '1';
    ssX5rst_s <= '1';
    wait for 100 ns;
    sstRst_s <= '0';
    ssX5rst_s <= '0';
   wait;
end process;

end Behavioral;
