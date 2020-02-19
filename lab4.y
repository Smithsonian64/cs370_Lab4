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
#include "lex.yy.c"
#include "symtable.h"

int regs[26];
int base, debugsw;
int offset = 0;

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
%token DISPLAY
%token SEARCH
%token MODIFY

%left '|'
%left '&'
//%left '+' '-'
%left '%'
//%left '*' '/' '%'

%type<value> expr INTEGER
%type<string> VARIABLE

%nonassoc UMINUS

%%	/* end specs, begin rules */

p	:	/*empty*/
  	|	decls list
	;

decls	: 	/*empty*/
      	|	decls dec
	;

dec	:	INT VARIABLE ';' '\n'
    			{
				Insert("INT", "temp", 0, offset++);
			}
    	|	INT expr '=' expr ';' '\n'	
    			{	
				Insert("INT", $2, $4, offset++);
			}
    	;

list	:	/* empty */
	|	list stat '\n'
	|	list error '\n'
	|	list command '\n'
			{ 
				yyerrok; 
			}
	;

stat	:	expr
			{ 
				fprintf(stderr,"the anwser is %d\n", $1); 
			}
	|	VARIABLE '=' expr
			{ 
				if(Search($1)==1) Modify($1, $3);
				else puts("label does not exist"); 
			}
	;

command	:	DISPLAY
			{
				Display();
			}
	|	SEARCH VARIABLE
			{
				if(Search($2)==1)puts("true");
				else(puts("false"));
			}
	|	MODIFY VARIABLE expr
			{
				Modify($2, $3);
				printf("changed %s to %d\n", $2, $3);
			}
	;

expr	:	'(' expr ')'
			{ 
				$$ = $2; 
			}
		VARIABLE '=' VARIABLE
			{
				/*Modify($1, */
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
	|	expr '%' expr
			{ 
				$$ = $1 % $3; 
			}
	|	expr '&' expr
			{ 
				$$ = $1 & $3; 
			}
	|	expr '|' expr
			{
				$$ = $1 | $3; 
			}
	|	MINUS expr	%prec UMINUS
			{ 
				$$ = -$2; 
			}
	|	VARIABLE
			{ 
				$$ = $1; 
			}
	|	INTEGER {
				$$=$1;
			}
	;




%%	/* end of rules, start of program */

int main(void) { 
	
	yyparse();
	return 1;
}
