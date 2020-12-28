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
DELETE  {return SQL_DELETE;}
FROM 	{return SQL_FROM;}
TRUNCATE	{return SQL_TRUNCATE;}

INSERT {return SQL_INSERT;}
INTO 	{return SQL_INTO;}
VALUES	{return SQL_VALUES;}

UPDATE {return SQL_UPDATE;}
SET	{return SQL_SET;}

CREATE {return SQL_CREATE;}
TABLE {return SQL_TABLE;}
IF {return SQL_IF;}
NOT {return SQL_NOT;}
EXISTS {return SQL_EXISTS;}
NULL {return SQL_NULL;}

SELECT {return SQL_SELECT;}
GROUP {return SQL_GROUP;}
BY {return SQL_BY;}
HAVING {return SQL_HAVING;}

VARCHAR {return SQL_VARCHAR;}
INTEGER {return SQL_INTEGER;}




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
