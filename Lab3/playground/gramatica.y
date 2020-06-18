%token a
%token b
%token dolar
%token erro
%%
SS	:	S dolar  	{printf ("Fim da analise\n"); return;}
	;
S	:
	|  a S b
	;
%%
yylex () {
	char x;
	x = getchar ();
	while (x == ' ' || x == '\n' || x == '\t' || x == '\r')
		x = getchar ();
	printf ("Caractere lido: %c\n", x);
	if (x == 'a') return a; if (x == 'b') return b;
	if (x == '$') return dolar; return erro;
}
