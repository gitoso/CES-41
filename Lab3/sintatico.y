%{
#include <stdio.h>
#include <stdlib.h>

enum tipos {
    SOMA=1, SUB, MULT, DIV, MOD, EQ, NEQ, LT, LEQ, GT, GEQ, FINAL
};

int tab = 0;
%}

%union {
    char string[50];
    int atr;
    int valor;
    float valreal;
    char carac;
}

%type               Prog Decls ListDecl Declaracao Tipo ListElem Elem Dims ListDim ListMod Modulo Cabecalho CabFunc CabProc ListParam Parametro Corpo ModPrincipal Comandos CmdComp ListCmd Comando CmdSe CmdSenao CmdEnquanto CmdRepetir CmdPara CmdLer ListLeit CmdEscrever ListEscr ElemEscr ChamadaProc Argumentos CmdRetornar CmdAtrib ListExpr Expressao ExprAux1 ExprAux2 ExprAux3 ExprAux4 Termo Fator Variavel Subscritos ListSubscr ChamadaFunc

%token    <string>   ID
%token    <valor>    CTINT
%token    <string>   CTCARAC
%token    <valreal>  CTREAL
%token    <string>   CADEIA

%token    <atr>      OPAD
%token    <atr>      OPMULT
%token    <atr>      OPREL
%token               OR
%token               AND
%token               NOT
%token               NEG
%token               ATRIB
%token               ABPAR
%token               FPAR
%token               ABCOL
%token               FCOL
%token               ABCHAV
%token               FCHAV
%token               ABTRIP
%token               FTRIP
%token               PVIG
%token               VIRG

%token               CARAC
%token               CHAMAR
%token               COMANDOS
%token               ENQUANTO 
%token               ESCREVER
%token               FALSO
%token               FUNCAO
%token               INT
%token               LER
%token               LOGIC
%token               PARA
%token               PRINCIPAL 
%token               PROCEDIMENTO
%token               PROGRAMA
%token               REAL
%token               REPETIR
%token               RETORNAR
%token               SE
%token               SENAO
%token               VAR
%token               VERDADE
%token               INVAL
%%

Prog        :   PROGRAMA ID ABTRIP {tabular(); printf("programa %s {{{", $2); tab++; printf("\n");}  Decls ListMod ModPrincipal FTRIP {printf("\n"); printf("}}}\n"); printf("\n\nPrograma Compilado com Sucesso!\n\n"); return;}
            ;
Decls       :
            |   VAR  ABCHAV {printf("\n"); tabular(); printf("var {\n"); tab++;} ListDecl FCHAV {tab--; tabular(); printf("}\n");}
            ;
ListDecl    :   Declaracao
            |   ListDecl Declaracao
            ;
Declaracao  :   {tabular();} Tipo ABPAR {printf("(");} ListElem FPAR {printf(")\n");}
            ;
Tipo        :   INT {printf("int ");}
            |   REAL {printf("real ");}
            |   CARAC {printf("carac");}
            |   LOGIC {printf("logic");}
            ;
ListElem    :   Elem
            |   ListElem VIRG {printf(", ");} Elem
            ;
Elem        :   ID {printf("%s", $1);} Dims
            ;
Dims        :   
            |   ABCOL {printf("[");} ListDim FCOL {printf("]");}
            ;
ListDim     :   CTINT {printf("%d", $1);}
            |   ListDim VIRG CTINT {printf(", %d", $3);}
            ;
ListMod     :
            |   ListMod Modulo
            ;
Modulo      :   Cabecalho {printf("\n"); tab++;} Corpo {printf("\n"); tab--;}
            ;
Cabecalho   :   {printf("\n"); tabular(); printf("funcao ");} CabFunc
            |   CabProc
            ;
CabFunc     :   FUNCAO Tipo ID ABPAR FPAR {printf("%s ()", $3);}
            |   FUNCAO Tipo ID ABPAR {printf(" %s (", $3);} ListParam FPAR {printf(")");} 
            ;
CabProc     :   PROCEDIMENTO   ID  ABPAR  FPAR  {printf("\n"); tabular(); printf("procedimento %s ()", $2);}
            |   PROCEDIMENTO   ID  ABPAR {printf("\n"); tabular(); printf("procedimento %s (", $2);} ListParam  FPAR {printf(")");}
            ;
ListParam   :   Parametro
            |   ListParam VIRG {printf(", ");} Parametro
            ;
Parametro   :   Tipo ID {printf("%s", $2);}
            ;
Corpo       :   Decls Comandos 
            ;
ModPrincipal:   {printf("\n"); tabular();} PRINCIPAL {printf("principal \n"); tab++;}  Corpo {printf("\n"); tab--;}
            ;
Comandos    :   COMANDOS {printf("\n"); tabular(); printf("comandos "); tab++;}  CmdComp {tab--;}
            ;
CmdComp     :   ABCHAV {printf("{");} ListCmd FCHAV {printf("\n"); tab--; tabular(); printf("}"); tab++;}
            ;
ListCmd     :   
            |   ListCmd Comando
            ;
