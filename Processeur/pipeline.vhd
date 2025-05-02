----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2025 10:08:25 AM
-- Design Name: 
-- Module Name: pipeline - Behavioral
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

entity pipeline is
    Port ( RST : in STD_LOGIC;
    CLK : in STD_LOGIC);

end pipeline;

architecture Behavioral of pipeline is

component Instr_MEM is
    Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (32 downto 0));
end component Instr_MEM;

component pipe is
    Port ( CLK : in STD_LOGIC;
           OP_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DEST_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC1_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC2_IN : in STD_LOGIC_VECTOR (7 downto 0);
           OP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DEST_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC1_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC2_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component pipe;


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



component ALU is
     Port ( Ctrl_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC);
end component ALU;



component Data_MEM is
Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0)
        );
end component Data_MEM;

signal signal_out_mem_instr: STD_LOGIC_VECTOR (31 downto 0) := (others=>'0') ; -- signal de sortie de la memoire d'instruction
signal IP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- pointeur d'instruction

signal DI_DST : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal A entre LIDI et DIEX => signal de destination
signal DI_OP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal OP entre LIDI et DIEX => operande
signal DI_SRC1 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal B entre LIDI et DIEX => source 1
signal DI_SRC2 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal C entre LIDI et DIEX => source2

signal EX_DST : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal A entre DIEX et EXMEM => signal de destination
signal EX_OP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal OP entre DIEX et EXMEM => operande
signal EX_SRC1 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal B entre DIEX et EXMEM => source 1
signal EX_SRC2 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal C entre DIEX et EXMEM => source2

signal MEM_DST : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal A entre EXMEM et MEMRE => signal de destination
signal MEM_OP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal OP entre EXMEM et MEMRE => operande
signal MEM_SRC1 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal B entre EXMEM et MEMRE => source 1

signal RE_DST : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal A entre MEMRE et le retour => signal de destination
signal RE_OP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal OP entre MEMRE et le retour => operande
signal RE_SRC1 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal B entre MEMRE et le retour => source 1




begin

mem_inst : Instr_MEM port map(
ADR=>IP,
CLK=>CLK,
OUTPUT=>signal_out_mem_instr
);

li_di : pipe port map(
CLK=>CLK,
OP_IN => signal_out_mem_instr(31 downto 24),
DEST_IN  =>signal_out_mem_instr(23 downto 16),
SRC1_IN  =>signal_out_mem_instr(15 downto 8),
SRC2_IN  =>signal_out_mem_instr(7 downto 0),
OP_OUT=>DI_OP,
DEST_OUT =>DI_DST,
SRC1_OUT =>DI_SRC1,
SRC2_OUT =>DI_SRC2
);

banc_de_registres : banc_registres port map(

A =>(others=>'0'),
B => (others=>'0'),
RST =>'0',
CLK =>CLK,
Wb => RE_DST(3 downto 0),
W => '0',  --- to link with LC
DATA=> RE_SRC1
--QA=>
--QB=>
); 

di_ex : pipe port map(
CLK=>CLK,
OP_IN => DI_OP,
DEST_IN  =>DI_DST,
SRC1_IN  =>DI_SRC1,
SRC2_IN  =>DI_SRC2,
OP_OUT=>EX_DST,
DEST_OUT =>EX_DST,
SRC1_OUT =>EX_SRC1,
SRC2_OUT =>EX_SRC2
);

ual:ALU port map(
);

data_mem : Data_MEM port map(

);

process (CLK)
    begin
    if (CLK='1') then 

    end if;
    end process;


process (CLK)
    begin
    end process;
    
process (CLK)
    begin
    end process;
    
    
process (CLK)
    begin
    end process;
        
        
process (CLK)
    begin
    end process;    




end Behavioral;
