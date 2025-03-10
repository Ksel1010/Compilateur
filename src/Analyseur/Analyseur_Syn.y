%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "src/C/ts.h"
#include "src/C/asm.h"



TS * ts;
Asm* asmT;

/* Déclarations des fonctions */
int yylex(void);
void yyerror(const char *s);

%}


%union {
     int nb;
     char id[30];
}

/* to do : GESTION tID !!!!
          - add printf avec 1 seul argument (voir la doc)
          -add AND XOR OR 
          -Instruction switchcase*/
%token tWHILE tIF tELSE tCASE tSWITCH tFOR tRETURN tDEFAULT // Mots clés
%token tVOID tINT tLONG tCHAR tFLOAT tCONST tMAIN // Types
%token tSOE tGOE tDIF tST tGT tDEQ tL_AND tL_OR // Opérateurs logiques
%token tSLASH tSTAR tMINUS tPLUS tEQ tAND tNOT tOR tXOR// Operateurs sur nombre
%token tUNDER tCOMMA tSOB tSCB tOB tCB tSEM tOP tCP tCOLON //Ponctuations
%token tERROR tPRINTF
%token <id> tID
%token <nb> tNB 

%type <id> AffIDRec AffID


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
Body : tOB IRec tCB;

IRec : I 
     | I IRec;

I : //IfElse
//     | While
//     | For 
//     | SwitchCase
      Declaration 
     | Affectation 
     | tRETURN Operation tSEM ;

/*Pour les conditions ( if while etc...)*/


/*
Condition : Condition tGT Condition 
          | Condition tST Condition 
          | Condition tSOE Condition 
          | Condition tGOE Condition 
          | Condition tDIF Condition 
          | Condition tDEQ Condition 
          | Condition tL_AND Condition 
          | Condition tL_OR Condition 
          | tNOT Condition
          | Condition tXOR Condition 
          | tOP Condition tCP           
          | Operation;
*/


/*Operation*/ 
// Pour le moment focus sur les int avec mult add et soust plus tard ajouter char (concatenation...) float etc...
// Si on complete on devrait créer un autre nom pour les type sur lesquelles on apllique des opperation pour pas les melanger avec void etc...



Operation : Operation tPLUS Operation {}
          | Operation tMINUS Operation 
          | Operation tSTAR Operation 
          | Operation tSLASH Operation 
          | tOP Operation tCP
          | tID
  /*             {
               printf("%s\n", $1);
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp);
               TS* sous_ts = TS_exist(ts, $1);
               if (index!=NULL){
                    ASM_add(asmT, COP, ts->indice, sous_ts->indice, 0);
               }
               }*/
          | tNB 
               {
               printf("%d\n", $1);
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp);
               ASM_add(asmT, AFC, ts->indice, $1,0);
               }

/* Declaration et Affection */
Declaration : {printf("declaration: \n");}Type  DecIDRec tSEM ;

DecIDRec : DecID
          | DecID tCOMMA{printf(",\n");} DecIDRec;

DecID : tID {Symbol s = {"",1,TYPE_INT};
           strcpy(s.name, $1); 
           ts=TS_push(ts, s);
           printf("%s = ", $1);
           } 
           tEQ Operation {
               //printf("Declaration ID %s \n", $1);
               TS* sous_ts = TS_exist(ts, $1);
               if(sous_ts!= NULL){
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    TS_pop(ts);
               }
           }
     | tID {
           Symbol s = {"",0,TYPE_INT};
           printf("%s \n", $1);
           strcpy(s.name, $1);
           ts=TS_push(ts, s);
          }
           ;



Affectation : AffIDRec tSEM 
          {
               //printf("affectation %s \n", $1);
               TS* sous_ts = TS_exist(ts, $1);
               if(sous_ts!= NULL){
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    TS_pop(ts);
               }
          };

AffIDRec : AffID 
          |AffID tCOMMA  
          {
          //printf("affectation IDREC-2 %s \n", $1);
          TS * sous_ts = TS_exist(ts, $1);
          if(sous_ts != NULL){
               ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
               TS_pop(ts);
          }
          } AffIDRec;

AffID : tID
         { 
          //printf("affectation ID %s \n", $1);
          Symbol s = {"",0,TYPE_INT};
          strcpy(s.name, $1); 
          printf("$1 : %s\n", $1);
          TS * sous_ts = TS_exist(ts, s.name);
          TS_print(ts);
          if(sous_ts != NULL){
               sous_ts->symbol.state = 1;

          }
          else{
               printf("Variable %s non déclarée", $1);
               return 1;
          } 
          }
          tEQ Operation
          ;


/*=============Fonction=============*/

//Fonction : Type  tID  tOP ArgRec tCP Body;

ArgRec : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*=============If et Switch=============*/

/*IfElse : tIF tOP Condition tCP Body 
     | tIF tOP Condition tCP Body tELSE Body;
*/
//TODO SWITCH CASE


//While : tWHILE tOP Condition tCP Body;

//Une boucle for c'est : for (affectation ou declaration, condition d'arret, incrementation)
//ici je prefere utilise la regle operation plutot que d'en créer une juste pour les incremation ( du genre a = a*2 / a = a+1 / a++ etc...)
//For : tFOR tOP Affectation Condition tSEM Operation tCP Body
//    | tFOR tOP Declaration Condition tSEM Operation tCP Body
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
     return yyparse();
}


void yyerror(const char *s)
{
     fprintf(stderr, "%s\n", s);
}



