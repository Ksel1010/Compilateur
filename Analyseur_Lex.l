%option noyywrap
D   [0-9]
C [A-Za-z]

%%

%{Mots clés du language%}
while             	return tWHILE;
if                	return tIF;
else              	return tELSE;
case              	return tCASE;
switch            	return tSWITCH;
for               	return tFOR;
void              	return tVOID;
int               	return tINT;
long              	return tLONG;
char              	return tCHAR;
float             	return tFLOAT;
const             	return tCONST;
return              return tRETURN;
default             return tDEFAULT;


%{Symboles de comparaison %}
"<="                return tSOE;
">="                return tGOE;
"!="                return tDIF;
"<"                 return tST;
">"                 return tGT;
"=="                return tDEQ;
"&&"                return tL_AND;
"||"                return tL_OR;

%{Opérateurs %} 
%{Peut etre ajouter  les ++ += ...%}
"/"               	return tSLASH;
"*"               	return tSTAR;
"-"               	return tMINUS;
"+"               	return tPLUS;
"="               	return tEQ;

%{Opérateurs bit à bit %}
"&"                 return tAND;
"!"                 return tNOT;
"|"                 return tOR;
"^"                 return tXOR


%{Ponctuations %}
"_"               	return tUNDER;
","               	return tCOMMA;
"["               	return tSOB;
"]"               	return tSCB;
"{"               	return tOB;
"}"               	return tCB;
";"               	return tSEM;
"("             	return tOP;
")"               	return tCP;
":"                 return tCOLON

%{Token Générales%}
{D}+              	return tNB[%s], yytext;
{C}({C}|{D}|"_")* 	return tID[%s], yytext;

%{Caractères speciaux%}
" "               	{ }
\t                	{ }
\n                	{ }
.                 	{ return ERROR\n; exit(2); }

%%