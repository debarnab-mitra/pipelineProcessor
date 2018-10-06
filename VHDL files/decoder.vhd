library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity decoder is
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
end entity;

architecture Behave of decoder is
   begin
   	process(X,Y,enable)
			variable tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7: std_logic_vector(16 downto 0) := (others => '0');
			begin
			if(enable = '1') then 
				if(Y = "000") then
					tmp0 := ('1' & X);
				else
					tmp0 := "00000000000000000";
				end if;
				if(Y = "001") then
					tmp1 := ('1' & X);
				else
					tmp1 := "00000000000000000";
				end if;
				if(Y = "010") then
					tmp2 := ('1' & X);
				else
					tmp2 := "00000000000000000";
				end if;
				if(Y = "011") then
					tmp3 := ('1' & X);
				else
					tmp3 := "00000000000000000";
				end if;
				if(Y = "100") then
					tmp4 := ('1' & X);
				else
					tmp4 := "00000000000000000";
				end if;
				if(Y = "101") then
					tmp5 := ('1' & X);
				else
					tmp5 := "00000000000000000";
				end if;
				if(Y = "110") then
					tmp6 := ('1' & X);
				else
					tmp6 := "00000000000000000";
				end if;
				if(Y = "111") then
					tmp7 := ('1' & X);
				else
					tmp7 := "00000000000000000";
				end if;
			else 
				tmp0 := "00000000000000000";
				tmp1 := "00000000000000000";
				tmp2 := "00000000000000000";
				tmp3 := "00000000000000000";
				tmp4 := "00000000000000000";
				tmp5 := "00000000000000000";
				tmp6 := "00000000000000000";
				tmp7 := "00000000000000000";
			end if;
			Z0 <= tmp0; Z1 <= tmp1; Z2 <= tmp2; Z3 <= tmp3; Z4 <= tmp4; Z5 <= tmp5; Z6 <= tmp6; Z7 <= tmp7;
		end process;
end Behave;
  

