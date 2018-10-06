library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

package Pack is 
--------------------------------extra components-----------------------------------------------------

component encoder1 is
port(X0: in std_logic_vector(15 downto 0);
	X1: in std_logic_vector(15 downto 0);
	X2: in std_logic_vector(15 downto 0);
	X3: in std_logic_vector(15 downto 0);
	X4: in std_logic_vector(15 downto 0);
	X5: in std_logic_vector(15 downto 0);
	X6: in std_logic_vector(15 downto 0);
	X7: in std_logic_vector(15 downto 0);
	Y: in std_logic_vector(2 downto 0);
	enable: in std_logic;
   Z: out std_logic_vector(15 downto 0));
end component;
component decoder is
port(X: in std_logic_vector(15 downto 0);
	enable: in std_logic;
	Y: in std_logic_vector(2 downto 0);
        Z0: out std_logic_vector(16 downto 0);
	Z1: out std_logic_vector(16 downto 0);
	Z2: out std_logic_vector(16 downto 0);
	Z3: out std_logic_vector(16 downto 0);
	Z4: out std_logic_vector(16 downto 0);
	Z5: out std_logic_vector(16 downto 0);
	Z6: out std_logic_vector(16 downto 0);
	Z7: out std_logic_vector(16 downto 0));
end component;
component RF is
port (Din0: in std_logic_vector(16 downto 0);
	 Din1: in std_logic_vector(16 downto 0);
	 Din2: in std_logic_vector(16 downto 0);
	 Din3: in std_logic_vector(16 downto 0);
	 Din4: in std_logic_vector(16 downto 0);
	 Din5: in std_logic_vector(16 downto 0);
	 Din6: in std_logic_vector(16 downto 0);
	 Din7: in std_logic_vector(16 downto 0);
	 Dout0: out std_logic_vector(15 downto 0);
	 Dout1: out std_logic_vector(15 downto 0);
	 Dout2: out std_logic_vector(15 downto 0);
	 Dout3: out std_logic_vector(15 downto 0);
	 Dout4: out std_logic_vector(15 downto 0);
	 Dout5: out std_logic_vector(15 downto 0);
	 Dout6: out std_logic_vector(15 downto 0);
	 Dout7: out std_logic_vector(15 downto 0);
    clk, enable: in std_logic);
end component;

--------------------------------------------------- IF Stage------------------------------------------------
component Multiplexor2 is
	port(sel: in std_logic;
	     A: in std_logic_vector(15 downto 0);
	     B: in std_logic_vector(15 downto 0);
	     O: out std_logic_vector(15 downto 0));
end component;

component PC_Register is
	port (Din: in std_logic_vector(15 downto 0);
	      Dout: out std_logic_vector(15 downto 0);
	      clk, enable: in std_logic);
end component;

component code_memory is
   port(clk,reset: in std_logic;
	mem_enable: in std_logic;
     	r_w: in std_logic;
  	addr: in std_logic_vector(15 downto 0);
        write_data: in std_logic_vector(15 downto 0); 
        read_data: out std_logic_vector(15 downto 0));
end component;

component Increment is
	port (Iin: in std_logic_vector(15 downto 0);
	      Iout: out std_logic_vector(15 downto 0));
end component;

component IF_stage is
	port (reset: in std_logic;
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_Write_in: in std_logic;
	      M2_in: in std_logic;
	      priority_encoder_string: in std_logic_vector(15 downto 0);
	      IR_out: out std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
 	      IncrementedPC_out: out std_logic_vector(15 downto 0);
	      clk: in std_logic);
end component;

---------------------------------------------------------- IF Stage Ends-----------------------------
component IF_ID_Pipeline is
	port (IR_in: in std_logic_vector(15 downto 0);
	      IR_out: out std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      clk, enable: in std_logic);
end component;

------------------------------------------------------ID Stage----------------------------------------

component Multiplexor3 is
	port(sel: in std_logic;
	     A: in std_logic_vector(25 downto 0);
	     B: in std_logic_vector(25 downto 0);
	     O: out std_logic_vector(25 downto 0));
end component;

component Multiplexor4 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end component;

component Multiplexor5 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end component;

component Multiplexor6 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end component;

component priority_encoder is
port( x: in std_logic_vector(15 downto 0);
      clk : in std_logic;
      a: out std_logic_vector(2 downto 0);					
      i: out std_logic_vector(15 downto 0);					
      done: out std_logic;
	  M8_Control: out std_logic);
end component;

