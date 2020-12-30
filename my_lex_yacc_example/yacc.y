%{
//int yydebug=1;
#include "main.h"
extern "C"
{
	void yyerror(const char *s);
	extern int yylex(void);
}
%}
%define api.token.prefix {SQL_}
%left '(' ')'

/*********************************
 ** Token Definition
  *********************************/
  %token <sval> IDENTIFIER STRING
  %token <fval> FLOATVAL
  %token <ival> INTVAL

  /* SQL Keywords */
  %token DEALLOCATE PARAMETERS INTERSECT TEMPORARY TIMESTAMP
  %token DISTINCT NVARCHAR RESTRICT TRUNCATE ANALYZE BETWEEN
  %token CASCADE COLUMNS CONTROL DEFAULT EXECUTE EXPLAIN
  %token INTEGER NATURAL PREPARE PRIMARY SCHEMAS
  %token SPATIAL VARCHAR VIRTUAL DESCRIBE BEFORE COLUMN CREATE DELETE DIRECT
  %token DOUBLE ESCAPE EXCEPT EXISTS EXTRACT CAST FORMAT GLOBAL HAVING IMPORT
  %token INSERT ISNULL OFFSET RENAME SCHEMA SELECT SORTED
  %token TABLES UNIQUE UNLOAD UPDATE VALUES AFTER ALTER CROSS
  %token DELTA FLOAT GROUP INDEX INNER LIMIT LOCAL MERGE MINUS ORDER
  %token OUTER RIGHT TABLE UNION USING WHERE CALL CASE CHAR COPY DATE DATETIME
  %token DESC DROP ELSE FILE FROM FULL HASH HINT INTO JOIN
  %token LEFT LIKE LOAD LONG NULL PLAN SHOW TEXT THEN TIME
  %token VIEW WHEN WITH ADD ALL AND ASC END FOR INT KEY
  %token NOT OFF SET TOP AS BY IF IN IS OF ON OR TO
  %token ARRAY CONCAT ILIKE SECOND MINUTE HOUR DAY MONTH YEAR
  %token TRUE FALSE
  %token TRANSACTION BEGIN COMMIT ROLLBACK

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
	|	create_statement{
			cout<<"a preparable stmt of create_statement"<<endl;
		}
	/*
	|	
		update_statement{
			cout<<"a preparable stmt of update_statement"<<endl;
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
create_statement:
		CREATE TABLE opt_not_exists table_name '(' column_def_commalist ')'{
			cout<<"a create stmt"<<endl;		
		}
	;
opt_not_exists:
		IF NOT EXISTS
	|	/*empty*/
	;
column_def_commalist:
		column_def
	|	column_def_commalist ',' column_def
	;
column_def:
		IDENTIFIER column_type opt_column_nullable
	;
column_type:
		VARCHAR
	|	INTEGER
	;
opt_column_nullable:
		NULL
	|	NOT NULL
	|	/*empty*/
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
