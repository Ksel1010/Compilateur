#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asm.h"

Asm*  ASM_init(){
    Asm* asmT = (Asm*) malloc(sizeof(Asm));
    asmT->first = NULL;
    asmT->last = NULL;
    return asmT;
}

Instruction* ASM_next(Asm* asmT){
    Instruction* inst = asmT->first;
    asmT->first = inst->next;
    return inst;
}

Instruction* ASM_add(Asm* asmT, char operation , int dst, int src1, int src2){
    Instruction* inst = (Instruction*) malloc(sizeof(Instruction));
    inst -> op = operation;
    inst -> addDst = dst;
    inst -> addSrc1 = src1;
    inst -> addSrc2 = src2;
    inst -> next = NULL;
    if(asmT->first == asmT->last){
        if (asmT->first == NULL){
            // table des instructions vide
            asmT -> first = inst;
            asmT -> last = inst;
        }
        else{
            // table des instructions contient une unique instruction
            asmT -> first -> next = inst;
            asmT -> last = inst;
        }
    }
    else{
        asmT -> last = inst;
    }
    Asm* in;
    Instruction* instr = in->first;
    while(instr!=NULL){
        printf("regle: %c %d %d %d \n",instr->op, inst->addDst, inst->addSrc1 , inst->addSrc2);
        instr = ASM_next(in);
    }
    return inst;
}