----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 08:44:19 AM
-- Design Name: 
-- Module Name: Instr_MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instr_MEM is
    Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           JMP_FALSE_FLAG : in STD_LOGIC;
           DI_OP : in std_logic_vector (7 downto 0);
           DI_DST : in std_logic_vector (7 downto 0);
           EX_OP : in std_logic_vector (7 downto 0);
           EX_DST : in std_logic_vector (7 downto 0);
           MEM_OP : in std_logic_vector (7 downto 0);
           MEM_DST : in std_logic_vector (7 downto 0);
           RE_OP : in std_logic_vector (7 downto 0);
           RE_DST : in std_logic_vector (7 downto 0);
           ALEA: out STD_LOGIC :='0';
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0):=(others=>'0'));
end Instr_MEM;


architecture Behavioral of Instr_MEM is

type instructions is array (255 downto 0) of STD_LOGIC_VECTOR (31 downto 0);

signal signal_alea : std_logic :='0';
signal next_instruction : std_logic_vector(31 downto 0) := x"00000000";
signal last_instruction : std_logic_vector(31 downto 0) := x"00000000";
signal internal_clock : std_logic :='0';

constant Clock_period : time := 25 ns; --half the period of CLK;

signal ROM: instructions:= (others=>(others=>'0'));
signal ADD : std_logic_vector(7 downto 0) := x"01";
signal MUL : std_logic_vector(7 downto 0) := x"02";
signal SOU : std_logic_vector(7 downto 0) := x"03";
signal COP : std_logic_vector(7 downto 0) := x"05";
signal AFC : std_logic_vector(7 downto 0) := x"06";
signal STR : std_logic_vector(7 downto 0) := x"07";
signal LDR : std_logic_vector(7 downto 0) := x"08";
signal NOP : std_logic_vector(31 downto 0) := x"00000000";
signal JMP : std_logic_vector(7 downto 0) := x"09";
signal JMF : std_logic_vector(7 downto 0) := x"0a";
signal PRINT :std_logic_vector(7 downto 0) := x"13";
 

begin

--ROM(1) <= JMP & x"06" & x"00" & x"00";  
ROM(0) <= AFC & x"01" & x"09" & x"00";  -- 9 à R1
ROM(1) <= AFC & x"02" & x"07" & x"00";  -- 7 a R2
ROM(2) <= AFC & x"03" & x"06" & x"00";  -- 6 a R3
ROM(3) <= ADD & x"04" & x"02" & x"03";  -- R4 = R2 + R3 = 13 = 0x0d
ROM(4) <= ADD & x"01" & x"01" & x"01";  -- R1 = R1 + R1 = 9 + 9 = 18 = 0x12
ROM(5) <= COP & x"00" & x"01" & x"00";  -- R0 = R1 = 0x12
ROM(6) <= COP & x"01" & x"04" & x"00";  -- R1 = R4 = 0x0d
ROM(7) <= STR & x"05" & x"03" & x"00";  -- @5 = R3 = 0x06
ROM(8) <= STR & x"01" & x"01" & x"00";  -- @1 = R1 = 0x0d
ROM(9) <= LDR & x"07" & x"05" & x"00";  -- R7 = @5 = 0x06
ROM(10) <= JMF & x"10" & x"00" & x"00";  -- JMP 16 => si false on ne fait rien sinon on fait les affectations et on imprime
ROM(11) <= AFC & x"0b" & x"0b" & x"00";
ROM(12) <= AFC & x"0c" & x"0c" & x"00";
ROM(13) <= AFC & x"0d" & x"0d" & x"00";
ROM(14) <= AFC & x"0e" & x"0e" & x"00";
ROM(15) <= PRINT & x"0e" & x"00" & x"00";  -- R7 = @5 = 0x06





--ROM(8) <= ADD & x"01" & x"01" & x"02";  -- mettre à l'adresse 0:  @1+@2 = 7+9 = 16 = x10
--ROM(9) <= SOU & x"04" & x"02" & x"03";  -- je soustrais 3 de 1 => 16 - 6 =10 et stocker dans 1
--ROM(10) <= MUL & x"03" & x"03" & x"01";
--ROM(11) <= COP & x"05" & x"03" & x"00";
--ROM(12) <= AFC & x"00" & x"05" & x"00";  -- 5 à l'adresse 4

