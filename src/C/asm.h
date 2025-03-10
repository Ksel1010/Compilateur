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
#define INf 9 // inferieur
#define SUP 10 // superieur
#define EQU 11 // equal
#define PRI 12 // print


typedef struct Instruction 
{
    char op;
    int addDst; 
    int addSrc1;
    int addSrc2;
    struct Instruction* next;
} Instruction;

typedef struct Asm
{
    Instruction* first;
    Instruction* last;
}Asm ;

Asm*  ASM_init();

Instruction* ASM_add(Asm* asmT, char operation , int dst, int src1, int src2);

#endif