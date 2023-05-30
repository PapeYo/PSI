#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"

int size = 0;
int depth_max = 0;
extern int yylineno;

// initialize a symbol table
symbol* init_table() {
    return malloc(SIZE*sizeof(symbol*));
}

// adds a symbol to the table
char * add_symbol(symbol* tab, char* name, char* type, int declared_symbol) {
    if (size >= SIZE) {
        yyerror("Stack overflow\n");
    }
    symbol s = {init :declared_symbol, depth:depth_max};
    strcpy(s.var_name, name);
    strcpy(s.var_type, type);
    tab[size] = s;
    size++;
    char * addr_size = malloc(3);
    sprintf(addr_size, "%d", size-1);
    return addr_size;
}

// deletes symbols from the symbol table
void delete_symbol(symbol * tab) {
    int i;
    int nb = 0;
    for (i=0; i < size; i++) {
        symbol s = tab[i];
        if (s.depth == depth_max) {
            nb++;
        }
    }
    size -= nb;
}

// Gets symbol by its name
symbol get_symbol(symbol* tab, char* name) {
    int i;
    for (i = 0; i < size; i++) {
        if (strcmp(tab[i].var_name, name) == 0) {
            return tab[i];
        }
    }
    // Variable not found, add uninitialized symbol with default value 0 to the table
    if (size >= SIZE) {
        yyerror("Stack overflow\n");
    }
    symbol s = { init: 1, depth: depth_max };
    strcpy(s.var_name, name);
    strcpy(s.var_type, "int");
    s.var_value = 0;
    tab[size] = s;
    size++;
    return s;
}

// Gets symbol address by its name
char* get_addr(symbol* tab, char* name, int mode) {
    int i;
    for (i = 0; i < size; i++) {
        if (strcmp(tab[i].var_name, name) == 0) {
            char* i_addr = malloc(3);
            sprintf(i_addr, "%d", i);
            return i_addr;
        }
    }
    if (size >= SIZE) {
        yyerror("Stack overflow\n");
    }
    symbol s = { init: 1, depth: depth_max };  
    strcpy(s.var_name, name);
    strcpy(s.var_type, "int"); 
    s.var_value = 0; 
    tab[size] = s;
    size++;
    if (mode == 0) {
        char* error = malloc(100);
        sprintf(error, "[%d] ERROR: Unknown symbol <%s>.\n", yylineno, name);
        yyerror(error);
        exit(-1);
    }
    return "-1";
}

// Removes last symbol and returns the new last address
char * pop_addr(symbol* tab) {
    if (size == 0) {exit(-1);}
    size--;
    char * addr_size = malloc(3);
    sprintf(addr_size, "%d", size);
    return addr_size;
}

// Removes last symbol and returns the new last symbol
symbol pop_symbol(symbol* tab) {
    if (size == 0) {exit(-1);}
    size--;
    return tab[size];
}

/*
 * Checks that given symbol is correct
 * Called function rigth after depiling
 * 0 -> result_end
 * 1 -> result_condition
 * 2 -> tmp_if
*/
// pops a symbol from the symbol table, and returns the address of the symbol
char * pop_check_symbol(symbol * ts, int errno) {
   symbol s = pop_symbol(ts);
   char * expected_name = malloc(20);
   char * error = malloc(30);
   switch (errno) {
        case 0:
            if (!(strcmp(s.var_name, "result_end") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: Unexpected statement before condition.\n", yylineno);
                yyerror(error);
            }
            break;
        case 1:
            if (!(strcmp(s.var_name, "result_condition") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: An unexpected error occurred.\n", yylineno);
                yyerror(error);
            }
            break;
        case 2:
            if (!(strcmp(s.var_name, "tmp_if") == 0)) {
                char * error = malloc(100);
                sprintf(error, "[%d] ERROR: An unexpected error occurred.\n", yylineno);
                yyerror(error);
            }
            break;
        default:
            break;
   }
   char * s_addr = malloc(3);
   sprintf(s_addr, "%d", get_table_size());
   free(expected_name);
   free(error);
   return s_addr;
}

// Raises an error if trying to redefine an existing symbol
void raise_def_error(symbol * ts, char* name) {
    if (strcmp(get_addr(ts, name, 1), "-1") != 0) {
        char * error = malloc(100);
        sprintf(error, "[%d] ERROR: Redefinition of <%s>.\n", yylineno, name);
        yyerror(error);
    }
}

// prints the symbol table
void print_ts(symbol* tab) {
    int i;
    for (i=0; i < size; i++) {
        print_symbol(tab[i]);
        printf("\n");
    }
}

// prints the details of a symbol
void print_symbol(symbol s) {
    printf("Name : %-16s\t", s.var_name);
    printf("Type : %s\t", s.var_type);
    printf("Depth : %d\t", s.depth);
    printf("Init : %d\t", s.init);
    printf("\n");
}
    
// returns the size of the symbol table
int get_table_size() {
    return size;
}

// Increases symbol table's depth by 1
void increase_depth() {
    depth_max++;
}

// Decreases symbol table's depth by 1
void decrease_depth() {
    depth_max-- ;
}