----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 08:54:01 AM
-- Design Name: 
-- Module Name: Test_registres - Behavioral
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


entity testbench_registres is
end testbench_registres;
architecture Behavioral of testbench_registres is

component banc_registres is
     Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Wb : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end component banc_registres;
signal A : std_logic_vector (3 downto 0) := (others=>'0');
signal B : std_logic_vector (3 downto 0) := (others=>'0');
signal Wb : std_logic_vector (3 downto 0) := (others=>'0');
signal W : std_logic := '0';
signal DATA : std_logic_vector (7 downto 0) := (others=>'0');
signal RST : std_logic := '1';
signal CLK : std_logic := '0';
signal QA : std_logic_vector (7 downto 0) := (others=>'0');
signal QB : std_logic_vector (7 downto 0) := (others=>'0');

constant Clock_period : time := 50 ns;

begin
uut : banc_registres port map(
    A => A,
    B => B,
    Wb => Wb,
    W=>W,
    DATA=>DATA,
    RST=>RST,
    CLK=>CLK,
    QA=>QA,
    QB=>QB
);
process
begin
CLK <= not(CLK);
wait for Clock_period/2;
end process;

process
begin



B <= "0111"; --@7 Qb= 0x0
wait for 50 ns;
DATA <= "00000010";
W <= '1';
Wb <= "0111"; -- write @7 0x2 => Qb = 0x2
wait for 50 ns;
DATA <= "00000001";
Wb <= "1000";
A <= "1000";--read write @8 0x1 => QA = 0x1
wait for 50 ns;
W<= '0';
RST <= '0'; -- 0x0 pour tt
A <= "1000"; -- lire 0x0
B <= "0111"; -- ecrire 0x0
wait for 50 ns;
RST <= '1'; -- reset a 0x0  pour tt
wait for 50 ns;




end process;


end Behavioral;
