#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "functions.h"


FuncT* FT_init(){
    FuncT* funcT = malloc(sizeof(FuncT));
    funcT->main = -1;
    funcT->first = NULL;
    funcT->last = NULL;
}

void FT_main(FuncT* funcT, int ligne){
    if (funcT->main==-1){
        funcT->main = ligne;
    }
    else{
        printf(ANSI_COLOR_RED "la fonction main a été déclarée plusieurs fois\n" ANSI_RESET_ALL);
        exit (1);
    }
}

void FT_push(FuncT* funcT, char id[30], int ligne){
    Function* func = malloc(sizeof(Function));
    strcpy(func->id, id);
    func->ligne = ligne;
    func->next = NULL;
    if (funcT-> first == NULL && funcT->last == NULL){
        funcT->first = func;
    }else{
        funcT->last->next = func;
    }
        funcT->last = func;
}


int FT_get(FuncT* funcT, char id[]){
    Function* func = funcT->first;
    while(func!=NULL){
        if (strcmp(func->id, id)==0){
            return func->ligne;
        }
        func = func->next;
    }
    return -1;
}
void FT_freeAll(FuncT* funcT){
    Function* func = funcT->first;
    Function* funcNext;
    while(func!=NULL){
        funcNext = func->next;
        free(func);
        func = funcNext;
    }
    free(funcT);
}
void FT_print(FuncT* funcT){
    Function* func = funcT->first;
    while(func!=NULL){
        printf("Function : %s, at %d\n", func->id, func->ligne);
        func= func->next;
    }
}