/*
 * symtable.c
 * 
 * Modified by Michael Smith February 2020
 * 
 * pulled from https://forgetcode.com/C/101-Symbol-table
 *
 * This code implements a symbol table through the use of a 
 * linked list and user input
 * 
 * modifications made:
 * -properly indented code
 * -created a .h file and moved funciton prototypes there
 * -added comments
 */

#include<stdio.h>
//#include<conio.h>
#include<malloc.h>
#include<string.h>
#include<stdlib.h>
/*#include"symtable.h"*/

int size=0;

struct SymbTab {
	char * label;
	char * symbol;
	int data;
	int address;
	struct SymbTab *next;
};

struct SymbTab *first,*last;

void Insert(char * symbol, char * name, int data, int offset);

void Display();

int Search(char * name);

void Modify();

void Delete(char * name);

int getData(char * name);

void Insert(char * symbol, char * name, int data, int offset) {
	int n;
	n=Search(name);
	if(n==1)
		printf("\n\tThe label exists already in the symbol table\n\tDuplicate can't be inserted");
	else {
		struct SymbTab *p;
		p=malloc(sizeof(struct SymbTab));
		p->label = name;
		p->symbol = symbol;
		p->address = offset;
		p->data = data;
		p->next=NULL;
		if(size==0) {
			first=p;
			last=p;
		}
		else {
			last->next=p;
			last=p;
		}
		size++;
		printf("Symbol inserted:\"%s\" \"%s\" \"%d\" \"%d\"\n",p->symbol, p->label, p->data, p->address);
	}
}

void Display() {
	int i;
	struct SymbTab *p;
	p=first;
	printf("\n\tTYPE\t\tSYMBOL\t\tVALUE\t\tADDRESS\n");
	for(i=0;i<size;i++) {
		printf("\t%s\t\t%s\t\t%d\t\t%d\n",p->symbol,p->label,p->data,p->address);
		p=p->next;
	}
}

int Search(char * name) {
	int i,flag=0;
	struct SymbTab *p;
	p=first;
	for(i=0;i<size;i++) {
		if(strcmp(p->label,name)==0)
		flag=1;
		p=p->next;
	}	
	return flag;
}

void Modify(char * name, int value) {
	int temp = 0;	
	struct SymbTab *p;
	p = first;
	if(!Search(name)) {
		puts("symbol does not exists");
		return;
	}
	for(int i=0;i<size;i++) {
	
		if(strcmp(p->label,name)==0) {
			temp = p->data;
			p->data = value;
			break;
		}
		p = p->next;
	}
	return;
}

void Delete(char * name) {
	int a;
	struct SymbTab *p,*q;
	p=first;
	a=Search(name);
	if(a==0) {
		printf("\n\tLabel not found\n");
		return;
	}
	else {
		if(strcmp(first->label,name)==0)
			first=first->next;
		else if(strcmp(last->label,name)==0) {
			q=p->next;
			while(strcmp(q->label,name)!=0) {
				p=p->next;
				q=q->next;
			}
			p->next=NULL;
			last=p;
		}
		else {
			q=p->next;
			while(strcmp(q->label,name)!=0) {
				p=p->next;
				q=q->next;
			}
			p->next=q->next;
		}
		size--;
		printf("deleted %s\n", name);
	}
}

int getData(char * name) {
	struct SymbTab *p;
	p=first;
	for(int i = 0; i < size; i++) {
		if(strcmp(p->label, name)==0) {
			return p->data;
		}
		p=p->next;
	}
	return -1;
}
