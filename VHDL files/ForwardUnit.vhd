library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity ForwardUnit is
	port (A1_in: in std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A3_EX_MA_in: in std_logic_vector(2 downto 0);
	      A3_MA_WB_in: in std_logic_vector(2 downto 0);
	      opcode_RR_EX: in std_logic_vector(3 downto 0);
	      opcode_EX_MA: in std_logic_vector(3 downto 0);
	      opcode_MA_WB: in std_logic_vector(3 downto 0);
	      WB_EX_MA: in std_logic_vector(3 downto 0);
	      WB_MA_WB: in std_logic_vector(3 downto 0);
	      sel_1: out std_logic_vector(1 downto 0); --m12
	      sel_2: out std_logic_vector(1 downto 0); --m11
	      clk: in std_logic);
end entity;

architecture Behave of ForwardUnit is
	      signal tsel_1: std_logic_vector(1 downto 0) := "00";
	      signal tsel_2: std_logic_vector(1 downto 0) := "00";
begin
    process(A1_in,A2_in,A3_EX_MA_in,A3_MA_WB_in,opcode_RR_EX,opcode_EX_MA,opcode_MA_WB,WB_EX_MA,WB_MA_WB)
    begin
        --if(clk'event and (clk  = '1')) then
	    tsel_1 <= "00";
	    tsel_2 <= "00";
		if(opcode_RR_EX = "1000" or opcode_RR_EX = "0011" or opcode_RR_EX = "0110") then -- incoming instruction should not use forwardede data at input 1 for JAL, LHI, LM 
		tsel_1 <= "00";
		tsel_2 <= "00";
        elsif(A1_in = A3_EX_MA_in) then
			if(((opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(0) = '0') or (opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '0' and opcode_EX_MA(0) = '1') or (opcode_EX_MA(3) = '1' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '0') or (opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '1' and opcode_EX_MA(0) = '1' )) and (WB_EX_MA(3) = '1')) then ---all arithmetic instructions, JAL and JLR and LHI(Left)
				tsel_1(0) <= '1';
				tsel_1(1) <= '0';
			end if;
		elsif(A1_in = A3_MA_WB_in) then 
    		if(((opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '1' and opcode_MA_WB(1) = '0' and opcode_MA_WB(0) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(0) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '0' and opcode_MA_WB(0) = '1') or (opcode_MA_WB(3) = '1' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '1' and opcode_MA_WB(0) = '1' )) and (WB_MA_WB(3) = '1')) then ---LW instruction and all other instructions written previously
				tsel_1 <= "11";
			end if;
	   end if;

----sel_2 should have 00 if Imm data enters M9 -- ADI,LW,JAL,LHI
----incoming instruction should not use forwarded data at input 2 for ADI, JAL, LHI, LW 
	   if((opcode_RR_EX(3) = '0' and opcode_RR_EX(2) = '0' and opcode_RR_EX(0) = '0') or (opcode_RR_EX(3) = '0' and opcode_RR_EX(2) = '1' and opcode_RR_EX(1) = '0' and opcode_RR_EX(0) = '1') or (opcode_RR_EX(3) = '1' and opcode_RR_EX(2) = '1' and opcode_RR_EX(1) = '0' and opcode_RR_EX(0) = '0') or (opcode_RR_EX(3) = '1' and opcode_RR_EX(2) = '0' and opcode_RR_EX(1) = '0' and opcode_RR_EX(0) = '1') or (opcode_RR_EX(3) = '0' and opcode_RR_EX(2) = '1' and opcode_RR_EX(1) = '1')) then 
		   if(A2_in = A3_EX_MA_in) then 
			if(((opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(0) = '0') or (opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '0' and opcode_EX_MA(0) = '1') or (opcode_EX_MA(3) = '1' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '0') or (opcode_EX_MA(3) = '0' and opcode_EX_MA(2) = '0' and opcode_EX_MA(1) = '1' and opcode_EX_MA(0) = '1' )) and (WB_EX_MA(3) = '1')) then ---all arithmetic instructions, JAL and JLR
				tsel_2(0) <= '0';
				tsel_2(1) <= '1';
			end if;
		   elsif(A2_in = A3_MA_WB_in) then ---LW instruction
	    		if(((opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '1' and opcode_MA_WB(1) = '0' and opcode_MA_WB(0) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(0) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '0' and opcode_MA_WB(0) = '1') or (opcode_MA_WB(3) = '1' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '0') or (opcode_MA_WB(3) = '0' and opcode_MA_WB(2) = '0' and opcode_MA_WB(1) = '1' and opcode_MA_WB(0) = '1' )) and (WB_MA_WB(3) = '1')) then ---LW instruction and all other instructions written previously
				tsel_2 <= "11";
			end if;
		   end if;
	   else
		   tsel_2 <= "00";
	   end if;
       --end if;

    end process;
sel_1 <= tsel_1;
sel_2 <= tsel_2;
end Behave;
