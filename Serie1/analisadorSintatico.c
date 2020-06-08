#include<stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

// Estruturas de dados
#define TRUE 1
#define FALSE 0
#define MAXCADEIA 30

enum tipos {
    ID,
	CTE,
	OPAD,
	ATRIB,
	ACHAV,
	FCHAV,
	APAR,
	FPAR,
	PVIRG,
	FINAL,
    INVAL
};

typedef int logic;

typedef union atribatomo {
	char *cadeia; int valor;
	char carac;
} atribatomo;

typedef struct atomo {
    int tipo;
    atribatomo atrib;
} atomo;

// Global Variables
logic erro;
FILE *program, *result;
char carac;
char *cadeia;
char nomearq[512], nomearqSaida[516];	
atomo atom;

// Funções do analisador léxico (headers)
atomo ClassificaCaractere();
atomo ClassificaCadeia();
atomo FormaNumero();
void FormaCadeia();
char NovoCarac ();
void NovoAtomo ();
void ImprimeAtomo();

// Funções do analisador léxico (definições)
atomo ClassificaCaractere() {
	atomo atomL;

	switch(carac) {
		case '+':
			atomL.tipo = OPAD;
			break;
		case '=':
			atomL.tipo = ATRIB;
			break;
		case '(':
			atomL.tipo = APAR;
			break;
		case ')':
			atomL.tipo = FPAR;
			break;
		case '{':
			atomL.tipo = ACHAV;
			break;
		case '}':
			atomL.tipo = FCHAV;
			break;
		case ';':
			atomL.tipo = PVIRG;
			break;
	}
	atomL.atrib.carac = carac;

	return atomL;
}

atomo ClassificaCadeia() {
	atomo atomL;
	size_t len = strlen(cadeia);

	atomL.tipo = ID;
	atomL.atrib.cadeia = (char *)malloc(len * sizeof(char));
	strncpy(atomL.atrib.cadeia, cadeia, len);
	return atomL;
}

atomo FormaNumero() {
	atomo atomL;

	atomL.tipo = CTE;
	atomL.atrib.valor = atoi(cadeia);
	return atomL;
}

void FormaCadeia() {
	size_t len = strlen(cadeia);
	cadeia[len] = carac;
	cadeia[len + 1] = '\0';
}

char NovoCarac () {
	char carac;
	carac = fgetc(program);
	if(carac != EOF)
		return carac;
	else
		return '\0';
}

void NovoAtomo () {
	int estado = 1;
	if (atom.tipo == ID) {
		free (atom.atrib.cadeia);
	}
	cadeia = malloc(MAXCADEIA * sizeof(char));
	*cadeia = 0;
	while (estado != 3) {
		switch (estado) {
			case 1: 
				switch(carac) {
					case '+':
					case '=':
					case '(':
					case ')':
					case '{':
					case '}':
					case ';':
						atom = ClassificaCaractere();
						carac = NovoCarac();
						estado = 3;
						break;

					case '\0':
						atom.tipo = FINAL;
						estado = 3;
						break;

					default:
						if(isalpha(carac)) {
							FormaCadeia();
							carac = NovoCarac();
							estado = 2;
						}
						else if(isdigit(carac)) {
							FormaCadeia();
							carac = NovoCarac();
							estado = 4;
						}
						else if((isspace(carac) || iscntrl(carac)) && carac != 0) {
							carac = NovoCarac();
							estado = 1;
						}
						else {
							atom.tipo = INVAL;
							atom.atrib.carac = carac;
							carac = NovoCarac();
							estado = 3;
						}
				} 
				break;
			case 2:
				if(isalpha(carac) || isdigit(carac)) {
					FormaCadeia();
					carac = NovoCarac();
					estado = 2;
				}
				else {
					atom = ClassificaCadeia();
					estado = 3;
				}
				break;
			case 4: 
				if(isdigit(carac)) {
					FormaCadeia();
					carac = NovoCarac();
					estado = 4;
				}
				else {
					atom = FormaNumero();
					estado = 3;
				}
				break;
		}
	}
	free (cadeia);
}

char* StrAtomo() {
    char *aux = (char *)malloc(MAXCADEIA * sizeof(char));
    switch (atom.tipo) {
        case ID:
            strcpy(aux, atom.atrib.cadeia);
            return aux;
        case CTE:
            sprintf(aux, "%d", atom.atrib.valor);
            return aux;
        case OPAD:
        case ATRIB:
        case ACHAV:
        case FCHAV:
        case APAR:
        case FPAR:
        case PVIRG:
        case INVAL:
            aux[0] = atom.atrib.carac;
            aux[1] = '\0';
            return aux;
        default:
            return "<<atomo inválido>>";
    }
}

