%{
#include	<stdio.h>
#include	<stdlib.h>
%}
%token		DOLAR
%token		CTE
%token		OPAD
%token		OPMULT
%token		ABPAR
%token		FPAR
%token		INVAL
%%
line	:	expr DOLAR         
			{printf("Fim da analise\n"); return;}
		;
expr	:	expr	OPAD	term
		|	term
		;
term	:	term	OPMULT fat
		|	fat
		;
fat	:	CTE
		|	ABPAR	 expr	 FPAR
		;
%%
#include "lex.yy.c"
