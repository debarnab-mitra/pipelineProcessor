library std;
use std.standard.all;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;
entity MA is
port(

	--+*+*+*+
	--INPUTS
	--+*+*+*+

	--=====================================
	--These inputs come from EX/MA register
	--=====================================
	MA_in :in std_logic_vector(4 downto 0); -- MA_in(4) = M20, MA_in(3) = M14 , MA_in(2) = M15 , MA_in(1) = mem_enable , MA_in(0) = mew_r/w.
	WB_in :in std_logic_vector(3 downto 0);

	D2_in :in std_logic_vector(15 downto 0);
	D1_in :in std_logic_vector(15 downto 0);
	ALURESULT: in std_logic_vector(15 downto 0);
	A3_in :in std_logic_vector(2 downto 0);
	NPC_in :in std_logic_vector(15 downto 0);
	z_in :in std_logic;
	clk :in std_logic;
	Opcode_in : in std_logic_vector(3 downto 0);


	--+*+*+*+*+
	--OUTPUTS
	--+*+*+*+*+

	WB_out: out std_logic_vector(3 downto 0);
	DATA : out std_logic_vector(15 downto 0);
	A3_out : out std_logic_vector(2 downto 0);
	NPC_out : out std_logic_vector(15 downto 0);
	z_out : out std_logic;
	Opcode_out : out std_logic_vector( 3 downto 0));

end entity;

architecture Behaviour of MA is
	signal m14_memory,memory_m15,addr : std_logic_vector(15 downto 0) := (others => '0');
	signal m14_sel: std_logic := '0';
	begin
		m14_sel <= MA_in(3);
		m14: Multiplexor1 port map(A => D2_in, B => D1_in, sel => m14_sel, O => m14_memory);
		m15: Multiplexor1 port map(A => memory_m15, B => ALURESULT, sel => MA_in(2), O => DATA);
		m20: Multiplexor1 port map(A => ALURESULT, B => D2_in, sel => MA_in(4), O => addr);
		mem: data_memory port map(clk => clk ,reset => '0',mem_enable => MA_in(1),r_w => MA_in (0),addr => addr,write_data => m14_memory,read_data =>memory_m15);
		WB_out <= WB_in;
		A3_out <= A3_in;
		NPC_out <= NPC_in;
		z_out <= z_in;
		Opcode_out <= Opcode_in;

end Behaviour;
