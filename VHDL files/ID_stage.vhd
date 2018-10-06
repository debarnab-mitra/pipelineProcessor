library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;


entity Multiplexor3 is
	port(sel: in std_logic;
	     A: in std_logic_vector(25 downto 0);
	     B: in std_logic_vector(25 downto 0);
	     O: out std_logic_vector(25 downto 0));
end entity;

architecture Behave of Multiplexor3 is
	begin
	process(A, B, sel)
	begin
	for I in 0 to 25 loop	
		O(I) <= (A(I) and (not sel)) or (B(I) and sel);
	end loop;
	end process;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;


entity Multiplexor4 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end entity;

architecture Behave of Multiplexor4 is
	begin
	process(A, B, sel)
	begin	
	for I in 0 to 2 loop
		O(I) <= (A(I) and not sel) or (B(I) and sel);
	end loop;
	end process;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;


entity Multiplexor5 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end entity;

architecture Behave of Multiplexor5 is
	begin
	process(A, B, sel)
	begin
	for I in 0 to 2 loop	
		O(I) <= (A(I) and not sel) or (B(I) and sel);
	end loop;
	end process;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;


entity Multiplexor6 is
	port(sel: in std_logic;
	     A: in std_logic_vector(2 downto 0);
	     B: in std_logic_vector(2 downto 0);
	     O: out std_logic_vector(2 downto 0));
end entity;

architecture Behave of Multiplexor6 is
	begin
	process(A, B, sel)
	begin
	for I in 0 to 2 loop	
		O(I) <= (A(I) and not sel) or (B(I) and sel);
	end loop;
	end process;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity ID_stage is
	port (reset: in std_logic;
			IR_in: in std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);   ---prev value of A3 in ID/RR reg
	      OPC_in: in std_logic_vector(3 downto 0);  ---prev value of OPC in ID/RR reg
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
	      M3_sel: out std_logic;
	      PC_Write_out : out std_logic;
	      IF_ID_Write_out : out std_logic;
	      priority_encoder_string_out : out std_logic_vector(15 downto 0);
	      cz_out: out std_logic_vector(1 downto 0);
	      clk: in std_logic);
end entity;

architecture Behave of ID_stage is
	signal opcode : std_logic_vector(3 downto 0);
	signal I11_9 : std_logic_vector(2 downto 0);
	signal I8_6 : std_logic_vector(2 downto 0);
	signal I5_3 : std_logic_vector(2 downto 0);
	signal I5_0 : std_logic_vector(5 downto 0);
	signal I8_0 : std_logic_vector(8 downto 0);
	signal HDU_output_IF_ID, HDU_output_PC, HDU_output_M3, HDU_output_M3_tem : std_logic := '1';
	signal M1,M2,M3,M4,M5,M6,M8,C_en,Z_en,M14,M15,M18,M19,M20,Mem_en,Mem_R_W,RF_Write,PC_Write, IF_ID_Write: std_logic;
	signal M7,M9,M10,M13,ALU_OP,M16,M17 : std_logic_vector(1 downto 0);
	signal MA : std_logic_vector(3 downto 0);
	signal control, op_control_signals : std_logic_vector(25 downto 0);
	signal zeros: std_logic_vector(25 downto 0)  := (others => '0');
	signal done, M8_Control_PE: std_logic;
	signal addr: std_logic_vector(2 downto 0);
