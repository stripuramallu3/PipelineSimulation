--Sreeramamurthy Tripuramallu 903057502
-- A lw-stall signal and flush signal are new inputs 
-- lw-stall is used ensures that the existiing signal remains in the pipeline register when a load-word stall occurs
-- flush will reset the register (branches) 
-- IF/ID stage pipeline register
--

Library IEEE;
use IEEE.std_logic_1164.all;


entity pipe_reg1 is
port (	if_PC4 : in std_logic_vector(31 downto 0);
	if_instruction: in std_logic_vector( 31 downto 0);
	clk, reset : in std_logic;
	id_PC4 : out std_logic_vector(31 downto 0);
	id_instruction: out std_logic_vector( 31 downto 0); 

	lw_stall : in std_logic; 
	
	flush : in std_logic);
end pipe_reg1;

architecture behavioral of pipe_reg1 is
begin
process
begin
wait until (rising_edge(clk));
if reset = '1' OR (flush = '1' )then
id_PC4 <= x"00000000";
id_instruction <= x"00000000";
elsif lw_stall = '1' then

else
id_PC4 <= if_PC4;
id_instruction <= if_instruction;
end if;
end process;
end behavioral;
