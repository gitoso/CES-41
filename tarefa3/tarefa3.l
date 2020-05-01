%{
#define ACEITA      1
#define REJEITA     2
%}
delim       [ \t\n\r]
ws          {delim}+
aceita      [01]*(2[01]*2[01]*2[01]*2[01]*2)*[01]*
alfabeto    [012]*
%%
{aceita}    {return ACEITA;}
{alfabeto}  {return REJEITA;}
%%
int main(int argc, char* argv[])
{
    int i;

    while(i = yylex())
    {
        switch(i)
        {
            case ACEITA:
                printf("\n %-20s: Aceita \n", yytext);
                break;
            case REJEITA:
                printf("\n %-20s: Rejeita \n", yytext);
                break;
        }
    }
    return 0;
}