begin
	I11_9 <= IR_in(11 downto 9);
	I8_6 <= IR_in(8 downto 6);
	I5_3 <= IR_in(5 downto 3);
	I5_0 <= IR_in(5 downto 0);
	I8_0 <= IR_in(8 downto 0);
	MA(3) <= M14_in;
	MA(2) <= M15_in;
	MA(1) <= Mem_en_in;
	MA(0) <= Mem_RW_in;
	opcode <= IR_in(15 downto 12);
	OPC_out <= IR_in(15 downto 12);
	PC_out <= PC_in;
	Imm6_out <= IR_in(5 downto 0);
	Imm9_out <= IR_in(8 downto 0);
	cz_out <= IR_in(1 downto 0);

	pe : priority_encoder port map(x => IR_in, clk => clk, a => addr, i => priority_encoder_string_out, done => done, M8_Control => M8_Control_PE);

	hazard_detection_unit : HDU port map(Opcode => opcode, OPC => OPC_in, I8_6 => I8_6, I5_3 => I5_3, I11_9 => I11_9, MA => MA, A3 => A3_in, addr => addr, PC_Write => HDU_output_PC, IF_ID_Write => HDU_output_IF_ID, M3 => HDU_output_M3_tem, clk => clk);
	HDU_output_M3 <= HDU_output_M3_tem;
	control_signals : ControlSignals port map(reset => reset,IR => IR_in, done => done, addr => addr, M8_Control_PE => M8_Control_PE, HDU_output_PC => HDU_output_PC, HDU_output_M3 => HDU_output_M3, HDU_output_IF_ID => HDU_output_IF_ID, M2 => M2, PC_Write => PC_Write, IF_ID_Write => IF_ID_Write, M1 => M1, M3 => M3, M4 => M4, M5 => M5, M6 => M6, M7 => M7, M8 => M8, M9 => M9, M10 => M10, M13 => M13, ALU_OP => ALU_OP, C_en => C_en, Z_en => Z_en, M14 => M14, M15 => M15, M16 => M16, M17 => M17, M18 => M18, M19 => M19, M20 => M20, Mem_en => Mem_en, Mem_R_W => Mem_R_W, RF_Write => RF_Write, clk => clk);

	M2_out <= M2;
	PC_Write_out <= PC_Write;
	IF_ID_Write_out <= IF_ID_Write;
	control(0) <= M7(0);
	control(1) <= M7(1);
	control(2) <= M8;
	control(3) <= M9(0);
	control(4) <= M9(1);
	control(5) <= M10(0);
	control(6) <= M10(1);
	control(7) <= M13(0);
	control(8) <= M13(1);
	control(9) <= ALU_OP(1);
	control(10) <= ALU_OP(0);
	control(11) <= C_en;
	control(12) <= Z_en;
	control(13) <= M17(0);
	control(14) <= M17(1);
	control(15) <= M18;
	control(16) <= M19;
	control(17) <= M14;
	control(18) <= M15;
	control(19) <= Mem_en;
	control(20) <= Mem_R_W;
	control(21) <= M20;
	control(22) <= RF_Write;
	control(23) <= M16(0);
	control(24) <= M16(1);
	control(25) <= M1;

	mux6 : Multiplexor6 port map(sel => M6, A => I11_9, B => addr, O => A3_out);
	mux5 : Multiplexor5 port map(sel => M5, A => I5_3, B => I11_9, O => A2_out);
	mux4 : Multiplexor4 port map(sel => M4, A => I8_6, B => addr, O => A1_out);
	mux3 : Multiplexor3 port map(sel => HDU_output_M3_tem, A => zeros, B => control, O => op_control_signals);

	M3_sel <= HDU_output_M3_tem;
	
	RR_out(0) <= op_control_signals(2);
	RR_out(1) <= op_control_signals(1);
	RR_out(2) <= op_control_signals(0);

	IE_out(0) <= op_control_signals(16);
	IE_out(1) <= op_control_signals(15);
	IE_out(2) <= op_control_signals(14);
	IE_out(3) <= op_control_signals(13);
	IE_out(4) <= op_control_signals(12);
	IE_out(5) <= op_control_signals(11);
	IE_out(6) <= op_control_signals(10);
	IE_out(7) <= op_control_signals(9);
	IE_out(8) <= op_control_signals(8);
	IE_out(9) <= op_control_signals(7);
	IE_out(10) <= op_control_signals(6);
	IE_out(11) <= op_control_signals(5);
	IE_out(12) <= op_control_signals(4);
	IE_out(13) <= op_control_signals(3);

	MA_out(0) <= op_control_signals(20);
	MA_out(1) <= op_control_signals(19);
	MA_out(2) <= op_control_signals(18);
	MA_out(3) <= op_control_signals(17);
	MA_out(4) <= op_control_signals(21);

	WB_out(0) <= op_control_signals(25);
	WB_out(1) <= op_control_signals(24);
	WB_out(2) <= op_control_signals(23);
	WB_out(3) <= op_control_signals(22);

	--done_out <= done;
	
	
end Behave;
