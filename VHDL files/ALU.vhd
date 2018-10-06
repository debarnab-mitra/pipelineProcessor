library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Pack.all;
entity ALU is
   port(X: in std_logic_vector(15 downto 0);
        Y: in std_logic_vector(15 downto 0);
		clk: in std_logic;
		alu_enable: in std_logic;
		IE_RR_EX: in std_logic_vector(13 downto 0);
		WB_RR_EX: in std_logic_vector(3 downto 0);
		WB_EX_MA: out std_logic_vector(3 downto 0);
		instruction_op_code: in std_logic_vector(3 downto 0); 
		instruction_op_flag: in std_logic_vector(1 downto 0); 
		op_code: in std_logic_vector(1 downto 0); 
		Cin: in std_logic;
		Zin: in std_logic;
		C: out std_logic;
		Z: out std_logic;
		C_en: out std_logic;
		Z_en: out std_logic;
		alu_result: out std_logic_vector(15 downto 0);
		alu_done: out std_logic);
end entity ALU;

architecture Behave of ALU is
		signal talu_done: std_logic := '0';
		signal tWB_EX_MA,tWB_EX_MA_BEQ: std_logic_vector(3 downto 0) := (others => '0');
		signal tC_en:std_logic := '0';
		signal tZ_en: std_logic := '0';
		signal tZ: std_logic;
	
begin
	process(X,Y,alu_enable,instruction_op_flag, op_code, instruction_op_code, IE_RR_EX, WB_RR_EX, Cin, Zin)
		variable tmp, Y_neg, Y2: std_logic_vector(15 downto 0) := (others => '0');
		variable C_in, C_out, C_in1, C_out1: std_logic := '0';
		variable one: std_logic_vector(15 downto 0) := "0000000000000001";
		variable equal_count: integer := 0;
	begin	
		talu_done <= '0';
		if(instruction_op_code = "0000") then
			if(instruction_op_flag = "10") then
			    if(Cin = '1') then
					tWB_EX_MA(3) <= '1'; --RF-write
					tWB_EX_MA(2) <= '0'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '1';
					tZ_en <= '1';
			    else
					tWB_EX_MA(3) <= '0'; ---RF-write
					tWB_EX_MA(2) <= '1'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '0';
			     end if;
			elsif(instruction_op_flag = "01") then
			    if(Zin = '1') then
					tWB_EX_MA(3) <= '1'; ---RF-write
					tWB_EX_MA(2) <= '0'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '1';
					tZ_en <= '1';
			    else
					tWB_EX_MA(3) <= '0'; ---RF-write
					tWB_EX_MA(2) <= '1'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '0';
				end if;
			else
				tWB_EX_MA(3) <= WB_RR_EX(3); ---RF-write
				tWB_EX_MA(2) <= WB_RR_EX(2); --m16(0)
				tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
				tWB_EX_MA(0) <= WB_RR_EX(0); --M1
				tC_en <= IE_RR_EX(5);
				tZ_en <= IE_RR_EX(4);
			end if;
		elsif(instruction_op_code = "0010") then
			if(instruction_op_flag = "10") then
			    if(Cin = '1') then
					tWB_EX_MA(3) <= '1'; ---RF-write
					tWB_EX_MA(2) <= '0'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '1';
			    else
					tWB_EX_MA(3) <= '0'; ---RF-write
					tWB_EX_MA(2) <= '1'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '0';
			    end if;
			elsif(instruction_op_flag = "01") then
			    if(Zin = '1') then
					tWB_EX_MA(3) <= '1'; ---RF-write
					tWB_EX_MA(2) <= '0'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '1';
			    else
					tWB_EX_MA(3) <= '0'; ---RF-write
					tWB_EX_MA(2) <= '1'; --m16(0)
					tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
					tWB_EX_MA(0) <= WB_RR_EX(0); --M1
					tC_en <= '0';
					tZ_en <= '0';
			    end if;
			else
				tWB_EX_MA(3) <= WB_RR_EX(3); ---RF-write
				tWB_EX_MA(2) <= WB_RR_EX(2); --m16(0)
				tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
				tWB_EX_MA(0) <= WB_RR_EX(0); --M1
				tC_en <= IE_RR_EX(5);
				tZ_en <= IE_RR_EX(4);
			end if;
		else 
				tWB_EX_MA(3) <= WB_RR_EX(3); ---RF-write
				tWB_EX_MA(2) <= WB_RR_EX(2); --m16(0)
				tWB_EX_MA(1) <= WB_RR_EX(1); --m16(1)
				tWB_EX_MA(0) <= WB_RR_EX(0); --M1
				tC_en <= IE_RR_EX(5);
				tZ_en <= IE_RR_EX(4);
			
		end if;
		if(alu_enable = '1') then
			if(op_code(0) = '0' and op_code(1) = '0') then
				C_in := '0';
				for I in 0 to 15 loop
					tmp(I) := (X(I) xor Y(I)) xor C_in;
					C_out := ((X(I) and Y(I)) or (C_in and (X(I) xor Y(I))));
					C_in := C_out;
				end loop;
			end if;			
			if(op_code(0) = '0' and op_code(1) = '1') then
				equal_count := 0;
				for I in 0 to 15 loop
					if(X(I) = Y(I)) then
						equal_count := equal_count + 1;				
					end if;
				end loop;
				if(equal_count = 16) then
					tmp := "0000000000000000";
					tWB_EX_MA_BEQ(3) <= WB_RR_EX(3);
					tWB_EX_MA_BEQ(2) <= '0';
					tWB_EX_MA_BEQ(1) <= '0';						
					tWB_EX_MA_BEQ(0) <= '1';
				else
					tmp := "0000000000000001";
					tWB_EX_MA_BEQ(3) <= WB_RR_EX(3);
					tWB_EX_MA_BEQ(2) <= '1';
					tWB_EX_MA_BEQ(1) <= '1';
					tWB_EX_MA_BEQ(0) <= '1';
				end if;
				
			end if;	
			if(op_code(0) = '1' and op_code(1) = '0') then
				tmp := not (X and Y);
			end if;
		end if;

	   	alu_result <= tmp;
		C <= C_out;

		if(tmp = "0000000000000000") then
		tZ <= '1';
		else 
		tZ <= '0';
		end if;
		talu_done <= '1';
	end process;

	C_en <= tC_en;
	Z_en <= tZ_en;
	Z <= tZ;
	alu_done <= talu_done;
	WB_EX_MA <= tWB_EX_MA_BEQ when instruction_op_code = "1100" else
		    tWB_EX_MA when ((instruction_op_code = "0000") or (instruction_op_code = "0010")) else
		    WB_RR_EX;
end Behave;
				

