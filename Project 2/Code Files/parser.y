/*
Name: Ben Sutter
Date: March 30th, 2021
Class: CMSC 430
Purpose: Enhance functionality from Project 2 so the language can be parsed.
*/

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token REAL_LITERAL
%token BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS REAL

%token IF THEN ELSE ENDIF CASE OTHERS ARROW ENDCASE WHEN

%%

function:	
	function_header optional_variable body

optional_variable:
	variable |
	;

variable:
	IDENTIFIER ':' type IS statement_ |
	IDENTIFIER ':' type IS statement_ variable |
	error ';' ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';'  |
	error ';' ;

optional_parameters:
	parameter | 
	;

parameter:
	IDENTIFIER ':' type |
	IDENTIFIER ':' type ',' parameter;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' |
	error ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF  |
	CASE expression IS optional_case OTHERS ARROW statement_  ENDCASE  |
	invalid_statements ;

invalid_statements:
	REDUCE error ENDREDUCE ';' |
	IF error ENDIF ';' |
	CASE error ENDCASE ';' ;

optional_case:
	case |
	;

case:
	WHEN INT_LITERAL ARROW statement_ |
	WHEN INT_LITERAL ARROW statement_ case ;

reductions:
	reductions statement_ |
	;

operator:
	ADDOP |
	MULOP ;
		    
expression:
	expression ANDOP relation |
	expression OROP expression |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent |
	factor REMOP exponent|
	exponent ;

exponent:
	primary EXPOP exponent |
	primary ;

primary:
	'(' expression ')' |
	primary operator primary|
	NOTOP primary |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER ;
    
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
