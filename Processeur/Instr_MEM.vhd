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
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0));
end Instr_MEM;

architecture Behavioral of Instr_MEM is

type instructions is array (255 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal ROM: instructions:= (others=>(others=>'0'));
signal ADD : std_logic_vector(7 downto 0) := x"01";
signal MUL : std_logic_vector(7 downto 0) := x"02";
signal SOU : std_logic_vector(7 downto 0) := x"03";
signal COP : std_logic_vector(7 downto 0) := x"05";
signal AFC : std_logic_vector(7 downto 0) := x"06";
signal STR : std_logic_vector(7 downto 0) := x"07";
signal LDR : std_logic_vector(7 downto 0) := x"08";
 

begin

--ROM(0) <= ADD & x"01" & x"03" & x"07"; 
ROM(1) <= AFC & x"01" & x"09" & x"00";  -- 9 à l'adresse 1
ROM(2) <= AFC & x"02" & x"07" & x"00";  -- 7 a l'adresse 2
ROM(3) <= AFC & x"03" & x"06" & x"00";  -- 6 a l'adresse 3
ROM(4) <= ADD & x"01" & x"01" & x"02";  -- mettre à l'adresse 0:  @1+@2 = 7+9 = 16
ROM(5) <= SOU & x"01" & x"01" & x"03";  -- je soustrais 3 de 1 => 16 - 6 =10 et stocker dans 1
ROM(6) <= AFC & x"04" & x"05" & x"00";  -- 5 à l'adresse 4
process(CLK)
    begin
        if (CLK='1') then 
            OUTPUT <= ROM(to_integer(unsigned(ADR)));
        end if;
end process;
end Behavioral;
