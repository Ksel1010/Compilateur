%option noyywrap
D   [0-9]
C [A-Za-z]

%%
while             printf(" tWHILE");
if                printf(" tIF");
else              printf(" tELSE");
case              printf(" tCASE");
switch            printf(" tSWITCH");
for               printf(" tFOR");
void              printf(" tVOID");
int               printf(" tINT");
long              printf(" tLONG");
char              printf(" tCHAR");
float             printf(" tFLOAT");
const             printf(" tCONST");
return            printf(" tRETURN");


"_"               printf(" tUNDER");
"-"               printf(" tMinus");
"/"               printf(" tSLASH");
","               printf(" tCOMMA");
"*"               printf(" tSTAR");
"<"               printf(" tST");
">"               printf(" tGT");
"+"               printf(" tADD");
"=="              printf(" tEQ");
"="               printf(" tAFFECT");
"["               printf(" tSOB");
""               printf(" tSCB");
"{"               printf(" tOB");
"}"               printf(" tCB");
";"               printf(" tSEM");
"("               printf(" tOP");
")"               printf(" tCP");

{D}+              printf(" tNB[%s]", yytext);
{C}({C}|{D}|"_")* printf(" tID[%s]", yytext);

" "               { }
\t                { }
\n                { }
.                 { printf(" ERROR\n"); exit(2); }

%%

void main(void) {
	yylex();
}