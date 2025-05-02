----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 10:25:13 AM
-- Design Name: 
-- Module Name: pipe - Behavioral
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

entity pipe is
    Port ( CLK : in STD_LOGIC;
           OP : in STD_LOGIC_VECTOR (7 downto 0);
           DEST : in STD_LOGIC_VECTOR (7 downto 0);
           SRC1 : in STD_LOGIC_VECTOR (7 downto 0);
           SRC2 : in STD_LOGIC_VECTOR (7 downto 0));
end pipe;

architecture Behavioral of pipe is

begin


end Behavioral;
