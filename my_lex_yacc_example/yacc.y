%{
#include "main.h"
extern "C"
{
	void yyerror(const char *s);
	extern int yylex(void);
}
%}

%token<sval> IDENTIFIER
%token SELECT FROM DELETE TRUNCATE

%type<statement> preparable_statement
%type<delete_stmt> delete_statement truncate_statement
%%
preparable_statement:
		delete_statement{
			cout<<"a preparable stmt"<<endl;
		}
	|	truncate_statement{
			cout<<"a preparable stmt of truncate_statement"<<endl;
		}
	;
delete_statement:
		DELETE FROM table_name{
			cout<<"a delete stmt"<<endl;	
		}
	;
truncate_statement:
		TRUNCATE table_name {
	
		}
	;
table_name:
		IDENTIFIER{
			cout<<"id: "<<$1<<endl;
		}
	;
%%

int main()
{
	const char* sFile = "file.txt";
	FILE *fp=fopen(sFile,"r");
	if(fp==NULL)
	{
		printf("cannot open %s\n",sFile);
		return -1;
	}
	extern FILE* yyin;
	yyin=fp;

	printf("-----------begin parsing %s\n",sFile);
	yyparse();
	puts("---------end parsing");

	fclose(fp);

	return 0;
}
