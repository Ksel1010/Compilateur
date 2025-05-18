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
--arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipeline is
    Port ( RST : in STD_LOGIC;
    CLK : in STD_LOGIC;
    OUTPUT : out std_logic_vector(7 downto 0));

end pipeline;

architecture Behavioral of pipeline is

component Instr_MEM is
    Port ( ADR : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           JMP_FALSE_FLAG : in STD_LOGIC;
           DI_OP : in std_logic_vector (7 downto 0);
           DI_DST : in std_logic_vector (7 downto 0);
           EX_OP : in std_logic_vector (7 downto 0);
           EX_DST : in std_logic_vector (7 downto 0);
           MEM_OP : in std_logic_vector (7 downto 0);
           MEM_DST : in std_logic_vector (7 downto 0);
           RE_OP : in std_logic_vector (7 downto 0);
           RE_DST : in std_logic_vector (7 downto 0);
           ALEA: out STD_LOGIC :='0';
           OUTPUT : out STD_LOGIC_VECTOR (31 downto 0):=(others=>'0'));
end component Instr_MEM;

component pipe is
    Port ( CLK : in STD_LOGIC;
           RST: in STD_LOGIC;
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

component sync_mem is
Port (CLK : in STD_LOGIC;
           OP_IN : in STD_LOGIC_VECTOR (7 downto 0);
           DEST_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC1_IN : in STD_LOGIC_VECTOR (7 downto 0);
           SRC2_IN : in STD_LOGIC_VECTOR (7 downto 0);
           OP_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DEST_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC1_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           SRC2_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component sync_mem;


signal IP : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ;
signal IP_unsigned : unsigned(7 downto 0):= (others => '0');

signal OUTPUT_PRINT: STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ;

signal signal_alea : std_logic:='0';
signal test : std_logic :='0';

signal signal_out_mem_instr: STD_LOGIC_VECTOR (31 downto 0) := (others=>'0') ; -- signal de sortie de la memoire d'instruction

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
signal RE_SRC2 : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0') ; -- signal B entre MEMRE et le retour => source 1

signal MEM_OUT: STD_LOGIC_VECTOR (7 downto 0);

--signal signal_sync_op: STD_LOGIC_VECTOR (7 downto 0);
--signal signal_sync_dest : STD_LOGIC_VECTOR (7 downto 0);
--signal signal_sync_src : STD_LOGIC_VECTOR (7 downto 0);

signal S_ALU: STD_LOGIC_VECTOR (7 downto 0);

signal QA_signal: STD_LOGIC_VECTOR (7 downto 0);
signal QB_signal: STD_LOGIC_VECTOR (7 downto 0);

signal MUX_BDR: STD_LOGIC_VECTOR (7 downto 0);
signal MUX_BDR_PRINT: STD_LOGIC_VECTOR (3 downto 0);
signal MUX_ALU: STD_LOGIC_VECTOR (7 downto 0);
signal MUX_RE_LOAD: STD_LOGIC_VECTOR (7 downto 0);
signal MUX_MEM_STR: STD_LOGIC_VECTOR (7 downto 0);

signal LC_RE : STD_LOGIC;
signal LC_EX : STD_LOGIC_VECTOR (2 downto 0);
signal LC_MEM : STD_LOGIC;

signal Z_FLAG : STD_LOGIC := '0';
signal JMP_FALSE_FLAG: std_logic :='0';

begin

mem_inst : Instr_MEM port map(
ADR=>IP,
CLK=>CLK,
JMP_FALSE_FLAG=>JMP_FALSE_FLAG,
DI_OP => DI_OP,
DI_DST => DI_DST,
EX_OP => EX_OP,
EX_DST => EX_DST,
MEM_OP => MEM_OP,
MEM_DST => MEM_DST,
RE_OP => RE_OP,
RE_DST => RE_DST,
ALEA=> signal_alea,
OUTPUT=>signal_out_mem_instr
);

li_di : pipe port map(
CLK=>CLK,
RST=> JMP_FALSE_FLAG,
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

A => MUX_BDR_PRINT,
B => DI_src2 (3 downto 0),
RST =>RST,
CLK =>CLK,
Wb => RE_DST(3 downto 0),
W => LC_RE,
DATA=> MUX_RE_LOAD,
QA=> QA_signal,
QB=> QB_signal
); 

di_ex : pipe port map(
CLK=>CLK,
RST => JMP_FALSE_FLAG,
OP_IN => DI_OP,
DEST_IN  =>DI_DST,
SRC1_IN  =>MUX_BDR,
SRC2_IN  =>QB_signal,
OP_OUT=>EX_OP,
DEST_OUT =>EX_DST,
SRC1_OUT =>EX_SRC1,
SRC2_OUT =>EX_SRC2
);

ual:ALU port map(
A=> EX_src1,
B=> EX_src2,
Ctrl_Alu =>LC_EX,
Z => Z_FLAG,
S=> S_ALU
);

ex_mem: pipe port map(
CLK=>CLK,
RST=> '0',
OP_IN => EX_OP,
DEST_IN  =>EX_DST,
SRC1_IN  =>MUX_ALU,
SRC2_IN  =>EX_SRC2,
OP_OUT=>MEM_OP,
DEST_OUT =>MEM_DST,
SRC1_OUT =>MEM_SRC1
);

data : Data_MEM port map(
CLK=>CLK,
ADR => MUX_MEM_STR, 
INPUT => MEM_src1,
RW => LC_MEM,
RST => RST,
OUTPUT => MEM_OUT
);


mem_re : sync_mem port map(
CLK=>CLK,
OP_IN => MEM_OP,
DEST_IN  =>MEM_DST,
SRC1_IN  =>MEM_OUT,
SRC2_IN => MEM_SRC1,
OP_OUT=>RE_OP,
DEST_OUT =>RE_DST,
SRC1_OUT =>RE_SRC1,
SRC2_OUT =>RE_SRC2
);

IP <= std_logic_vector(IP_unsigned);

process (CLK)
begin

    if (RST = '0') then
        IP_unsigned <=(others => '0'); 
    elsif (CLK = '0' and CLK'event) then
        if (signal_out_mem_instr(31 downto 24)= x"09") then --JMP
             IP_unsigned<= unsigned(signal_out_mem_instr(23 downto 16)); --saut a l'@
        elsif JMP_FALSE_FLAG = '1' then  --JMF and zero flag up 
                     test <= NOT(test);
                     IP_unsigned <= unsigned(EX_DST);
        else
            if (signal_alea = '0') then 
                IP_unsigned <= unsigned(IP) + 1; --si pas d'alea de données j'icrémente sinon je n'incrémente pas
            end if;
        end if;
    end if;

end process;

JMP_FALSE_FLAG <='1' when Z_FLAG = '1' and EX_OP = x"0a" else '0';


LC_RE <= '0' when (RE_OP=x"00" or RE_OP=x"07" or  (RE_OP>x"08"  and RE_OP/=x"09")) else '1';-- 1 ecriture : je necris pas si j'ai un str 7 ou print 8

LC_EX <= "000" when EX_op > x"03" else EX_op (2 downto 0);

LC_MEM <= '0' when MEM_OP = x"07" else '1'; --0 jecris et 1 je lis

MUX_BDR_PRINT <= DI_DST(3 downto 0) when DI_OP = x"13" else DI_SRC1 (3 downto 0);

MUX_BDR <= QA_signal when DI_OP <= x"05" or DI_OP = x"07" or DI_OP = x"13" or DI_OP = x"0a" else DI_src1; -- COP operation or JMF

MUX_ALU <= S_ALU when (EX_OP = x"01" or EX_OP = x"02" or EX_OP = x"03")  else EX_src1; -- add mul, sou

MUX_RE_LOAD <= RE_SRC1 when RE_OP =x"08"  else RE_SRC2;

MUX_MEM_STR <= MEM_DST when MEM_OP=x"07" or MEM_OP= x"13" else MEM_src1; -- je recupere la data dans un ldr et un print 

OUTPUT_PRINT <= MUX_RE_LOAD when RE_OP =x"13" ;  -- si j'ai instruction print je la sors

OUTPUT<= OUTPUT_PRINT;

        


end Behavioral;
