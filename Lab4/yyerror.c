#include <stdio.h>

int
yyerror ( char * msg )
{
    fprintf ( stderr, "%s\n", msg ) ;
}
