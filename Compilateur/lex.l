%{
#include <stdlib.h>
#include <stdio.h>
#include "parser.tab.h"
%}

%option noyywrap
%option noinput
%option nounput
%option yylineno

IDENTIFIERS   [a-zA-Z]+[a-zA-Z0-9|_]*
NUMBERS 	  [0-9]+(e[0-9]+)?
OLC  		  \/\/.*\n?
MLC           \/\*([^\*]|\*[^\/])*\*\/
%%

"if"          {return tIF;}
"else if"     {return tELIF;}    
"else"        {return tELSE;}
"while"       {return tWHILE;}
"for"         {return tFOR;}
"printf"      {return tPRINTF;}
"return"      {return tRETURN;}
"int"         {return tINT;}
"string"      {return tSTR;}
"const"       {return tCONST;}
"void"        {return tVOID;}
"main"        {return tMAIN;}
{IDENTIFIERS} {strcpy(yylval.varchar, yytext); return tID;}
{NUMBERS}     {yylval.nb = (int) strtold(yytext, NULL); return tNB;}
[ \t\n]+      {} /* Ignore whitespace characters */
{OLC}         {} /* Ignore one-line comments */
{MLC}         {} /* Ignore multi-line comments */ 
"+"           {return tADD;}
"-"           {return tSUB;}
"*"           {return tMUL;}
"/"           {return tDIV;}
"<"           {return tLT;}
">"           {return tGT;}
"!="          {return tNE;}
"=="          {return tEQ;}
">="          {return tGE;}
"<="          {return tLE;}
"="           {return tASSIGN;}
"&&"          {return tAND;}
"||"          {return tOR;}
"!"           {return tNOT;}
"{"           {return tLBRACE;}
"}"           {return tRBRACE;}
"("           {return tLPAR;}
")"           {return tRPAR;}
";"           {return tSEMI;}
","           {return tCOMMA;}
.		      {return tERR;}

%%

