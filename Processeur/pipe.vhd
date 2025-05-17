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
           RST : in STD_LOGIC:='0';
           OP_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DEST_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC1_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC2_IN : in STD_LOGIC_VECTOR (7 downto 0);
           OP_OUT : out STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
           DEST_OUT : out STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
           SRC1_OUT : out STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
           SRC2_OUT : out STD_LOGIC_VECTOR (7 downto 0):=(others=>'0')
           );
end pipe;

architecture Behavioral of pipe is

begin
process (CLK)
begin
if CLK='1' and RST = '0' then 
OP_OUT <= OP_IN;
DEST_OUT <= DEST_IN;
SRC1_OUT <= SRC1_IN;
SRC2_OUT <= SRC2_IN;
elsif CLK='1' and RST = '1' then 
OP_OUT <= (others=>'0');
DEST_OUT <= (others=>'0');
SRC1_OUT <= (others=>'0');
SRC2_OUT <= (others=>'0');
end if;
end process;

end Behavioral;
