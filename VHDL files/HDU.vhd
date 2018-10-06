--+++++++++++++++++++++++++++++++++++++++++++++++++++
--Changes have been made in Line No - 91,130,238,277
--+++++++++++++++++++++++++++++++++++++++++++++++++++

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity HDU is
	port (
		--===========================================
		--Opcode is required for all type of hazards.
		--===========================================	
		  Opcode : in std_logic_vector(3 downto 0);        --This comes from IF/ID register.
		   OPC : in std_logic_vector(3 downto 0);          --This comes from ID/RR register.
		--================================================
		--This is need for Load followed with dependencies
		--================================================
		  I8_6: in std_logic_vector(2 downto 0);           --This comes from IF/ID register.
	      I5_3: in std_logic_vector(2 downto 0);           --This comes from IF/ID register.
	      I11_9: in std_logic_vector(2 downto 0);           --This comes from IF/ID register.
	      ---------------------------------------------------------------
	      --The bits of MA are 3 = M14, 2 = M15, 1 = Mem_en, 0 = Mem_R/W.
	      ---------------------------------------------------------------
	      MA: in std_logic_vector(3 downto 0);			   --This comes from ID/RR register.
	      A3: in std_logic_vector(2 downto 0);             --This comes from ID/RR register.
		  addr: in std_logic_vector(2 downto 0);           --This comes from PE.
		  --=================
	      --Output of the HDU
	      --=================
	      PC_write :out std_logic;                         --This determines if PC is written or not in the current cycle.
	      IF_ID_Write :out std_logic;                      --This determines if IF_ID is written or not in the current cycle.
	      M3: out std_logic;                               --This is the control pin of the Mux M3_tem.
	      clk: in std_logic);
end entity;

architecture Behave of HDU is
	signal jump: std_logic_vector(2 downto 0) := (others => '0');
	signal lm : std_logic := '0';
	signal temp_opcode : std_logic_vector(3 downto 0) := (others => '0');
	signal PC_write_tem: std_logic := '1';
	signal IF_ID_Write_tem :std_logic := '1';                   
	signal M3_tem:std_logic := '1';  
 
