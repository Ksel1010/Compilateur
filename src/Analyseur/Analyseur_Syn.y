
%{   
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "src/C/ts.h"
#include "src/C/asm.h"
#include "y.tab.h"


#define ANSI_COLOR_RED          "\x1b[31m"
#define ANSI_RESET_ALL          "\x1b[0m"




TS * ts;
Asm* asmT;
int depth = 0;

/* Déclarations des fonctions */
int yylex(void);
void yyerror(const char *s);

%}


%union {
     int nb;
     char id[30];
     void* instr;
}

/* to do : GESTION tID !!!!
          - add printf avec 1 seul argument (voir la doc)
          -add AND XOR OR 
          -Instruction switchcase*/
%token tWoElse
%token tCASE tSWITCH tRETURN tDEFAULT // Mots clés
%token tVOID tINT tLONG tCHAR tFLOAT tCONST tMAIN // Types
%token tSOE tGOE tDIF tST tGT tDEQ tL_AND tL_OR // Opérateurs logiques
%token tSLASH tSTAR tMINUS tPLUS tEQ tAND tNOT tOR tXOR// Operateurs sur nombre
%token tUNDER tCOMMA tSOB tSCB tOB tCB tSEM tOP tCP tCOLON //Ponctuations
%token tERROR tPRINTF
%token <id> tID
%token <nb> tNB 
%token <instr> tIF tELSE tWHILE tFOR

%type <id> AffIDRec AffID 
%type <nb> Operation
%type <instr> If OptElse

%left tWoElse
%left tELSE

/* Modification des priorités */
%left tOR tL_OR
%left tAND tL_AND
%left tXOR
%left tGT tST tSOE tGOE tDIF tDEQ
%left tPLUS tMINUS
%left tSTAR tSLASH
%right tNOT

%start Compilateur
%%

/*=============Élément à utiliser partout=============*/

Compilateur : tINT tMAIN tOP ArgRec tCP Body;
/*
Compilateur : FunctionRec Main;

Main : tINT tMAIN tOP ArgRec tCP Body;

FunctionRec : FunctionR
               | ;
FunctionR : Function
          | Function FunctionR;
Function : tINT tID tOP ArgRec tCP Body;

*/


Type : Type tSTAR
     | tINT 
     | tVOID
     | tLONG
     | tCHAR
     | tFLOAT
     | tCONST;
/*impression d'une valeur*/

//Impression : tPRINTF tOP tID tCP tSEM;


/*Corps d'une fonction/Instruction*/
Body : tOB 
          {
               depth ++;
          } 
IRec tCB
          {
               depth --;
               ts = TS_context_cleanup(ts, depth);
               
          };

IRec : I 
     | I IRec;

I :     
//     | SwitchCase
      Declaration 
     | Affectation 
     | If
     | While
     | For
     | tRETURN Operation tSEM ;

/*Pour les conditions ( if while etc...)*/



