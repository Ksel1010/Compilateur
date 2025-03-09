%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

/* Déclarations des fonctions */
int yylex(void);
void yyerror(const char *s);
%}
/* to do : 
          -add AND XOR OR 
          -Instruction switchcase*/
%token tWHILE tIF tELSE tCASE tSWITCH tFOR tRETURN tDEFAULT // Mots clés
%token tVOID tINT tLONG tCHAR tFLOAT tCONST tMAIN // Types
%token tSOE tGOE tDIF tST tGT tDEQ tL_AND tL_OR // Opérateurs logiques
%token tSLASH tSTAR tMINUS tPLUS tEQ tAND tNOT tOR tXOR// Operateurs sur nombre
%token tUNDER tCOMMA tSOB tSCB tOB tCB tSEM tOP tCP tCOLON //Ponctuations
%token tERROR 
%token tID 
%token tNB


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


/*Corps d'une fonction/Instruction*/
Body : tOB IRec tCB;

IRec : I 
     | I IRec;

I : IfElse
//     | While
//     | For 
//     | SwitchCase
     | Declaration 
     | Affectation 
     | tRETURN Operation tSEM ;

/*Pour les conditions ( if while etc...)*/



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



/*Operation*/ 
// Pour le moment focus sur les int avec mult add et soust plus tard ajouter char (concatenation...) float etc...
// Si on complete on devrait créer un autre nom pour les type sur lesquelles on apllique des opperation pour pas les melanger avec void etc...



Operation : Operation tPLUS Operation
          | Operation tMINUS Operation
          | Operation tSTAR Operation
          | Operation tSLASH Operation
          | tOP Operation tCP
          | tID
          | tNB;

/* Declaration et Affection */
IDRec : tID 
     | tID tCOMMA IDRec;

Declaration : Type  IDRec tSEM 
     | Type IDRec tEQ Operation tSEM;

Affectation : IDRec tEQ Operation tSEM;


/*=============Fonction=============*/

//Fonction : Type  tID  tOP ArgRec tCP Body;

ArgRec : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*=============If et Switch=============*/

IfElse : tIF tOP Condition tCP Body 
     | tIF tOP Condition tCP Body tELSE Body;

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
     return yyparse();
}

void tableaux


void yyerror(const char *s)
{
     fprintf(stderr, "%s\n", s);
}