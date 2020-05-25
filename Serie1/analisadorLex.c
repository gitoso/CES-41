#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

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

typedef union atribatomo {
	char *cadeia; int valor;
	char carac;
} atribatomo;

typedef struct atomo {
    int tipo;
    atribatomo atrib;
} atomo;

char nomearq[512];
FILE *program, *result;
char carac;
char *cadeia; 
atomo atom;

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

void ImprimeLinha() {
	fprintf(result, "+-----+---------+--------------------------------+\n");
}

void ImprimeHeader() {
	fprintf(result, "Arquivo de entrada: %s\n", nomearq);
	ImprimeLinha();
	fprintf(result, "| #ID | %-7s | %-30s |\n", "ATOMO", "VALOR");
	ImprimeLinha();
}

void ImprimeAtomo() {
	switch(atom.tipo) {
		case ID:
			fprintf(result, "| %-3d | %-7s | %-30s |\n", atom.tipo, "ID", atom.atrib.cadeia);
			break;
		case CTE:
			fprintf(result, "| %-3d | %-7s | %-30d |\n", atom.tipo, "CTE", atom.atrib.valor);
			break;
		case OPAD:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "OPAD", atom.atrib.carac);
			break;
		case ATRIB:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "ATRIB", atom.atrib.carac);
			break;
		case ACHAV:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "ACHAV", atom.atrib.carac);
			break;
		case FCHAV:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "FCHAV", atom.atrib.carac);
			break;
		case APAR:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "APAR", atom.atrib.carac);
			break;
		case FPAR:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "FPAR", atom.atrib.carac);
			break;
		case PVIRG:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "PVIRG", atom.atrib.carac);
			break;
		case FINAL:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "FINAL", ' ');
			break;
		case INVAL:
			fprintf(result, "| %-3d | %-7s | %-30c |\n", atom.tipo, "INVAL", atom.atrib.carac);
			break;
	}
	ImprimeLinha();
}

int main(int argc, char *argv[]) {
    printf ("=== A N A L I S E    L E X I C A ===\n\n");
	printf ("Nome do arquivo: ");
	setbuf (stdin, NULL);
	fgets (nomearq, 511, stdin);
	strtok(nomearq, "\n");
	program = fopen (nomearq, "r");
	result = fopen ("atomosmp", "w");
	atom.tipo = INVAL; 
	carac = NovoCarac ();
	ImprimeHeader();
	while(atom.tipo != FINAL){
		NovoAtomo ();
		ImprimeAtomo ();
	}
	printf ("\nAnalise do arquivo '%s' encerrada", 	nomearq);
	printf ("\n\nVer atomos no arquivo 'atomosmp'\n");
    return 0;
}