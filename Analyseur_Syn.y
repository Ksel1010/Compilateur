
%%
Type : Type tSTAR
     | (tINT)
     | (tVOID)
     | (tLONG)
     | (tCHAR)
     | (tFLOAT)
     | (tCONST);

function : tID tOP Args tPF Body;


Args : Argr
     | ;  

Argr : Arg 
    | Arg tCOMMA Argr;

Arg : Type tID;

Body : tOB Is tCB;

Is : I
     | Is;

I : IfElse
     | While
     | For
     | SwitchCase
     | Declaration
     | Affectation;

Expression : tID
    | tNB;

Conditions : Condition
     |   tOP Condition Comparateur  Conditions tCP
     |   Condition  Comparateur  Conditions ;

Condition : Expression
     | Expression Comparateur Expression
     | tOP Expression Comparateur Expression tCP

/* Declaration + Affection */
Declaration : Type IDs tSC
    | Type IDs tEQ Expression tSC;

Affectation : IDs tEQ Expression tSC;

IDs : tID 
     | tID tCOMMA IDS;

/*If et Swtich*/

IfElse : tIF tOP Conditions tCP Body 
    | tIF tIF tOP Conditions tCP Body tELSE Body;

//TODO SWITCH CASE

/* Loop */
