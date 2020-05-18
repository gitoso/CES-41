%{
#include 	<string.h>
#define 	ELSE 		1
#define 	IF 		    2
#define	    WHILE   	3
#define	    ID		    4
#define	    CTINT		5
#define	    OPREL		6
#define     INVAL       7
#define     CTREAL      8
#define     CTCHAR      9
#define     CADEIA      10
#define 	LT 		1
#define 	LE 		2
#define	    GT		3
#define	    GE		4
#define	    EQ		5
#define	    NE		6
union {
	char string[50];
	int atr, valor;
	float valreal;
	char carac;
} yylval;
%}
delim		[ \t\n\r]
ws			{delim}+
digito	    [0-9]
letra		[A-Za-z]
ctint		{digito}+
ctreal      {digito}+\.{digito}*([Ee][+-]?{digito}+)?
carac1	    \\.|[^\\'\n]
ctcarac	    '{carac1}'
carac2	    \\.|[^\\\"\n]
string	    \"{carac2}*\"
id			{letra}({letra}|{digito})*
%%
{ws}		{ ;}
else		{return ELSE;}
if			{return IF;}
while		{return WHILE;}
{id}		{strcpy (yylval.string, yytext); return ID;}
{ctint}	    {yylval.valor = atoi(yytext); return CTINT;}
{ctreal}	{yylval.valreal = atof(yytext); return CTREAL;}
{ctcarac}	{strcpy (yylval.string, yytext); return CTCHAR;}
{string}	{strcpy (yylval.string, yytext); return CADEIA;}
"<"		    {yylval.atr = LT; return OPREL;}
"<="		{yylval.atr = LE; return OPREL;}
">"		    {yylval.atr = GT; return OPREL;}
">="		{yylval.atr = GE; return OPREL;}
"=="		{yylval.atr = EQ; return OPREL;}
"!="		{yylval.atr = NE; return OPREL;}
.		{yylval.carac = yytext[0]; return INVAL;}
%%
main () {
	int i;
	printf ("\n      texto      |   tipo   | atributo \n");
	printf ("----------------------------------------------\n");
	while (i = yylex ()) {
		printf ("%17s|%10d|", yytext, i);
		switch (i) {
			case ID: case CTCHAR: case CADEIA:
				printf ("%17s", yylval.string); break;
			case CTINT:
				printf ("%17d", yylval.valor); break;
			case CTREAL:
				printf ("%17g", yylval.valreal); break;
			case OPREL:
				printf ("%17d", yylval.atr); break;
            case INVAL:
                printf ("%17c", yylval.carac); break;
		}
		printf ("\n");
	}
}
