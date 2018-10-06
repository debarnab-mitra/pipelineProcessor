library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;
entity priority_encoder is
port( x: in std_logic_vector(15 downto 0);
	  clk : in std_logic;
      a: out std_logic_vector(2 downto 0);					--This is the REGISTER NUMBER WHICH IS TO BE LOADED.
	  i: out std_logic_vector(15 downto 0);					--This is the LM INSTRUCTION FOR THE NEXT REGISTER TO BE LOADED.
	  done: out std_logic;
	  M8_Control: out std_logic);
end entity;

architecture Behave of priority_encoder is
	signal tM8_Control:std_logic := '1';
   signal lm: std_logic := '0';
   begin
   	process(x)
		variable pos: integer := 0;
		variable tmp: std_logic_vector(15 downto 0) := (others => '1');
   	begin
		
		--===============================================================================
		--When the instruction is not LM or SM PE will raise done always.Hence the 
		--the values of i and a will not matter as the done dependent MUX will
		--ensure i and a dont make any difference.
		--===============================================================================
			if(not (((x(15) = '0') and (x(14) = '1') and (x(13) = '1') and (x(12) = '0')) or ((x(15) = '0') and (x(14) = '1') and (x(13) = '1') and (x(12) = '1')))) then
				done <= '1';
				tM8_Control <= '1';
				i <= "1111111111111111";
				a <= "000";
				lm <='0';   --==============+++++++++++++++=========================
		--================================================================================
			else
			-----------------
			-- Notes down if this was first time LM was executed and accrdingly sets M8_Control
			------------------
			if(lm = '0') then
				tM8_Control <= '1';
				lm <= '1';  --==============+++++++++++++++=========================
			else
				tM8_Control <= '0';
				lm <='1';  --==============+++++++++++++++=========================
			end if;
		--=============================================================
		--It will enter the else above only when instructin is LM or SM
		--When LM/SM is complete the if underneath will excecute.
		--=============================================================
				if(x(7 downto 0) = "00000000") then
					done <= '1';
					lm <= '0';  --==============+++++++++++++++=========================
					i <= "1111111111111111";
					a <= "000";
					pos:= 0;
					tmp:= (others => '1');
		--==========================================
				else
					lm <= '1';  --==============+++++++++++++++=========================
					for J in 0 to 7	loop 
						if (x(J) = '1') then
							pos := J;
							tmp:= (others => '1');  --==============+++++++++++++++=========================
							tmp(J) := '0';
							exit;
						else  --==============+++++++++++++++=========================
						pos := J;
						tmp:= (others => '1');
						tmp(J) := '1';	
						end if;
					end loop;
					
					
					for q in 0 to 15 loop
						i(q) <= x(q) and tmp(q);
					end loop;
					
									

					if(pos = 0) then
						a <= "000";
					elsif(pos = 1) then
						a <= "001";
					elsif(pos <= 2) then
						a <= "010";
					elsif(pos <= 3) then
						a <= "011";
					elsif(pos <= 4) then
						a <= "100";
					elsif(pos <= 5) then
						a <= "101";		
					elsif(pos <= 6) then
						a <= "110";
					else
						a <= "111";
					end if;
					
					done <= '0';
				end if;
		    end if;
	end process;
M8_Control <= tM8_Control;
end Behave;
  

