#ifndef MAIN_HPP
#define MAIN_HPP

#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;
/*
struct SQLStatement{};
struct DeleteStatement{};
struct InsertStatement{};
struct UpdateStatement{};
struct CreateStatement{};
struct SelectStatement{};
struct OrderDescription{};
*/
namespace hsql{
struct SQLStatement{};
struct SelectStatement{};
struct ImportStatement{};
struct ExportStatement{};
struct CreateStatement{};
struct InsertStatement{};
struct DeleteStatement{};
struct UpdateStatement{};
struct DropStatement{};
struct PrepareStatement{};
struct ExecuteStatement{};
struct ShowStatement{};
struct TransactionStatement{};

struct TableName{};
struct TableRef{};
struct Expr{};
struct OrderDescription{};
struct OrderType{};
struct WithDescription{};
struct DatetimeField{};
struct LimitDescription{};
struct ColumnDefinition{};
struct ColumnType{};
struct ImportType{};
struct GroupByDescription{};
struct UpdateClause{};
struct Alias{};
struct SetOperation{};
}

union HSQL_STYPE {
	double fval;
	int64_t ival;
	char* sval;
	uintmax_t uval;
	bool bval;

	hsql::SQLStatement* statement;
	hsql::SelectStatement* 	select_stmt;
	hsql::ImportStatement* 	import_stmt;
	hsql::ExportStatement* 	export_stmt;
	hsql::CreateStatement* 	create_stmt;
	hsql::InsertStatement* 	insert_stmt;
	hsql::DeleteStatement* 	delete_stmt;
	hsql::UpdateStatement* 	update_stmt;
	hsql::DropStatement*   	drop_stmt;
	hsql::PrepareStatement* prep_stmt;
	hsql::ExecuteStatement* exec_stmt;
	hsql::ShowStatement*    show_stmt;
	hsql::TransactionStatement* transaction_stmt;

	hsql::TableName table_name;
	hsql::TableRef* table;
	hsql::Expr* expr;
	hsql::OrderDescription* order;
	hsql::OrderType order_type;
    hsql::WithDescription* with_description_t;
	hsql::DatetimeField datetime_field;
	hsql::LimitDescription* limit;
	hsql::ColumnDefinition* column_t;
	hsql::ColumnType column_type_t;
	hsql::ImportType import_type_t;
	hsql::GroupByDescription* group_t;
	hsql::UpdateClause* update_t;
	hsql::Alias* alias_t;
	hsql::SetOperation* set_operator_t;

/*	std::vector<hsql::SQLStatement*>* stmt_vec;

	std::vector<char*>* str_vec;
	std::vector<hsql::TableRef*>* table_vec;
	std::vector<hsql::CDefinition*>* column_vec;
	std::vector<hsql::UpdateClause*>* update_vec;
	std::vector<hsql::Expr*>* expr_vec;
	std::vector<hsql::OrderDescription*>* order_vec;
	std::vector<hsql::WithDescription*>* with_description_vec;
*/
};
/*
union HSQL_STYPE
{
	char* sval;
	long int ival;
	double fval;
	struct SQLStatement* statement;
	struct DeleteStatement* delete_stmt;
	struct InsertStatement* insert_stmt;
	struct UpdateStatement* update_stmt;
	struct CreateStatement* create_stmt;
	struct SelectStatement* select_stmt;
	struct OrderDescription* order;
};
*/
#define YYSTYPE HSQL_STYPE
#endif
