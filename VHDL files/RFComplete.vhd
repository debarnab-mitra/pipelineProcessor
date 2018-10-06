library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity RFComplete is
	port(A1: in std_logic_vector(2 downto 0);
	A2: in std_logic_vector(2 downto 0);
	A3: in std_logic_vector(2 downto 0);
	D1: out std_logic_vector(15 downto 0);
	D2: out std_logic_vector(15 downto 0);
	D3: in std_logic_vector(15 downto 0);
	RF_Write: in std_logic;
	clk : in std_logic);
end entity;

architecture Procedural of RFComplete is
	signal Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7: std_logic_vector(16 downto 0);
	signal  X0, X1, X2, X3, X4, X5, X6, X7: std_logic_vector(15 downto 0);
	begin
	d:decoder port map(X => D3, enable => RF_Write, Y => A3, Z0 => Z0, Z1 => Z1, Z2 => Z2, Z3 => Z3, Z4 => Z4, Z5 => Z5, Z6 => Z6, Z7 => Z7);
	rf1:RF port map(Din0 => Z0, Din1 => Z1, Din2 => Z2, Din3 => Z3, Din4 => Z4, Din5 => Z5, Din6 => Z6, Din7 => Z7, Dout0 => X0, Dout1 => X1, Dout2 => X2, Dout3 => X3, Dout4 => X4, Dout5 => X5, Dout6 => X6, Dout7 => X7, clk => clk, enable => RF_Write);
	e1:encoder1 port map(X0 => X0, X1 => X1, X2 => X2, X3 => X3, X4 => X4, X5 => X5, X6 => X6, X7 => X7, Y => A1, enable => '1', Z => D1);
	e2:encoder1 port map(X0 => X0, X1 => X1, X2 => X2, X3 => X3, X4 => X4, X5 => X5, X6 => X6, X7 => X7, Y => A2, enable => '1', Z => D2);
end Procedural;
