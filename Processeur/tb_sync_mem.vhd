----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2025 07:37:22 PM
-- Design Name: 
-- Module Name: tb_sync_mem - Behavioral
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



entity tb_sync_mem is
end tb_sync_mem;

architecture behavior of tb_sync_mem is

    -- Component Declaration for the Unit Under Test (UUT)
    component sync_mem
        Port ( 
            CLK : in STD_LOGIC;
            IN_DEST : in STD_LOGIC_VECTOR (7 downto 0);
            IN_OP : in STD_LOGIC_VECTOR (7 downto 0);
            IN_SRC1 : in STD_LOGIC_VECTOR (7 downto 0);
            OUT_OP : out STD_LOGIC_VECTOR (7 downto 0);
            OUT_SRC1 : out STD_LOGIC_VECTOR (7 downto 0);
            OUT_DEST : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Testbench signals
    signal CLK : STD_LOGIC := '0';
    signal IN_DEST : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IN_OP : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal IN_SRC1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal OUT_SRC1 : STD_LOGIC_VECTOR (7 downto 0);
    signal OUT_OP : STD_LOGIC_VECTOR (7 downto 0);
    signal OUT_DEST : STD_LOGIC_VECTOR (7 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 50 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: sync_mem port map (
        CLK => CLK,
        IN_DEST => IN_DEST,
        IN_OP => IN_OP,
        IN_SRC1 => IN_SRC1,
        OUT_SRC1 => OUT_SRC1,
        OUT_OP => OUT_OP,
        OUT_DEST => OUT_DEST
    );

    -- Clock process to generate clock signal
process
begin
CLK <= not(CLK);
wait for CLK_PERIOD/2;
end process;

    -- Stimulus process to apply test vectors
    stim_proc: process
    begin
        -- Test case 1: IN_OP != x"7" and IN_OP != x"8"
        IN_OP <= x"01";  -- Some value other than x"7" or x"8"
        IN_DEST <= x"10"; -- Random value
        wait for 2 * CLK_PERIOD; -- Wait for two clock cycles
        
        -- Test case 2: IN_OP = x"7" (wait for rising edge)
        IN_OP <= x"07";
        IN_DEST <= x"20"; -- Random value
        wait for 5 * CLK_PERIOD; -- Ensure we wait for rising edge of clock
        
        -- Test case 3: IN_OP = x"8" (wait for rising edge)
        IN_OP <= x"08";
        IN_DEST <= x"30"; -- Random value
        wait for 5 * CLK_PERIOD; -- Ensure we wait for rising edge of clock

        -- Test case 4: IN_OP != x"7" and IN_OP != x"8"
        IN_OP <= x"01";  -- Some value other than x"7" or x"8"
        IN_DEST <= x"40"; -- Random value
        wait for 2 * CLK_PERIOD; -- Wait for two clock cycles

        -- End of test
        wait;
    end process;

end behavior;