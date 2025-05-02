----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2025 10:05:17 AM
-- Design Name: 
-- Module Name: banc_registres - Behavioral
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

entity banc_registres is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Wb : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end banc_registres;

architecture Behavioral of banc_registres is
type registers is array (15 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
signal banc: registers:= (others=>(others=>'0'));

begin
--Lecture 
 QA<= banc(to_integer(unsigned(A)));
 QB<= banc(to_integer(unsigned(B)));
 
 
 --ecriture
 process(CLK)
    begin
        if (CLK='1') then 
            if RST = '0' then 
                banc <=  (others=>(others=>'0'));
            else 
                if W= '1' then
                    banc(to_integer(unsigned(Wb))) <= DATA;
                end if;
            end if;
        end if;
 end process;
end Behavioral;
