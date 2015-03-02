%{
	#include <ctype.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	int lex(void);
%}

%union {
	int sum;
	int mul;
	int num;
}

%type <sum> A
%type <mul> M
%token <num> NUM

%%

S:
 | S A { printf("-> %d\n", $2); }
 ;

A: M       { $$ = $1; }
 | A '+' A { $$ = $1 + $3; }
 | A '-' A { $$ = $1 - $3; }
 ;

M: B       { $$ = $<num>1; }
 | B '*' M { $$ = $<num>1 * $3; }
 ;

B: NUM       { $<num>$ = $1; }
 | '(' A ')' { $<num>$ = $2; }
 ;

%%

enum {
	MaxLine = 1000,
};

char line[MaxLine], *p;

int
lex()
{
	char c;

	p += strspn(p, "\t ");
	switch ((c=*p++)) {
	case '+': return 2;
	case '-': return 3;
	case '*': return 4;
	case '(': return 5;
	case ')': return 6;
	case 0:
	case '\n':
		p--;
		return 0;
	}
	if (isdigit(c)) {
		yylval.num = strtol(p-1, &p, 0);
		return 1;
	}
	puts("lex error!");
	return 0;
}

int
main()
{
	while ((p=fgets(line, MaxLine, stdin))) {
		if (yyparse() < 0)
			puts("parse error!");
	}
	return 0;
}