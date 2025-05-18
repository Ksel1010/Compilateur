import argparse

ADD  = 1
MUL  = 2
SOU  = 3
DIV  = 4
COP  = 5
AFC  = 6
STR  = 7
LDR  = 8
JMP = 9
JMF = 10
INF = 11
INFE =  12 
SUP  = 13
SUPE =  14
EQU  = 15
NEQU =  16 
OR  = 17
AND  = 18 
NOT  = 20
XOR  = 21

PRI  = 19
NOP  = 00
CALL =  22
RET  = 23
PUSH =  24
POP  = 25

def traiter_instruction(code, dst, op1, op2):
    if code == ADD:
        return f"LDR R1 {op1} \nLDR R2 {op2} \nADD R0 R1 R2 \nSTR {dst} R0 0"
    elif code == MUL:
        return f"LDR R1 {op1} \nLDR R2 {op2} \nMUL R0 R1 R2 \nSTR {dst} R0 0"
    elif code == SOU:
        return f"LDR R1 {op1} \nLDR R2 {op2} \nSOU R0 R1 R2 \nSTR {dst} R0 0"
    elif code == DIV:
        return f"LDR R1 {op1} \nLDR R2 {op2} \nDIV R0 R1 R2 \nSTR {dst} R0 0"
    elif code == COP:
        return f"COP R{dst} R{op1} {op2}"
    elif code == AFC:
        return f"AFC R0 {op1} {op2} \nSTR {dst} R0"
    elif code == STR:
        return f"STR {dst} R{op1} {op2}"
    elif code == LDR:
        return f"LDR R{dst} {op1} {op2}"
    elif code == JMP:
        return f"JMP {dst} {op1} {op2}"
    elif code == JMF: # comme compilateur jmf dst=cond op1=line => cross compiler load la valeur de la condition
                      # puis JMF op1=line condition=R0 
        return f"LDR R0 {dst} 0 \nJMF R{op1} R0 0"
    elif code == INF:# inf a b 0 (compilateur)
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nINF R0 R1 R2 \nSTR {dst} R0 0"
    elif code == INFE:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nINFE R0 R1 R2 \nSTR {dst} R0 0"
    elif code == SUP:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nSUP R0 R1 R2 \nSTR {dst} R0 0"
    elif code == SUPE:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nSUPE R0 R1 R2 \nSTR {dst} R0 0"
    elif code == EQU:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nEQU R0 R1 R2 \nSTR {dst} R0 0"
    elif code == NEQU:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nNEQU R0 R1 R2 \nSTR {dst} R0 0"
    elif code == OR:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nOR R0 R1 R2 \nSTR {dst} R0 0"
    elif code == AND:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nAND R0 R1 R2 \nSTR {dst} R0 0"
    elif code == NOT:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nNOT R0 R1 R2 \nSTR {dst} R0 0"
    elif code == XOR:
        return f"LDR R1 {dst} 0 \nLDR R2 {op1} 0\nXOR R0 R1 R2 \nSTR {dst} R0 0"
    elif code == PRI:
        return f"LDR R0 {dst} 0 \nPRI R0 0 0"
    elif code == NOP:
        return f"NOP 0 0 0"
    elif code == CALL:#is actually a simple jump
        return f"CALL {dst}"
    elif code == RET:
        return f"RET {dst} {op1} {op2}"
    elif code == PUSH:
        return f"PUSH {dst} {op1} {op2}"
    elif code == POP:
        return f"POP {dst} {op1} {op2}"
    else:
        return f"INSTR inconnu: {code} {dst} {op1} {op2}"


def lire_et_traiter_fichier(entree_path, sortie_path):
    with open(entree_path, "r") as fichier_entree, open(sortie_path, "w") as fichier_sortie:
        for ligne in fichier_entree:
            ligne = ligne.strip()
            if not ligne:
                continue
            try:
                code, op1, op2, op3 = map(int, ligne.split())
                resultat = traiter_instruction(code, op1, op2, op3)
                fichier_sortie.write(resultat + "\n\n")
            except ValueError:
                fichier_sortie.write(f"Erreur de parsing sur la ligne : {ligne}\n")

parser = argparse.ArgumentParser(description="Traite un fichier d'instructions.")
    
parser.add_argument('--input', '-i', default='./target/output.o',
                        help='Fichier d\'entrée (par défaut: output.o)')
    
parser.add_argument('--output', '-o', default='./crossCompiled/output_CC.txt',
                        help='Fichier de sortie (par défaut: ./crossCompiled/output_CC.txt)')
    
args = parser.parse_args()
lire_et_traiter_fichier(args.input, args.output)
