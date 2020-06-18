%token a
%token b
%token c
%token d
%token dolar
%token erro
%%
SS	:	S dolar  	{printf ("Fim da analise\n"); return;}
	;
S	:  a b A c D
    ;
A   :  
    |  a b A c
    ;
D   :
    |  d d D
    ;
%%
yylex () {
	char x;
	x = getchar ();
	while (x == ' ' || x == '\n' || x == '\t' || x == '\r')
		x = getchar ();
	printf ("Caractere lido: %c\n", x);
	if (x == 'a') return a; if (x == 'b') return b;
    if (x == 'c') return c; if (x == 'd') return d;
	if (x == '$') return dolar; return erro;
}
