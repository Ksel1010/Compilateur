
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

/* to do :
          - add printf avec 1 seul argument (voir la doc)
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

/*point de départ*/
%start Compilateur
%%

/*=============Élément à utiliser partout=============*/

// notre C simplifié sera composé que par des fonctions qui seront utilisés dans l'ordre de leur déclaration
Compilateur : Functions ;


/*=============Fonction=============*/

Functions : Function Functions     
          | ;


Function : Type tID tOP ArgRec tCP Body
          | tINT tMAIN tOP ArgRec tCP Body ;



Type : tINT 
     | tVOID
     | tLONG
     | tCHAR
     | tFLOAT
   //  | Type tSTAR  // to do : les pointeurs
     | tCONST
     ;


ArgRec : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*impression d'une valeur*/

//Impression : tPRINTF tOP tID tCP tSEM;


/*Corps d'une fonction/Instruction*/
Body : tOB 
          {
               //profondeur de la table des symboles permet d'effacer le contexte
               depth ++;
          } 
IRec tCB
          {
               depth --;
               //efacer le contexte
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



// operation + - * / < <= > >= != == && || ^ 
Operation : 
          //   A > B 
          Operation tGT Operation 
               {
                    ASM_add(asmT, SUP, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A < B
          | Operation tST Operation 
               {
                    ASM_add(asmT, INF, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A <= B
          | Operation tSOE Operation 
               {
                    ASM_add(asmT, SUPE, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A >= B
          | Operation tGOE Operation 
               {
                    ASM_add(asmT, INFE, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A != B
          | Operation tDIF Operation
               {
                    ASM_add(asmT, NEQU, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A == B
          | Operation tDEQ Operation 
               {
                    ASM_add(asmT, EQU, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A && B
          | Operation tL_AND Operation 
               {
                    ASM_add(asmT, AND, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A || B
          | Operation tL_OR Operation 
               {
                    ASM_add(asmT, OR, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // ! A
          | tNOT Operation
               {
                    ASM_add(asmT, NOT, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A ^ B
          | Operation tXOR Operation 
               {
                    ASM_add(asmT, XOR, ts->indice - 1, ts-> indice,0);
                    Symbol s = TS_pop(ts);
               }
          // A + B
          | Operation tPLUS Operation 
               {
                    ASM_add(asmT, ADD, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          // A - B
          | Operation tMINUS Operation 
               {
                    ASM_add(asmT, SOU, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          // A * B
          | Operation tSTAR Operation 
               {
                    ASM_add(asmT, MUL, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          // A / B
          | Operation tSLASH Operation 
               {
                    ASM_add(asmT, DIV, ts->indice - 1, ts-> indice, ts->indice-1);
                    Symbol s = TS_pop(ts);
               }
          // (op)
          | tOP Operation tCP { $$ = $2 ; }
          // A 
          | tID
          
             {
               printf("%s\n", $1);
               // création variable temporaire
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp, depth);
               TS* sous_ts = TS_exist(ts, $1);
               // verification de l'existance de la variable dans la table des symboles
               if (sous_ts!=NULL){
                    ASM_add(asmT, COP, ts->indice, sous_ts->indice, 0);
               }
               else{
                    printf(ANSI_COLOR_RED "Variable  \" %s \"  non déclarée" ANSI_RESET_ALL , $1);
                    return 1;
               }
               }
          // value
          | tNB 
               {
               // création variable temporaire et lui affecter nb
               printf("%d\n", $1);
               Symbol temp = {"temp",0,TYPE_INT};
               ts = TS_push(ts, temp, depth);
               ASM_add(asmT, AFC, ts->indice, $1,0);
               }
;




/* ======== Declaration  ========= */
Declaration : {printf("declaration: \n");}Type  DecIDRec tSEM ;

DecIDRec : DecID
          | DecID tCOMMA{printf(",\n");} DecIDRec;

DecID : tID 
          // ajout a la table des symboles
          {Symbol s = {"",1,TYPE_INT};
           strcpy(s.name, $1); 
           ts=TS_push(ts, s, depth);
           printf("%s = ", $1);
           }
           
            
     tEQ Operation 
           
           {
               printf("Debut operation \n");
               TS* sous_ts = TS_exist(ts, $1);
               // verification que l'ajout a la table est bien fait
               if(sous_ts!= NULL){
                    //copy la valeur temporaire (faite par Operation) dans id
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    // pop la variable temporaire
                    Symbol s = TS_pop(ts);
               }
               else {
                    printf(ANSI_COLOR_RED "Variable  \" %s \"  non déclarée" ANSI_RESET_ALL , $1);
                    return 1;
               }
           }
     | tID {
          // rajout a la table des symboles 
           Symbol s = {"",0,TYPE_INT};
           printf("%s \n", $1);
           strcpy(s.name, $1);
           ts=TS_push(ts, s, depth);
          }
           ;


/* ======== Affectation ========== */
Affectation : AffIDRec tSEM 
          {
               printf("affectation %s \n", $1);
          };

AffIDRec : AffID 
          |AffID tCOMMA AffIDRec;
          

AffID : tID
         { 
          Symbol s = {"",0,TYPE_INT};
          strcpy(s.name, $1); 
          printf("$1 : %s\n", $1);
          //verification de l'existence de la var dans la table des symboles
          TS * sous_ts = TS_exist(ts, s.name);
          TS_print(ts);
          if(sous_ts != NULL){
               sous_ts->symbol.state = 1;

          }
          else{
               // variable non déclarée
               printf(ANSI_COLOR_RED "Variable \" %s \" non déclarée \n" ANSI_RESET_ALL, $1);
               return 1;
          } 
          }
          tEQ Operation

          {
               //copy la var temp dans id 
               TS * sous_ts = TS_exist(ts, $1);
               if(sous_ts != NULL){
                    ASM_add(asmT, COP, sous_ts->indice, ts->indice, 0);
                    Symbol s  = TS_pop(ts);
                    printf("symbol : %s\n", s.name);
               }
               else{
               // variable non déclarée
               printf(ANSI_COLOR_RED "Variable \" %s \" non déclarée \n" ANSI_RESET_ALL, $1);
               return 1;
          } 
          }
          ;




/*=============If et Switch=============*/

If: tIF tOP Operation tCP 
               {    // jump if  var temporaire de operation is false à une addresse indeterminee -1 pour le moment
                    Instruction* ligne = ASM_add(asmT, JMF, ts->indice, -1, 0);
                    // stocker l'instruction dans le premier token (tIF)
                    $1 = (void*)ligne;
                    // pop la variable temporaire de operation
                    TS_pop(ts);
               } 
          Body {
                    // on récupère le premier token (instruction)
                    Instruction* inst = (Instruction*) $1;
                    //on rajoute le saut à l @ de asm last + 2 
                    /*
                         - 1 ligne pour prendre en compte la derniere instruction du body
                         - 1 ligne pour le eviter jmp avant le else
                    */
                    inst->addSrc1 =  asmT->last->indice + 2;
                    
               }
               
          OptElse ;

OptElse : 
           tELSE 
          {   
               // dans le cas d'un else on fait un jmp vers une @ indeterminée pour le moment afin de pouvoir eviter ce bloc
               Instruction* ligne = ASM_add(asmT,JMP,-1, 0, 0) ;
               $1 = (void *)ligne ;
          }
          Body
          {
               // recupere instruction et mettre addresse = last + 1 afin de passer a l'instruction qui suit le body
               Instruction* ligne = (Instruction*)$1;
               ligne->addDst =  asmT->last->indice + 1;
          }

          |
          {
               // en absence du else on rajoute une operation nop (1 cycle perdu :'( ) afin de garder la cohérance du jmf
               ASM_add(asmT,NOP,0,0,0) ;
          }%prec tWoElse;



//TODO SWITCH CASE

/*==========While============*/

While : tWHILE tOP {
     // on sauvegarde l'@ de operation pour le jmf plus tard
     int ligne = asmT->last->indice + 1;
     $1 = (void*) &ligne;
}Operation tCP
          {
               // on jump if la var temp de operation is false à une @ indéterminé mais on enregistre
               // l'@ ou commence operation (enregistree auparavant) pour pouvoir la recuperer afin d'y revenir apre body
               Instruction* ligne = ASM_add(asmT, JMF, ts->indice, *((int*) $1), 0);
               $1 = (void*)ligne;
               TS_pop(ts);
          }
          Body
          {
               // recuperer instruction afin de recuperer la destination du jmp fin body et changer la valeur 
               // de jmf à la fin du body + 1 pour executer la premiere ligne apres le body
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



