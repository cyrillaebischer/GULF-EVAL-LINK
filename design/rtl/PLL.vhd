LIBRARY ieee;
USE ieee.std_logic_1164.all;

Library UNISIM;
use UNISIM.vcomponents.all;
library UNIMACRO;
use unimacro.Vcomponents.all;



ENTITY PLL IS

  PORT(
    clk_i           : in      std_logic;                      --system clock
    reset_i         : in      std_logic;                      --active low asynchronous reset
    clk_1_o       : out     std_logic;
    clk_1_inv_o  : out     std_logic;                       -- 180 degree shifted clk
    clk_div_o       : out     std_logic
    );
    
END PLL;

ARCHITECTURE behavior OF PLL is
    
    signal pll_locked_s     : std_logic;
    signal clk_feedback_s   : std_logic;

begin

    -- PLLE2_BASE: Base Phase Locked Loop (PLL)
    -- 7 Series
    -- Xilinx HDL Libraries Guide, version 14.7
    PLLE2_BASE_inst : PLLE2_BASE
    generic map (
        BANDWIDTH => "OPTIMIZED", -- OPTIMIZED, HIGH, LOW
        CLKFBOUT_MULT => 10, -- Multiply value for all CLKOUT, (2-64)
        CLKFBOUT_PHASE => 0.0, -- Phase offset in degrees of CLKFB, (-360.000-360.000).
        CLKIN1_PERIOD => 10.0, -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
        -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
        CLKOUT0_DIVIDE => 10,
        CLKOUT1_DIVIDE => 10,
        CLKOUT2_DIVIDE => 2,
        CLKOUT3_DIVIDE => 1,
        CLKOUT4_DIVIDE => 1,
        CLKOUT5_DIVIDE => 1,
        -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
        CLKOUT0_DUTY_CYCLE => 0.5,
        CLKOUT1_DUTY_CYCLE => 0.5,
        CLKOUT2_DUTY_CYCLE => 0.5,
        CLKOUT3_DUTY_CYCLE => 0.5,
        CLKOUT4_DUTY_CYCLE => 0.5,
        CLKOUT5_DUTY_CYCLE => 0.5,
        -- CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
        CLKOUT0_PHASE => 0.0,
        CLKOUT1_PHASE => 180.0,
        CLKOUT2_PHASE => 0.0,
        CLKOUT3_PHASE => 0.0,
        CLKOUT4_PHASE => 0.0,
        CLKOUT5_PHASE => 0.0,
        DIVCLK_DIVIDE => 1, -- Master division value, (1-56)
        REF_JITTER1 => 0.1, -- Reference input jitter in UI, (0.000-0.999).
        STARTUP_WAIT => "FALSE" -- Delay DONE until PLL Locks, ("TRUE"/"FALSE")
    )
    port map (
        -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
        CLKOUT0 => clk_1_o, -- 1-bit output: CLKOUT0
        CLKOUT1 => clk_1_inv_o, -- 1-bit output: CLKOUT1
        CLKOUT2 => clk_div_o, -- 1-bit output: CLKOUT2
        CLKOUT3 => open, -- 1-bit output: CLKOUT3
        CLKOUT4 => open, -- 1-bit output: CLKOUT4
        CLKOUT5 => open, -- 1-bit output: CLKOUT5
        -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
        CLKFBOUT => clk_feedback_s, -- 1-bit output: Feedback clock
        LOCKED => pll_locked_s, -- 1-bit output: LOCK
        CLKIN1 => clk_i, -- 1-bit input: Input clock
        -- Control Ports: 1-bit (each) input: PLL control ports
        PWRDWN => '0', -- 1-bit input: Power-down
        RST => reset_i, -- 1-bit input: Reset
        -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
        CLKFBIN => clk_feedback_s -- 1-bit input: Feedback clock
    );
    -- End of PLLE2_BASE_inst instantiation

end architecture behavior;