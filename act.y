%{
	#include <stdio.h>
	int yylex(), yyerror();
%}
%%
start: 'x' foo 'y';
foo: { puts("act!"); };
%%
int yyerror() { puts("oops, yacc error!"); }
int yylex() { int c = getchar(); printf("lex %d\n", c); return c==EOF?0:c; }

int main() { yyparse(); }
