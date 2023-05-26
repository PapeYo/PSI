#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "instructions.h"

int ti_size = 0;

/**
 * Initialises the instruction table
*/
instruction* init_ti() {
    return malloc(SIZE*sizeof(instruction));
}

/**
 * Adds an instruction to the table
*/
void add_instr(instruction* ti, char* name, char* arg1, char* arg2, char* arg3) {
    if (ti_size >= SIZE) printf("TOO MANY INSTRUCTIONS !\n");
    instruction inst;
    strcpy(inst.name, name);
    strcpy(inst.arg1, arg1);
    strcpy(inst.arg2, arg2);
    strcpy(inst.arg3, arg3);
    ti[ti_size] = inst;
    ti_size++;
}

/**
 * Returns instruction table's size
*/
int get_ti_size() {
    return ti_size;
}

/**
 * Displays the instruction table's size
*/
void print_ti(instruction* ti) {
    int i;
    for (i=0; i < ti_size; i++) {
        print_instr(ti[i], i);
        printf("\n");
    }
}

/**
 * Displays an instruction
*/
void print_instr(instruction i, int indice) {
    printf("%d - %s %s %s %s", indice, i.name, i.arg1, i.arg2, i.arg3);
}

/**
 * Converts the instruction into a string
*/
char * ti_to_string(instruction i) {
	char * string = malloc(100);
	char op_code = get_op_code(i);
	sprintf(string, "%c %s %s %s", op_code, i.arg1, i.arg2, i.arg3);
	return string;
}

/**
 * Converts the instruction's name into an hexadecimal code
*/
char get_op_code(instruction i) {
	if (strcmp(i.name, "ADD") == 0) {
	    return '1';
	}
	else if (strcmp(i.name, "MUL") == 0) {
	    return '2';
	}
	else if (strcmp(i.name, "SUB") == 0) {
	    return '3';
	}
	else if (strcmp(i.name, "DIV") == 0) {
	    return '4';
	}
	else if (strcmp(i.name, "COP") == 0) {
	    return '5';
	}
	else if (strcmp(i.name, "AFC") == 0) {
	    return '6';
	}
	else if (strcmp(i.name, "JMP") == 0) {
	    return '7';
	}
	else if (strcmp(i.name, "JMF") == 0) {
	    return '8';
	}
	else if (strcmp(i.name, "LT") == 0) {
	    return '9';
	}
	else if (strcmp(i.name, "GT") == 0) {
	    return 'A';
	}
	else if (strcmp(i.name, "EQU") == 0) {
	    return 'B';
	}
	else if (strcmp(i.name, "PRI") == 0) {
	    return 'C';
	}
	else if (strcmp(i.name, "AND") == 0) {
	    return 'D';
	}
	else if (strcmp(i.name, "OR") == 0) {
	    return 'E';
	}
	else if (strcmp(i.name, "NOT") == 0) {
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

/**
 * Writes the instruction table in a file named "asm.txt"
*/
void write_from_table(instruction * ti) {
    FILE * fPtr;
    fPtr = fopen("asm.txt","w");
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