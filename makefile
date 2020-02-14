all:	lab4

lab4:	y.tab.c
	gcc y.tab.c -o lab4

y.tab.c:clean
	lex lab4.l
	yacc -d lab4.y

clean:
	rm -f y.tab.c y.tab.h
