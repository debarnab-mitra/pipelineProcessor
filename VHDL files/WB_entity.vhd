library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity WB_entity is
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
end entity WB_entity;

architecture Struct of WB_entity is
signal M16_out: std_logic_vector(15 downto 0) := (others => '0');
begin
	--predicate
	A3_out <= A3_in;
	Data_MA_WB_D3 <= Data_in;
	M1: Multiplexor1 port map(A => PC_incremented, B => M16_out, sel => WB_in(0), O => PC_in);
	M16: Multiplexor2_15 port map(A => NPC_in, B => Data_in, D => PC_unincremented, C => (others => '0'), sel0 => WB_in(2), sel1 => WB_in(1), O => M16_out);
end Struct;
