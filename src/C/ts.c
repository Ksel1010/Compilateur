#include "ts.h"

/* declaration d'un symbol */

void TS_print(TS *ts) {
    printf("TS:\n");
    while (ts) {
         printf(">> '%s' @%d\n", ts->symbol.name, ts->indice);
         ts = ts->next;
    }
}

TS * TS_init(){
    return NULL;
}

Symbol pop(TS * ts){
    Symbol symbol = ts->symbol;
    ts = ts->next;
    return symbol;
}

TS * TS_push(TS * ts, Symbol symbol){
    printf("add: %s\n", symbol.name);
    TS * newTS = (TS *) malloc(sizeof(TS));
    newTS->symbol = symbol;
    newTS->next = ts;
    if (ts) newTS->indice = ts->indice + 1;
    else newTS->indice = 0;
    return newTS;
}

Symbol*  TS_exist(TS * ts, char name[TAILLE]){
    TS * current = ts;
    while(current != NULL){
         if(strcmp(current->symbol.name, name) == 0){
              return &(current->symbol);
         }
         current = current->next;
    }
    return NULL;
}

