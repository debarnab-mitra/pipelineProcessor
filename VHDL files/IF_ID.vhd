library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity IF_ID_Pipeline is
	port (IR_in: in std_logic_vector(15 downto 0);
	      IR_out: out std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      clk, enable: in std_logic);
end entity;

architecture Behave of IF_ID_Pipeline is
	signal tIR_out : std_logic_vector(15 downto 0) := (others => '0');
	signal tPC_out : std_logic_vector(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               tIR_out <= IR_in;
	       tPC_out <= PC_in;
           end if;
       end if;
    end process;
    
    PC_out <= tPC_out;
    IR_out <= tIR_out;
end Behave;
