%{
#include <string.h>

enum tipos {
    /* Palavras reservadas */
    CARAC=1, CHAMAR, COMANDOS, ENQUANTO, ESCREVER, FALSO, FUNCAO, INT, LER, LOGIC, PARA, PRINCIPAL, PROCEDIMENTO, PROGRAMA, REAL, REPETIR, RETORNAR, SE, SENAO, VAR, VERDADE,
    /* Constantes */
    ID, CTINT, CTCARAC, CTREAL, CADEIA,
    /* Operadores */
    ATRIB, OR, AND, NOT, NEG, OPAD, SOMA, SUB, OPMULT, MULT, DIV, MOD, OPREL, EQ, NEQ, LT, LEQ, GT, GEQ,
    /* Controle */
    ABPAR, FPAR, ABCOL, FCOL, ABCHAV, FCHAV, ABTRIP, FTRIP, PVIG, VIRG, INVAL, FINAL
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
carac1              \\.|[^\\'\n]
ctcarac             '{carac1}'
carac2              \\.|[^\\\"\n]
cadeia              \"{carac2}*\"
ctreal              {digito}+\.{digito}*([Ee][+-]?{digito}+)?
caractere           {letra}|{digito}
id                  {letra}{caractere}*
comentario          \/\*(.*\n*.*)\*\/

%%
{ws}                {;}
{comentario}        {;}

carac               {return CARAC;}
chamar              {return CHAMAR;}
comandos            {return COMANDOS;}
enquanto            {return ENQUANTO;}
escrever            {return ESCREVER;}
falso               {return FALSO;}
funcao              {return FUNCAO;}
int                 {return INT;}
ler                 {return LER;}
logic               {return LOGIC;}
para                {return PARA;}
principal           {return PRINCIPAL;}
procedimento        {return PROCEDIMENTO;}
programa            {return PROGRAMA;}
real                {return REAL;}
repetir             {return REPETIR;}
retornar            {return RETORNAR;}
se                  {return SE;}
senao               {return SENAO;}
var                 {return VAR;}
verdade             {return VERDADE;}

{id}                {strcpy (yylval.string, yytext); return ID;}
{ctint}             {yylval.valor = atoi(yytext); return CTINT;}
{ctcarac}           {strcpy (yylval.string, yytext); return CTCARAC;}
{ctreal}            {yylval.valreal = atof(yytext); return CTREAL;}
{cadeia}            {strcpy(yylval.string, yytext); return CADEIA;}

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

.                   {yylval.carac = yytext[0]; yylval.atr = INVAL; return INVAL;}
%%

void imprimeLinha() {
    printf("+--------------------------------+-------------------+--------------------------------+\n");
}

void imprimeHeader() {
    imprimeLinha();
    printf("| %-30s | %3s: %-12s | %-30s |\n", "TEXTO", "ID", "ATOMO", "ATRIBUTO");
    imprimeLinha();
}

int main (int argc, char* argv[]) {
    int i;
    imprimeHeader();
    while (i = yylex ()) {
        printf("| %-30s | %3d: ", yytext, i);
        switch (i) {
            case ID:
                printf("%-12s | %-30s |", "ID", yylval.string);
                break;
            case CTINT:
                printf("%-12s | %-30d |", "CTINT", yylval.valor);
                break;
            case CTCARAC:
                printf("%-12s | %-30s |", "CTCARAC", yylval.string);
                break;
            case CTREAL:
                printf("%-12s | %-30f |", "CTREAL", yylval.valreal);
                break;
            case CADEIA:
                printf("%-12s | %-30s |", "CADEIA", yylval.string);
                break;
            case OR:
                printf("%-12s | %-30s |", "OR", " ");
                break;
            case AND:
                printf("%-12s | %-30s |", "AND", " ");
                break;
            case NOT:
                printf("%-12s | %-30s |", "NOT", " ");
                break;
            case OPREL:
                switch(yylval.atr) {
                    case EQ:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "EQ");
                        break;
                    case NEQ:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "NEQ");
                        break;
                    case LT:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "LT");
                        break;
                    case LEQ:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "LEQ");
                        break;
                    case GT:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "GT");
                        break;
                    case GEQ:
                        printf("%-12s | %3d: %-25s |", "OPREL", yylval.atr, "GEQ");
                        break;
                }
                break;
            case OPAD:
                switch(yylval.atr) {
                    case SOMA:
                        printf("%-12s | %3d: %-25s |", "OPAD", yylval.atr, "SOMA");
                        break;
                    case SUB:
                        printf("%-12s | %3d: %-25s |", "OPAD", yylval.atr, "SUB");
                        break;
                }
                break;
            case OPMULT:
                switch(yylval.atr) {
                    case MULT:
                        printf("%-12s | %3d: %-25s |", "OPMULT", yylval.atr, "MULT");
                        break;
                    case DIV:
                        printf("%-12s | %3d: %-25s |", "OPMULT", yylval.atr, "DIV");
                        break;
                    case MOD:
                        printf("%-12s | %3d: %-25s |", "OPMULT", yylval.atr, "MOD");
                        break;
                }
                break;
            case NEG:
                printf("%-12s | %-30s |", "NEG", " ");
                break;
            case ATRIB:
                printf("%-12s | %-30s |", "ATRIB", " ");
                break;
            case ABPAR:
                printf("%-12s | %-30s |", "ABPAR", " ");
                break;
            case FPAR:
                printf("%-12s | %-30s |", "FPAR", " ");
                break;
            case ABCOL:
                printf("%-12s | %-30s |", "ABCOL", " ");
                break;
            case FCOL:
                printf("%-12s | %-30s |", "FCOL", " ");
                break;
            case ABCHAV:
                printf("%-12s | %-30s |", "ABCHAV", " ");
                break;
            case FCHAV:
                printf("%-12s | %-30s |", "FCHAV", " ");
                break;
            case ABTRIP:
                printf("%-12s | %-30s |", "ABTRIP", " ");
                break;
            case FTRIP:
                printf("%-12s | %-30s |", "FTRIP", " ");
                break;
            case PVIG:
                printf("%-12s | %-30s |", "PVIG", " ");
                break;
            case VIRG:
                printf("%-12s | %-30s |", "VIRG", " ");
                break;
            case CARAC:
                printf("%-12s | %-30s |", "CARAC", " ");
                break;
            case CHAMAR:
                printf("%-12s | %-30s |", "CHAMAR", " ");
                break;
            case COMANDOS:
                printf("%-12s | %-30s |", "COMANDOS", " ");
                break;
            case ENQUANTO:
                printf("%-12s | %-30s |", "ENQUANTO", " ");
                break;
            case ESCREVER:
                printf("%-12s | %-30s |", "ESCREVER", " ");
                break;
            case FALSO:
                printf("%-12s | %-30s |", "FALSO", " ");
                break;
            case FUNCAO:
                printf("%-12s | %-30s |", "FUNCAO", " ");
                break;
            case INT:
                printf("%-12s | %-30s |", "INT", " ");
                break;
            case LER:
                printf("%-12s | %-30s |", "LER", " ");
                break;
            case LOGIC:
                printf("%-12s | %-30s |", "LOGIC", " ");
                break;
            case PARA:
                printf("%-12s | %-30s |", "PARA", " ");
                break;
            case PRINCIPAL:
                printf("%-12s | %-30s |", "PRINCIPAL", " ");
                break;
            case PROCEDIMENTO:
                printf("%-12s | %-30s |", "PROCEDIMENTO", " ");
                break;
            case PROGRAMA:
                printf("%-12s | %-30s |", "PROGRAMA", " ");
                break;
            case REAL:
                printf("%-12s | %-30s |", "REAL", " ");
                break;
            case REPETIR:
                printf("%-12s | %-30s |", "REPETIR", " ");
                break;
            case RETORNAR:
                printf("%-12s | %-30s |", "RETORNAR", " ");
                break;
            case SE:
                printf("%-12s | %-30s |", "SE", " ");
                break;
            case SENAO:
                printf("%-12s | %-30s |", "SENAO", " ");
                break;
            case VAR:
                printf("%-12s | %-30s |", "VAR", " ");
                break;
            case VERDADE:
                printf("%-12s | %-30s |", "VERDADE", " ");
                break;
            case INVAL:
                printf("%-12s | %-30s |", "INVAL", " ");
                break;
            case FINAL:
                printf("%-12s | %-30s |", "FINAL", "EOF");
                break;
        }
        printf("\n");
        imprimeLinha();
    }
}