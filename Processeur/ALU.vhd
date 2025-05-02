----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2025 12:58:10 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.std_logic_signed.all;
--use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal aux : std_logic_vector(15 downto 0); 


begin
     aux <= (x"00" & A) + (x"00" & B) when Ctrl_Alu ="001"
     else A * B when Ctrl_Alu ="010"
     else (x"00"&A)-( x"00"&B) when Ctrl_Alu ="011"; 
            
     
     S<=aux(7 downto 0);
     N <= aux(7);
     C <= '1' when (aux(8) = '1') and Ctrl_Alu = "001" else '0';
     O <= '1' when (aux(15 downto 8) /= "00000000") and Ctrl_Alu = "010" else '0';
end Behavioral;
