-- Sreeramamurthy Tripuramallu 903057502
-- Test case was added to the file 
-- lw_stall is an input 
-- When the lw_stall signal is asserted the PC value does not change 
--
--
-- ECE 3056: Architecture, Concurrency and Energy in Computation
-- Sudhakar Yalamanchili
-- Pipelined MIPS Processor VHDL Behavioral Mode--
--
--
-- Instruction fetch behavioral model. Instruction memory is
-- provided within this model. IF increments the PC,  
-- and writes the appropriate output signals. 

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fetch is 
--

port(instruction  : out std_logic_vector(31 downto 0);
	  PC_out       : out std_logic_vector (31 downto 0);
	  Branch_PC    : in std_logic_vector(31 downto 0);
	  clock, reset, PCSource:  in std_logic; 
	
	  lw_stall: in std_logic);
	  
end fetch;

architecture behavioral of fetch is 
TYPE INST_MEM IS ARRAY (0 to 22) of STD_LOGIC_VECTOR (31 DOWNTO 0);
   SIGNAL iram : INST_MEM := (
 	X"00853820",   --  add $7, $4, $5
        X"00e43020",   --  add $6, $7, $4
        X"00000000",   --  nop
	X"00000000",   --  nop
	X"00000000",   --  nop
        X"00000000",   --  nop
        X"00000000",   --  nop 
	X"8c020030",   --  lw $2, 48($0)
	X"8c030038",   --  lw $3, 56($0)
	X"00430820",   --  add $1, $2, $3
	X"00000000",   -- nop
	X"00000000",   -- nop
	X"00000000",   -- nop
	X"00000000",   -- nop 
	X"00000000",   -- nop
	X"00001020",   -- add $2, $0, $0
	X"00001820",   -- add $3, $0, $0
  	X"00400820",   -- add $1, $2, $3
	X"00000000",   -- nop
	X"00000000",   -- nop
	X"00000000",   -- nop
	X"00000000",   -- nop 
	X"00000000"   -- nop
 
 
                     
   );
   
   SIGNAL PC, Next_PC : STD_LOGIC_VECTOR( 31 DOWNTO 0 );

BEGIN 						
-- access instruction pointed to by current PC
-- and increment PC by 4. This is combinational
		             
Instruction <=  iram(CONV_INTEGER(PC(6 downto 2)));  -- since the instruction
                                                     -- memory is indexed by integer
PC_out<= (PC + 4);			
   
-- compute value of next PC

Next_PC <=  (PC + 4)    when PCSource = '0' else
            Branch_PC    when PCSource = '1' else
            X"CCCCCCCC";
			   
-- update the PC on the next clock			   
	PROCESS
		BEGIN
			WAIT UNTIL (rising_edge(clock));
			IF (reset = '1') THEN
				PC<= X"00000000" ;
			ELSIF (lw_stall = '1') THEN
				PC <= PC; 
			ELSE 
				PC <= Next_PC;    -- cannot read/write a port hence need to duplicate info
			 end if; 
			 
	END PROCESS; 
   
   end behavioral;


	
