library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity ID_RR_Pipeline is
	port (M3_sel: in std_logic;
	      RR_in: in std_logic_vector(2 downto 0);
	      RR_out: out std_logic_vector(2 downto 0);
	      IE_in: in std_logic_vector(13 downto 0);
	      IE_out: out std_logic_vector(13 downto 0);
              MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      A1_in: in std_logic_vector(2 downto 0);
	      A1_out: out std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A2_out: out std_logic_vector(2 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      Imm6_in: in std_logic_vector(5 downto 0);
	      Imm6_out: out std_logic_vector(5 downto 0);
	      Imm9_in: in std_logic_vector(8 downto 0);
	      Imm9_out: out std_logic_vector(8 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      cz_in: in std_logic_vector(1 downto 0);
              cz_out: out std_logic_vector(1 downto 0);
	      clk, enable: in std_logic);
end entity;

architecture Behave of ID_RR_Pipeline is
	signal tRR_out : std_logic_vector(2 downto 0) := (others => '0');
	signal tIE_out : std_logic_vector(13 downto 0) := (others => '0');
	signal tMA_out : std_logic_vector(4 downto 0) := (others => '0');
	signal tWB_out : std_logic_vector(3 downto 0) := (others => '0');
	signal tA1_out : std_logic_vector(2 downto 0) := (others => '0');
	signal tA2_out : std_logic_vector(2 downto 0) := (others => '0');
	signal tA3_out : std_logic_vector(2 downto 0) := (others => '0');
	signal tImm6_out : std_logic_vector(5 downto 0) := (others => '0');
	signal tImm9_out : std_logic_vector(8 downto 0) := (others => '0');
	signal tPC_out : std_logic_vector(15 downto 0) := (others => '0');
	signal topcode_out : std_logic_vector(3 downto 0) := (others => '0');
	signal tcz_out: std_logic_vector(1 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               tRR_out <= RR_in;
	       tIE_out <= IE_in;
	       tMA_out <= MA_in;
	       tWB_out <= WB_in;
	       tA1_out <= A1_in;
	       tA2_out <= A2_in;
	       tA3_out <= A3_in;
	       tImm6_out <= Imm6_in;
	       tImm9_out <= Imm9_in;
	       tPC_out <= PC_in;
	       if(M3_sel = '1') then 
	       topcode_out <= opcode_in;
	       tcz_out <= cz_in;
	       else
	       topcode_out <= (others => '0');
	       tcz_out <= (others => '0');
	       end if;
           end if;
       end if;
    end process;

    RR_out <= tRR_out;
    IE_out <= tIE_out;
    MA_out <= tMA_out;
    WB_out <= tWB_out;
    A1_out <= tA1_out;
    A2_out <= tA2_out;
    A3_out <= tA3_out;
    Imm6_out <= tImm6_out;
    Imm9_out <= tImm9_out;
    PC_out <= tPC_out;
    opcode_out <= topcode_out;
    cz_out <= tcz_out;
end Behave;
