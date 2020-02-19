all:	lab4

lab4:	y.tab.c
	gcc y.tab.c -o lab4

y.tab.c:symtable.h clean
	lex lab4.l
	yacc -d lab4.y

symtable.h:	clean
	gcc symtable.h

clean:
	rm -f y.tab.c y.tab.h
