----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 08:54:01 AM
-- Design Name: 
-- Module Name: Test_data - Behavioral
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

entity Test_data is
end Test_data;

architecture Behavioral of Test_data is

component Data_MEM is
    Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end component Data_MEM;

signal ADR : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal INPUT : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
signal RW : STD_LOGIC:= '0';
signal RST : STD_LOGIC:= '0';
signal CLK : STD_LOGIC:= '0';
signal OUTPUT : STD_LOGIC_VECTOR (7 downto 0):= (others=>'0');
constant Clock_period : time := 50 ns;
begin

uut : Data_MEM port map(
ADR=>ADR,
INPUT=>INPUT,
RW=>RW,
RST=>RST,
CLK=>CLK,
OUTPUT=>OUTPUT
);

process
begin
CLK <= not(CLK);
wait for Clock_period/2;
end process;

process
begin
RST<='0';
ADR <= "00000000";


wait for 100 ns;--on met 65 a @255
RST<='1';
INPUT <= "10000001";
ADR <= "11111111";
RW <= '0';

wait for 100 ns;
RW <= '1';

wait for 100 ns;
RST<='1';
INPUT <= "11001100";--on met 108 à @86
ADR <= "10101010"; --
RW <= '0';

wait for 100 ns;
RW <= '1';

wait for 100 ns;
RST<='0';
end process;


end Behavioral;
