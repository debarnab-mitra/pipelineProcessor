library std;
use std.standard.all;
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity MA_WB_Pipeline is
	port (WB_in: in std_logic_vector(3 downto 0);
	      WB_out: out std_logic_vector(3 downto 0);
	      Data_in: in std_logic_vector(15 downto 0);
	      Data_out: out std_logic_vector(15 downto 0);
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

architecture Behave of MA_WB_Pipeline is
	       signal tWB_out :std_logic_vector(3 downto 0) := (others => '0');
	       signal tData_out : std_logic_vector(15 downto 0) := (others => '0');
	       signal tA3_out :std_logic_vector(2 downto 0):= (others => '0');
	       signal tNPC_out :std_logic_vector(15 downto 0):= (others => '0');
	       signal tZ_out :std_logic := '0';
	       signal topcode_out :std_logic_vector(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
	       tWB_out <= WB_in;
	       tData_out <= Data_in;
	       tA3_out <= A3_in;
	       tNPC_out <= NPC_in;
	       tZ_out <= Z_in;
	       topcode_out <= opcode_in;
           end if;
       end if;
    end process;

	       WB_out <= tWB_out;
	       Data_out <= tData_out;
	       A3_out <= tA3_out;
	       NPC_out <= tNPC_out;
	       Z_out <= tZ_out;
	       opcode_out <= topcode_out;
end Behave;