Comando     :   CmdComp
            |   {printf("\n"); tabular();} CmdSe
            |   {printf("\n"); tabular();} CmdEnquanto
            |   {printf("\n"); tabular();} CmdRepetir
            |   {printf("\n"); tabular();} CmdPara
            |   {printf("\n"); tabular();} CmdLer
            |   {printf("\n"); tabular();} CmdEscrever
            |   {printf("\n"); tabular();} CmdAtrib
            |   {printf("\n"); tabular();} ChamadaProc
            |   {printf("\n"); tabular();} CmdRetornar
            |   PVIG {printf("aaaa;");} 
            ;
CmdSe       :   SE   ABPAR {printf("se (");}  Expressao  FPAR {printf(") "); tab++;} Comando  CmdSenao {tab--;} 
            ;   
CmdSenao    :  
            |  SENAO   {tab--; printf("\n"); tabular(); printf("senao "); tab++;} Comando
            ;
CmdEnquanto :  ENQUANTO   ABPAR  {printf("enquanto (");} Expressao  FPAR {printf(") "); tab++;} Comando {tab--;} 
            ;
CmdRepetir  :  REPETIR {printf("repetir \n"); tab++;} Comando  ENQUANTO ABPAR {printf("enquanto (");} Expressao  FPAR  PVIG {printf(");");} 
            ;
CmdPara     :  PARA {printf("para ");} Variavel  ABPAR {printf(" (");}  ExprAux4  PVIG {printf("; ");}  Expressao  PVIG {printf("; ");} ExprAux4  FPAR {printf(") "); tab++;} Comando {tab--;}
            ;
CmdLer      :  LER   ABPAR  {printf("ler (");} ListLeit  FPAR  PVIG {printf(");");} 
            ;        
ListLeit    :  Variavel  
            |  ListLeit  VIRG {printf(", ");} Variavel 
            ;  
CmdEscrever :  ESCREVER   ABPAR {printf("escrever (");} ListEscr  FPAR  PVIG {printf(");");}  
            ;    
ListEscr    :  ElemEscr  
            |  ListEscr  VIRG {printf(", ");} ElemEscr 
            ;    
ElemEscr    :  CADEIA {printf("%s", $1);}
            |  Expressao 
            ;    
ChamadaProc :  CHAMAR   ID  ABPAR {printf("chamar %s (", $2);} Argumentos  FPAR  PVIG  {printf(");");}
            ;    
Argumentos  :  
            |  ListExpr 
            ;
CmdRetornar :  RETORNAR   PVIG  {printf("retornar ;");} 
            |  RETORNAR {printf("retornar ");} Expressao  PVIG {printf(";");}  
            ;        
CmdAtrib    :  Variavel  ATRIB {printf(" = ");}  Expressao  PVIG {printf(";");} 
            ;
ListExpr    :  Expressao 
            |  ListExpr  VIRG {printf(", ");} Expressao 
            ;    
Expressao   :  ExprAux1 
            |  Expressao  OR {printf(" || ");} ExprAux1 
            ;    
ExprAux1    :  ExprAux2 
            |  ExprAux1  AND {printf(" && ");} ExprAux2 
            ;    
ExprAux2    :  ExprAux3 
            |  NOT {printf("!");} ExprAux3 
            ;    
ExprAux3    :  ExprAux4 
            |  ExprAux4  OPREL {
                switch($2) {
                    case LT:
                        printf(" < ");
                    break;
                    case LEQ:
                        printf(" <= ");
                    break;
                    case GT:
                        printf(" > ");
                    break;
                    case GEQ:
                        printf(" >= ");
                    break;
                    case EQ:
                        printf(" == ");
                    break;
                    case NEQ:
                        printf(" != ");
                    break;
                }
            } ExprAux4 
            ;    
ExprAux4    :  Termo 
            |  ExprAux4  OPAD {
                switch($2) {
                    case SOMA:
                        printf(" + ");
                    break;
                    case SUB:
                        printf(" - ");
                    break;
                }
            } Termo 
            ;    
Termo       :  Fator 
            |  Termo  OPMULT {
                switch($2) {
                    case MULT:
                        printf(" * ");
                    break;
                    case DIV:
                        printf(" / ");
                    break;
                    case MOD:
                        printf(" % ");
                    break;
                }
            } Fator 
            ;    
Fator       :  Variavel 
            |  CTINT {printf("%d", $1);}
            |  CTREAL {printf("%.4f", $1);}
            |  CTCARAC {printf("%s", $1);}
            |  VERDADE  {printf("verdade");}
            |  FALSO  {printf("falso");}
            |  NEG {printf("~");} Fator 
            |  ABPAR  Expressao  FPAR 
            |  ChamadaFunc 
            ;
Variavel    :  ID {printf("%s", $1);} Subscritos 
            ;    
Subscritos  :  
            |  ABCOL {printf("[");}  ListSubscr  FCOL  {printf("]");}
            ;    
ListSubscr  :  ExprAux4 
            |  ListSubscr  VIRG {printf(", ");}  ExprAux4 
            ;    
ChamadaFunc :   ID  ABPAR  {printf("%s (", $1);} Argumentos  FPAR {printf(")");} 
            ;

%%
#include "lex.yy.c"

void tabular() {
    int i;
    for (i = 1; i <= tab; i++) {
        printf("   ");
    }
}