#define SIZE 1000

typedef struct symbol {
    char name[16];
    char type[16];
    int init;
    int depth;
} symbol;

void yyerror(char * s);

symbol * init_table();

char * add_symbol(symbol * table, char * name, char * type, int declare);
void delete_depth(symbol * table);

symbol get_symbol(symbol * table, char * name);
char * get_address(symbol * table, char * name, int mode);
char * depile_address(symbol * table);
symbol depile_symbol(symbol * table);

char * depile_verify_symbol(symbol * table, int errno);
void raise_def_error(symbol * table, char * name);

void print_table(symbol * table);
void print_symbol(symbol s);
int get_table_size();

void increase_depth();
void decrease_depth();