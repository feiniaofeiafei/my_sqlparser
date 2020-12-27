#ifndef MAIN_HPP
#define MAIN_HPP

#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

struct SQLStatement{};
struct DeleteStatement{};

union HSQL_STYPE
{
	char* sval;
	struct SQLStatement* statement;
	struct DeleteStatement* delete_stmt;
};
#define YYSTYPE HSQL_STYPE
#endif
