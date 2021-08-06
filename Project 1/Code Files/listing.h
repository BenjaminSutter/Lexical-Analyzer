/*
Name: Ben Sutter
Date: March 30th, 2021
Class: CMSC 430
Purpose: This code remains unchanged from the skeleton code.
This file contains the function prototypes for the functions that produce the // compilation listing
*/

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);