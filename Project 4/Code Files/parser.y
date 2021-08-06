/*
Name: Ben Sutter
Date: May 11th, 2021
Class: CMSC 430
Purpose: Updated to allow for more semantic parsing.
*/


%{

#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;
//Used to set the precedent for the first case statement (all other cases should follow the type)
Types firstCaseStatement;
//Used to reset the value of firstCaseStatement
Types defaultType;
Types returnType;//Used to determine what value is being returned

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER 
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ADDOP MULOP RELOP REMOP EXPOP 
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN REAL

%type <type> type statement statement_ reductions expression relation term factor primary exponent case optional_case case_statement case_head

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' {returnType = $5;} ; 

optional_parameters:
	parameter ',' optional_parameters | 
	parameter |
	;

parameter:
	IDENTIFIER ':' type {if (!symbols.find($1, $3)) symbols.insert($1, $3);
						else appendError(DUPLICATE_IDENTIFIER, $1);};

optional_variable:
	variable |
	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{checkAssignment($3, $5, "Variable Initialization"); 
		if (!symbols.find($1, $3)) symbols.insert($1, $3);
		else appendError(DUPLICATE_IDENTIFIER, $1);};


type:
	INTEGER {$$ = INT_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} |
	REAL {$$ = REAL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' 
	{if (returnType == $2) cout << "\nReturn type declared in header actually matched what was returned, good job.";};
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIfStatement($2, $4, $6);} |
	case_head case_statement ENDCASE {firstCaseStatement = defaultType;} ;

case_head:
	CASE expression {$$ = checkCaseHead($2);};

case_statement:
	 IS optional_case OTHERS ARROW statement_ 
	 {if (firstCaseStatement != $5) appendError(GENERAL_SEMANTIC, "All case staments must match in type");}

optional_case:
	optional_case case |
	{$$ = MISMATCH;} ;

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $4; if (!firstCaseStatement) firstCaseStatement = $4;
		else if (firstCaseStatement != $4)  appendError(GENERAL_SEMANTIC, "All case staments must match in type");};

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression ANDOP expression {$$ = checkLogical($1, $3);} |
	expression OROP expression {$$ = checkLogical($1, $3);}|
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent  {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent  {$$ = checkRemainder($1, $3);} |
	exponent;

exponent: 
	primary EXPOP exponent {$$ = checkArithmetic($1, $3);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	NOTOP primary {$$ = $2;} |
	INT_LITERAL | 
	BOOL_LITERAL |
	REAL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{

	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
