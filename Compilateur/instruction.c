#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "instruction.h"

int ti_size = 0;
int REG[20];

instr* init_ti() {
    return malloc(SIZE*sizeof(instr));
}

// adds a new instruction to the instruction table
void add_instr(instr* tab, char* name, char * arg1, char * arg2, char * arg3) {
    if (ti_size >= SIZE) printf("SIZE EXCEEDED\n");
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
    printf("Instr index - Instr Name - Argument 1 - Argument 2 - Argument 3\n");
    int i;
    for (i = 0; i < ti_size; i++) {
        print_instr(tab[i], i);
        printf("\n");
    }
}

// prints the details of an instruction structure
void print_instr(instr i, int index) {
    printf("%-16d %-13s %-12s %-12s %s", index, i.instr_name, i.arg1, i.arg2, i.arg3);
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
        return '0' + 1; 
	}
    else if (strcmp(i.instr_name, "MUL") == 0) {
        return '0' + 2;
    }
    else if (strcmp(i.instr_name, "SUB") == 0) {
        return '0' + 3;
    }
    else if (strcmp(i.instr_name, "DIV") == 0) {
        return '0' + 4;
    }
    else if (strcmp(i.instr_name, "COP") == 0) {
        return '0' + 5;
    }
    else if (strcmp(i.instr_name, "AFC") == 0) {
        return '0' + 6;
    }
    else if (strcmp(i.instr_name, "JMP") == 0) {
        return '0' + 7;
    }
    else if (strcmp(i.instr_name, "JMF") == 0) {
        return '0' + 8;
    }
    else if (strcmp(i.instr_name, "LT") == 0) {
        return '0' + 9;
    }
    else if (strcmp(i.instr_name, "GT") == 0) {
        return '0' + 10;
    }
    else if (strcmp(i.instr_name, "EQ") == 0) {
        return '0' + 11;
    }
    else if (strcmp(i.instr_name, "PRI") == 0) {
        return '0' + 12;
    }
    else if (strcmp(i.instr_name, "AND") == 0) {
        return '0' + 13;
    }
    else if (strcmp(i.instr_name, "OR") == 0) {
        return '0' + 14;
    }
    else if (strcmp(i.instr_name, "NOT") == 0) {
        return '0' + 15;
    }
    else if (strcmp(i.instr_name, "RET") == 0) {
        return '0' + 16;
    }
    else if (strcmp(i.instr_name, "NE") == 0) {
        return '0' + 17;
    }
    else if (strcmp(i.instr_name, "LE") == 0) {
        return '0' + 18;
    }
    else if (strcmp(i.instr_name, "GE") == 0) {
        return '0' + 19;
    }
    else {
        return '_';
    }
}

// Writes the instruction table in a file named "asm.txt"
void write_in_file(instr * ti) {
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

void interpreter(instr *t, int ti_size) {
    int i = 0;
    while (i < ti_size) {
        if (strcmp(t[i].instr_name, "ADD") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] + REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "MUL") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] * REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "SUB") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] - REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "DIV") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] / REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "COP") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )];

        else if (strcmp(t[i].instr_name, "AFC") == 0)
            REG[atoi(t[i].arg1)] = atoi(t[i].arg2 );

        else if (strcmp(t[i].instr_name, "JMP") == 0)
            i = t[i].arg1 - 1;

        else if (strcmp(t[i].instr_name, "JMF") == 0) {
            if (REG[atoi(t[i].arg1)] == 0)
                i = t[i].arg2 - 1;
        }
        else if (strcmp(t[i].instr_name, "LT") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] < REG[atoi(t[i].arg3)]);

        else if (strcmp(t[i].instr_name, "GT") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] > REG[atoi(t[i].arg3)]);

        else if (strcmp(t[i].instr_name, "EQ") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] == REG[atoi(t[i].arg3)]);

        else if (strcmp(t[i].instr_name, "PRI") == 0)
            printf("%d\n", REG[atoi(t[i].arg1)]);

        else if (strcmp(t[i].instr_name, "AND") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] && REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "OR") == 0)
            REG[atoi(t[i].arg1)] = REG[atoi(t[i].arg2 )] || REG[atoi(t[i].arg3)];

        else if (strcmp(t[i].instr_name, "NOT") == 0)
            REG[atoi(t[i].arg1)] = !REG[atoi(t[i].arg2 )];

        else if (strcmp(t[i].instr_name, "RET") == 0)
            return;

        else if (strcmp(t[i].instr_name, "NE") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] != REG[atoi(t[i].arg3)]);

        else if (strcmp(t[i].instr_name, "LE") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] <= REG[atoi(t[i].arg3)]);

        else if (strcmp(t[i].instr_name, "GE") == 0)
            REG[atoi(t[i].arg1)] = (REG[atoi(t[i].arg2 )] >= REG[atoi(t[i].arg3)]);
        i++;
    }
}

void print_interpreter(){
    printf("\n");
    for (int i = 0; i < 20; i++){
        printf("REG [ %d ] = %d \n", i, REG[i]);
    }
}