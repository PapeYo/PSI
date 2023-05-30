#define SIZE 1000

/**
 * Instruction type
*/
typedef struct instr {
    char instr_name[30];
    char arg1[3];
    char arg2[3];
    char arg3[3];
} instr;

/**
 * Init the instruction table
*/
instr* init_ti();

/**
 * Add an instruction to the table
*/
void add_instr(instr* tab, char* nom, char* arg1, char* arg2, char* arg3);

/**
 * Get the size of (number of instructions in) the table
*/
int get_ti_size();

/**
 * Display the instruction table
*/
void print_ti(instr* tab);

/**
 * Display an instruction
*/
void print_instr(instr i, int indice);

/**
 * Converts an instruction into a string
*/
char * ti_to_string(instr i);

/**
 * Converts the operation into a code
*/
char get_op_code(instr i);

/**
 * Write instructions in a file
*/
void write_in_file(instr * ti);

void interpreter(instr *t, int ti_size);
void print_interpreter();