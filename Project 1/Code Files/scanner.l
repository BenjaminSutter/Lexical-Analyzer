/*
Name: Ben Sutter
Date: March 30th, 2021
Class: CMSC 430
Purpose: Add new lexemes to the language based on Project 1 requirements.
Contains flex output file.
*/

%{
#include <cstdio>
#include <string>
#include <iostream>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws			[ \t\r]+
comment		\-\-.*\n
line		[\n]
id			[A-Za-z]([_]?[A-Za-z0-9])*
digit		[0-9]
int			{digit}+
punc		[\(\),:;]
real		[0-9]+[.][0-9]*([Ee][-+]?[0-9]+)?
comment2	\/\/.*\n

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"			{ ECHO; return(RELOP); }
"+"			{ ECHO; return(ADDOP); }
"*"			{ ECHO; return(MULOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end			{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is			{ ECHO; return(IS); }
reduce		{ ECHO; return REDUCE; }
returns		{ ECHO; return(RETURNS); }
and			{ ECHO; return(ANDOP); }

"=>"		{ ECHO; return(ARROW); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
if			{ ECHO; return(IF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
or			{ ECHO; return(OROP); }
not			{ ECHO; return(NOTOP); }
"="		{ ECHO; return(RELOP); }
"/="		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }
"-"			{ ECHO; return(ADDOP); }
"/"			{ ECHO; return(MULOP); }
rem			{ ECHO; return(REMOP); }
"**"		{ ECHO; return(EXPOP); }
true		{ ECHO; return(BOOL_LITERAL); }
false		{ ECHO; return(BOOL_LITERAL); }

{real}		{ ECHO; return(REAL_LITERAL);}
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.			{ ECHO; appendError(LEXICAL, yytext); }
%%

int main()
{
	cout << "Output sentence";
	firstLine();
	
	FILE *file = fopen("lexemes.txt", "wa"); 
	int token = yylex();
	while (token)
	{
		fprintf(file, "%d %s\n", token, yytext);
		token = yylex();
	}
	lastLine();
	fclose(file);
	return 0;
}