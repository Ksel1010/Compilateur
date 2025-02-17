%option noyywrap
D   [0-9]
C [A-Za-z]

%%
while             return tWHILE;
if                return tIF;
else              return tELSE;
case              return tCASE;
switch            return tSWITCH;
for               return tFOR;
void              return tVOID;
int               return tINT;
long              return tLONG;
char              return tCHAR;
float             return tFLOAT;
const             return tCONST;
return            return tRETURN;
default 		  return tDEFAULT;

"_"               return tUNDER;
"-"               return tMinus;
"/"               return tSLASH;
","               return tCOMMA;
"*"               return tSTAR;
"<"               return tST;
">"               return tGT;
"+"               return tADD;
"=="              return tEQ;
"="               return tAFFECT;
"["               return tSOB;
"]"               return tSCB;
"{"               return tOB;
"}"               return tCB;
";"               return tSEM;
"("               return tOP;
")"               return tCP;

{D}+              return tNB[%s], yytext;
{C}({C}|{D}|"_")* return tID[%s], yytext;

" "               { }
\t                { }
\n                { }
.                 { return ERROR\n; exit(2); }

%%

void main(void) {
	yylex();
}