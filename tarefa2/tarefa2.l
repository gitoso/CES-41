%{
#define ACEITA      1
#define REJEITA     2
%}
delim       [ \t\n\r]
ws          {delim}+
par0        1*(01*0)*1*
par1        0*(10*1)*0*
alfabeto    [01]*
%%
{par0}      {return REJEITA;}
{par1}      {return REJEITA;}
{alfabeto}  {return ACEITA;}
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
