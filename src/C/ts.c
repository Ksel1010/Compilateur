#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"

/* declaration d'un symbol */



void TS_print(TS *ts) {
    printf("TS:\n");
    while (ts) {
         printf(">> '%s' @%d \t depth: %d\n", ts->symbol.name, ts->indice, ts->depth);
         ts = ts->next;
    }
}

TS * TS_init(){
    return NULL;
}

Symbol TS_pop(TS * ts){
    Symbol symbol = ts->symbol;
    *ts = *ts->next;
    //Free
    
    return symbol;
}

TS * TS_push(TS * ts, Symbol symbol, int depth){
    printf("push: %s\n", symbol.name);
    TS * newTS = (TS *) malloc(sizeof(TS));
    newTS->symbol = symbol;
    newTS->next = ts;
    if (ts != NULL){
        newTS->indice = ts->indice + 1;
    }
    else{
        newTS->indice = 0;
    }
    newTS->depth = depth;
    TS_print(newTS);
    return newTS;
}

TS*  TS_exist(TS * ts, char name[TAILLE]){
    TS * current = ts;
    while(current != NULL){
         if(strcmp(current->symbol.name, name) == 0){
              return current;
         }
         current = current->next;
    }
    return NULL;
}

TS* TS_context_cleanup(TS * ts, int depth){
    printf("clean depth %d\n", depth);
    TS * current = ts;
    TS_print(current);
    if (depth != 0){
        while(current->depth > depth){
            TS_print(current);
            while(current->depth > depth){
            TS_print(current);
            TS_pop(current);
            }
        }
        printf("fin clean ts : \n");
        TS_print(current);
        return current;
    }else{
        printf("vidage  clean ts : \n");
        return NULL;
    }
   
}