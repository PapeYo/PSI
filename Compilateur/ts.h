#define SIZE 1000

/**
 * Symbol type
*/
typedef struct symbol {
    char var_name[16];
    char var_type[16];
    int init;
    int depth;
    int var_value;
} symbol;

void yyerror(char *s);
void yywarning(char *s);

/**
 * Init the symbol table
*/
symbol* init_table();

/**
 * Add a symbol to the table
*/
char * add_symbol(symbol* tab, char* name, char* type, int declared_symbol);

/**
 * Delete symbols at the actual depth
*/
void delete_symbol(symbol* tab);

/**
 * Get symbol ny its name
*/
symbol get_symbol(symbol* tab, char* name);

/**
 * Get symbol address by its name
*/
char* get_addr(symbol* ts, char* name, int mode);

/**
 * Remove last symbol and return the new last address
*/
char* pop_addr(symbol* tab);

/**
 * Remove last symbol and return the new last symbol
*/
symbol pop_symbol(symbol* tab);

/**
 * Checks that given symbol is correct
 * Called function rigth after depiling
 * 0 -> result_end
 * 1 -> result_condition
 * 2 -> tmp_if
*/
char * pop_check_symbol(symbol * ts, int errno);

/**
 * Raise an error if trying to redefine an existing symbol
*/
void raise_def_error(symbol * ts, char* name);

/**
 * Display the symbol table
*/
void print_ts(symbol* tab);

/**
 * Display a symbol detailed
*/
void print_symbol(symbol s);

/**
 * Get the size of (number of symbols in) the table
*/
int get_table_size();

/**
 * Increase actual depth by 1
*/
void increase_depth();

/**
 * Decrease actual depth by 1
*/
void decrease_depth();