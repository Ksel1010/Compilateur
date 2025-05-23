#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asm.h"


int len = 0;

Asm*  ASM_init(){
    Asm* asmT = (Asm*) malloc(sizeof(Asm));
    asmT->first = NULL;
    asmT->last = NULL;
    return asmT;
}

Instruction* ASM_next(Asm* asmT){
    if(asmT-> first == NULL){
        return NULL;
    }
    Instruction* inst = asmT->first;
    asmT->first = inst->next;
    if (asmT->first == NULL) {
        asmT->last = NULL;
    }
    return inst;
}

Instruction* ASM_add(Asm* asmT, char operation , int dst, int src1, int src2){
    Instruction* inst = (Instruction*) malloc(sizeof(Instruction));
    inst -> op = operation;
    inst -> addDst = dst;
    inst -> addSrc1 = src1;
    inst -> addSrc2 = src2;
    inst -> indice = len;
    inst -> next = NULL;
    if(asmT->first == NULL){
        // table des instructions vide
        asmT -> first = inst;
        asmT -> last = inst;
    }
    else{
        asmT -> last -> next = inst;
        asmT -> last = inst;
    }
    Asm* in = asmT;
    len ++;
    return inst;
}


void ASM_print(Asm* asmT, char* destination){
    int i = 0;
    FILE * file = fopen(destination, "w");
    if (file == NULL) {
       perror("Error opening file");
       exit(1);
   }
    while(asmT->first != NULL){
        Instruction* inst = asmT->first;
        fprintf(file,"%d %d %d %d\n", inst->op, inst->addDst, inst->addSrc1, inst->addSrc2);
        ASM_next(asmT);
        i++;
    }
    fclose(file);
}


Instruction* ASM_get(Asm* asmT, int index){
    Instruction* inst = asmT->first;
    while(inst != NULL && inst->indice != index){
        inst = inst->next;
    }
    return inst;
}
void ASM_freeAll(Asm* asmT) {
    if (asmT == NULL) {
        return;
    }
    
    Instruction* current = asmT->first;
    while (current != NULL) {
        Instruction* next = current->next;
        free(current);
        current = next;
    }
    
    free(asmT);
}
