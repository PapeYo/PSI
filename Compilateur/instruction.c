#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "instruction.h"

int ti_size = 0;

instr* init_ti() {
    return malloc(SIZE*sizeof(instr));
}

// adds a new instruction to the instruction table
void add_instr(instr* tab, char* name, char * arg1, char * arg2, char * arg3) {
    if (ti_size >= SIZE) printf("TAILLE MAXIMALE DEPASSEE\n");
    instr i;
    strcpy(i.instr_name, name);
    strcpy(i.arg1, arg1);
    strcpy(i.arg2, arg2);
    strcpy(i.arg3, arg3);
    tab[ti_size] = i;
    ti_size++;
}

// returns the instruction table size
int get_ti_size() {
    return ti_size;
}

// prints the table instruction
void print_ti(instr* tab) {
    int i;
    for (i=0; i < ti_size; i++) {
        print_instr(tab[i], i);
        printf("\n");
    }
}

// prints the details of an instruction structure
void print_instr(instr i, int index) {
    printf("%d - %s %s %s %s", index, i.instr_name, i.arg1, i.arg2, i.arg3);
}

// converts an instruction into a string
char * ti_to_string(instr i) {
	char * string = malloc(100);
	char op_code = get_op_code(i);
	sprintf(string, "%c %s %s %s", op_code, i.arg1, i.arg2, i.arg3);
	return string;
}

// returns the opcode corresponding to a given instruction
char get_op_code(instr i) {
	if (strcmp(i.instr_name, "ADD") == 0) {
	    return '1';
	}
	else if (strcmp(i.instr_name, "MUL") == 0) {
	    return '2';
	}
	else if (strcmp(i.instr_name, "SUB") == 0) {
	    return '3';
	}
	else if (strcmp(i.instr_name, "DIV") == 0) {
	    return '4';
	}
	else if (strcmp(i.instr_name, "COP") == 0) {
	    return '5';
	}
	else if (strcmp(i.instr_name, "AFC") == 0) {
	    return '6';
	}
	else if (strcmp(i.instr_name, "JMP") == 0) {
	    return '7';
	}
	else if (strcmp(i.instr_name, "JMF") == 0) {
	    return '8';
	}
	else if (strcmp(i.instr_name, "LT") == 0) {
	    return '9';
	}
	else if (strcmp(i.instr_name, "GT") == 0) {
	    return 'A';
	}
	else if (strcmp(i.instr_name, "EQU") == 0) {
	    return 'B';
	}
	else if (strcmp(i.instr_name, "PRI") == 0) {
	    return 'C';
	}
	else if (strcmp(i.instr_name, "AND") == 0) {
	    return 'D';
	}
	else if (strcmp(i.instr_name, "OR") == 0) {
	    return 'E';
	}
	else if (strcmp(i.instr_name, "NOT") == 0) {
	    return 'F';
	}
	/*
	else if (strcmp(i.name, "NE") == 0) {
	    return '10';
	}
	else if (strcmp(i.name, "LE") == 0) {
	    return '11';
	}
	else if (strcmp(i.name, "GE") == 0) {
	    return '12';
	}*/
	else {
        return '_';
	}
}

// Writes the instruction table in a file named "asm.txt"
void write_from_table(instr * ti) {
	FILE * fPtr;
	fPtr = fopen("asm.txt", "w");
	if(fPtr == NULL) {
        	printf("Unable to create file.\n");
        	exit(EXIT_FAILURE);
    	}
	int i;
	for (i=0; i<ti_size; i++) {
		fputs(ti_to_string(ti[i]), fPtr);
		fputs("\n", fPtr);
	}
}