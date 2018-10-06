library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity Multiplexor2 is
	port(sel: in std_logic;
	     A: in std_logic_vector(15 downto 0);
	     B: in std_logic_vector(15 downto 0);
	     O: out std_logic_vector(15 downto 0));
end entity;

architecture Behave of Multiplexor2 is
	begin
	process(A, B, sel)
	begin	
		for I in 0 to 15 loop
			O(I) <= (A(I) and not sel) or (B(I) and sel);
		end loop;
	end process;
end Behave;


library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;


entity PC_Register is
	port (Din: in std_logic_vector(15 downto 0);
	      Dout: out std_logic_vector(15 downto 0);
	      clk, enable: in std_logic);
end entity;

architecture Behave of PC_Register is
signal pc_temp: std_logic_vector(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               pc_temp <= Din;
           end if;
       end if;
    end process;
 Dout <= pc_temp;
end Behave;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity Increment is
	port (Iin: in std_logic_vector(15 downto 0);
	      Iout: out std_logic_vector(15 downto 0));
--	      clk: in std_logic);
end entity;



architecture Serial of Increment is
begin
  process(Iin)
    variable carry: std_logic;
    variable one: std_logic_vector(15 downto 0) := "0000000000000001"; 
  begin 
    carry := '0';
    for I in 0 to 15 loop
       Iout(I) <= Iin(I) xor one(I) xor carry;
       carry := (Iin(I) and one(I)) or (carry and (Iin(I) xor one(I)));
    end loop;
  end process; 
end Serial;

library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity IF_stage is
	port (PC_in: in std_logic_vector(15 downto 0);
	      PC_Write_in: in std_logic;
	      M2_in: in std_logic;
	      priority_encoder_string: in std_logic_vector(15 downto 0);
	      IR_out: out std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
 	      IncrementedPC_out: out std_logic_vector(15 downto 0);
	      clk: in std_logic;
	      reset: in std_logic);
end entity;

architecture Mixed of IF_stage is
	signal pc_op : std_logic_vector(15 downto 0);
	signal inst : std_logic_vector(15 downto 0);
	signal temp : std_logic_vector(15 downto 0) := (others => '0');
	signal m2_sel : std_logic := '1';
	signal tPC_in: std_logic_vector(15 downto 0) := (others => '0');
begin
	m2_sel <= M2_in;
	
	process(reset,clk)
	begin
	if(reset = '1') then
	tPC_in <= (others => '0');
	else
	tPC_in <= PC_in;
	end if;
	end process;

	pc_reg : PC_Register port map(Din => tPC_in, Dout => pc_op, clk => clk, enable => PC_Write_in);
	PC_out <= pc_op;
	inc : Increment port map(Iin => pc_op, Iout => IncrementedPC_out);
	mem : code_memory port map(clk => clk, reset => '0', mem_enable => '1', r_w => '0', addr => pc_op, write_data => temp, read_data => inst);
	m2 : Multiplexor2 port map(sel => m2_sel, A => priority_encoder_string, B => inst, O => IR_out);
end Mixed;
