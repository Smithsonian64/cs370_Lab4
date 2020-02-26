%{

/*
 *			**** CALC ****
 *
 * This routine will function like a desk calculator
 * There are 26 integer registers, named 'a' thru 'z'
 *
 */

/* This calculator depends on a LEX description which outputs either VARIABLE or INTEGER.
   The return type via yylval is integer 

   When we need to make yylval more complicated, we need to define a pointer type for yylval 
   and to instruct YACC to use a new type so that we can pass back better values
 
   The registers are based on 0, so we substract 'a' from each single letter we get.

   based on context, we have YACC do the correct memmory look up or the storage depending
   on position

   Modified by Michael Smith
   February 2020

   This yacc routine uses return values provided by lex to produce values
   based on the defined grammar and return types.

   It will produce values just like a normal calculator based on character
   inputs from the user. It will throw syntax errors for obvious things
   like non mathmetical characters.

   Changes:
   -added grammar for expr '*' expr which allows multiplication to work
   -changed associativity for UMINUS to %nonassoc to allow the grammar
    '-' expr to work by allowing it to be the only legal grammar for
    negative numbers and any others whould be grammar for minus if not 
    blatant syntax errors
*/


	/* begin specs */
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>
#include "lex.yy.c"
#include "symtable.h"
#define MAX 3

int regs[26];
int base, debugsw;
int offset = 0;
int num = 0;
bool error = false;

void yyerror (s)  /* Called by yyparse on error */
     char *s;
{
  printf ("%s\n", s);
}


%}
/*  defines the start symbol, what values come back from LEX and how the operators are associated  */


%start p

%union {

	char * string;
	int value;

}

%token INT
%token INTEGER
%token VARIABLE
%token PLUS
%token MINUS
%token MULT
%token DIV
%token AND
%token OR
%token MODULUS
%token DISPLAY
%token DELETE
%token SEARCH
%token HELP
%token REGS

%left OR
%left AND
%left PLUS MINUS
%left MULT DIV MODULUS

%type<value> expr INTEGER
%type<string> VARIABLE

%nonassoc UMINUS

%%	/* end specs, begin rules */

p	:	/*empty*/
  	|	decls list
	;

decls	: 	/*empty*/
      	|	decls '\n'
      	|	decls command '\n'
      	|	decls dec
	|	decls error
			{
				puts("error, did nothing");
			}
	;

dec	:	INT VARIABLE ';' '\n'
    			{
				/*inserts variable into symbol table iff variable does not exist and 
				offset is not at MAX*/
				if(Search($2)==1) puts("variable already exists");
				else if(num >= MAX) puts("at max number of variables");
				else {
					regs[offset] = 0;
					Insert("INT", $2, offset++);
					num++;
				}
				
			}
    	|	INT VARIABLE '=' expr ';' '\n'	
    			{		
				/*inserts variable into symbol table iff variable does not exist and 
				offset is not at MAX. This declaration can be used to define a variable
				with a value within the declaration.*/
				if(Search($2)==1) puts("variable already exists");	
				else if(num >= MAX) puts("at max number of variables");
				else {
					regs[offset] = $4;
					Insert("INT", $2, offset++);
					num++;
				}
			}
    	;

list	:	/* empty */
     	|	list '\n'
	|	list stat '\n'
	|	list error '\n'
			{
				puts("did nothing instead");
			}
	|	list command '\n'
	|	list decls
	;

stat	:	expr
			{ 
				fprintf(stderr,"the anwser is %d\n", $1); 
			}
	|	VARIABLE
			{
				if(Search($1)!=1) puts("variable does not exist");
				else fprintf(stderr,"%d\n",regs[getAddress($1)]);
			}
	|	VARIABLE '=' expr
			{ 
				if(Search($1)==1 && error != true) {
					 regs[getAddress($1)] = $3;
				}
				else {
					puts("variable does not exist");
					error = false;
				} 
			}	
	|	VARIABLE '=' VARIABLE
			{ 
				if(Search($1)!=1) {
					puts("left side variable does not exist");
				}
				else if(Search($3)!=1) {
					puts("right side variable does not exist");
				}
				else {
					regs[getAddress($1)] = regs[getAddress($3)];
				}
			}
	;

command	:	HELP	
			{
				int c;
				FILE *helpFile;
				helpFile = fopen("help.txt", "r");
				if (helpFile) {
    				while ((c = getc(helpFile)) != EOF)
        				putchar(c);
    				fclose(helpFile);
}
			}
	|	DISPLAY
			{
				Display();
			}
	|	DELETE	VARIABLE
			{
				if(Search($2)!=1) puts("variable does not exist");
				else {
					Delete($2);
					num--;
				}
			}
	|	SEARCH VARIABLE
			{
				if(Search($2)==1)puts("true");
				else(puts("false"));
			}
	|	REGS
			{
				printf("\tregister\tvalue\n");
				for(int i = 0; i < MAX; i++) {
					printf("\t%d\t\t%d\n",i ,regs[i]);
				}
			}
	;

expr	:	'(' expr ')'
			{ 
				$$ = $2; 
			}
	|	expr MINUS  expr
			{ 
				$$ = $1 - $3; 
			}
	|	expr PLUS expr
			{ 
				$$ = $1 + $3; 
			} 
	|	expr MULT expr
			{ 
				$$ = $1 * $3; 
			}
	|	expr DIV expr
			{ 
				$$ = $1 / $3; 
			}
	|	expr MODULUS expr
			{ 
				$$ = $1 % $3; 
			}
	|	expr AND expr
			{ 
				$$ = $1 & $3; 
			}
	|	expr OR expr
			{
				$$ = $1 | $3; 
			}
	|	MINUS expr	%prec UMINUS
			{ 
				$$ = -$2; 
			}
	|	VARIABLE
			{ 
				if(Search($1)==0) {
					fprintf(stderr, "variable not in symbol table\n");
					error = true;
				}
				else {
					$$ = regs[getAddress($1)]; 
				}
			}
	|	INTEGER {
				$$=$1;
			}
	;


%%	/* end of rules, start of program */

int main(void) { 
	puts("Type \"help\" to see commands and instructions");	
	yyparse();
	return 1;
}
