%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"
#include "instruction.h"

int varchar[16];
int yylex(); 
void yywarning(char *s);
extern int yylineno; 

symbol * ts;
instr * ti;
%}

%union {int nb; char varchar[16];}

%type <nb> VarType PreType Type 

%token tADD tSUB tMUL tDIV
%token tLT tGT tNE tEQ tGE tLE
%token tAND tOR tNOT
%token tLBRACE tRBRACE tLPAR tRPAR tSEMI tCOMMA
%token tIF tELSE tELIF tWHILE 
%token tPRINTF tRETURN tINT tVOID tASSIGN tFOR tCONST tSTR tMAIN tERR    
%token <nb> tNB
%token <varchar> tID

%left tADD tSUB tMUL tDIV
%left tOR tAND
%left tEQ tLT tGT

%start Program
%%

Program: Functions;

Functions: Function | Function Functions ;

Function: FunctionType FunctionName tLPAR DeclareArgs tRPAR tLBRACE Body tRBRACE |
          FunctionType FunctionName tLPAR DeclareArgs tRPAR tLBRACE Body Return tSEMI tRBRACE ;

Return: tRETURN RightOperand {
    char* return_value = pop_addr(ts);
    add_instr(ti, "RET", return_value, "_", "_");
};


CallFunction: tPRINTF tLPAR tID tRPAR {add_instr(ti, "PRI", get_addr(ts, $3, 0), "_", "_"); } |
    FunctionName tLPAR CallArgs tRPAR ;

DeclareArgs: VarType tID DeclArgNext |;

DeclArgNext: tCOMMA DeclareArgs |;

CallArgs: RightOperand CallArgNext |;

CallArgNext: tCOMMA CallArgs |;

PreType: tCONST { $$ = 1; } | { $$ = 0; } ;

Type: tINT { $$ = 10; } | tSTR { $$ = 20; } | tVOID { $$ = 00; };

FunctionType : Type;

VarType: PreType Type { $$ = $1 + $2; } ;

FunctionName: tMAIN | tID; 

Body: Lines;

Lines: Line Lines |;

Line: CallFunction tSEMI |
Declaration tSEMI | 
Assignment tSEMI | 
Condition tLBRACE {increase_depth();} Body tRBRACE {
    delete_symbol(ts);
    decrease_depth();
    symbol tmp_condition = pop_symbol(ts);
    int jmp_index = tmp_condition.init;
    char* ti_addr = malloc(4);
    if (strcmp(tmp_condition.var_name, "tmp_while") == 0) {
        sprintf(ti_addr, "%d", get_ti_size() + 1);
        char* jmp = malloc(4); // 
        sprintf(jmp, "%d", pop_symbol(ts).init);
        add_instr(ti, "JMP", jmp, "_", "_");
        free(jmp);
    } else {
        sprintf(ti_addr, "%d", get_ti_size() - 1);
    }
    strcpy(ti[jmp_index].arg2, ti_addr);
    free(ti_addr);
};

Declaration: VarType tID {
    char vartype[5];
    sprintf(vartype, "%d", $1);
    // raise_def_error(ts, $2);
    add_symbol(ts, $2, vartype, 0);
} |
VarType tID tASSIGN RightOperand {
    char * ro = pop_addr(ts); 
    char vartype[5];
    sprintf(vartype, "%d", $1);
    // raise_def_error(ts, $2);
    add_symbol(ts, $2, vartype, 1);
    add_instr(ti, "COP", get_addr(ts, $2, 0), ro, "_"); 
};

RightOperand: CallFunction | 
Operations  | 
tNB {
    char * nb_char = malloc(3);
    sprintf(nb_char, "%d", $1);
    add_instr(ti, "AFC", add_symbol(ts, "tmp", "tmp", 0), nb_char, "_");
} | 
tID {
    symbol s = get_symbol(ts, $1);
    if (s.init == 0) {
        char * error = malloc(100);
        sprintf(error, "[%d] ERROR: Variable <%s> has not been initialized.\n", yylineno, s.var_name);
        yyerror(error);
    }
    char * addr = get_addr(ts, s.var_name, 0);
    add_instr(ti, "COP", add_symbol(ts, "tmp", "tmp", 0), addr, "_");
};

Operations:
  Negative |
  Addition |
  Substraction |
  Division |
  Multiplication |
  And |
  Or |
  Equal |
  Lower |
  Greater | 
  Diff | 
  LowerEqual | 
  GreaterEqual ; 

Negative: tSUB RightOperand {
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "SUB", arg1, "0", arg2);
}; 

Substraction: RightOperand tSUB RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "SUB", arg1, arg2, arg3);
};

Addition: RightOperand tADD RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "ADD", arg1, arg2, arg3);
};

Division: RightOperand tDIV RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "DIV", arg1, arg2, arg3);
};

