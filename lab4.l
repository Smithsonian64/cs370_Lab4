/*                 
Small LEX routine which returns two formal tokens (INTEGER and VARIABLE)
along with single string elements like '+'.

This LEX definition is the companion to the docalc.y YACC routine which
is a simple calculator

                   Modified by Michael Smith
                   February 2020

Changes:
-added lex catches for right parentheses '(' and right parentheses ')' and
 returns them to yacc


*/
%{
int mydebug=0;
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}


%%

"regs"		{	
			if (mydebug) fprintf(stderr,"REGS found\n"); 
			return (REGS);
		}

"help"		{
			if (mydebug) fprintf(stderr,"HELP found\n"); 
			return (HELP);
		}

"search"	{
			if (mydebug) fprintf(stderr,"SEARCH found\n"); 
			return (SEARCH);
		}

"delete"	{
			if (mydebug) fprintf(stderr,"DELETE found\n"); 
			return (DELETE);
		}

"display"	{
			if (mydebug) fprintf(stderr,"DISPLAY found\n"); 
			return (DISPLAY);
		}

"int"		{
			if (mydebug) fprintf(stderr,"INT found\n"); 
			return (INT);
		}

[a-zA-Z][a-zA-Z]*	{
			if (mydebug) fprintf(stderr,"VARIABLE found\n"); 
			yylval.string=strdup(yytext); 
			return(VARIABLE);
		}

[0-9][0-9]*	{
			if (mydebug) fprintf(stderr,"INTEGER found\n"); 
			yylval.value=atoi((const char *)yytext); 
			return(INTEGER);
		}

[ \t]		{
			if (mydebug) fprintf(stderr,"Whitespace found\n");
		}

[=\;] 	{
			if (mydebug) fprintf(stderr,"return a token %c\n",*yytext); 
                       	return (*yytext);
		}

"\+"		{
			if(mydebug) fprintf(stderr, "found PLUS\n");
			return PLUS;
		}
 
"\*"		{	if(mydebug) fprintf(stderr, "found MULT\n");
			return MULT;
		}

"\-"		{
			if(mydebug) fprintf(stderr, "found MINUS\n");
			return MINUS;
		}

"\/"		{
			if(mydebug) fprintf(stderr, "found DIV\n");
			return DIV;
		}

"\&"		{
			if(mydebug) fprintf(stderr, "found AND\n");
			return AND;
		}

"\|"		{
			if(mydebug) fprintf(stderr, "found OR\n");
			return OR;
		}

"\%"		{
			if(mydebug) fprintf(stderr, "found MODULUS\n");
			return MODULUS;
		}

[(]		{	
			if (mydebug) fprintf(stderr,"Open parentheses found\n");
			return (*yytext);
		}

[)]		{
			if (mydebug) fprintf(stderr,"Close parentheses found\n");
			return (*yytext);}

\n 		{ 
			if (mydebug) fprintf(stderr,"carriage return %c\n",*yytext); 
                       	return (*yytext);
		}

%%

int yywrap(void)
{ return 1;}


