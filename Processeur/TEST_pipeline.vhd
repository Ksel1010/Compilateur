----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2025 09:34:35 AM
-- Design Name: 
-- Module Name: TEST_pipeline - Behavioral
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

entity TEST_pipeline is
--  Port ( );
end TEST_pipeline;

architecture Behavioral of TEST_pipeline is
component pipeline
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           OUTPUT : out std_logic_vector(7 downto 0));
end component;

signal CLK : std_logic:='0';
signal RST : std_logic;

constant Clock_period : time := 50 ns;
begin

uut : pipeline port map(
    CLK=>CLK,
    RST=>RST
);

process
begin
CLK <= not(CLK);
wait for Clock_period/2;
end process;


process
begin

--RST <= '1';
--INS <= x"00";
--wait for 200 ns;
RST <= '1';
wait;


end process;




end Behavioral;
