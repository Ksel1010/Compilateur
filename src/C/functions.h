#ifndef FUNCTIONS_H
#define FUNCTIONS_H

#define ANSI_COLOR_RED          "\x1b[31m"
#define ANSI_RESET_ALL          "\x1b[0m"


typedef struct Function
{
    char id[30];
    int ligne;
    struct Function* next;
}Function;

typedef struct FuncT
{
    int main ;
    Function* first;
    Function* last;
}FuncT;

FuncT* FT_init();

void FT_main(FuncT* funcT, int ligne);

void FT_push(FuncT* funcT, char id[30], int ligne);

int FT_get(FuncT* FuncT, char id[]);

void FT_freeAll(FuncT* funcT);

void FT_print(FuncT* funcT);

#endif