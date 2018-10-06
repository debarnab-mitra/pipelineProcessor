library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

--==========================
--WIll pass A when sel =1 
--==========================
entity Multiplexor1 is
	port(A: in std_logic_vector(15 downto 0);
   		 B: in std_logic_vector(15 downto 0);
   		 sel: in std_logic;
   		 O: out std_logic_vector(15 downto 0));
end entity Multiplexor1;
architecture Behave of Multiplexor1 is
	begin
	process(A, B, sel)
	begin
		for I in 15 downto 0 loop	
			O(I) <= (A(I) and not sel) or (B(I) and (sel));
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

entity Multiplexor2_2 is                       -- sel0   sel1
	port(A: in std_logic_vector(15 downto 0);   --   0      0
   		 B: in std_logic_vector(15 downto 0);   --   0      1
		 C: in std_logic_vector(15 downto 0);   --   1      0
		 D: in std_logic_vector(15 downto 0);   --   1      1
   		 sel0: in std_logic;
		 sel1: in std_logic;
   		 O: out std_logic_vector(15 downto 0));
end entity Multiplexor2_2;
architecture Behave of Multiplexor2_2 is
	begin
	process(A, B, C, sel0, sel1)
	begin
		for I in 15 downto 0 loop 
			O(I) <= (B(I) and (not sel0) and sel1) or (A(I) and (not sel0) and (not sel1)) or (C(I) and sel0 and (not sel1));
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

entity SE10 is 
	port(A: in std_logic_vector(5 downto 0);
		  B: out std_logic_vector(15 downto 0));
end entity SE10;
architecture Behave of SE10 is
	begin
	process(A)
	begin
		for I in 15 downto 0 loop
			if(I < 6) then 
			B(I) <= A(I);
			else
			B(I) <= A(5);
			end if;
		end loop;
	end process;
end Behave;

library std;
use std.standard.all;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity SE7 is 
	port(A: in std_logic_vector(8 downto 0);
		  B: out std_logic_vector(15 downto 0));
end entity SE7;
architecture Behave of SE7 is
	begin
	process(A)
	begin
		for I in 15 downto 0 loop
			if(I < 9) then 
			B(I) <= A(I);
			else
			B(I) <= A(8);
			end if;
		end loop;
	end process;
end Behave;

library std;
use std.standard.all;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity ZE is 
	port(A: in std_logic_vector(8 downto 0);
		 B: out std_logic_vector(15 downto 0));
end entity ZE;
architecture Behave of ZE is
	begin
	process(A)
	begin
		for I in 15 downto 0 loop
			if(I > 6) then 
			B(I) <= A(I-7);
			else
			B(I) <= '0';
			end if;
		end loop;
	end process;
end Behave;

library std;
use std.standard.all;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
library work;
use work.Pack.all;

entity RR is
port(

	--+*+*+*+
	--INPUTS
	--+*+*+*+

	--=================================
	--ALL THESE ARE FROM ID/RR REGISTER
	--=================================
	RR_in :in std_logic_vector(2 downto 0); -- RR_in(2) = M7_0 ; RR_in(1) = M7_1 ; 0 bit = M8
	IE_in :in std_logic_vector(13 downto 0);
	MA_in :in std_logic_vector(4 downto 0);
	WB_in :in std_logic_vector(3 downto 0);

	A1_in :in std_logic_vector(2 downto 0); 
	A2_in :in std_logic_vector(2 downto 0);
	A3_in :in std_logic_vector(2 downto 0);

	Imm6 :in std_logic_vector(5 downto 0);
	Imm9 :in std_logic_vector(8 downto 0);
	PC_in :in std_logic_vector(15 downto 0);
	OPC_in :in std_logic_vector(3 downto 0);
	cz_in: in std_logic_vector(1 downto 0);
	
	--=============================
	--THIS IS FROM MEM/WB REGISTER
	--=============================
	A3_MA_WB :in std_logic_vector( 2 downto 0);
	D3_MA_WB :in std_logic_vector( 15 downto 0);

	--=======================
	--This comes from the PE
	--=======================


	--============================================
	--THIS COMES FROM THE TOPMOST ADD IN EXE STAGE
	--============================================
	add_output : in std_logic_vector( 15 downto 0);

	--==========================================
	--THIS COMES FROM THE WB SIGNALS IN WB STAGE
	--==========================================
	RF_write : in std_logic;
	clk : in std_logic;
	--+*+*+*+*+
	--OUPTUTS
	--+*+*+*+*+

	IE_out :out std_logic_vector(13 downto 0);
	MA_out :out std_logic_vector(4 downto 0);
	WB_out :out std_logic_vector(3 downto 0);

	D1_out : out std_logic_vector( 15 downto 0);
	D2_out : out std_logic_vector( 15 downto 0);
	PC_out :out std_logic_vector( 15 downto 0);
	Imm16 : out std_logic_vector( 15 downto 0);

	A3_out :out std_logic_vector(2 downto 0); 
	A1_out :out std_logic_vector(2 downto 0);
	A2_out :out std_logic_vector(2 downto 0);
	cz_out: out std_logic_vector(1 downto 0);

	OPC_out :out std_logic_vector(3 downto 0)
	);
end entity;

architecture Behave1 of RR is
	signal se10_m7_1,se7_m7_2,ze_m7_3,rf_m8_1 : std_logic_vector(15 downto 0);


	begin
			rf1: RFComplete port map(A1 => A1_in, A2 => A2_in, A3 => A3_MA_WB, D1 => D1_out, D2 =>rf_m8_1, D3 => D3_MA_WB, RF_Write => RF_write, clk => clk);
			se10_1: SE10 port map(A => Imm6, B => se10_m7_1);
			se7_1: SE7 port map(A => Imm9, B => se7_m7_2);
			ze_1: ZE port map(A => Imm9, B => ze_m7_3);
			m7: Multiplexor2_2 port map(A => se10_m7_1, B => se7_m7_2, C => ze_m7_3, D => (others => '0'), sel0 => RR_in(2),sel1 => RR_in(1),O => Imm16);
			m8: Multiplexor1 port map(A => add_output, B => rf_m8_1, sel => RR_in(0), O => D2_out);

			IE_out <= IE_in;
			MA_out <= MA_in;
			WB_out <= WB_in;
			PC_out <= PC_in;
			A3_out <= A3_in;
			A1_out <= A1_in;
			A2_out <= A2_in;
			OPC_out <= OPC_in;
			cz_out <= cz_in;
end Behave1;




