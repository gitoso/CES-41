#!/bin/bash
./clean.sh
flex lexico.l
yacc sintatico-semantico.y
gcc y.tab.c main.c yyerror.c -o sintatico-semantico -lfl
./sintatico-semantico < exemplos/testeErros.comp > exemplos/testeErros.dat
./sintatico-semantico < exemplos/completo.comp > exemplos/completo.dat
./sintatico-semantico < exemplos/completo-inline.comp > exemplos/completo-inline.dat
