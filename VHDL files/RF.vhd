library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity RF is
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
end entity;

architecture Behave of RF is
signal tmp0, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7: std_logic_vector(15 downto 0) := (others => '0');
begin
process(clk, enable)
   begin
      if(clk'event and (clk  = '0')) then
	if(enable = '1') then
            if(Din0(16) = '1') then
					 for I in 0 to 15 loop
					 tmp0(I) <= Din0(I);
					 end loop; 
	    end if;
            if(Din1(16) = '1') then
					 for I in 0 to 15 loop
					 tmp1(I) <= Din1(I);
					 end loop; 
	    end if;
            if(Din2(16) = '1') then
					for I in 0 to 15 loop
					tmp2(I) <= Din2(I);
					end loop;
	    end if;
            if(Din3(16) = '1') then
					for I in 0 to 15 loop
					tmp3(I) <= Din3(I);
					end loop; 
	    end if;
            if(Din4(16) = '1') then
					 for I in 0 to 15 loop
					 tmp4(I) <= Din4(I);
					 end loop;
	    end if;
            if(Din5(16) = '1') then
					for I in 0 to 15 loop
					tmp5(I) <= Din5(I);
				end loop; 
	    end if;
            if(Din6(16) = '1') then
					for I in 0 to 15 loop
					tmp6(I) <= Din6(I);
					end loop; 
 	     end if;
		if(Din7(16) = '1') then
					for I in 0 to 15 loop
					tmp7(I) <= Din7(I);
					end loop; 
		end if;
				
			end if;
		end if;
   end process;
Dout0 <= tmp0; Dout1 <= tmp1; Dout2 <= tmp2; Dout3 <= tmp3; Dout4 <= tmp4; Dout5 <= tmp5; Dout6 <= tmp6; Dout7 <= tmp7;
end Behave;