begin
    process(clk,Opcode,OPC,I8_6,I5_3,I11_9,MA,A3,addr)
    begin
	if(clk'event and (clk  = '0')) then
	    PC_write_tem <= '1';
	    IF_ID_Write_tem <= '1';
	    M3_tem <= '1';
-----	--=======================================
--1--	--For LW instruction dependencies
-----	--=======================================
	    if (((OPC = "0100") and (MA /= "0000") and (A3 /= "111")) and (((Opcode = "0000" or Opcode = "0010") and (A3 = I8_6 or A3 = I5_3)) or ((Opcode = "0001" or Opcode = "0100" or Opcode = "1001") and (A3 = I8_6)) or ((Opcode = "0110" or Opcode = "0111") and (A3 = I11_9)) or ((Opcode = "0101" or Opcode = "1100") and (A3 = I11_9 or A3 = I8_6)))) then 
		PC_write_tem <= '0';
	    	IF_ID_Write_tem <= '0';
	    	M3_tem <= '0';

--+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*


	--===========================================================================
	--Case when the Destination of the previous instruction is the RA field of LM
	--===========================================================================
	    elsif( (Opcode = "0110" or Opcode = "0111" ) and (A3 = I11_9)) then
		PC_write_tem <= '0';
		IF_ID_Write_tem <= '0';
		M3_tem <= '0';

--+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*



-----   --==================================================================================================================================================================
--2--   --For BEQ,JLR,JAL hazards/ R7 is the destination register(Cases ADD,ADC,ADZ,ADI,NDU,NDC,NDZ,LHI,LW), The first 3 equality below are for BJJ rest all are foe R7 dest. 
-----   --==================================================================================================================================================================
	    elsif ((Opcode = "1100" or Opcode = "1000" or Opcode = "1001") or ((Opcode = "0000" or Opcode = "0001" or Opcode = "0010" or Opcode = "0011" or Opcode = "0100") and (I11_9 = "111")) or ((Opcode = "0110") and (addr = "111"))) then 
	    	--**********************************************************************************************************************************************************************
	    	--BJJ/R7 Dep. hazard has been detected. We will forward the BJJ/R7 Dep. control values to ID/RR register
	    	--Freeze Pc and IF/ID so that so that it reads the same BJJ/R7 Dep. instruction.Then it will go to the next condition.
	    	if (jump = "000") then 
	    		PC_write_tem <= '0';
	    		IF_ID_Write_tem <= '0';
	    		M3_tem <= '1';
	    		jump <= "001";
	    	--**********************************************************************************************************************************************************************
	    	--At the end of this cycle, original BJJ/R7 Dep. control values will be written to RR/EX register.
	    	--We will send 0 via M3_tem to the ID/RR register.Pc and IF/ID are still frozen so that it reads the same old BJJ/R7 Dep. instruction.Then it will go to the next condition.
	    	elsif (jump = "001") then 
	    		PC_write_tem <= '0';
	    		IF_ID_Write_tem <= '0';
	    		M3_tem <= '0';
	    		jump <= "010";
	    	--**********************************************************************************************************************************************************************
	    	--At the end of this cycle, original BJJ/R7 Dep. control values will be written in EX/MEM register.
	    	--We will send 0 via M3_tem  in the ID/RR register. So at the end of this cycle ID/RR and RR/EX both have 0 in them.
	    	--Pc and IF/ID are still frozen so that it reads the same old BJJ/R7 Dep. instruction.Then it will go to the next condition.
	    	elsif (jump = "010") then 
	    		PC_write_tem <= '0';
	    		IF_ID_Write_tem <= '0';
	    		M3_tem <= '0';
	    		jump <= "011";
	    	--**********************************************************************************************************************************************************************
	    	--At the end of this cycle, original BJJ/R7 Dep. control values will be written in MEM/WB register.
	    	--We will send 0 in the ID/RR register. So at the end of this cycle ID/RR , RR/EX  and EX/MEM have 0 in them.
	    	--Pc and IF/ID are still frozen so that it reads the same old BJJ/R7 Dep. instruction.Then it will go to the next condition.
	    	--At the end of this cycle the NPC has the new PC value and in the next cycle we must activate PC Write so that Pc gets the new value.
	    	elsif (jump = "011") then 
	    		PC_write_tem <= '0';
	    		IF_ID_Write_tem <= '0';
	    		M3_tem <= '0';
	    		jump <= "100";
	    	--*********************************************************************************************************************************************************************
	    	--At the end of this cycle the PC will get the correct value. All the pipeline registers except IF/ID will have control signals as 0. IF/ID will still
	    	-- have the original BJJ/R7 Dep..So basically the PC of the next correct instruction after BJJ/R7 Dep. is now in PC.We will again send 0 to ID/RR.
			elsif (jump = "100") then 
	    		PC_write_tem <= '1';
	    		IF_ID_Write_tem <= '0';
	    		M3_tem <= '0';
	    		jump <= "101";
	    	--*********************************************************************************************************************************************************************
	    	--Using correct PC for instruction after BJJ/R7 Dep. We will access the Instruction Memory in this cycle and write the IF/ID with the values for the next  
	    	--instruction. We will again send 0 to the ID/RR.
	    	elsif (jump = "101") then 
	    		PC_write_tem <= '1';
	    		IF_ID_Write_tem <= '1';
	    	    M3_tem <= '0';
	    		jump <= "000";
	    	end if;
	    	--***************************************************************************************************************************************************************************
	    	--After the above final elsif IF/ID will have the next instruction so the Opcode will now no longer correspond to the older BJJ/R7 Dep. one. Hence if the next instruction is
	    	-- not a BJJ/R7 Dep. then it will not enter the outer if as the IF/ID register is now no longer frozen.
	    	--***************************************************************************************************************************************************************************
	    
-----   --=========================
--3--   --LM followed by dependency
-----   --=========================
	    elsif(Opcode = "0110" or lm = '1') then 
	    	if(lm = '0') then 
	    		lm <= '1';
	    		PC_write_tem <= '1';
	    		IF_ID_Write_tem <= '1';
	    		M3_tem <= '1';
	    	else
	    		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    		--This marks the end of LM instruction where we need to check for dependencies
	    		--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	    	 	if (Opcode /= "0110") then
	    	 		lm <= '0';
					
					--~~~~~~~~~~~~~~~~~~~~~~~
			    	--ADD,ADC,ADZ,NDU,NDC,NDZ
			    	--~~~~~~~~~~~~~~~~~~~~~~~
			    	if (Opcode = "0000" or Opcode = "0010") then
			    		if(A3 = I8_6 or A3 = I5_3) then
			    			PC_write_tem <= '0';
			    			IF_ID_Write_tem <= '0';
			    			M3_tem <= '0';
			    		else
	    					PC_write_tem <= '1';
	    					IF_ID_Write_tem <= '1';
	    					M3_tem <= '1';
	    				end if;	 
			    	
			    	--~~~~~~~~~~
			    	--ADI,LW,JLR
			    	--~~~~~~~~~~
			        elsif (Opcode = "0001" or Opcode = "0100" or Opcode = "1001") then
			        	if (A3 = I8_6) then
			        		PC_write_tem <= '0';
			    			IF_ID_Write_tem <= '0';
			    			M3_tem <= '0';
			    		else
	    					PC_write_tem <= '1';
	    					IF_ID_Write_tem <= '1';
	    					M3_tem <= '1';
	    				end if;
			    	
			    	--~~~~~
			    	--LM SM
			    	--~~~~~
			    	elsif (Opcode = "0110" or Opcode = "0111") then
			    		if (A3 = I11_9) then
			    			PC_write_tem <= '0';
			    			IF_ID_Write_tem <= '0';
			    			M3_tem <= '0';
			    		else
	    					PC_write_tem <= '1';
	    					IF_ID_Write_tem <= '1';
	    					M3_tem <= '1';
	    				end if;

	    			--///////////////////////////////////////////////////////////////
					-- I made a mistake for SW and BEQ which has been rectified here.	    		
					--///////////////////////////////////////////////////////////////

	    			--~~~~~~~
	    			--SW,BEQ
	    			--~~~~~~~
	    			elsif (Opcode = "0101" or Opcode = "1100") then 
	    				if (A3 = I11_9 or A3 = I8_6) then
	    					PC_write_tem <= '0';
	    					IF_ID_Write_tem <= '0';
	    					M3_tem <= '0';
	    				else
	    					PC_write_tem <= '1';
	    					IF_ID_Write_tem <= '1';
	    					M3_tem <= '1';
	    				end if; 
					--////////////////////////////////////////////////////////////////
	    			
	    			--~~~~~~~~
	    			--LHI ,JAL
	    			--~~~~~~~~
	    			else
	    				PC_write_tem <= '1';
	    				IF_ID_Write_tem <= '1';
	    				M3_tem <= '1';
			    	end if;


			    --~~~~~~~~~~~~~~~~~~~~~~~
			    --When LM is still going 
			    --~~~~~~~~~~~~~~~~~~~~~~~
			    else
			    	PC_write_tem <= '1';
	    			IF_ID_Write_tem <= '1';
	    			M3_tem <= '1';  	 		 		    	 		 
			    end if;
			end if;
	    
-----   --========================
--4--   --When there is no hazard
-----   --========================
	    else
	    	PC_write_tem <= '1';
	    	IF_ID_Write_tem <= '1';
	    	M3_tem <= '1';
	    end if;
	end if;
end process;
PC_write <= PC_write_tem;
IF_ID_Write <= IF_ID_Write_tem;
M3 <= M3_tem;
end Behave;
