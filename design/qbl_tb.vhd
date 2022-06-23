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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity qbl_tb is
--  Port ( );
end qbl_tb;

architecture Behavioral of qbl_tb is

component design_1 is
  port (
    Eval_Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Eval_Din_valid : in STD_LOGIC;
    Eval_Dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    Eval_Dout_valid : out STD_LOGIC;
    Eval_dataOut : out STD_LOGIC;
    GULF_Din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    GULF_Din_valid : in STD_LOGIC;
    clkX5_i : in STD_LOGIC;
    clk_i : in STD_LOGIC;
    rstX5_i : in STD_LOGIC;
    rst_i : in STD_LOGIC
  );
  end component design_1;


signal GULF_dout : std_logic_vector (7 downto 0) ;
signal GULF_Dout_valid : std_logic ;
signal Eval_Dout : std_logic_vector (7 downto 0);
signal Eval_Dout_valid : std_logic ;
signal Eval_dataOut : std_logic;

signal GULF_Din :  std_logic_vector (7 downto 0 ) := (others => '0');
signal GULF_Din_valid : std_logic := '0';
signal GULF_dataIn    : std_logic;

signal Eval_Din: std_logic_vector (7 downto 0):= (others => '0');
signal Eval_Din_valid : std_logic := '0' ;
signal rst_i, rstX5_i, clk_i, clk_x5_i : std_logic := '0' ;

constant clk_i_period : time := 10 ns;  -- 1/127 = 7.8740157

begin

uut: design_1 port map (

    GULF_Din => GULF_Din,
    GULF_Din_Valid => GULF_Din_Valid,
    Eval_DOut => Eval_DOut,
    Eval_dataOut => Eval_dataOut,
    Eval_Din => Eval_Din,
    Eval_Din_Valid => Eval_Din_Valid,
    Eval_Dout_valid => Eval_Dout_valid,
    rst_i => rst_i,
    rstx5_i => rstx5_i,
    clk_i => clk_i,
    clkx5_i => clk_x5_i
    
);

stim_proc: process
begin
wait for 1 ns;
	
wait for 45 us;
GULF_Din <= x"AB";
GULF_Din_Valid <= '1';

wait for 4*clk_i_period;
GULF_Din <= x"CD";
GULF_Din_Valid <= '1';

wait for 4*clk_i_period;
GULF_Din <= x"EF";
GULF_Din_Valid <= '1';

wait for 4*clk_i_period;
GULF_Din <= x"00";
GULF_Din_Valid <= '1';

wait for 4 us;
GULF_Din_Valid <= '0';

--wait for 1 us;
--GULF_Din_Valid <= '0';

--wait for 10 us;
--Eval_Din <= x"BB";
--Eval_Din_Valid <= '1';

--wait for 1 us;
--Eval_Din <= x"DD";
--Eval_Din_Valid <= '1';
--wait for 1 us;
--Eval_Din <= x"FF";
--Eval_Din_Valid <= '1';
--wait for 1 us;
--Eval_Din_Valid <= '0';

end process; 

-- clock process
clock: process
begin 
    clk_i <= '0';
    wait for clk_i_period/2;
    clk_i <= '1';
    wait for clk_i_period/2;
end process;

-- clock process
clockx5: process
begin 
    clk_x5_i <= '0';
    wait for clk_i_period/10;
    clk_x5_i <= '1';
    wait for clk_i_period/10;
end process;

-- reset process
reset: process
begin
    rst_i <= '1';
    rstx5_i <= '1';
    wait for 100 ns;
   rst_i <= '0';
   rstx5_i <= '0';
   wait;
end process;

end Behavioral;
