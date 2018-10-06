library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity Multiplexor2_15 is
	port(A: in std_logic_vector(15 downto 0);
   		B: in std_logic_vector(15 downto 0);
			C: in std_logic_vector(15 downto 0);
			D: in std_logic_vector(15 downto 0);
   		sel0: in std_logic;
			sel1: in std_logic;
   		O: out std_logic_vector(15 downto 0));
end entity Multiplexor2_15;
architecture Behave of Multiplexor2_15 is
	begin
	process(A, B, C, D, sel0, sel1)
	begin
		for I in 15 downto 0 loop 
			O(I) <= (B(I) and (not sel0) and sel1) or (A(I) and (not sel0) and (not sel1)) or (C(I) and sel0 and (not sel1)) or (D(I) and sel0 and sel1);
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

entity DataRegister1 is
	
	port (Din: in std_logic;
	      Dout: out std_logic;
	      clk, enable: in std_logic);
end entity;
architecture Behave of DataRegister1 is
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               Dout <= Din;
           end if;
       end if;
    end process;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity EX_entity is
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
		  cz_in: in std_logic_vector(1 downto 0);
		  Z: out std_logic;
		  clk: in std_logic);
end entity;

architecture Struct of EX_entity is
	signal M10_out, M9_out, M19_out, M17_out: std_logic_vector(15 downto 0);
	signal M12_sel, M11_sel: std_logic_vector(1 downto 0);
	signal ALU_in_a, ALU_in_b, ALU_2_out, ALUResult: std_logic_vector(15 downto 0);
	signal alu_done, C_out,C_en, C_in, Z_en, Z_in, Z_out: std_logic := '0';
begin
	--predicate
	D2_out <= ALU_in_b;
	D1_out <= ALU_in_a;
	MA_out <= MA_in;
	Z <= Z_out;
	opcode_out <= opcode_in;
	A3_out <= A3_in;
	
	M10: Multiplexor2_15 port map(A => D1_in, D => (others => '0'), C => (0 => '1', others => '0'), B => PC_in, sel0 => IE_in(11), sel1 => IE_in(10), O => M10_out);
	M9: Multiplexor2_15 port map(A => D2_in, B => PC_in, D => Imm16_in, C => (others => '0'), sel0 => IE_in(13), sel1 => IE_in(12), O => M9_out);
	FDU: ForwardUnit port map(A1_in => A1_in, A2_in => A2_in, A3_EX_MA_in => A3_EX_MA_in, A3_MA_WB_in => A3_MA_WB_in, WB_EX_MA => WB_EX_MA, WB_MA_WB => WB_MA_WB, opcode_RR_EX => opcode_in, opcode_EX_MA => opcode_EX_MA, opcode_MA_WB => opcode_MA_WB, sel_1 => M12_sel, sel_2 => M11_sel, clk => clk);
	M11: Multiplexor2_15 port map(A => M9_out, B => ALUResult_EX_MA, D => Data_MA_WB, C => (others => '0'), sel0 => M11_sel(0), sel1 => M11_sel(1), O => ALU_in_b);
	M12: Multiplexor2_15 port map(A => M10_out, C => ALUResult_EX_MA, D => Data_MA_WB, B => (others => '0'), sel0 => M12_sel(0), sel1 => M12_sel(1), O => ALU_in_a);
	M17: Multiplexor2_15 port map(A => Imm16_in, B => (0 => '1', others => '0'), D => (others => '0'), C => (others => '0'), sel0 => IE_in(3), sel1 => IE_in(2), O => M17_out);
	M19: Multiplexor1 port map(A => PC_in, B => ALU_in_a, sel => IE_in(0), O => M19_out);
	alu_small: ALU_2 port map(X => M19_out, Y => M17_out, clk => clk, op_code => "00", R => ALU_2_out);
	alu1: ALU port map(X => ALU_in_a, Y => ALU_in_b, clk => clk, alu_enable => '1', IE_RR_EX => IE_in, WB_RR_EX => 
	WB_in, WB_EX_MA => WB_out, instruction_op_code => opcode_in, op_code => IE_in(7 downto 6), instruction_op_flag => cz_in, Cin => C_out, Zin => Z_out, C => C_in, Z => Z_in, C_en => C_en, Z_en => Z_en, alu_result => ALUResult, alu_done => alu_done);
	c1: DataRegister1 port map(Din => C_in, Dout => C_out, enable => C_en, clk => clk);
	z1: DataRegister1 port map(Din => Z_in, Dout => Z_out, enable => Z_en, clk => clk);
	M13: Multiplexor2_15 port map(A => ALUResult, B => ALU_in_a, D => ALU_2_out, C => (others => '0'), sel0 => IE_in(9), sel1 => IE_in(8), O => NPC_in);
	M18: Multiplexor1 port map(A => ALUResult, B => ALU_2_out, sel => IE_in(1), O => ALUResult_in);
	alu_top: ALU_2 port map(X => ALU_in_b, Y => (0 => '1', others => '0'), clk => clk, op_code => "00", R => D2_pe_in);
end Struct;
