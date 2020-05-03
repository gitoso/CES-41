%{
#define ACEITA      1
#define REJEITA     2
#define FORA        3
%}
delim       [ \t\n\r]
ws          {delim}+
aceita      [01]*(2[01]*2[01]*2[01]*2[01]*2)*[01]*
alfabeto    [012]*
separador   \-+
string	    [^ \t\n\r]+

%%
{ws}        {;}
{aceita}    {return ACEITA;}
{alfabeto}  {return REJEITA;}
{separador} {printf("--------------------------------------\n");}
{string}    {return FORA;}
%%

int main(int argc, char* argv[])
{
    int i;

    while(i = yylex())
    {
        switch(i)
        {
            case ACEITA:
                printf("%-30s: Aceita \n", yytext);
                break;
            case REJEITA:
                printf("%-30s: Rejeita \n", yytext);
                break;
            case FORA:
                printf("%-30s: Rejeita (fora do alfabeto) \n", yytext);
                break;
        }
    }
    return 0;
}
