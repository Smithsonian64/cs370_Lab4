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

-When a variable is in an expression its address it fetched using its name then the value is fetched using the address

-When a variable is on the left side its value is changed in regs.
 Its address is also stored in the symbol table.

-A function getAddress(char * name) was created to retrieve the address of a
 variable
