library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
entity data_memory is
   port(clk,reset: in std_logic;
	mem_enable: in std_logic;
     	r_w: in std_logic;
  	addr: in std_logic_vector(15 downto 0);
        write_data: in std_logic_vector(15 downto 0); 
        read_data: out std_logic_vector(15 downto 0));
   
end entity data_memory;

architecture Behave of data_memory is
type mem_arr is array(0 to 350) of std_logic_vector(15 downto 0);

--************************Data for max20******************************
signal mem: mem_arr := (0 => "0000000000000001",
			1 => "0000000000000010",
			2 => "0000000000000011",
			3 => "0000000000000100",
			4 => "0000000000000101",
			5 => "0000000000000110",
			6 => "0000000000000111",
			7 => "0000000000001000",
			8 => "0000000100000000",
			9 => "0000011100001010", -- 30A
			10 => "0000000100000010",
			11 => "0000000100000011",
			12 => "0000000100000100",
			13 => "0000000100000101",
			14 => "0000000100000110",
			15 => "0000000100000111",
			16 => "0000000100001000",
			17 => "0000000100001001",
			18 => "0000000100001010",
			19 => "0000000100001001",
			20 => "0000000000001010",
			others => "0000000000000000");
--***********************************************************************

--************************DATA for LM SM program*************************

--signal mem: mem_arr := (
--							0 => "0000000000000001",
--							1 => "0000000000000001",
--							2 => "0000000000000011",
--							3 => "0000000000000100",
--							4 => "0000000000000101",
--							5 => "0000000000000110",
--							6 => "0000000000000111",
--							7 => "0000000000001000",
--							256 => "0000000100000000",
--							257 => "0000000100000001",
--							258 => "0000000100000010",
--							259 => "0000000100000011",
--							260 => "0000000100000100",
--							261 => "0000000100000101",
--							262 => "0000000100000110",
--							263 => "0000000100000111",
--							264 => "0000000100001000",
--							265 => "0000000100001001",
--							266 => "0000000100001010",
--						others => "0000000000000000");
--***************************************************************************

type mem_instruction is array(0 to 14) of std_logic_vector(15 downto 0);		
begin			
process(clk,reset,mem_enable,r_w,addr,write_data)
begin
	if(mem_enable = '1') then
		-- read happens throughout the cycle;
		-- write only at the falling edge;
		if(reset = '0') then 
				-- read case, r_w = 0
				if(r_w = '0') then 
					read_data <= mem(to_integer(unsigned(addr)));
				-- write case, r_w = 1
				else	
				    if(clk'event and (clk  = '1')) then						
					 mem(to_integer(unsigned(addr))) <= write_data;
				    end if;
				  	 -- value at the output is the value that has just been written
					read_data <= write_data;
				end if;	
		else 
			read_data <= (others => '1');
	
		end if;
	else	
	read_data <= (others => '1');	
	end if;
end process;
		
end Behave;
		
