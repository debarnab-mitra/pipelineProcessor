library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
entity code_memory is
   port(clk,reset: in std_logic;
	mem_enable: in std_logic;
     	r_w: in std_logic;
  	addr: in std_logic_vector(15 downto 0);
        write_data: in std_logic_vector(15 downto 0); 
        read_data: out std_logic_vector(15 downto 0));
   
end entity code_memory;

architecture Behave of code_memory is
	type mem_arr is array(0 to 1000) of std_logic_vector(15 downto 0);

--*****************************program to find the max no. **********************************
signal mem: mem_arr := (
				0 => "0011000000000000",
				1 => "0100001000000000",
				2 => "0011010000000000",
				3 => "0001010010010011",
				4 => "0001000000000001",
				5 => "0100011000000000",
				6 => "0011100000000000",
				7 => "0010100100100000",
				8 => "0010101001100000",
				9 => "0001101101000001",
				10 => "0000100011101000",
				11 => "0011101000000000",
				12 => "0000001011101010",
				13 => "1100000010000100",
				14 => "0011101000000000",
				15 => "0001101101000100",
				16 => "1001100101000000",
				17 => "0101001010000001",
				18 => "0001111111000000",
				others => "0000000000000000");
--***********************************************************************************************	

---*******************************Program to show LM SM******************************************
--signal mem: mem_arr := (0 => "0011000100000001",	--lhi r0 8080
--			1 => "0011001100000001", --lhi r1 8080 
--			2 => "1100000010001000", --beq r0 r2 8
--			3 => "0000111001000000", --add r7 r1 r0
--			256 => "0110111001011101", --lm r7 (load 0,2,3,4,6)
--			257 => "0111000011011100", --sm r0 (store 2,3,4,6,7) 
--			259 => "0011000000000010", --lhi r0 256
--			260 => "0100101000000000", --lw r5 r0 0
--			261 => "0100111000000000", --lw r7 r0 0
----			6 => "1100000010000010", --beq r0 r2 2
----			7 => "1000101000000100", --jal r5 4
----			8 => "1000101000000100", --jal r5 4  
----			--8=> "1001110101000000", --jlr r6 r5
----			11 =>"0011000100010001", --lhi r0 8080  
----			12 =>"0011000000000000", --lhi r0 0000
--			others => "0000000000000000");
--*********************************************************************************************			
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
		
