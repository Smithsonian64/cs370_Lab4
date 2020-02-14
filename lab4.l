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

int mydebug=1;
#include "y.tab.h"
%}


%%

"int"		{return (INT);}

[a-z]		{if (mydebug) fprintf(stderr,"Letter found\n"); 
                       yylval=*yytext-'a'; return(VARIABLE);}
[0-9][0-9]*	{if (mydebug) fprintf(stderr,"Digit found\n"); 
                       	yylval=atoi((const char *)yytext); return(INTEGER);}
[ \t]		{if (mydebug) fprintf(stderr,"Whitespace found\n");}
[=\-+*/%&|;] 	{ if (mydebug) fprintf(stderr,"return a token %c\n",*yytext); 
                       return (*yytext);}
[(]		{if (mydebug) fprintf(stderr,"Open parentheses found\n");
			return (*yytext);}
[)]		{if (mydebug) fprintf(stderr,"Close parentheses found\n");
			return (*yytext);}
\n 		{ if (mydebug) fprintf(stderr,"carriage return %c\n",*yytext); 
                       return (*yytext);}

%%

int yywrap(void)
{ return 1;}


