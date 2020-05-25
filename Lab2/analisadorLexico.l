%{
#include <string.h>

enum {
    ID, CTINT, CTCARAC, CTREAL, CADEIA, OR AND, NOT, OPREL, OPAD, OPMULT, NEG, ATRIB, ABPAR, FPAR, ABCOL, FCOL, ABCHAV, FCHAV, ABTRIP, FTRIP, PVIG, VIRG, RESERVADA, SOMA, SUB, MULT, DIV, MOD, EQ, NEQ, LT, LEQ, GT, GEQ, ATRIB, ABPAR, FPAR, ABCOL, FCOL, ABCHAV, FCHAV, ABTRIP, FTRIP, PVIG, VIRG
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
caractere           {letra}|{digito}
ctint               {digito}+
ctcarac             '(\)?{caractere}'
ctreal              {digito}+\.{digito}*((E|e)(+|-)?({digito}+)?
cadeia              "((\)?{caractere})*"
id                  {letra}{caractere}*

%%
{ws}                {;}

/* --- Palavra reservadas --- */
carac               {return RESERVADA;}
chamar              {return RESERVADA;}
comandos            {return RESERVADA;}
enquanto            {return RESERVADA;}
escrever            {return RESERVADA;}
falso               {return RESERVADA;}
funcao              {return RESERVADA;}
int                 {return RESERVADA;}
letra               {return RESERVADA;}
logic               {return RESERVADA;}
para                {return RESERVADA;}
principal           {return RESERVADA;}
procedimento        {return RESERVADA;}
programa            {return RESERVADA;}
real                {return RESERVADA;}
repetir             {return RESERVADA;}
retornar            {return RESERVADA;}
se                  {return RESERVADA;}
senao               {return RESERVADA;}
var                 {return RESERVADA;}
verdade             {return RESERVADA;}

/* --- Sintaxes --- */
{id}                {strcpy(yylval.string, yytext); return ID;}
{ctint}             {yylval.valor = atoi(yytext); return CTINT;}
{ctcarac}           {yylval.carac = yytext[0]; return CTCARAC;}
{ctreal}            {yylval.valreal = atof(yytext); return CTREAL;}
{cadeia}            {strcpy(yylval.string, yytext); return CADEIA;}

/* --- Operadores --- */
"!="                {yylval.atr = NEQ; return OPREL;}
"<="                {yylval.atr = LEQ; return OPREL;}
"<"                 {yylval.atr = LT; return OPREL;}
">="                {yylval.atr = GEQ; return OPREL;}
">"                 {yylval.atr = GT; return OPREL;}
"=="                {yylval.atr = EQ; return OPREL;}
"+"                 {yylval.atr = SOMA; return OPAD;}
"-"                 {yylval.atr = SUB; return OPAD;}
"*"                 {yylval.atr = MULT; return OPMULT;}
"/"                 {yylval.atr = DIV; return OPMULT;}
"%"                 {yylval.atr = MOD; return OPMULT;}
"||"                {return OR;}
"&&"                {return AND;}
"!"                 {return NOT;}
"~"                 {return NEG;}

/* --- Separadores e outros --- */
"="                 {return ATRIB;}
"("                 {return ABPAR;}
")"                 {return FPAR;}
"["                 {return ABCOL;}
"]"                 {return FCOL;}
"{"                 {return ABCHAV;}
"}"                 {return FCHAV;}
"{{{"               {return ABTRIP;}
"}}}"               {return FTRIP;}
";"                 {return PVIG;}
","                 {return VIRG;}

/* --- Demais caracteres --- */
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
