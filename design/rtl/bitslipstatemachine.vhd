library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.two_s_complement_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity statemachine is
	port ( 
		clk_i   : in std_logic;
		reset_i : in std_logic;
		
		start_i : in std_logic;
		port_i  : in std_logic_vector (7 downto 0);
		
		rdy_o      : out std_logic;
		load_in_o  : out std_logic;
		load_out_o : out std_logic;
		
		port_o  : out std_logic_vector(7 downto 0)
	);
end statemachine;

architecture Behavioral of statemachine is

	--Type
	type FSM_states is
	(
		IDLE, RDIN, WROUT
	);
	
	--Signal
	signal next_state_s, current_state_s: FSM_states;
	signal temp_reg_s : std_logic_vector(7 downto 0);
begin
	next_state_logic: process(current_state_s, reset_i, start_i)	
	--State machine - next state
	begin
			if (reset_i = '1') then
				next_state_s <= IDLE;
			else
				case current_state_s is
					when IDLE =>
						if (start_i = '1') then
							next_state_s <= RDIN;
						end if;
					when RDIN =>
						next_state_s <= WROUT;
					when WROUT =>
						next_state_s <= IDLE;
				end case;
			end if;
	end process;
	
	current_state: process(clk_i, reset_i)
	begin
		if reset_i = '1' then
			current_state_s <= IDLE;
		elsif rising_edge(clk_i) then
			current_state_s <= next_state_s;
		end if;
	end process;

	--Output of state machine
	output_logic: process(current_state_s)
	begin
		-- default
		rdy_o <= '0';
		load_in_o <= '0';
		load_out_o <= '0';
		
		case current_state_s is
			when IDLE =>
				rdy_o <= '1';
			when RDIN =>
				load_in_o <= '1';
			when WROUT =>
				load_out_o <= '1';
		end case;
	end process;
	
	--Combinatory 2's complement (combinatory)
	--port_o <= std_logic_vector(unsigned(not port_i)+ 1);
	port_o <= complement2(port_i);
	
end Behavioral;

