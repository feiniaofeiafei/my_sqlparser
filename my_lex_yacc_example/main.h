#ifndef MAIN_HPP
#define MAIN_HPP

#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

struct SQLStatement{};
struct DeleteStatement{};
struct InsertStatement{};
struct UpdateStatement{};
struct CreateStatement{};
struct SelectStatement{};

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
};
#define YYSTYPE HSQL_STYPE
#endif
