/*
Name: Ben Sutter
Date: March 30th, 2021
Class: CMSC 430
Purpose: Add new lexemes to the language based on Project 1 requirements.
Added boolean and the ability to parse it, integers, and reals
*/

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
real		[0-9]+[.][0-9]*([Ee][-+]?[0-9]+)?
comment2	\/\/.*\n
bool    (true)|(false)

%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }

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
"="			{ ECHO; yylval.oper = EQUALS; return(RELOP); }
"/="		{ ECHO; yylval.oper = DOESNOTEQUAL; return(RELOP); }
">"			{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="		{ ECHO; yylval.oper = EQUALORGREATER; return(RELOP); }
"<="		{ ECHO; yylval.oper = EQUALORLESS; return(RELOP); }
"-"			{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"/"			{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
rem			{ ECHO; yylval.oper = REMAINDER; return(REMOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
{bool}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(BOOL_LITERAL); }
{real}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(REAL_LITERAL);}
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
