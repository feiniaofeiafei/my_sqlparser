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

/*
//non-terminals between the<> is a pointer variable,points to a structure

%type<statement> preparable_statement
%type<delete_stmt> delete_statement truncate_statement
%type<insert_stmt> insert_statement
%type<update_stmt> update_statement
%type<create_stmt> create_statement
%type<select_stmt> select_statement

%type <order>		    order_desc
*/

/*********************************
 ** Non-Terminal types (http://www.gnu.org/software/bison/manual/html_node/Type-Decl.html)
 *********************************/

%type <stmt_vec>	    statement_list
%type <statement> 	    statement preparable_statement
%type <exec_stmt>	    execute_statement
%type <transaction_stmt>    transaction_statement
%type <prep_stmt>	    prepare_statement
%type <select_stmt>     select_statement select_with_paren select_no_paren select_clause select_within_set_operation select_within_set_operation_no_parentheses
%type <import_stmt>     import_statement
%type <export_stmt>     export_statement
%type <create_stmt>     create_statement
%type <insert_stmt>     insert_statement
%type <delete_stmt>     delete_statement truncate_statement
%type <update_stmt>     update_statement
%type <drop_stmt>	    drop_statement
%type <show_stmt>	    show_statement
%type <table_name>      table_name
%type <sval> 		    file_path prepare_target_query
%type <bval> 		    opt_not_exists opt_exists opt_distinct opt_column_nullable opt_all
%type <uval>		    opt_join_type
%type <table> 		    opt_from_clause from_clause table_ref table_ref_atomic table_ref_name nonjoin_table_ref_atomic
%type <table>		    join_clause table_ref_name_no_alias
%type <expr> 		    expr operand scalar_expr unary_expr binary_expr logic_expr exists_expr extract_expr cast_expr
%type <expr>		    function_expr between_expr expr_alias param_expr
%type <expr> 		    column_name literal int_literal num_literal string_literal bool_literal
%type <expr> 		    comp_expr opt_where join_condition opt_having case_expr case_list in_expr hint
%type <expr> 		    array_expr array_index null_literal
%type <limit>		    opt_limit opt_top
%type <order>		    order_desc
%type <order_type>	    opt_order_type
%type <datetime_field>	datetime_field
%type <column_t>	    column_def
%type <column_type_t>   column_type
%type <update_t>	    update_clause
%type <group_t>		    opt_group
%type <alias_t>		    opt_table_alias table_alias opt_alias alias
%type <with_description_t>  with_description
%type <set_operator_t>  set_operator set_type

// ImportType is used for compatibility reasons
%type <import_type_t>	opt_file_type file_type

%left		OR
%left		AND
%right		NOT
%nonassoc	'=' EQUALS NOTEQUALS LIKE ILIKE
%nonassoc	'<' '>' LESS GREATER LESSEQ GREATEREQ

%nonassoc	NOTNULL
%nonassoc	ISNULL
%nonassoc	IS				/* sets precedence for IS NULL, etc */
%left		'+' '-'
%left		'*' '/' '%'
%left		'^'
%left		CONCAT

/* Unary Operators */
%right  UMINUS
%left		'[' ']'
%left		'(' ')'
%left		'.'
%left   JOIN

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
	|	
		update_statement{
			cout<<"a preparable stmt of update_statement"<<endl;
		}
	/*
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
update_statement:
		UPDATE table_ref_name_no_alias SET update_clause_commalist opt_where
		
	;
update_clause_commalist:
		update_clause
	|	update_clause_commalist ',' update_clause
	;
update_clause:
		IDENTIFIER '=' expr
	;
opt_where:
		WHERE expr
	|	/*empty*/
	;
table_ref_name_no_alias:
		table_name
	;
table_name:
		IDENTIFIER
	|	IDENTIFIER '.' IDENTIFIER
	;
expr_list:
		expr_alias
	|	expr_list ',' expr_alias
	;
opt_literal_list:
		literal_list
	|	/*empty*/
	;
expr_alias:
		expr opt_alias
	;
opt_alias:
		alias
	|	/*empty*/
	;
alias:
		AS IDENTIFIER
	|	IDENTIFIER
	;

expr:
		operand
	|	between_expr
	|	logic_expr
	| 	exists_expr
	|	in_expr
	;
operand:
		'(' expr ')'
	|	array_index
	|	scalar_expr
	|	unary_expr
	|	binary_expr
	|	case_expr
	|	function_expr
	|	extract_expr
	|	cast_expr
	|	array_expr
 /*	|	'(' select_no_paren ')' */
	;
scalar_expr:
		column_name
	|	literal
	;
unary_expr:
		'-' operand
	|	NOT operand
	|	operand ISNULL
	|	operand IS NULL
	|	operand IS NOT NULL
	;
binary_expr:
		comp_expr
	|	operand '-' operand
	|	operand '+' operand
	|	operand '/' operand
	|	operand '*' operand
	|	operand '%' operand
	|	operand '^' operand
	|	operand LIKE operand
	|	operand NOT LIKE operand
	|	operand ILIKE operand
	|	operand CONCAT operand
	;
logic_expr:
		expr AND expr
	|	expr OR expr
	;
in_expr:
		operand IN '(' expr_list ')'
	|	operand NOT IN '(' expr_list ')'
/*	|	operand IN '(' select_no_paren ')'
	|	operand NOT IN '(' select_no_paren ')' */
	;
case_list:
		WHEN expr THEN expr
	| 	case_list WHEN expr THEN expr
	;
case_expr:
		CASE expr case_list END
	|	CASE expr case_list ELSE expr END
	|	CASE case_list END
	|	CASE case_list ELSE expr END
	;
exists_expr:
		EXISTS
	|	NOT EXISTS
	;

comp_expr:
		operand '=' operand
	|	operand EQUALS operand
	|	operand NOTEQUALS operand
	|	operand '<' operand
	|	operand '>' operand
	|	operand LESSEQ operand
	|	operand GREATEREQ operand
	;

function_expr:
		IDENTIFIER '(' ')'
	|	IDENTIFIER '('opt_distinct expr_list ')'
	;
opt_distinct:
		DISTINCT
	|	/*empty*/
	;
extract_expr:
		EXTRACT '(' datetime_field FROM expr ')'
	;
cast_expr:
		CAST '(' expr AS column_type ')'
	;
datetime_field:
		SECOND
	|	MINUTE
	|	HOUR
	|	DAY
	|	MONTH
	|	YEAR
	;
array_expr:
		ARRAY '[' expr_list ']'
	;
array_index:
		operand '[' int_literal ']'
	;
between_expr:
		operand BETWEEN operand AND operand
	;
column_name:
		IDENTIFIER
	|	IDENTIFIER '.' IDENTIFIER
	|	'*'
	|	IDENTIFIER '.' '*'
	;
literal:
		string_literal
	|	bool_literal
	|	num_literal
	|	null_literal
	|	param_expr
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
string_literal:
		STRING
	;
bool_literal:
		TRUE
	|	FALSE
	;
num_literal:
		FLOATVAL{
			cout<<"FLOATVAL: "<<$1<<endl;
		}
	|	int_literal{
			cout<<"INTVAL: "<<$1<<endl;
		}
	;
int_literal:
		INTVAL
	;
null_literal:
		NULL
	;
param_expr:
		'?'
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