Operation : Operation tGT Operation 
               {
                    ASM_add(asmT, SUP, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tST Operation 
               {
                    ASM_add(asmT, INF, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tSOE Operation 
               {
                    ASM_add(asmT, SUPE, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tGOE Operation 
               {
                    ASM_add(asmT, INFE, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tDIF Operation
               {
                    ASM_add(asmT, NEQU, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tDEQ Operation 
               {
                    ASM_add(asmT, EQU, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tL_AND Operation 
               {
                    ASM_add(asmT, AND, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tL_OR Operation 
               {
                    ASM_add(asmT, OR, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | tNOT Operation
               {
                    ASM_add(asmT, NOT, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tXOR Operation 
               {
                    ASM_add(asmT, XOR, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          | Operation tPLUS Operation 
               {
                    ASM_add(asmT, ADD, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          | Operation tMINUS Operation 
               {
                    ASM_add(asmT, SOU, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          | Operation tSTAR Operation 
               {
                    ASM_add(asmT, MUL, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          | Operation tSLASH Operation 
               {
                    ASM_add(asmT, DIV, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          | tOP Operation tCP { $$ = $2 ; }
          | tID
          
             {
               printf("%s\n", $1);
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp, depth);
               TS* sous_ts = TS_exist(ts, $1);
               if (sous_ts!=NULL){
                    ASM_add(asmT, COP, ts->indice, sous_ts->indice, 0);
               }
               else{
                    printf(ANSI_COLOR_RED "Variable  \" %s \"  non déclarée" ANSI_RESET_ALL , $1);
                    return 1;
               }
               }
          | tNB 
               {
               printf("%d\n", $1);
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp, depth);
               ASM_add(asmT, AFC, ts->indice, $1,0);
               }
;



/*Operation*/ 
// Pour le moment focus sur les int avec mult add et soust plus tard ajouter char (concatenation...) float etc...
// Si on complete on devrait créer un autre nom pour les type sur lesquelles on apllique des opperation pour pas les melanger avec void etc...



/* Declaration et Affection */
Declaration : {printf("declaration: \n");}Type  DecIDRec tSEM ;

DecIDRec : DecID
          | DecID tCOMMA{printf(",\n");} DecIDRec;

DecID : tID {Symbol s = {"",1,TYPE_INT};
          
           strcpy(s.name, $1); 
           ts=TS_push(ts, s, depth);
           printf("%s = ", $1);
           }
           
            
     tEQ Operation 
           
           {
               printf("Debut operation \n");
               TS* sous_ts = TS_exist(ts, $1);
               if(sous_ts!= NULL){
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    Symbol s = TS_pop(ts);
               }
           }
     | tID {
           Symbol s = {"",0,TYPE_INT};
           printf("%s \n", $1);
           strcpy(s.name, $1);
           ts=TS_push(ts, s, depth);
          }
           ;



Affectation : AffIDRec tSEM 
          {
               printf("affectation %s \n", $1);
          };

AffIDRec : AffID 
          
          |AffID tCOMMA 
     /*     {
          printf("affectation IDREC-2 %s \n", $1);
          TS * sous_ts = TS_exist(ts, $1);
          if(sous_ts != NULL){
               ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
               TS_pop(ts);
          }
          //strcpy($$, $1);
          } */
          AffIDRec;
          

AffID : tID
         { 
          Symbol s = {"",0,TYPE_INT};
          strcpy(s.name, $1); 
          printf("$1 : %s\n", $1);
          TS * sous_ts = TS_exist(ts, s.name);
          TS_print(ts);
          if(sous_ts != NULL){
               sous_ts->symbol.state = 1;

          }
          else{
               printf(ANSI_COLOR_RED "Variable \" %s \" non déclarée \n" ANSI_RESET_ALL, $1);
               return 1;
          } 
          }
          tEQ Operation

          {
               TS * sous_ts = TS_exist(ts, $1);
               if(sous_ts != NULL){
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    Symbol s  = TS_pop(ts);
                    printf("symbol : %s\n", s.name);
               }
          }
          ;


/*=============Fonction=============*/

//Fonction : Type  tID  tOP ArgRec tCP Body;

ArgRec : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*=============If et Switch=============*/

If: tIF tOP Operation tCP 
               {
                    Instruction* ligne = ASM_add(asmT, JMF, ts->indice, -1, 0);
                    $1 = (void*)ligne;
                    TS_pop(ts);
               } 
          Body {
                    Instruction* inst = (Instruction*) $1;
                    inst->addSrc1 =  asmT->last->indice + 2;
                    
               }
               
          OptElse ;

OptElse : 
           tELSE 
          {   
               Instruction* ligne = ASM_add(asmT,JMP,-1, 0, 0) ;
               $1 = (void *)ligne ;
               //ligne->addSrc1 =  asmT->last->indice + 1;
          }
          Body
          {
               Instruction* ligne = (Instruction*)$1;
               ligne->addDst =  asmT->last->indice + 1;
          }

          |
          {
               ASM_add(asmT,NOP,0,0,0) ;
          }%prec tWoElse;

//TODO SWITCH CASE


While : tWHILE tOP {
     int ligne = asmT->last->indice + 1;
     $1 = (void*) &ligne;
}Operation tCP
          {
               Instruction* ligne = ASM_add(asmT, JMF, ts->indice, *((int*) $1), 0);
               $1 = (void*)ligne;
               TS_pop(ts);
          }
          Body
          {
               Instruction* ligne = (Instruction*)$1;
               ASM_add(asmT, JMP, ligne->addSrc1, 0, 0);
               ligne->addSrc1 =  asmT->last->indice +1;
          };

//Une boucle for c'est : for (affectation ou declaration, condition d'arret, incrementation)
// c soit on fait pop de asm pour enlever AFFID afin de la mettre apres le body soit on utilise des sauts de la maniere suivante:
/*
     1/AFF | dec 
     2/Op (ex: i<5)<--
 ----3/JMF           |
 | -------4/jmp      |
 | |  -->7/op(ex ++) |
 | |  | 8/jmp -------|
 | |--|-> 5/Body
 |    |------6/jmp
 |
 |---> fin du for

*/
//to do revoir le for
For : tFOR {
          printf("debut for\n");
     }
     tOP{
          depth ++;
     } Affectation //1/
     {
          printf("affectation for : \n");
          TS_print(ts);
     }
     Operation //2/
     {
          printf("ope1 for : ts = \n");
          TS_print(ts);
          printf("jmf \n");
          //3/
          Instruction* ligne = ASM_add(asmT, JMF, ts->indice  , asmT->last->indice, 0);
          $1 = (void*)ligne;
          ASM_add(asmT, JMP, asmT->last->indice + 7 , 0, 0);
     }
     tSEM AffID 
     {
          printf("affectation 2 for : ts = \n");
          TS_print(ts);
          ASM_add(asmT, JMP, asmT->last->indice - 8 , 0, 0);
     }   
     tCP Body {
          Instruction* ligne = (Instruction*)$1;
          ASM_add(asmT, JMP, asmT->last->indice - 6, 0, 0);
          ligne->addSrc1 =  asmT->last->indice +1;
          depth--;
          TS_context_cleanup(ts, depth);
          
     }
//    | tFOR tOP Affectation Condition tSEM Operation tCP Body
//     | tFOR tOP 




/*
Remarque :
     - Comment faire pour ajouter une regle pour les tableaux ? => tID tSOB tNB tSCB = tNB ou tOB (tNb tSC)* tCB
Question :
     - Est ce que c'est le role de l'analyseur syntaxique de detecter qu'une fonction autre que void doit avoir un return dans le body 
 ou ou est ce que c'est a l'analyseur semantique 
*/
%%
int main(void)
{
     ts = TS_init();
     asmT = ASM_init();
     yyparse();
     ASM_print(asmT);
     TS_print(ts);

     return 0;
}


void yyerror(const char *s)
{
     fprintf(stderr, "%s\n", s);
}



