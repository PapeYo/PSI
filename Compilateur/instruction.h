#define SIZE 1000

typedef struct instr {
    char instr_name[20];
    char arg1[3];
    char arg2[3];
    char arg3[3];
} instr;

instr* init_ti();

void add_instr(instr* tab, char* nom, char* arg1, char* arg2, char* arg3);
int get_ti_size();

void print_ti(instr* tab);
void print_instr(instr i, int indice);

char * ti_to_string(instr i);
char get_op_code(instr i);
void write_in_file(instr * ti);

void interpreter(instr *t, int ti_size);
void print_interpreter();