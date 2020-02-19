Michael Smith
Lab4

Completed requirments:
-Context free grammar was extended
	P -> DECLS list
	DECLS -> DECLS DECL|empty
	DECL -> int VARIABLE ';' '\n'

-Variable names can now containe upper and lower case letters

-Union created to allow tokens to be either a value or a string

-Tokens now take on a type defined in the union

-When a VARIABLE is matched strdup() is used to pass a copy of the string to 
 yylval.string

-Semantic directives added to deal with when VARIABLE is matched

-Copies of variables already in the symbol table cannot be added.
 redesigned so that declaration mode and statement mode no longer
 exist and either can be done at any time.

-When a variable is in an expression its value it fetched using its name

-When a variable is on the left side its value is changed in the symbol table.
 Its address is also stored in the symbol table. The regs array isnt used.

-A function getData(char * name) was created to retrieve the value of a
 variable

-This project does not use regs[] and instead stores everything in the symbol
 table. Variable values are fetched by name rahter than adress becuase it is
 more direct; name->value rather than name->address->value
