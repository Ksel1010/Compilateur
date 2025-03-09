%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}
D [0-9]
C [A-Za-z]

%%

main             	return tMAIN; 
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


"<="                return tSOE;
">="                return tGOE;
"!="                return tDIF;
"<"                 return tST;
">"                 return tGT;
"=="                return tDEQ;
"&&"                return tL_AND;
"||"                return tL_OR;


"/"               	return tSLASH;
"*"               	return tSTAR;
"-"               	return tMINUS;
"+"               	return tPLUS;
"="               	return tEQ;

"&"                 return tAND;
"!"                 return tNOT;
"|"                 return tOR;
"^"                 return tXOR;


"_"               	return tUNDER;
","               	return tCOMMA;
"["               	return tSOB;
"]"               	return tSCB;
"{"               	return tOB;
"}"               	return tCB;
";"               	return tSEM;
"("             	return tOP;
")"               	return tCP;
":"                 return tCOLON;

{D}+              	{return tNB ;}
{C}({C}|{D}|"_")* 	{return tID;}

" "               	{ }
\t                	{ }
\n                	{ }
.                 	{ return tERROR;  }

%%
int yywrap(void) {
    return 1;
}