component HDU is
port (
		--===========================================
		--Opcode is required for all type of hazards.
		--===========================================	
		  Opcode : in std_logic_vector(3 downto 0);        --This comes from IF/ID register.
		  OPC : in std_logic_vector(3 downto 0);           --This comes from ID/RR register.
		--================================================
		--This is need for Load followed with dependencies
		--================================================
		  I8_6: in std_logic_vector(2 downto 0);           --This comes from IF/ID register.
	      I5_3: in std_logic_vector(2 downto 0);           --This comes from IF/ID register.
	      I11_9: in std_logic_vector(2 downto 0);          --This comes from IF/ID register.
	      ---------------------------------------------------------------
	      --The bits of MA are 3 = M14, 2 = M15, 1 = Mem_en, 0 = Mem_R/W.
	      ---------------------------------------------------------------
	      MA: in std_logic_vector(3 downto 0);			   --This comes from ID/RR register.
	      A3: in std_logic_vector(2 downto 0);             --This comes from ID/RR register. 
		  addr: in std_logic_vector(2 downto 0);           --This comes from PE.
	      --=================
	      --Output of the HDU
	      --=================
	      PC_Write :out std_logic;                         --This determines if PC is written or not in the current cycle.
	      IF_ID_Write :out std_logic;                      --This determines if IF_ID is written or not in the current cycle.
	      M3: out std_logic;                               --This is the control pin of the Mux M3.

	      clk: in std_logic);
end component;

component ControlSignals is
port (	reset: in std_logic;
			IR: in std_logic_vector(15 downto 0);
		  addr: in std_logic_vector(2 downto 0);
	      done: in std_logic;
		  M8_Control_PE: in std_logic;
	      HDU_output_PC: in std_logic;
	      HDU_output_M3: in std_logic;
	      HDU_output_IF_ID: in std_logic;
	      --FDU_output: in std_logic;
	      M2: out std_logic;
	      PC_Write: out std_logic;
	      IF_ID_Write: out std_logic;
	      M1: out std_logic;	   
	      M3: out std_logic;
	      M4: out std_logic;
	      M5: out std_logic;
	      M6: out std_logic;
	      M7: out std_logic_vector(1 downto 0);
	      M8: out std_logic;
	      M9: out std_logic_vector(1 downto 0);
	      M10: out std_logic_vector(1 downto 0);
	      --M11: out std_logic_vector(1 downto 0);
	      --M12: out std_logic_vector(1 downto 0);
	      M13: out std_logic_vector(1 downto 0);
	      ALU_OP: out std_logic_vector(1 downto 0);
	      C_en: out std_logic;
	      Z_en: out std_logic;
	      M14: out std_logic;
	      M15: out std_logic;
	      M16: out std_logic_vector(1 downto 0);
	      M17: out std_logic_vector(1 downto 0);
	      M18: out std_logic;
	      M19: out std_logic;
	      M20: out std_logic;
	      Mem_en: out std_logic;
	      Mem_R_W: out std_logic;
	      RF_Write: out std_logic;
	      clk: in std_logic);
