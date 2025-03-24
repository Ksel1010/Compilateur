#ifndef TS_H
#define TS_H

#include <stdio.h>
#include <stdlib.h>
#define TAILLE 30

typedef enum {
    TYPE_INT,
    TYPE_VOID,
} VarType;

typedef struct Symbol {
    char name[TAILLE];  
    int state; // 0 = non initialisé, 1 = initialisé   
    VarType type; 
} Symbol;

/* declaration de la pile qui contient les symboles*/
typedef struct TS { //Table des symboles
     Symbol symbol;
     struct TS* next;
     int indice;
     int depth;
     
} TS;

/* fonctions faisable sur la TS */
TS * TS_init();

Symbol TS_pop(TS * ts);

void TS_print(TS * ts);

TS * TS_push(TS * TS, Symbol symbol, int depth);

TS*  TS_exist(TS * TS, char name[TAILLE]);

TS* TS_context_cleanup(TS * ts);

#endif