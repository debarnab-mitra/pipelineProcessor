library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;

entity EX_MA_Pipeline is
	port (MA_in: in std_logic_vector(4 downto 0);
	      MA_out: out std_logic_vector(4 downto 0);
	      WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      D1_in: in std_logic_vector(15 downto 0);
	      D1_out: out std_logic_vector(15 downto 0);
	      D2_in: in std_logic_vector(15 downto 0);
	      D2_out: out std_logic_vector(15 downto 0);
	      ALU_in: in std_logic_vector(15 downto 0);
	      ALU_out: out std_logic_vector(15 downto 0);
	      A3_in: in std_logic_vector(2 downto 0);
	      A3_out: out std_logic_vector(2 downto 0);
	      NPC_in: in std_logic_vector(15 downto 0);
	      NPC_out: out std_logic_vector(15 downto 0);
	      Z_in: in std_logic;
	      Z_out:out std_logic;
	      opcode_in: in std_logic_vector(3 downto 0);
	      opcode_out: out std_logic_vector(3 downto 0);
	      clk, enable: in std_logic);
end entity;

architecture Behave of EX_MA_Pipeline is
	       signal tMA_out :std_logic_vector(4 downto 0) := (others => '0');
	       signal tWB_out :std_logic_vector(3 downto 0) := (others => '0');
	       signal tD1_out :std_logic_vector(15 downto 0):= (others => '0');
	       signal tD2_out :std_logic_vector(15 downto 0):= (others => '0');
	       signal tALU_out :std_logic_vector(15 downto 0):= (others => '0');
	       signal tA3_out :std_logic_vector(2 downto 0):= (others => '0');
	       signal tNPC_out :std_logic_vector(15 downto 0):= (others => '0');
	       signal tZ_out :std_logic := '0';
	       signal topcode_out :std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
	       tMA_out <= MA_in;
	       tWB_out <= WB_in;
	       tD1_out <= D1_in;
	       tD2_out <= D2_in;
	       tALU_out <= ALU_in;
	       tA3_out <= A3_in;
	       tNPC_out <= NPC_in;
	       tZ_out <= Z_in;
	       topcode_out <= opcode_in;
           end if;
       end if;
    end process;
	       MA_out <= tMA_out;
	       WB_out <= tWB_out;
	       D1_out <= tD1_out;
	       D2_out <= tD2_out;
	       ALU_out <= tALU_out;
	       A3_out <= tA3_out;
	       NPC_out <= tNPC_out;
	       Z_out <= tZ_out;
	       opcode_out <= topcode_out;
end Behave;
