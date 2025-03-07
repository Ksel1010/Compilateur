%token tWHILE tIF tELSE tCASE tSWITCH tFOR tRETURN tDEFAULT // Mots clés
%token tVOID tINT tLONG tCHAR tFLOAT tCONST // Types
%token tSOE tGOE tDIF tST tGT tDEQ tL_AND tL_OR // Opérateurs logiques
%token tSLASH tSTAR tMINUS tPLUS tEQ tAND tNOT tOR tXOR// Operateurs sur nombre
%token tUNDER tCOMMA tSOB tSCB tOB tCB tSEM tOP tCP tCOLON //Ponctuations
%token tID tNB

%%

/*=============Élément à utiliser partout=============*/

Type : Type tSTAR
     | tINT
     | tVOID
     | tLONG
     | tCHAR
     | tFLOAT
     | tCONST;

OperateurMath : tMINUS
     | tPLUS
     | tSTAR
     | tSLASH
     | tAND
     | tOR
     | tXOR;

Comparateur : tGT
     | tST
     | tSOE
     | tGOE
     | tDIF
     | tDEQ
     | tL_AND
     | tL_OR;

/*Corps d'une fonction/Instruction*/
Body : tOB IRec tCB;

IRec : I
     | I IRec;

I : IfElse
     | While
     | For
//     | SwitchCase
     | Declaration
     | Affectation
     | tRETURN Expression tSEM
     |;

/*Pour les conditions ( if while etc...)*/

Expression : tID
    | tNB;

ConditionRec : Condition
     |   tOP Condition Comparateur  ConditionRec tCP
     |   Condition  Comparateur  ConditionRec ;

Condition : Expression
     | Expression Comparateur Expression
     | tOP Expression Comparateur Expression tCP;

/*Operation*/ 
// Pour le moment focus sur les int avec mult add et soust plus tard ajouter char (concatenation...) float etc...
// Si on complete on devrait créer un autre nom pour les type sur lesquelles on apllique des opperation pour pas les melanger avec void etc...

OperationIntRec : OperationInt
     |   tOP OperationInt OperateurMath  OperationIntRec tCP
     |   OperationInt  OperateurMath  OperationIntRec ;

OperationInt : Expression OperateurMath Expression
     | tOP Expression OperateurMath Expression tCP
     | tNOT Expression
     | Expression;
/* Declaration et Affection */
IDRec : tID 
     | tID tCOMMA IDRec;

Declaration : Type IDRec tSEM
     | Type IDRec tEQ Expression tSEM;

Affectation : IDRec tEQ Expression tSEM;


/*=============Fontion=============*/
Fonction : Type tID tOP ArgRec tCP Body;

ArgRec : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*=============If et Switch=============*/

IfElse : tIF tOP ConditionRec tCP Body 
     | tIF tOP ConditionRec tCP Body tELSE Body;

//TODO SWITCH CASE

/*=============Boucle for et while=============*/ // Pourquoi pas faire le doWhile plus tard

While : tWHILE tOP ConditionRec tCP Body;

//Une boucle for c'est : for (affectation ou declaration, condition d'arret, incrementation)
//ici je prefere utilise la regle operation plutot que d'en créer une juste pour les incremation ( du genre a = a*2 / a = a+1 / a++ etc...)
For : tFOR tOP Affectation ConditionRec tSEM OperationIntRec tCP Body
     | tFOR tOP Declaration ConditionRec tSEM OperationIntRec tCP Body
     | tFOR tOP 




/*
Remarque :
     - Comment faire pour ajouter une regle pour les tableaux ? => tID tSOB tNB tSCB = tNB ou tOB (tNb tSC)* tCB
Question :
     - Est ce que c'est le role de l'analyseur syntaxique de detecter qu'une fonction autre que void doit avoir un return dans le body 
ou ou est ce que c'est a l'analyseur semantique 
*/