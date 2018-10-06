library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity ALU_2 is
   port(X: in std_logic_vector(15 downto 0);
        Y: in std_logic_vector(15 downto 0);
	clk : in std_logic;
        op_code: in std_logic_vector(1 downto 0); 
        R: out std_logic_vector(15 downto 0));
end entity ALU_2;

architecture Behave of ALU_2 is
begin
	process(X,Y,op_code, clk)
		variable tmp: std_logic_vector(15 downto 0) := (others => '0');
		variable C_in, C_out: std_logic := '0';
	begin
		if(clk'event and (clk='0')) then
		if(op_code(0) = '0' and op_code(1) = '0') then
			C_in := '0';
			for I in 0 to 15 loop
				tmp(I) := (X(I) xor Y(I)) xor C_in;
				C_out := ((X(I) and Y(I)) or (C_in and (X(I) xor Y(I))));
				C_in := C_out;
			end loop;
		end if;			
		end if;
	   	R <= tmp;
	end process;
end Behave;
