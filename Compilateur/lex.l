%{
#include <stdlib.h>
#include <stdio.h>
#include "parser.tab.h"
%}

%option noyywrap
%option noinput
%option nounput
%option yylineno

INTEGER             [0-9]+
HEX_INT             "0x"[0-9A-F]+
IDENTIFIERS         [a-zA-Z][a-z0-9]*
OLC                 "//".*\n
MLC_START           "/*"
MLC_TXT             (.|\n)*
MLC_END             "*/"

%%

"if"                            {return tIF;}
"else if"                       {return tELIF;}
"else"                          {return tELSE;}
"while"                         {return tWHILE;}
"for"                           {return tFOR;}
"print"                         {return tPRINT;}
"return"                        {return tRETURN;}
"int"                           {return tINT;}
"string"                        {return tSTRING;}
"const"                         {return tCONST;}
"void"                          {return tVOID;}
"main"                          {return tMAIN;}
{IDENTIFIERS}                   {return tID;}
{INTEGER}                       {return tNB;}
{HEX_INT}                       {return tNB;}
[ \n]+                          { } /* ignores whitespaces and new lines */
{OLC}                           { } /* ignores one line comment */
{MLC_START}{MLC_TXT}{MLC_END}   { } /* ignores multi line comment */
"+"                             {return tADD;}
"-"                             {return tSUB;}
"*"                             {return tMUL;}
"/"                             {return tDIV;}
"<"                             {return tLT;}
">"                             {return tGT;}
"!="                            {return tNE;}
"=="                            {return tEQ;}
">="                            {return tGE;}
"<="                            {return tLE;}
"="                             {return tASSIGN;}
"&&"                            {return tAND;}
"||"                            {return tOR;}
"!"                             {return tNOT;}
"{"                             {return tLBRACE;}
"}"                             {return tRBRACE;}
"("                             {return tLPAR;}
")"                             {return tRPAR;}
";"                             {return tSEMI;}
","                             {return tCOMMA;}
.                               { }

%%