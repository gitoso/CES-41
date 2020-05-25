%{
#include <string.h>

enum {
    ID, CTINT, CTREAL, OPAD, MAIS, MENOS, OPMULT, VEZES, DIV, ABPAR, FPAR, ABCHAV, FCHAV, ATRIB, VIRG, PVIRG, PROGRAM, VAR, INT, REAL, INVAL
};

union {
    char string[50];
    int atr, valor;
    float valreal;
    char carac;
} yylval;
%}
delim               [ \t\n\r]
ws                  {delim}+
digito              [0-9]
letra               [A-Za-z]
ctint               {digito}+
ctreal              {digito}+\.{digito}*
id                  {letra}({letra}|{digito})*

%%
{ws}                {;}
program             {return PROGRAM;}
var                 {return VAR;}
int                 {return INT;}
real                {return REAL;}
{id}                {strcpy(yylval.string, yytext); return ID;}
{ctint}             {yylval.valor = atoi(yytext); return CTINT;}
{ctreal}            {yylval.valreal = atof(yytext); return CTREAL;}
"+"                 {yylval.atr = MAIS; return OPAD;}
"-"                 {yylval.atr = MENOS; return OPAD;}
"*"                 {yylval.atr = VEZES; return OPMULT;}
"/"                 {yylval.atr = DIV; return OPMULT;}
"("                 {return ABPAR;}
")"                 {return FPAR;}
"{"                 {return ABCHAV;}
"}"                 {return FCHAV;}
"="                 {return ATRIB;}
","                 {return VIRG;}
";"                 {return PVIRG;}
.                   {yylval.carac = yytext[0]; yylval.atr = INVAL; return INVAL;}
%%

int main (int argc, char* argv[]) {
    int i;
    printf ("\n   texto  |   tipo   | atributo  \n");
    printf ("-------------------------------- \n");

    while (i = yylex ()) {
        printf ("%10s|%10d|", yytext, i);
        switch (i) {
            case ID:
                printf ("%10s", yylval.string); break;
            case CTINT:
                printf ("%10d", yylval.valor); break;
            case CTREAL:
                printf ("%10f", yylval.valreal); break;
            case OPAD:
                printf ("%10d", yylval.atr); break;
            case OPMULT:
                printf ("%10d", yylval.atr); break;
            case INVAL:
                printf ("%10c", yylval.carac); break;
        }
        printf ("\n");
    }
    return 0;
} 
