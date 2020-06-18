%%
prod :	'C' 'O' 'M' 'P' ' ' '2' '1'	
			{printf ("Reconheco!\n"); return;}
	  ; 
%%
yylex () {
	return getchar ();
}