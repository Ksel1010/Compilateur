#ifndef ASM_H
#define ASM_H

#define ADD 1 // +
#define MUL 2 // *
#define SOU 3 // -
#define DIV 4 // /
#define COP 5 // copy
#define AFC 6 // affect 

#define JMP 7 // jump if inconditionnel
#define JMF 8 // jump if false

#define INF 9 // inferieur
#define INFE 10 // inferieur ou egal
#define SUP 11 // superieur
#define SUPE 12 // superieur ou egal
#define EQU 13 // equal
#define NEQU 14 // not equal
#define OR 15 // or
#define AND 16 // and
#define NOT 17 // not
#define XOR 18 // xor

#define PRI 19 // print

typedef struct Instruction 
{
    char op;
    int addDst; 
    int addSrc1;
    int addSrc2;
    int indice;
    struct Instruction* next;
} Instruction;

typedef struct Asm
{
    Instruction* first;
    Instruction* last;
}Asm ;

Asm*  ASM_init();
void ASM_print(Asm* asmT);
Instruction* ASM_add(Asm* asmT, char operation , int dst, int src1, int src2);
Instruction* ASM_get(Asm* asmT, int indice);

#endif