process
begin
internal_clock <= not(internal_clock);
wait for Clock_period/2;
end process;


alea_gest: process (internal_clock)
begin
    if (CLK='0' and internal_clock='0') then 
        -- Default value
        signal_alea <= '0';
        -- Decode current instruction
        case next_instruction(31 downto 24) is

            -- Arithmetic instructions: ADD, MUL, SUB, etc.
            when x"01" | x"02" | x"03" | x"04" =>
                if ( ((DI_OP /= x"00") and (DI_DST = next_instruction(15 downto 8) or DI_DST = next_instruction(7 downto 0)))
                  or ((EX_OP /= x"00") and (EX_DST = next_instruction(15 downto 8) or EX_DST = next_instruction(7 downto 0)))
                  or ((MEM_OP /= x"00") and (MEM_DST = next_instruction(15 downto 8) or MEM_DST = next_instruction(7 downto 0)))
                  or ((last_instruction(31 downto 24) /= x"00") and (last_instruction(23 downto 16) = next_instruction(15 downto 8) or last_instruction(23 downto 16) = next_instruction(7 downto 0)))
                  --or ((RE_OP /= x"00") and (RE_DST = next_instruction(15 downto 8) or RE_DST = next_instruction(7 downto 0)))
                ) then
                    signal_alea <= '1';
                end if;

            -- COP or LDR  STR ou print 
            when x"05" | x"08" | x"07" =>
                if ( ((DI_OP /= x"00") and (DI_DST = next_instruction(15 downto 8)))
                  or ((EX_OP /= x"00") and (EX_DST = next_instruction(15 downto 8)))
                  or ((MEM_OP /= x"00") and (MEM_DST = next_instruction(15 downto 8)))
                  or ((last_instruction(31 downto 24) /= x"00") and last_instruction(23 downto 16) = next_instruction(15 downto 8))
                  --or ((RE_OP /= x"00") and (RE_DST = next_instruction(15 downto 8)))
                ) then
                    signal_alea <= '1';
                end if;
            if (next_instruction(31 downto 24)= x"08") then 
                if ( ((DI_OP = x"07") and (DI_DST = next_instruction(23 downto 16)))
                  or ((EX_OP = x"07") and (EX_DST = next_instruction(23 downto 16)))
                  --or ((MEM_OP /= x"07") and (MEM_DST = next_instruction(24 downto 16)))
                  or ((last_instruction(31 downto 24) = x"08") and last_instruction(23 downto 16) = next_instruction(23 downto 16))
                  --or ((RE_OP /= x"00") and (RE_DST = next_instruction(15 downto 8)))
                ) then
                    signal_alea <= '1';
                end if;
            end if;
            --PRINT dst = dst d'une operation qui ecrit (ADD, SOU, MUL, AFF, COP, LDR)
            when x"13" =>
                if ( ((DI_OP /= x"00") and (DI_DST = next_instruction(23 downto 16)))
                  or ((EX_OP /= x"00") and (EX_DST = next_instruction(23 downto 16)))
                  or ((MEM_OP /= x"00") and (MEM_DST = next_instruction(23 downto 16)))
                  or ((last_instruction(31 downto 24) /= x"00") and last_instruction(23 downto 16) = next_instruction(23 downto 16))
                  --or ((RE_OP /= x"00") and (RE_DST = next_instruction(15 downto 8)))
                ) then
                    signal_alea <= '1';
                end if;
            when others =>
                null;
        end case;
   end if;
end process;

OUTPUT<= last_instruction;

process(CLK)

    begin
        if (CLK='1') then 
            if signal_alea = '0' and JMP_FALSE_FLAG = '0'then --pas d'alea j'incrémente
                last_instruction <= ROM(to_integer(unsigned(ADR)));
            else -- exite un alea j'envoie une operation NOP
                last_instruction<= (others=>'0'); 
            end if;
        end if;
end process;

ALEA <= signal_alea;

next_instruction <= ROM(to_integer(unsigned(ADR)));

end Behavioral;
