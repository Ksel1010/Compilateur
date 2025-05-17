----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2025 06:40:36 PM
-- Design Name: 
-- Module Name: sync_mem - Behavioral
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

entity sync_mem is
    Port ( CLK : in STD_LOGIC;
           OP_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DEST_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC1_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC2_IN : in STD_LOGIC_VECTOR (7 downto 0);
           OP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DEST_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC1_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC2_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end sync_mem;


architecture Behavioral of sync_mem is

    signal OP_signal: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal DEST_signal: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal SRC1_signal: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal SRC2_signal: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin

SRC1_signal <= SRC1_IN;
SRC1_OUT <= SRC1_signal;

OP_signal<=OP_IN;
DEST_signal<=DEST_IN;
SRC2_signal<=SRC2_IN;

process (CLK)
begin
if CLK='1' then 
OP_OUT <= OP_signal;
DEST_OUT <= DEST_signal;
SRC2_OUT <= SRC2_signal;
end if;
end process;

end Behavioral;
