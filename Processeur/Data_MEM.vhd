----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 08:35:26 AM
-- Design Name: 
-- Module Name: Data_MEM - Behavioral
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

entity Data_MEM is
Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0)
        );
end Data_MEM;
       
architecture Behavioral of Data_MEM is

type registers is array (255 downto 0) of STD_LOGIC_VECTOR (7 downto 0);
signal RAM: registers:= (others=>(others=>'0'));


begin
    
process(CLK)
    begin
        if (CLK='1') then 
            if RST = '0' then 
                RAM <=  (others=>(others=>'0'));
            else 
                if RW= '0' then
                    RAM(to_integer(unsigned(ADR))) <= INPUT;
                else
                    OUTPUT<= RAM(to_integer(unsigned(ADR))) ;
                end if;
            end if;
        end if;
 end process;
end Behavioral;