Multiplication: RightOperand tMUL RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "MUL", arg1, arg2, arg3);
};

And: RightOperand tAND RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "AND", arg1, arg2, arg3);
};

Or: RightOperand tOR RightOperand {
    char * arg3 = pop_addr(ts);
    char * arg2 = pop_addr(ts);
    char * arg1 = add_symbol(ts, "tmp", "tmp", 0);
    add_instr(ti, "OR", arg1, arg2, arg3);
};

Equal: RightOperand tEQ RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);    
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "EQU", result_egal, op1, op2);
};

Lower: RightOperand tLT RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "LT", result_egal, op2, op1);
};

Greater: RightOperand tGT RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "GT", result_egal, op2, op1);
};

Assignment : tID tASSIGN RightOperand {
    char * addr = get_addr(ts, $1, 0);
    add_instr(ti, "COP", addr, pop_addr(ts), "_");
    ts[strtol(addr, NULL, 10)].init = 1; // convertir char* en int
};

Diff: RightOperand tNE RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);    
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "NE", result_egal, op1, op2); 
};

LowerEqual: RightOperand tLE RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "LE", result_egal, op2, op1); 
};

GreaterEqual: RightOperand tGE RightOperand {
    char * op1 = pop_addr(ts);
    char * op2 = pop_addr(ts);
    char * result_egal = add_symbol(ts, "tmp", "result_condition", 0);
    add_instr(ti, "GE", result_egal, op2, op1); 
};

Condition:
  For |
  While |
  If |
  Elif |
  Else;

For: tFOR ForCondition ;
While: tWHILE {
    add_symbol(ts, "tmp_while2", "tmp", get_ti_size());
} 
ArgCondition {
    char * condition = pop_addr(ts);
    add_symbol(ts, "tmp_while", "tmp", get_ti_size());
    add_instr(ti, "JMF", condition, "-1", "_");
};

If: tIF ArgCondition {
    char * condition = pop_addr(ts);
    char * result_end = add_symbol(ts, "result_end", "tmp", 0);
    add_symbol(ts, "tmp_if", "tmp", get_ti_size());
    add_instr(ti, "JMF", condition, "-1", "_");
};

Elif: tELIF ArgCondition {
    char * cond_addr_elif = pop_addr(ts); 
    char * end_addr;
    end_addr = pop_check_symbol(ts, 0);
    char * result_end = add_symbol(ts, "result_end", "tmp", 0);
    char * result_condition = add_symbol(ts, "result_condition", "tmp", 0);
    char * result_not = add_symbol(ts, "tmp", "result_not", 0);
    add_instr(ti, "NOT", result_not, end_addr, "_");
    pop_addr(ts); 
    pop_addr(ts);
    add_instr(ti, "AND", result_condition, result_not, cond_addr_elif);
    add_instr(ti, "OR", result_end, result_condition, end_addr);
    add_symbol(ts, "tmp_if", "tmp", get_ti_size());
    add_instr(ti, "JMF", result_condition, "-1", "_");
};

Else: tELSE {
    char * end_addr;
    end_addr = pop_check_symbol(ts, 0);
    char * result_not = add_symbol(ts, "tmp", "result_not", 0);
    add_instr(ti, "NOT", result_not, end_addr, "_");
    pop_addr(ts); 
    add_symbol(ts, "tmp_if", "tmp", get_ti_size());
    add_instr(ti, "JMF", result_not, "-1", "_");
};

ArgCondition: tLPAR Boolean tRPAR;

ForCondition: tLPAR DeclarationIndex tSEMI Boolean tSEMI Assignment tRPAR;

DeclarationIndex: Assignment | tID;

Boolean: Operations |  
tID {
    add_instr(ti, "COP", add_symbol(ts, "tmp", "tmp", 0), get_addr(ts, $1, 0), "_");
};

%%
void yyerror(char *s) { 
    fprintf(stderr, "%s\n", s); free(s); exit(-1); }

void yywarning(char *s) { 
    printf("%s\n", s); }
    
int main(void) {
  // yydebug=1;
  printf("--------------\n");
  printf("Start Program !\n");
  ts = init_table();
  ti = init_ti();
  yyparse();
  printf("--------------\n");
  printf("Symbol table !\n");
  printf("--------------\n");  
  print_ts(ts);
  printf("--------------\n");
  printf("Instruction table !\n");
  printf("--------------\n");
  print_ti(ti);
  write_in_file(ti);
  int ti_size = get_ti_size();
  printf("--------------\n");
  printf("Interpreting code \n");
  printf("--------------\n");
  interpreter(ti, ti_size);
  printf("--------------\n");
  printf("Printing register table:\n");
  printf("--------------\n");
  print_interpreter();
  printf("--------------\n");
  printf("Valid syntax !\n");
  printf("--------------\n");
  return 0;
}