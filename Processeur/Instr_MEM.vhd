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
           OUTPUT : out STD_LOGIC_VECTOR (32 downto 0));
end Instr_MEM;

architecture Behavioral of Instr_MEM is

type instructions is array (255 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
signal R0M: instructions:= (others=>(others=>'0'));
begin
process(CLK)
    begin
        if (CLK='1') then 
            OUTPUT <= R0M(to_integer(unsigned(ADR)));
        end if;
end process;
end Behavioral;
