%{
//int yydebug=1;
#include "main.h"
extern "C"
{
	void yyerror(const char *s);
	extern int yylex(void);
}
%}

//terminals
%token<sval> IDENTIFIER STRING
%token<ival> INTVAL
%token<fval> FLOATVAL

%token FROM DELETE TRUNCATE
%token INSERT INTO VALUES
%token UPDATE SET
%token CREATE TABLE
%token SELECT GROUP BY HAVING
%token VARCHAR INTEGER

%left '(' ')'
//non-terminals between the<> is a pointer variable,points to a structure
%type<statement> preparable_statement
%type<delete_stmt> delete_statement truncate_statement
%type<insert_stmt> insert_statement
/*%type<update_stmt> update_statement
%type<create_stmt> create_statement
%type<select_stmt> select_statement
*/



%%
preparable_statement:
		delete_statement{
			cout<<"a preparable stmt of delete_statement"<<endl;
		}
	|	truncate_statement{
			cout<<"a preparable stmt of truncate_statement"<<endl;
		}
	|	insert_statement{
			cout<<"a preparable stmt of insert_statement"<<endl;
		}
	/*
	|	
		update_statement{
			cout<<"a preparable stmt of update_statement"<<endl;
		}
	|	create_statement{
			cout<<"a preparable stmt of create_statement"<<endl;
		}
	|	select_statement{
			cout<<"a preparable stmt of select_statement"<<endl;
		}
		*/
	;
delete_statement:
		DELETE FROM table_name{
			cout<<"a delete stmt"<<endl;	
		}
	;
truncate_statement:
		TRUNCATE table_name {
			cout<<"a truncate stmt"<<endl;	
		}
	;
insert_statement:
		INSERT INTO table_name opt_column_list VALUES '(' literal_list ')'{
			cout<<"a insert stmt"<<endl;	
		}
	;
opt_column_list:
		'('ident_commalist ')'{cout<<"ident_commalist"<<endl;}
	|	/*empty*/ {cout<<"empty"<<endl;}
	;
ident_commalist:
		IDENTIFIER  {cout<<"identifier in ident_commalist"<<endl;}
	|	ident_commalist ',' IDENTIFIER
	;
literal_list:
		literal {
			cout<<"literal in literal list"<<endl;
		}
	|	literal_list ',' literal{
			cout<<"literal_list and literal in literal list"<<endl;
		}
	;
literal:
		num_literal{
			cout<<"literal"<<endl;
		}
	;
num_literal:
		FLOATVAL{
			cout<<"FLOATVAL: "<<$1<<endl;
		}
	|	INTVAL{
			cout<<"INTVAL: "<<$1<<endl;
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
