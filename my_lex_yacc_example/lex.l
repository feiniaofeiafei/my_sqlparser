%{
#include "main.h"
#include "yacc.tab.h"

extern "C"
{
	int yywrap(void);
	int yylex(void);
}
%}
%%
[ \t\n]+	/* skip whitespace */;
DELETE  {return DELETE;}
FROM 	{return FROM;}
TRUNCATE	{return TRUNCATE;}

[A-Za-z][A-Za-z0-9]* {
	yylval.sval = yytext;
	return IDENTIFIER;
}
%%
int yywrap(void)
{
	puts("--------the file is end");
	return 1;
}