// Funções do analisador sintatico (headers)
void Esperado(char *expected, char *message);
void ExecEaux();
void ExecTermo();
void ExecExpressao();
void ExecLCaux();
void ExecComando();
void ExecListCmd();
void ExecCmdComp();
void ExecProg();

// Funções do analisador sintatico (definições)
void Esperado(char *expected, char *message) {
    erro = TRUE;
    char *strAtomo = StrAtomo();
    fprintf(result, "[Error: Expected %s] Átomo: %s : %s\n", expected, strAtomo, message);
}

void ExecEaux() {
    int estado = 33;
    while (estado != 35) {
        switch (estado) {
            case 33:
                if (atom.tipo == OPAD) {
                    NovoAtomo();
                    estado = 34;
                }
                else {
                    // Nao faz nada
                    estado = 35;
                }
                break;
            case 34:
                ExecExpressao();
                estado = 35;
                break;
        }
    }
}

void ExecTermo() {
    int estado = 27;
    while (estado != 32) {
        switch (estado) {
            case 27: 
                if (atom.tipo == APAR) {
                    NovoAtomo();
                    estado = 28;
                }
                else if (atom.tipo == CTE || atom.tipo == ID) {
                    NovoAtomo();
                    estado = 32;
                }
                else {
                    estado = 30;
                }
                break;
            case 28:
                ExecExpressao();
                estado = 29;
                break;
            case 29:
                if (atom.tipo == FPAR) {
                    NovoAtomo();
                    estado = 32;
                }
                else {
                    estado = 31;
                }
                break;
            case 30:
                // Tratamento de erro
                if (atom.tipo == APAR) {
                    NovoAtomo();
                    estado = 28;
                }
                else if (atom.tipo == CTE || atom.tipo == ID || atom.tipo == FPAR) {
                    NovoAtomo();
                    estado = 32;
                }
                else {
                    Esperado("APAR or CTE or ID", "Termo inválido, deve ser uma expressão entre parênteses ou um número");
                    NovoAtomo();
                    estado = 30;
                }
                break;
            case 31:
                // Tratamento de erro
                if (atom.tipo == FPAR || atom.tipo == CTE || atom.tipo == ID) {
                    NovoAtomo();
                    estado = 32;
                }
                else if (atom.tipo == FINAL) {
                    estado = 32;
                }
                else {
                    Esperado("FPAR", "Imediatamente ao término de uma expressão deve haver um fechamento de parênteses");
                    NovoAtomo();
                    estado = 31;
                }
                break;
        }
    }
}

void ExecExpressao() {
    int estado = 24;
    while (estado != 26) {
        switch (estado) {
            case 24:
                ExecTermo();
                estado = 25;
                break;
            case 25:
                ExecEaux();
                estado = 26;
                break;
        }
    }
}

void ExecLCaux() {
    int estado = 22;
    while (estado != 23) {
        switch (estado) {
            case 22:
                if (atom.tipo == ID) {
                    ExecListCmd();
                }
                else {
                    estado = 23;
                }
                break;
        }
    }
}

void ExecComando() {
    int estado = 14;
    while (estado != 21) {
        switch (estado) {
            case 14:
                if (atom.tipo == ID) {
                    NovoAtomo();
                    estado = 15;
                }
                else {
                    estado = 18;
                }
                break;
            case 15:
                if (atom.tipo == ATRIB) {
                    NovoAtomo();
                    estado = 16;
                }
                else {
                    estado = 19;
                }
                break;
            case 16:
                ExecExpressao();
                estado = 17;
                break;
            case 17:
                if (atom.tipo == PVIRG) {
                    NovoAtomo();
                    estado = 21;
                }
                else {
                    estado = 20;
                }
                break;
            case 18:
                // Tratamento de Erros
                if (atom.tipo == ID) {
                    NovoAtomo();
                    estado = 15;
                }
                else if (atom.tipo == ATRIB) {
                    NovoAtomo();
                    estado = 16;
                }
                else if (atom.tipo == PVIRG) {
                    NovoAtomo();
                    estado = 21;
                }
                else if (atom.tipo == FINAL) {
                    estado = 21;
                }
                else {
                    Esperado("ID", "Um comando deve inicializar com um nome de variável (ID) válido");
                    NovoAtomo();
                    estado = 18;
                }
                break;
            case 19:
                // Tratamento de Erros
                if (atom.tipo == ATRIB) {
                    NovoAtomo();
                    estado = 16;
                }
                else if (atom.tipo == PVIRG) {
                    NovoAtomo();
                    estado = 21;
                }
                else if (atom.tipo == FINAL) {
                    estado = 21;
                }
                else {
                    Esperado("ATRIB", "Faltando átomo de atribuição (=)");
                    NovoAtomo();
                    estado = 19;
                }
                break;
            case 20:
                // Tratamento de Erros
                if (atom.tipo == PVIRG) {
                    NovoAtomo();
                    estado = 21;
                }
                else if (atom.tipo == FINAL) {
                    estado = 21;
                }
                else {
                    Esperado("PVIRG", "Um comando deve encerrar com ponto-vírgula (;)");
                    NovoAtomo();
                    estado = 20;
                }
                break;
        }
    }
}

