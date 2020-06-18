%token apar
%token fpar
%token dolar
%token erro
%%
SS	:	S dolar  	{printf ("Fim da analise\n"); return;}
	;
S	:  apar A fpar
    |  S apar A fpar
    ;
A   :  
    |  S
    ;
%%
yylex () {
	char x;
	x = getchar ();
	while (x == ' ' || x == '\n' || x == '\t' || x == '\r') in
		x = getchar ();
	printf ("Caractere lido: %c\n", x);
	if (x == '(') return apar; if (x == ')') return fpar;
	if (x == '$') return dolar; return erro;
}
