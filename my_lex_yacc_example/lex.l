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

INSERT {return INSERT;}
INTO 	{return INTO;}
VALUES	{return VALUES;}

UPDATE {return UPDATE;}
SET	{return SET;}

CREATE {return CREATE;}
TABLE {return TABLE;}

SELECT {return SELECT;}
GROUP {return GROUP;}
BY {return BY;}
HAVING {return HAVING;}

VARCHAR {return VARCHAR;}
INTEGER {return INTEGER;}




[A-Za-z][A-Za-z0-9]* {
	yylval.sval = yytext;
	return IDENTIFIER;
}
-?[0-9]+ {
    yylval.ival = atol(yytext);
	    return INTVAL;
		}

-?[0-9]+"."[0-9]* { 
	yylval.fval = atof(yytext);
	return FLOATVAL;
}

[(),.] {return yytext[0];}
%%
int yywrap(void)
{
	puts("--------the file is end");
	return 1;
}
