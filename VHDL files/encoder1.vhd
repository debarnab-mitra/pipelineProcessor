library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity encoder1 is
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
end entity;

architecture Behave of encoder1 is
   begin
   process(X0,X1,X2,X3,X4,X5,X6,X7,Y,enable)
		variable tmp: std_logic_vector(15 downto 0) := (others => '1');
   	begin
		if(enable = '1') then 
			if(Y = "000") then
				Z <= X0;
			elsif(Y = "001") then
				Z <= X1;
			elsif(Y = "010") then
				Z <= X2;
			elsif(Y = "011") then
				Z <= X3;
			elsif(Y = "100") then
				Z <= X4;
			elsif(Y = "101") then
				Z <= X5;
			elsif(Y = "110") then
				Z <= X6;
			elsif(Y = "111") then
				Z <= X7;
			else Z <= X0;	
			end if;
		else 
			Z <= X0;
		end if;
	end process;
end Behave;
  

