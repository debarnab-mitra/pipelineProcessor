library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity RR_EX_Pipeline is
	port (IE_in: in std_logic_vector(13 downto 0);
	      IE_out: out std_logic_vector(13 downto 0);
          MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      D1_in: in std_logic_vector(15 downto 0);
	      D1_out: out std_logic_vector(15 downto 0);
	      D2_in: in std_logic_vector(15 downto 0);
	      D2_out: out std_logic_vector(15 downto 0);
	      PC_in: in std_logic_vector(15 downto 0);
	      PC_out: out std_logic_vector(15 downto 0);
	      Imm16_in: in std_logic_vector(15 downto 0);
	      Imm16_out: out std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      A1_in: in std_logic_vector(2 downto 0);
	      A1_out: out std_logic_vector(2 downto 0);
	      A2_in: in std_logic_vector(2 downto 0);
	      A2_out: out std_logic_vector(2 downto 0);
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      cz_in: in std_logic_vector(1 downto 0);
              cz_out: out std_logic_vector(1 downto 0);
	      clk, enable: in std_logic);
end entity;

architecture Behave of RR_EX_Pipeline is
signal tIE_out:  std_logic_vector(13 downto 0) := (others => '0');
signal tMA_out:  std_logic_vector(4 downto 0) := (others => '0');
signal tWB_out:  std_logic_vector(3 downto 0) := (others => '0');
signal tD1_out:  std_logic_vector(15 downto 0) := (others => '0');
signal tD2_out:  std_logic_vector(15 downto 0) := (others => '0');
signal tPC_out:  std_logic_vector(15 downto 0) := (others => '0');
signal tImm16_out:  std_logic_vector(15 downto 0) := (others => '0');
signal tA3_out:  std_logic_vector(2 downto 0) := (others => '0');
signal tA1_out:  std_logic_vector(2 downto 0) := (others => '0');
signal tA2_out:  std_logic_vector(2 downto 0) := (others => '0');
signal topcode_out:  std_logic_vector(3 downto 0) := (others => '0');
signal tcz_out: std_logic_vector(1 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
	       tIE_out <= IE_in;
	       tMA_out <= MA_in;
	       tWB_out <= WB_in;
	       tD1_out <= D1_in;
	       tD2_out <= D2_in;
	       tA1_out <= A1_in;
	       tA2_out <= A2_in;
	       tA3_out <= A3_in;
	       tImm16_out <= Imm16_in;
	       tPC_out <= PC_in;
	       topcode_out <= opcode_in;
	       tcz_out <= cz_in;
           end if;
       end if;
    end process;
    		IE_out <= tIE_out;
	       MA_out <= tMA_out;
	       WB_out <= tWB_out;
	       D1_out <= tD1_out;
	       D2_out <= tD2_out;
	       A1_out <= tA1_out;
	       A2_out <= tA2_out;
	       A3_out <= tA3_out;
	       Imm16_out <= tImm16_out;
	       PC_out <= tPC_out;
	       opcode_out <= topcode_out;
	       cz_out <= tcz_out;
end Behave;
