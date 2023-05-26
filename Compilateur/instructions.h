#define SIZE 1000

typedef struct instruction {
    char name[16];
    char arg1[3];
    char arg2[3];
    char arg3[3];
} instruction;

instruction* init_ti();

void add_instr(instruction* ti, char* name, char* arg1, char* arg2, char* arg3);
int get_ti_size();

void print_ti(instruction* ti);
void print_instr(instruction i, int indice);

char * ti_to_string(instruction i);
char get_op_code(instruction i);
void write_from_table(instruction * ti);