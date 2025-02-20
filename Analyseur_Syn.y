%token tWHILE tIF tELSE tCASE tSWITCH tFOR tRETURN tDEFAULT // Mots clés
%token tVOID tINT tLONG tCHAR tFLOAT tCONST // Types
%token tSOE tGOE tDIF tST tGT tDEQ tL_AND tL_OR // Opérateurs logiques
%token tSLASH tSTAR tMINUS tPLUS tEQ tAND tNOT tOR tXOR// Operateurs sur nombre
%token tUNDER tCOMMA tSOB tSCB tOB tCB tSEM tOP tCP //Ponctuations
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

Operateur : tMINUS
     | tPLUS
     | tSTAR
     | tSLASH;
     | tAND
     | tNOT
     | tOR
     | tXOR

Comparateur : tGT
     | tST
     | tSOE
     | tGOE
     | tDIF
     | tDEQ;
     | tL_AND
     | tL_OR;

/*Corps d'une fonction/Instruction*/
Body : tOB Is tCB;

Is : I
     | Is;

I : IfElse
     | While
     | For
//     | SwitchCase
     | Declaration
     | Affectation;

/*Pour les conditions ( if while etc...)*/

Expression : tID
    | tNB;

Conditions : Condition
     |   tOP Condition Comparateur  Conditions tCP
     |   Condition  Comparateur  Conditions ;

Condition : Expression
     | Expression Comparateur Expression
     | tOP Expression Comparateur Expression tCP;

/*Operation*/ 
// Pour le moment focus sur les int avec mult add et soust plus tard ajouter char (concatenation...) float etc...
// Si on complete on devrait créer un autre nom pour les type sur lesquelles on apllique des opperation pour pas les melanger avec void etc...

OperationsInt : OperationInt
     |   tOP OperationInt Operateur  OperationInt tCP
     |   OperationInt  Operateur  OperationInt ;

OperationInt : tINT Operateur tINT
     | tOP tINT Operateur tINT tCP;
/* Declaration et Affection */
IDs : tID 
     | tID tCOMMA IDs;

Declaration : Type IDs tSEM
     | Type IDs tEQ Expression tSEM;

Affectation : IDs tEQ Expression tSEM;


/*=============Fontion=============*/
Fonction : Type tID tOP Args tCP Body;

Args : Argr
     | ;  

Argr : Arg 
     | Arg tCOMMA Argr;

Arg : Type tID;



/*=============If et Switch=============*/

IfElse : tIF tOP Conditions tCP Body 
     | tIF tOP Conditions tCP Body tELSE Body;

//TODO SWITCH CASE

/*=============Boucle for et while=============*/ // Pourquoi pas faire le doWhile plus tard

While : tWHILE tOP Conditions tCP Body;

//Une boucle for c'est : for (affectation ou declaration, condition d'arret, incrementation)
//ici je prefere utilise la regle operation plutot que d'en créer une juste pour les incremation ( du genre a = a*2 / a = a+1 / a++ etc...)
For : tFOR tOP Affectation tSEM Conditions tSEM OperationsInt tCP Body
     | tFOR tOP Affectation tSEM Conditions tSEM OperationsInt tCP Body



//Est ce que c'est le role de l'analyseur syntaxique de detecteur qu'un fonction autre que void doit avoir un return dans le body 
// ou ou est ce que c'est a l'analyseur semantique 