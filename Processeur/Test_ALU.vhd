----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2024 03:52:52 PM
-- Design Name: 
-- Module Name: testbench_alu - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_ALU is
end Test_ALU;

architecture Behavioral of Test_ALU is

component ALU is
     Port ( Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC);
end component ALU;
           signal A : STD_LOGIC_VECTOR (7 downto 0);
           signal B : STD_LOGIC_VECTOR (7 downto 0);
           signal control : STD_LOGIC_VECTOR (2 downto 0);
           signal carry : STD_LOGIC;
           signal overflow : STD_LOGIC;
           signal negative : STD_LOGIC;
           signal S : STD_LOGIC_VECTOR (7 downto 0);

begin
uut : ALU port map(
    A=>A,
    B=>B,
    C=>carry,
    Ctrl_Alu=>control,
    O=>overflow,
    N=>negative,
    S=>S
);
process
begin
--S <= "00000000";
--carry <= '0';
--overflow <= '0';
--negative <= '0';
    A <= "10000001";
    B <= "10000000";
    control <= "001";
    wait for 100 ns;
    control <= "010";
    wait for 100 ns;
    control <= "011" ;
    wait for 100 ns;
    
    A <= "00000001";
    B <= "00000010";
    control <= "001";
    wait for 100 ns;
    control <= "010" ;
    wait for 100 ns;
    control <= "011";
    wait for 100 ns;
end process;

end Behavioral;