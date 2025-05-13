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
           IN_DEST : in STD_LOGIC_VECTOR (7 downto 0);
           IN_OP : in STD_LOGIC_VECTOR (7 downto 0);
           OUT_OP : out STD_LOGIC_VECTOR (0 downto 0);
           OUT_DEST : out STD_LOGIC_VECTOR (7 downto 0));
end sync_mem;

architecture Behavioral of sync_mem is

signal OP_signal:  STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
signal DEST_signal:  STD_LOGIC_VECTOR (7 downto 0)  := (others=>'0');

begin

OP_signal <= IN_OP;
DEST_signal <= IN_DEST;

process
begin
    if IN_OP /= x"7" and IN_OP /= x"8" then
        OUT_DEST <= DEST_signal;
        OUT_OP <= OP_signal;
    else
        wait until rising_edge(CLK);  
        OUT_DEST <= DEST_signal;
        OUT_OP <= OP_signal;
    end if;

end process;




end Behavioral;
