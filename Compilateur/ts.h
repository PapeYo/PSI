#define SIZE 1000

typedef struct symbol {
    char var_name[16];
    char var_type[16];
    int init;
    int depth;
    int var_value;
} symbol;

void yyerror(char *s);
void yywarning(char *s);

symbol* init_table();

char * add_symbol(symbol* tab, char* name, char* type, int declared_symbol);
void delete_symbol(symbol* tab);

symbol get_symbol(symbol* tab, char* name);
char* get_addr(symbol* ts, char* name, int mode);
char* pop_addr(symbol* tab);
symbol pop_symbol(symbol* tab);

char * pop_check_symbol(symbol * ts, int errno);
void raise_def_error(symbol * ts, char* name);

void print_ts(symbol* tab);
void print_symbol(symbol s);
int get_table_size();

void increase_depth();
void decrease_depth();