void ExecListCmd() {
    int estado = 11;
    while (estado != 13) {
        switch (estado) {
            case 11:
                ExecComando();
                estado = 12;
                break;
            case 12:
                ExecLCaux();
                estado = 13;
                break;
        }
    }
}

void ExecCmdComp() {
    int estado = 5;
    while (estado != 10) {
        switch (estado) {
            case 5:
                if (atom.tipo == ACHAV) {
                    NovoAtomo();
                    estado = 6;
                }
                else {
                    estado = 8;
                }
                break;
            case 6:
                ExecListCmd();
                estado = 7;
                break;
            case 7:
                if (atom.tipo == FCHAV) {
                    NovoAtomo();
                    estado = 10;
                }
                else {
                    estado = 9;
                }
                break;
            case 8:
                // Tratamento de erros
                if (atom.tipo == ACHAV) {
                    NovoAtomo();
                    estado = 6;
                }
                else if (atom.tipo == FCHAV) {
                    NovoAtomo();
                    estado = 10;
                }
                else if (atom.tipo == FINAL) {
                    // Nao faz nada
                    Esperado("ACHAV", "Término inesperado");
                    estado = 10;
                }
                else {
                    Esperado("ACHAV", "Imediatamente após o nome do programa deve existir uma abertura de chaves");
                    NovoAtomo();
                    estado = 8;
                }
                break;
            case 9:
                // Tratamento de erros
                if (atom.tipo == FCHAV) {
                    NovoAtomo();
                    estado = 10;
                }
                else if (atom.tipo == FINAL) {
                    // Nao faz nada
                    Esperado("FCHAV", "Término inesperado");
                    estado = 10;
                }
                else {
                    Esperado("FCHAV", "Após os comandos o programa deve ser encerrado imediatamente com um fechamento de chaves");
                    NovoAtomo();
                    estado = 9;
                }
                break;
        }
    }
}

void ExecProg () {
    int estado = 1;
	while (estado != 4)
		switch (estado) {
			case 1:
				if (atom.tipo == ID) {
                    NovoAtomo ();
                    estado = 2;
                }
				else {
                    estado = 3;
                }
				break;
            case 2:
                ExecCmdComp();
                estado = 4;
                break;
            case 3:
                // Tratamento de erros
                if (atom.tipo == ID) {
                    NovoAtomo ();
                    estado = 2;
                }
                else if (atom.tipo == FINAL) {
                    // Nao faz nada
                    Esperado("ID", "Término inesperado");
                    estado = 4;
                }
                else {
                    Esperado ("ID", "O programa deve inicializar com um átomo do tipo ID");
                    NovoAtomo();
                    estado = 3;
                }
                break;
		}
} 


// Main Program
int main(int argc, char* argv[]) {
    printf ("=== A N A L I S E    S I N T A T I C A ===\n\n");
	printf ("Nome do arquivo: ");
	setbuf (stdin, NULL);
	fgets (nomearq, 511, stdin);
	strtok(nomearq, "\n");
	program = fopen (nomearq, "r");
    strcpy(nomearqSaida, nomearq);
    strcat(nomearqSaida, ".log");
	result = fopen (nomearqSaida, "w");
	erro = FALSE;
	carac = NovoCarac ();
	NovoAtomo ();
	ExecProg ();
	printf ("\nAnalise do arquivo '%s' encerrada!\n", nomearq);
	if (erro) {
		printf ("\nPrograma com erros!!!\n");
	    printf ("Ver analise no arquivo '%s'\n", nomearqSaida);
    }
    else {
        printf ("\nPrograma livre de erro sintático!\n");
        fprintf(result, "Programa livre de erro sintático!");
    }
    return 0;
}