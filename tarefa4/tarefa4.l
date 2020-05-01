%{
#define ACEITA      1
#define REJEITA     2
%}
delim       [ \t\n\r]
ws          {delim}+
rejeita     [01]*(00000|10000|01000|00100|00010|00001|11000|10100|10010|10001|01100|01010|01001|00110|00101|00011)[01]*
alfabeto    [01]{5,}
%%
{rejeita}   {return REJEITA;}
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
