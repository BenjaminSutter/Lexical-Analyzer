/*
Name: Ben Sutter
Date: April 22nd, 2021
Class: CMSC 430
Purpose: Enhanced functionality from Project 2 so the language can be parsed and return values.
*/

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<float> symbols;

double result;
double* arguments; //Grab the arguments as doubles for use in parameter
int currentArgument = 1; //Keeps track of what argument equals what parameter. Start at index one to skip index 0
//Since reduce works by the first head being 0 (add or subtract) or 1 (multiply/divide), it is necessary to skip the first division.
bool skipFirstReduceDivision = true;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	float value;
}

%token <iden> IDENTIFIER REAL_LITERAL BOOL_LITERAL
%token <value> INT_LITERAL 

%token <oper> ADDOP MULOP RELOP REMOP EXPOP 
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN REAL

%type <value> body statement_ statement reductions expression relation term factor exponent primary case optional_case
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_parameters:
	parameter ',' optional_parameters | 
	parameter |
	;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, arguments[currentArgument]); currentArgument++;} ;

optional_variable:
	variable |
	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	BOOLEAN |
	REAL ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3; skipFirstReduceDivision = true;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 == 1 ? $4 : $6;}  |
	CASE expression IS optional_case OTHERS ARROW statement_ ENDCASE {$$ = isnan($4) ? $7 : $4;} ;

//Case statement, case, and optional_case from: https://github.com/sfiler2112/compilers-project3/blob/master/parser.y
optional_case:
	optional_case case { $$ = isnan($1) ? $2 : $1;} |
	{$$ = NAN;} ; 

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $<value>-2 == $2 ? $4 : NAN;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2, skipFirstReduceDivision); skipFirstReduceDivision = false;} |
	{$$ = $<oper>0 == ADD || $<oper>0 == SUBTRACT ? 0 : 1;} ;

expression:
	expression ANDOP expression {$$ = $1 && $3;} |
	expression OROP expression {$$ = $1 || $3;}|
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
	primary EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	NOTOP primary {$$ = !($2);} |
	INT_LITERAL | 
	BOOL_LITERAL {$$ = evaluateBoolean($1);} |
	REAL_LITERAL {$$ = evaluateReal($1);} |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	arguments = new double[argc];
	for(int i = 0; i < argc; i++)
	{
		//If a string is passed as parameter and it is true, then it equals 1.
		//Other wise, strings are automatically parsed as 0.
		if (!std::string(argv[i]).compare("true")) {
			arguments[i] = 1;
		} else {
		arguments[i] = atof(argv[i]); 
		}
	}

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "\nResult = " << result << endl;
	return 0;
} 
