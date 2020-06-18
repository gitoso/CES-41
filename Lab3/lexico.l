%{
#include <string.h>
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
comentario          \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

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
