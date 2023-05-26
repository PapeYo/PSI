#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"

int size = 0;
int depth_max = 0;
extern int yylineno;

/**
 * Initialises a symbol table
*/
symbol * init_table() {
    return malloc(SIZE*sizeof(symbol*));
}

/**
 * Adds a symbol to the table
*/
char * add_symbol(symbol * table, char * name, char * type, int decl) {
    if (size >= SIZE) {
        yyerror("Too many symbols ! \n");
    }
    symbol s = {init:decl, depth:depth_max};
    strcpy(s.name, name);
    strcpy(s.type, type);
    table[size] = s;
    size++;
    char * size_address = malloc(3);
    sprintf(size_address, "%d", size-1);
    return size_address;
}

/**
 * Removes all deepest symbols
*/
void delete_depth(symbol * table) {
    int i;
    int nb = 0;
    for (i=0; i<size; i++) {
        symbol s = table[i];
        if (s.depth == depth_max) {
            nb++;
        }
    }
    size -= nb;
}

/**
 * Gets symbol by its name
*/
symbol get_symbol(symbol* table, char* name) {
    int i;
    for (i=0; i < size; i++) {
        if (strcmp(table[i].name, name) == 0) {
            return table[i];
        }
    }
    char * error = malloc(100);
    sprintf(error, "[%d] ERROR: Unknown symbol <%s>.\n", yylineno, name);
    yyerror(error);
    exit(-1);
}

/**
 * Gets symbol address by its name
*/
char * get_address(symbol * table, char * name, int mode) {
    int i;
    for (i=0; i < size; i++) {
        if (strcmp(table[i].name, name) == 0) {
            char * i_addr = malloc(3);
            sprintf(i_addr, "%d", i);
            return i_addr;
        }
    }
    if (mode == 0) {
        char * error = malloc(100);
        sprintf(error, "[%d] ERROR: Unknown variable <%s>.\n", yylineno, name);
        yyerror(error);
    }
    return "-1";    
}

/**
 * Removes last symbol and returns the new last address
*/
char * depile_address(symbol * table) {
    if (size == 0) {exit(-1);}
    size--;
    char * size_address = malloc(3);
    sprintf(size_address, "%d", size);
    return size_address;
}

/**
 * Removes last symbol and returns the new last symbol
*/
symbol depile_symbol(symbol * table) {
    if (size == 0) {exit(-1);}
    size--;
    return table[size]; 
}

/*
 * Verify that given symbol is correct
 * Called function rigth after depiling
 * 0 -> result_end
 * 1 -> result_condition
 * 2 -> tmp_if
*/
char * depile_verify_symbol(symbol * table, int errno) {
    symbol s = depile_symbol(table);
    char * expected = malloc(20);
    char * error = malloc(30);
    switch (errno) {
        case 0:
            if (!(strcmp(s.name, "result_end") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: Unexpected statement before condition.\n", yylineno);
                yyerror(error);
            }
            break;
        case 1:
            if (!(strcmp(s.name, "result_condition") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: An unexpected error has occurred.\n", yylineno);
                yyerror(error);
            }
            break;
        case 2:
            if (!(strcmp(s.name, "tmp_if") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: An unexpected error has occurred.\n", yylineno);
                yyerror(error);
            }
            break;
            
        default:
            break;
    }
    // The symbol is correct, we return its address
    char * s_address = malloc(3);
    sprintf(s_address, "%d", get_table_size());
    free(expected);
    free(error);
    return s_address;
}

/**
 * Raises an error if trying to redefine an existing symbol
*/
void raise_def_error(symbol * table, char * name) {
    if (strcmp(get_address(table, name, 1), "-1") != 0) {
        char * error = malloc(100);
        sprintf(error, "[%d] ERROR: Redefinition of <%s>.\n", yylineno, name);
        yyerror(error);
    }
}

/**
 * Displays symbol table
*/
void print_table(symbol* table) {
    int i;
    for (i=0; i < size; i++) {
        print_symbol(table[i]);
        printf("\n");
    }
}

/**
 * Displays a symbol
*/
void print_symbol(symbol s) {
    printf("%s (%s, %d, %d) ", s.name, s.type, s.init, s.depth);
}

/**
 * Returns symbol table's size
*/
int get_table_size() {
    return size;
}

/**
 * Increases symbol table's depth by 1
*/
void increase_depth() {
    depth_max++;
}

/**
 * Decreases symbol table's depth by 1
*/
void decrease_depth() {
    depth_max-- ;
}