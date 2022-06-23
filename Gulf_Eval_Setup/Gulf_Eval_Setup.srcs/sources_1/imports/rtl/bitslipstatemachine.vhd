library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bitslip_fsm is
	port ( 
		clk_i   : in std_logic;
		rst_i : in std_logic;
		
		aligned_i : in std_logic;
		
		bitslip_o  : out std_logic
	);
end bitslip_fsm;

architecture Behavioral of bitslip_fsm is

	--Type
	type FSM_state is
	(
		IDLE, BITSLIP, WAIT_S
	);
	
	--Signal
	signal state_s: FSM_state;
begin
    --State machine - next state logic
    process (clk_i) 
    begin
        if rising_edge(clk_i) then 
            if (rst_i='1') then
                state_s  <= IDLE;
                
            else
                case state_s is
                    when IDLE =>
                        if aligned_i = '0' then
                            state_s <= BITSLIP;
                        end if;
                        
                    when BITSLIP =>
                        state_s  <= WAIT_S;

                    when WAIT_S =>
                        state_s <= IDLE;
                     
                    when others =>
                       state_s <= IDLE;
                           
                end case;
            end if;
        end if;
    end process;
    
-- output Logic of state machine
        process (state_s)
        begin
            -- default value
            bitslip_o <= '0';
            
            case state_s is
                when IDLE =>
                    bitslip_o <= '0';
                when BITSLIP =>
                    bitslip_o <= '1';
                when WAIT_S =>
                    null;
                when others =>
                    null;                                         
            end case;
        end process;
    
end Behavioral;
