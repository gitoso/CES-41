%{
#include <stdio.h>
#include <stdlib.h>

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

%token    <valor>    ID
%token    <valor>    CTINT
%token    <carac>    CTCARAC
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

Prog        :   PROGRAMA  ID ABTRIP  Decls ListMod ModPrincipal FTRIP {printf("\n\nPrograma Compilado com Sucesso!\n\n"); return;}
            ;
Decls       :
            |   VAR  ABCHAV ListDecl FCHAV
            ;
ListDecl    :   Declaracao
            |   ListDecl Declaracao
            ;
Declaracao  :   Tipo ABPAR ListElem FPAR
            ;
Tipo        :   INT 
            |   REAL 
            |   CARAC
            |   LOGIC 
            ;
ListElem    :   Elem
            |   ListElem VIRG Elem
            ;
Elem        :   ID Dims
            ;
Dims        :   
            |   ABCOL ListDim FCOL
            ;
ListDim     :   CTINT
            |   ListDim VIRG CTINT
            ;
ListMod     :
            |   ListMod Modulo
            ;
Modulo      :   Cabecalho Corpo
            ;
Cabecalho   :   CabFunc
            |   CabProc
            ;
CabFunc     :   FUNCAO  Tipo ID ABPAR FPAR
            |   FUNCAO  Tipo ID ABPAR ListParam FPAR
            ;
CabProc     :   PROCEDIMENTO   ID  ABPAR  FPAR   
            |   PROCEDIMENTO   ID  ABPAR  ListParam  FPAR
            ;
ListParam   :   Parametro
            |   ListParam VIRG Parametro
            ;
Parametro   :   Tipo ID 
            ;
Corpo       :   Decls Comandos 
            ;
ModPrincipal:   PRINCIPAL  Corpo 
            ;
Comandos    :   COMANDOS  CmdComp 
            ;
CmdComp     :   ABCHAV ListCmd FCHAV
            ;
ListCmd     :   
            |   ListCmd Comando 
            ;
Comando     :   CmdComp 
            |   CmdSe 
            |   CmdEnquanto 
            |   CmdRepetir 
            |   CmdPara 
            |   CmdLer 
            |   CmdEscrever 
            |   CmdAtrib 
            |   ChamadaProc 
            |   CmdRetornar 
            |   PVIG 
            ;
CmdSe       :   SE   ABPAR  Expressao  FPAR  Comando  CmdSenao 
            ;   
CmdSenao    :  
            |  SENAO   Comando 
            ;
CmdEnquanto :  ENQUANTO   ABPAR  Expressao  FPAR  Comando 
            ;
CmdRepetir  :  REPETIR   Comando  ENQUANTO   ABPAR  Expressao  FPAR  PVIG 
            ;
CmdPara     :  PARA   Variavel  ABPAR  ExprAux4  PVIG  Expressao  PVIG  ExprAux4  FPAR  Comando 
            ;
CmdLer      :  LER   ABPAR  ListLeit  FPAR  PVIG 
            ;        
ListLeit    :  Variavel  
            |  ListLeit  VIRG  Variavel 
            ;  
CmdEscrever :  ESCREVER   ABPAR  ListEscr  FPAR  PVIG  
            ;    
ListEscr    :  ElemEscr  
            |  ListEscr  VIRG  ElemEscr 
            ;    
ElemEscr    :  CADEIA 
            |  Expressao 
            ;    
ChamadaProc :  CHAMAR   ID  ABPAR  Argumentos  FPAR  PVIG  
            ;    
Argumentos  :  
            |  ListExpr 
            ;
CmdRetornar :  RETORNAR   PVIG  
            |  RETORNAR   Expressao  PVIG 
            ;        
CmdAtrib    :  Variavel  ATRIB  Expressao  PVIG 
            ;
ListExpr    :  Expressao 
            |  ListExpr  VIRG  Expressao 
            ;    
Expressao   :  ExprAux1 
            |  Expressao  OR  ExprAux1 
            ;    
ExprAux1    :  ExprAux2 
            |  ExprAux1  AND  ExprAux2 
            ;    
ExprAux2    :  ExprAux3 
            |  NOT  ExprAux3 
            ;    
ExprAux3    :  ExprAux4 
            |  ExprAux4  OPREL  ExprAux4 
            ;    
ExprAux4    :  Termo 
            |  ExprAux4  OPAD  Termo 
            ;    
Termo       :  Fator 
            |  Termo  OPMULT  Fator 
            ;    
Fator       :  Variavel 
            |  CTINT 
            |  CTREAL 
            |  CTCARAC
            |  VERDADE  
            |  FALSO  
            |  NEG  Fator 
            |  ABPAR  Expressao  FPAR 
            |  ChamadaFunc 
            ;
Variavel    :  ID  Subscritos 
            ;    
Subscritos  :  
            |  ABCOL  ListSubscr  FCOL  
            ;    
ListSubscr  :  ExprAux4 
            |  ListSubscr  VIRG  ExprAux4 
            ;    
ChamadaFunc :   ID  ABPAR  Argumentos  FPAR 
            ;

%%
#include "lex.yy.c"

void tabular() {
    int i;
    for (i = 1; i <= tab; i++) {
        printf("    ");
    }
}