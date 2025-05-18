#ifndef ASM_H
#define ASM_H

#define ADD 1 // +
#define MUL 2 // *
#define SOU 3 // -
#define DIV 4 // /
#define COP 5 // copy
#define AFC 6 // affect 
#define STR 7 // store used in the processor
#define LDR 8 // load register used in processor





#define JMP 9 // jump if inconditionnel
#define JMF 10 // jump if false

#define INF 11 // inferieur
#define INFE 12 // inferieur ou egal
#define SUP 13 // superieur
#define SUPE 14 // superieur ou egal
#define EQU 15 // equal
#define NEQU 16 // not equal
#define OR 17 // or
#define AND 18 // and
#define NOT 20 // not
#define XOR 21 // xor

#define PRI 19 // print

#define NOP 0 //operation vide nop

#define CALL 22
#define RET 23
#define PUSH 24
#define POP 25

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
void ASM_print(Asm* asmT, char* destination);
Instruction* ASM_add(Asm* asmT, char operation , int dst, int src1, int src2);
Instruction* ASM_get(Asm* asmT, int indice);
void ASM_freeAll(Asm* asmT) ;


#endif