end component;
component ID_stage is
	port (reset: in std_logic;
			IR_in: in std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);   ---prev value of A3 in ID/RR reg
	      OPC_in: in std_logic_vector(3 downto 0);  ---prev value of OPC in ID/RR reg
	      --done_out: out std_logic;
	      --addr: in std_logic_vector(2 downto 0);
	      M14_in : in std_logic;			---prev value of M14 in ID/RR reg
	      M15_in : in std_logic;                    ---prev value of M15 in ID/RR reg
	      Mem_en_in : in std_logic;                 ---prev value of Mem_en in ID/RR reg
	      Mem_RW_in : in std_logic;                    ---prev value of Mem_RW in ID/RR reg
	      RR_out: out std_logic_vector(2 downto 0);
	      IE_out: out std_logic_vector(13 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      A1_out: out std_logic_vector(2 downto 0);
	      A2_out: out std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      Imm6_out: out std_logic_vector(5 downto 0);
	      Imm9_out: out std_logic_vector(8 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      OPC_out: out std_logic_vector(3 downto 0);
	      M2_out : out std_logic;
	      M3_sel : out std_logic;
	      PC_Write_out : out std_logic;
	      IF_ID_Write_out : out std_logic;
	      priority_encoder_string_out : out std_logic_vector(15 downto 0);
	      cz_out: out std_logic_vector(1 downto 0);
	      clk: in std_logic);
end component;

------------------------------------------ID Stage Ends--------------------------------------------------

component ID_RR_Pipeline is
	port (M3_sel: in std_logic;
	      RR_in: in std_logic_vector(2 downto 0);
	      RR_out: out std_logic_vector(2 downto 0);
	      IE_in: in std_logic_vector(13 downto 0);
	      IE_out: out std_logic_vector(13 downto 0);
              MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      A1_in: in std_logic_vector(2 downto 0);
	      A1_out: out std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A2_out: out std_logic_vector(2 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      Imm6_in: in std_logic_vector(5 downto 0);
	      Imm6_out: out std_logic_vector(5 downto 0);
	      Imm9_in: in std_logic_vector(8 downto 0);
	      Imm9_out: out std_logic_vector(8 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      cz_in: in std_logic_vector(1 downto 0);
              cz_out: out std_logic_vector(1 downto 0);
	      clk, enable: in std_logic);
end component;

----------------------------------------------RR stage----------------------------------

component RFComplete is
		port(A1: in std_logic_vector(2 downto 0);
		A2: in std_logic_vector(2 downto 0);
		A3: in std_logic_vector(2 downto 0);
		D1: out std_logic_vector(15 downto 0);
		D2: out std_logic_vector(15 downto 0);
		D3: in std_logic_vector(15 downto 0);
		RF_write: in std_logic;
		clk : in std_logic);
		end component;

	component Multiplexor1 is
		port(A: in std_logic_vector(15 downto 0);
	   		B: in std_logic_vector(15 downto 0);
	   		sel: in std_logic;
	   		O: out std_logic_vector(15 downto 0));
	end component;


	component Multiplexor2_2 is
	port(A: in std_logic_vector(15 downto 0);
	 	B: in std_logic_vector(15 downto 0);
		C: in std_logic_vector(15 downto 0);
		D: in std_logic_vector(15 downto 0);
	  	sel0: in std_logic;
		sel1: in std_logic;
	  	O: out std_logic_vector(15 downto 0));
	end component;	


	component SE7 is 
	port(A: in std_logic_vector(8 downto 0);
	     B: out std_logic_vector(15 downto 0));
	end component;

	component SE10 is 
	port(A: in std_logic_vector(5 downto 0);
	     B: out std_logic_vector(15 downto 0));
	end component;

	component ZE is 
	port(A: in std_logic_vector(8 downto 0);
	     B: out std_logic_vector(15 downto 0));
	end component;

	component RR is
	port(

		--+*+*+*+
		--INPUTS
		--+*+*+*+

		--=================================
		--ALL THESE ARE FROM ID/RR REGISTER
		--=================================
		RR_in :in std_logic_vector(2 downto 0); -- RR_in(1) = M7_0 ; RR_in(0) = M7_1 ;
		IE_in :in std_logic_vector(13 downto 0);
		MA_in :in std_logic_vector(4 downto 0);
		WB_in :in std_logic_vector(3 downto 0);

		A1_in :in std_logic_vector(2 downto 0); 
		A2_in :in std_logic_vector(2 downto 0);
		A3_in :in std_logic_vector(2 downto 0);

		Imm6 :in std_logic_vector(5 downto 0);
		Imm9 :in std_logic_vector(8 downto 0);
		PC_in :in std_logic_vector(15 downto 0);
		OPC_in :in std_logic_vector(3 downto 0);
                cz_in: in std_logic_vector(1 downto 0);
		
		--=============================
		--THIS IS FROM MEM/WB REGISTER
		--=============================
		A3_MA_WB :in std_logic_vector( 2 downto 0);
		D3_MA_WB :in std_logic_vector( 15 downto 0);

		--=======================
		--This comes from the PE
		--=======================
		

		--============================================
		--THIS COMES FROM THE TOPMOST ADD IN EXE STAGE
		--============================================
		add_output : in std_logic_vector( 15 downto 0);

		--==========================================
		--THIS COMES FROM THE WB SIGNALS IN WB STAGE
		--==========================================
		RF_write : in std_logic;
		clk : in std_logic;
		--+*+*+*+*+
		--OUPTUTS
		--+*+*+*+*+

		IE_out :out std_logic_vector(13 downto 0);
		MA_out :out std_logic_vector(4 downto 0);
		WB_out :out std_logic_vector(3 downto 0);

		D1_out : out std_logic_vector( 15 downto 0);
		D2_out : out std_logic_vector( 15 downto 0);
		PC_out :out std_logic_vector( 15 downto 0);
		Imm16 : out std_logic_vector( 15 downto 0);

		A3_out :out std_logic_vector(2 downto 0); 
		A1_out :out std_logic_vector(2 downto 0);
		A2_out :out std_logic_vector(2 downto 0);
		cz_out: out std_logic_vector(1 downto 0);

		OPC_out :out std_logic_vector(3 downto 0)
		);
end component;

--------------------------------------------------RR stage Ends-------------------------------

component RR_EX_Pipeline is
	port (IE_in: in std_logic_vector(13 downto 0);
	      IE_out: out std_logic_vector(13 downto 0);
              MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      D1_in: in std_logic_vector(15 downto 0);
	      D1_out: out std_logic_vector(15 downto 0);
	      D2_in: in std_logic_vector(15 downto 0);
	      D2_out: out std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      Imm16_in: in std_logic_vector(15 downto 0);
	      Imm16_out: out std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      A1_in: in std_logic_vector(2 downto 0);
	      A1_out: out std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A2_out: out std_logic_vector(2 downto 0);
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      cz_in: in std_logic_vector(1 downto 0);
              cz_out: out std_logic_vector(1 downto 0);
	      clk, enable: in std_logic);
end component;

----------------------------- EX Stage-----------------------------------------------------
component DataRegister1 is
	port (Din: in std_logic;
	      Dout: out std_logic;
	      clk, enable: in std_logic);
	end component;

component ALU is
   port(X: in std_logic_vector(15 downto 0);
        Y: in std_logic_vector(15 downto 0);
		clk : in std_logic;
		alu_enable: in std_logic;
		IE_RR_EX: in std_logic_vector(13 downto 0);
		WB_RR_EX: in std_logic_vector(3 downto 0);
		WB_EX_MA: out std_logic_vector(3 downto 0);
		instruction_op_code: in std_logic_vector(3 downto 0); 
		instruction_op_flag: in std_logic_vector(1 downto 0); 
	        op_code: in std_logic_vector(1 downto 0); 
		Cin: in std_logic;
		Zin: in std_logic;
		C: out std_logic;
		Z: out std_logic;
		C_en: out std_logic;
		Z_en: out std_logic;
		alu_result: out std_logic_vector(15 downto 0);
		alu_done: out std_logic);
end component ALU;

component ALU_2 is
   port(X: in std_logic_vector(15 downto 0);
        Y: in std_logic_vector(15 downto 0);
	clk : in std_logic;
        op_code: in std_logic_vector(1 downto 0); 
        R: out std_logic_vector(15 downto 0));
end component ALU_2;

component ForwardUnit is
	port (A1_in: in std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A3_EX_MA_in: in std_logic_vector(2 downto 0);
	      A3_MA_WB_in: in std_logic_vector(2 downto 0);
		  WB_EX_MA: in std_logic_vector(3 downto 0);
	      WB_MA_WB: in std_logic_vector(3 downto 0);
	      opcode_RR_EX: in std_logic_vector(3 downto 0);
	      opcode_EX_MA: in std_logic_vector(3 downto 0);
	      opcode_MA_WB: in std_logic_vector(3 downto 0);
	      sel_1: out std_logic_vector(1 downto 0);---for M12
	      sel_2: out std_logic_vector(1 downto 0);---for M11
	      clk: in std_logic);
end component;


component Multiplexor2_15 is
port(A: in std_logic_vector(15 downto 0);
	B: in std_logic_vector(15 downto 0);
	C: in std_logic_vector(15 downto 0);
	D: in std_logic_vector(15 downto 0);
	sel0: in std_logic;
	sel1: in std_logic;
	O: out std_logic_vector(15 downto 0));
end component;

component EX_entity is
	port (IE_in: in std_logic_vector(13 downto 0);
          MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      D1_in: in std_logic_vector(15 downto 0);
	      D1_out: out std_logic_vector(15 downto 0);
	      D2_in: in std_logic_vector(15 downto 0);
	      D2_out: out std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
		  NPC_in: out std_logic_vector(15 downto 0);
		  ALUResult_in : out std_logic_vector(15 downto 0);
		  ALUResult_EX_MA: in std_logic_vector(15 downto 0);
		  Data_MA_WB: in std_logic_vector(15 downto 0);
	      Imm16_in: in std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
		  A3_out: out std_logic_vector(2 downto 0);
	      A1_in: in std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
		  A3_EX_MA_in: in std_logic_vector(2 downto 0);
		  A3_MA_WB_in: in std_logic_vector(2 downto 0);
		  WB_EX_MA: in std_logic_vector(3 downto 0);
		  WB_MA_WB: in std_logic_vector(3 downto 0);
		  opcode_in: in std_logic_vector(3 downto 0);
		  opcode_EX_MA: in std_logic_vector(3 downto 0);
		  opcode_MA_WB: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
		  D2_pe_in: out std_logic_vector(15 downto 0);
		  Z: out std_logic;
		  cz_in: in std_logic_vector(1 downto 0);
		  clk: in std_logic);
end component;
-------------------------------------EX Stage Ends-----------------------------------------

component EX_MA_Pipeline is
	port (MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      D1_in: in std_logic_vector(15 downto 0);
	      D1_out: out std_logic_vector(15 downto 0);
	      D2_in: in std_logic_vector(15 downto 0);
	      D2_out: out std_logic_vector(15 downto 0);
	      ALU_in: in std_logic_vector(15 downto 0);
	      ALU_out: out std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      NPC_in: in std_logic_vector(15 downto 0);
	      NPC_out: out std_logic_vector(15 downto 0);
	      Z_in: in std_logic;
	      Z_out:out std_logic;
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      clk, enable: in std_logic);
end component;
-------------------------------------------------MA Stage------------------------------------------------
----------------Other components Defined Earlier---------------------------------------------------------
	component data_memory is 
		port(clk,reset: in std_logic;
			mem_enable: in std_logic;
     		r_w: in std_logic;
  			addr: in std_logic_vector(15 downto 0);
        	write_data: in std_logic_vector(15 downto 0); 
        	read_data: out std_logic_vector(15 downto 0));
   	end component;

component MA is
	port(
		MA_in :in std_logic_vector(4 downto 0); 
		WB_in :in std_logic_vector(3 downto 0);
		D2_in :in std_logic_vector(15 downto 0);
		D1_in :in std_logic_vector(15 downto 0);
		ALURESULT: in std_logic_vector(15 downto 0);
		A3_in :in std_logic_vector(2 downto 0);
		NPC_in :in std_logic_vector(15 downto 0);
		z_in :in std_logic;
		clk :in std_logic;
		Opcode_in : in std_logic_vector( 3 downto 0);

		WB_out: out std_logic_vector(3 downto 0);
		DATA : out std_logic_vector(15 downto 0);
		A3_out : out std_logic_vector(2 downto 0);
		NPC_out : out std_logic_vector(15 downto 0);
		z_out : out std_logic;
		Opcode_out : out std_logic_vector(3 downto 0));

end component;
------------------------------------------------------MA Stage Ends-----------------------------------
component MA_WB_Pipeline is
	port (WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      Data_in: in std_logic_vector(15 downto 0);
	      Data_out: out std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      NPC_in: in std_logic_vector(15 downto 0);
	      NPC_out: out std_logic_vector(15 downto 0);
	      Z_in: in std_logic;
	      Z_out:out std_logic;
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      clk, enable: in std_logic);
end component;

------------------------------------------------------WB Stage-----------------------------------
----------------Other components Defined Earlier-------------------------------------------------
component WB_entity is
port (WB_in: in std_logic_vector(3 downto 0);
	  Data_in: in std_logic_vector(15 downto 0);
	  Data_MA_WB_D3: out std_logic_vector(15 downto 0);
	  A3_in: in std_logic_vector(2 downto 0);
	  A3_out: out std_logic_vector(2 downto 0);
	  NPC_in: in std_logic_vector(15 downto 0);
	  Z_in: in std_logic;
	  PC_in: out std_logic_vector(15 downto 0);
	  PC_incremented: in std_logic_vector(15 downto 0);
	  PC_unincremented: in std_logic_vector(15 downto 0)
);
end  component;


---------------------------Toplevel---------------------------------------------------
component Microprocessor is
port(
	 clk: in std_logic;
	reset: in std_logic
	);
end component;

end Pack;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity Microprocessor is
port(
	 clk: in std_logic;
	 reset: in std_logic

	);
end entity;

architecture Behaviour of Microprocessor is

--================================================
--SIGNALS FOR JOINING IF/ID REGISTER WITH IF STAGE
--================================================
signal ifid_ir_if : std_logic_vector(15 downto 0) := (others => '0');
signal ifid_pc_if : std_logic_vector(15 downto 0) := (others => '0');

--================================================
--SIGNALS FOR JOINING IF/ID REGISTER WITH ID STAGE
--================================================
signal ifid_ir_id : std_logic_vector(15 downto 0) := (others => '0');
signal ifid_pc_id : std_logic_vector(15 downto 0) := (others => '0');
signal ifid_write_id : std_logic := '1';
--================================================
--SIGNALS FOR JOINING ID/RR REGISTER WITH ID STAGE
--================================================
signal idrr_rr_id : std_logic_vector(2 downto 0)  := (others => '0'); --changed
signal idrr_ie_id : std_logic_vector(13 downto 0) := (others => '0');
signal idrr_ma_id : std_logic_vector(4 downto 0) := (others => '0');
signal idrr_wb_id : std_logic_vector(3 downto 0) := (others => '0');
signal idrr_a1_id : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_a2_id : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_a3_id : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_imm6_id : std_logic_vector(5 downto 0) := (others => '0');
signal idrr_imm9_id : std_logic_vector(8 downto 0) := (others => '0');
signal idrr_pc_id : std_logic_vector(15 downto 0) := (others => '0');
signal idrr_opc_id : std_logic_vector(3 downto 0) := (others => '0');
signal idrr_cz_id : std_logic_vector(1 downto 0) := (others => '0');
signal id_m3_idrr: std_logic := '0';
--================================================
--SIGNALS FOR JOINING ID/RR REGISTER WITH RR STAGE
--================================================
signal idrr_rr_rr : std_logic_vector(2 downto 0) := (others => '0'); --changed
signal idrr_ie_rr : std_logic_vector(13 downto 0) := (others => '0');
signal idrr_ma_rr : std_logic_vector(4 downto 0) := (others => '0');
signal idrr_wb_rr : std_logic_vector(3 downto 0) := (others => '0');
signal idrr_a1_rr : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_a2_rr : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_a3_rr : std_logic_vector(2 downto 0) := (others => '0');
signal idrr_imm6_rr : std_logic_vector(5 downto 0) := (others => '0');
signal idrr_imm9_rr : std_logic_vector(8 downto 0) := (others => '0');
signal idrr_pc_rr : std_logic_vector(15 downto 0) := (others => '0');
signal idrr_opc_rr : std_logic_vector(3 downto 0) := (others => '0');
signal idrr_cz_rr : std_logic_vector(1 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING RR STAGE WITH RR/EX REGISTER
--================================================
signal rrex_ie_rr : std_logic_vector(13 downto 0) := (others => '0');
signal rrex_ma_rr : std_logic_vector(4 downto 0) := (others => '0');
signal rrex_wb_rr : std_logic_vector(3 downto 0) := (others => '0');
signal rrex_d1_rr : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_d2_rr : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_pc_rr : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_imm16_rr : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_a3_rr : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_a1_rr : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_a2_rr : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_opc_rr : std_logic_vector(3 downto 0) := (others => '0');
signal rrex_cz_rr : std_logic_vector(1 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING EX STAGE WITH RR/EX REGISTER
--================================================
signal rrex_ie_ex : std_logic_vector(13 downto 0) := (others => '0');
signal rrex_ma_ex : std_logic_vector(4 downto 0) := (others => '0');
signal rrex_wb_ex : std_logic_vector(3 downto 0) := (others => '0');
signal rrex_d1_ex : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_d2_ex : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_pc_ex : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_imm16_ex : std_logic_vector(15 downto 0) := (others => '0');
signal rrex_a3_ex : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_a1_ex : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_a2_ex : std_logic_vector(2 downto 0) := (others => '0');
signal rrex_opc_ex : std_logic_vector(3 downto 0) := (others => '0');
signal rrex_cz_ex : std_logic_vector(1 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING EX STAGE WITH EX/MA REGISTER
--================================================
signal exma_ma_ex : std_logic_vector(4 downto 0) := (others => '0');
signal exma_wb_ex : std_logic_vector(3 downto 0) := (others => '0');
signal exma_d2_ex : std_logic_vector(15 downto 0) := (others => '0');
signal exma_d1_ex : std_logic_vector(15 downto 0) := (others => '0');
signal exma_aluresult_ex : std_logic_vector(15 downto 0) := (others => '0');
signal exma_a3_ex : std_logic_vector(2 downto 0) := (others => '0');
signal exma_npc_ex : std_logic_vector(15 downto 0) := (others => '0');
signal exma_z_ex : std_logic := '0';
signal exma_opcode_ex : std_logic_vector(3 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING MA STAGE WITH EX/MA REGISTER
--================================================
signal exma_ma_ma : std_logic_vector(4 downto 0) := (others => '0');
signal exma_wb_ma : std_logic_vector(3 downto 0) := (others => '0');
signal exma_d2_ma : std_logic_vector(15 downto 0) := (others => '0');
signal exma_d1_ma : std_logic_vector(15 downto 0) := (others => '0');
signal exma_aluresult_ma : std_logic_vector(15 downto 0) := (others => '0');
signal exma_a3_ma : std_logic_vector(2 downto 0) := (others => '0');
signal exma_npc_ma : std_logic_vector(15 downto 0) := (others => '0');
signal exma_z_ma : std_logic := '0';
signal exma_opcode_ma : std_logic_vector(3 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING MA STAGE WITH MA/WB REGISTER
--================================================
signal mawb_wb_ma : std_logic_vector(3 downto 0) := (others => '0');
signal mawb_data_ma : std_logic_vector(15 downto 0) := (others => '0');
signal mawb_a3_ma : std_logic_vector(2 downto 0) := (others => '0');
signal mawb_npc_ma : std_logic_vector(15 downto 0) := (others => '0');
signal mawb_z_ma : std_logic := '0';
signal mawb_opcode_ma : std_logic_vector(3 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING WB STAGE WITH MA/WB REGISTER
--================================================
signal mawb_wb_wb : std_logic_vector(3 downto 0) := (others => '0');
signal mawb_data_wb : std_logic_vector(15 downto 0) := (others => '0');
signal mawb_a3_wb : std_logic_vector(2 downto 0) := (others => '0');
signal mawb_npc_wb : std_logic_vector(15 downto 0) := (others => '0');
signal mawb_z_wb : std_logic := '0';
signal mawb_opcode_wb : std_logic_vector(3 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING ID STAGE WITH RR STAGE
--================================================
signal id_done_rr, id_m2_id : std_logic := '0';
--================================================
--SIGNALS FOR JOINING IF STAGE WITH WB STAGE
--================================================
signal wb_pcin_if : std_logic_vector(15 downto 0) := (others => '0');
signal wb_incpc_if : std_logic_vector(15 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING IF STAGE WITH ID STAGE
--================================================
signal if_m2_id : std_logic := '0';
signal if_pestring_id : std_logic_vector(15 downto 0) := (others => '0');
signal if_pcwrite_id : std_logic := '0';
--================================================
--SIGNALS FOR JOINING RR STAGE WITH WB STAGE
--================================================
signal rr_a3_wb : std_logic_vector(2 downto 0) := (others => '0');
signal rr_d3_wb : std_logic_vector(15 downto 0) := (others => '0');
--================================================
--SIGNALS FOR JOINING RR STAGE WITH EX STAGE
--================================================
signal rr_d2_ex : std_logic_vector(15 downto 0) := (others => '0');

begin

	if_stage_pm : IF_stage port map(
			reset => reset,
		  PC_in => wb_pcin_if,
	      PC_Write_in => if_pcwrite_id,
	      M2_in => if_m2_id,
	      priority_encoder_string => if_pestring_id,
	      IR_out => ifid_ir_if,
	      PC_out => ifid_pc_if,
 	      IncrementedPC_out => wb_incpc_if,
	      clk => clk);

		
	
	if_id_register : IF_ID_Pipeline port map(
		  IR_in => ifid_ir_if,
	      IR_out => ifid_ir_id,
	      PC_in => ifid_pc_if,
	      PC_out => ifid_pc_id,
	      clk => clk, 
	      enable => ifid_write_id);
		

	id_stage_pm : ID_stage port map(
			reset => reset,
		  IR_in => ifid_ir_id,
	      PC_in => ifid_pc_id,
	      A3_in => idrr_a3_rr,  ---prev value of A3 in ID/RR reg
	      OPC_in => idrr_opc_rr, ---prev value of OPC in ID/RR reg
	      --done_out => id_done_rr,
	      M14_in => idrr_ma_rr(3), --prev value of M14 in ID/RR reg
	      M15_in  => idrr_ma_rr(2),                   ---prev value of M15 in ID/RR reg
	      Mem_en_in => idrr_ma_rr(1),                 ---prev value of Mem_en in ID/RR reg
	      Mem_RW_in  => idrr_ma_rr(0),                 ---prev value of Mem_RW in ID/RR reg
	      RR_out =>idrr_rr_id,
	      IE_out => idrr_ie_id, 
	      MA_out => idrr_ma_id,
	      WB_out => idrr_wb_id,
	      A1_out => idrr_a1_id,
	      A2_out => idrr_a2_id,
	      A3_out => idrr_a3_id,
	      Imm6_out => idrr_imm6_id,
	      Imm9_out => idrr_imm9_id,
	      PC_out => idrr_pc_id,
	      OPC_out => idrr_opc_id,
	      M2_out => if_m2_id,
	      M3_sel => id_m3_idrr,
	      PC_Write_out =>  if_pcwrite_id,
	      IF_ID_Write_out => ifid_write_id,
	      priority_encoder_string_out => if_pestring_id,
	      cz_out => idrr_cz_id,
	      clk => clk
	      );
	
	id_rr_register : ID_RR_Pipeline port map(M3_sel => id_m3_idrr,
		  RR_in => idrr_rr_id,
	      RR_out => idrr_rr_rr, 
	      IE_in => idrr_ie_id,
	      IE_out => idrr_ie_rr,
          MA_in =>idrr_ma_id,
	      MA_out => idrr_ma_rr, 
	      WB_in => idrr_wb_id,
	      WB_out => idrr_wb_rr,
	      A1_in => idrr_a1_id,
	      A1_out => idrr_a1_rr, 
	      A2_in => idrr_a2_id,
	      A2_out => idrr_a2_rr, 
	      A3_in => idrr_a3_id,
	      A3_out =>idrr_a3_rr, 
	      Imm6_in => idrr_imm6_id,
	      Imm6_out => idrr_imm6_rr,
	      Imm9_in => idrr_imm9_id,
	      Imm9_out => idrr_imm9_rr,
	      PC_in => idrr_pc_id,
	      PC_out => idrr_pc_rr, 
	      opcode_in => idrr_opc_id,
	      opcode_out => idrr_opc_rr,
	      cz_in => idrr_cz_id,
	      cz_out => idrr_cz_rr,
	      clk => clk,
	      enable => '1'
	      );
	
	rr_stage_pm : RR port map(
		  RR_in => idrr_rr_rr, 
		  IE_in => idrr_ie_rr, 
		  MA_in => idrr_ma_rr, 
		  WB_in => idrr_wb_rr,
		  A1_in => idrr_a1_rr, 
		  A2_in => idrr_a2_rr,
		  A3_in => idrr_a3_rr,
		  Imm6 => idrr_imm6_rr,
		  Imm9 => idrr_imm9_rr,
		  PC_in => idrr_pc_rr,
		  OPC_in => idrr_opc_rr, 
		  A3_MA_WB => rr_a3_wb,
		  D3_MA_WB => rr_d3_wb,
		  --done => id_done_rr, 
		  add_output => rr_d2_ex,
		  RF_write => mawb_wb_wb(3),
		  clk => clk, 
		  IE_out => rrex_ie_rr, 
		  MA_out=> rrex_ma_rr,
		  WB_out => rrex_wb_rr,
		  D1_out => rrex_d1_rr, 
		  D2_out => rrex_d2_rr,
		  PC_out => rrex_pc_rr, 
		  Imm16 => rrex_imm16_rr,
		  A3_out => rrex_a3_rr,
		  A1_out => rrex_a1_rr,
		  A2_out => rrex_a2_rr,
		  OPC_out => rrex_opc_rr,
		  cz_in => idrr_cz_rr,
	      	  cz_out => rrex_cz_rr);

	rr_ex_register :RR_EX_Pipeline port map(
		  IE_in => rrex_ie_rr,
	      IE_out => rrex_ie_ex,
          MA_in => rrex_ma_rr,
	      MA_out =>rrex_ma_ex,
	      WB_in => rrex_wb_rr,
	      WB_out => rrex_wb_ex,
	      D1_in => rrex_d1_rr,
	      D1_out => rrex_d1_ex,
	      D2_in => rrex_d2_rr,
	      D2_out => rrex_d2_ex,
	      PC_in => rrex_pc_rr,
	      PC_out => rrex_pc_ex,
	      Imm16_in => rrex_imm16_rr,
	      Imm16_out => rrex_imm16_ex,
	      A3_in => rrex_a3_rr,
	      A3_out => rrex_a3_ex,
	      A1_in => rrex_a1_rr,
	      A1_out => rrex_a1_ex,
	      A2_in => rrex_a2_rr,
	      A2_out => rrex_a2_ex,
	      opcode_in => rrex_opc_rr,
	      opcode_out => rrex_opc_ex,
	      cz_in => rrex_cz_rr,
	      cz_out => rrex_cz_ex,
	      clk => clk,
	      enable => '1'
			);

	ex_stage_pm : EX_entity port map(
		  IE_in => rrex_ie_ex,
          MA_in => rrex_ma_ex,
	      MA_out =>exma_ma_ex,
	      WB_in => rrex_wb_ex,
	      WB_out => exma_wb_ex,
	      D1_in => rrex_d1_ex,
	      D1_out => exma_d1_ex,
	      D2_in => rrex_d2_ex,
	      D2_out => exma_d2_ex,
	      PC_in => rrex_pc_ex,
	      NPC_in => exma_npc_ex,
		  ALUResult_in => exma_aluresult_ex,
	      Imm16_in => rrex_imm16_ex,
	      A3_in => rrex_a3_ex,
		  A3_out => exma_a3_ex,
	      A1_in => rrex_a1_ex,
	      A2_in => rrex_a2_ex,
		  A3_EX_MA_in => exma_a3_ma,
		  A3_MA_WB_in => mawb_a3_wb,
		  WB_EX_MA => exma_wb_ma,
		  WB_MA_WB => mawb_wb_wb,
		  opcode_in => rrex_opc_ex,
		  opcode_EX_MA => exma_opcode_ma,
		  opcode_MA_WB => mawb_opcode_wb,
	      opcode_out => exma_opcode_ex,
		  D2_pe_in => rr_d2_ex,
		  Z => exma_z_ex,
		  clk => clk,
		  cz_in => rrex_cz_ex,
		  ALUResult_EX_MA => exma_aluresult_ma,
		  Data_MA_WB => mawb_data_wb	
		
		  );
	
	ex_ma_reigster : EX_MA_Pipeline port map(
		  MA_in => exma_ma_ex,
	      MA_out => exma_ma_ma,
	      WB_in => exma_wb_ex,
	      WB_out => exma_wb_ma,
	      D1_in => exma_d1_ex,
	      D1_out => exma_d1_ma,
	      D2_in => exma_d2_ex,
	      D2_out => exma_d2_ma,
	      ALU_in => exma_aluresult_ex,
	      ALU_out => exma_aluresult_ma,
	      A3_in => exma_a3_ex,
	      A3_out => exma_a3_ma,
	      NPC_in => exma_npc_ex,
	      NPC_out => exma_npc_ma,
	      Z_in => exma_z_ex,
	      Z_out => exma_z_ma,
	      opcode_in => exma_opcode_ex,
	      opcode_out => exma_opcode_ma,
	      clk => clk,
	      enable => '1'
			);

	ma_stage_pm : MA port map(
		MA_in => exma_ma_ma,
		WB_in => exma_wb_ma,
		D2_in => exma_d2_ma,
		D1_in => exma_d1_ma,
		ALURESULT => exma_aluresult_ma,
		A3_in  => exma_a3_ma,
		NPC_in => exma_npc_ma,
		z_in => exma_z_ma,
		clk  => clk,
		Opcode_in  => exma_opcode_ma,
		WB_out =>mawb_wb_ma,
		DATA  => mawb_data_ma,
		A3_out => mawb_a3_ma,
		NPC_out => mawb_npc_ma,
		z_out  => mawb_z_ma,
		Opcode_out => mawb_opcode_ma
		);

	ma_wb_register : MA_WB_Pipeline port map(
		  WB_in => mawb_wb_ma,
	      WB_out => mawb_wb_wb,
	      Data_in => mawb_data_ma,
	      Data_out => mawb_data_wb,
	      A3_in => mawb_a3_ma,
	      A3_out => mawb_a3_wb,
	      NPC_in => mawb_npc_ma,
	      NPC_out => mawb_npc_wb,
	      Z_in => mawb_z_ma,
	      Z_out => mawb_z_wb,
	      opcode_in => mawb_opcode_ma,
	      opcode_out => mawb_opcode_wb,
	      clk => clk,
	      enable => '1'
	      );


	wb_stage_pm : WB_entity port map(
	  WB_in => mawb_wb_wb,
	  Data_in => mawb_data_wb,
	  Data_MA_WB_D3 => rr_d3_wb,
	  A3_in => mawb_a3_wb,
	  A3_out => rr_a3_wb,
	  NPC_in => mawb_npc_wb,
	  Z_in => mawb_z_wb,
	  PC_in => wb_pcin_if,
	  PC_incremented => wb_incpc_if,
	  PC_unincremented => ifid_pc_if
);

			
end Behaviour;
	

