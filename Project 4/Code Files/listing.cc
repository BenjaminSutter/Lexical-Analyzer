/*
Name: Ben Sutter
Date: May 11th, 2021
Class: CMSC 430
Purpose: Added ability to display multiple errors from the same line using a queue.
Also counts lexical, syntax, and semantic errors rather than simply total errors.
This file contains the bodies of the functions that produces the compilation.
Updated to include all error categories
*/

#include <cstdio>
#include <string>
#include <queue>
#include <iostream>

using namespace std;

#include "listing.h"

static int lineNumber;
queue <string> errorQueue;
static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;
static bool errorFound = false;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ", lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ", lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	//If errors were found, display them. Otherwise print compiled succesffuly.
	if (errorFound) {
		cout << "Lexical errors: " << lexicalErrors;
		cout << "\nSyntax errors: " << syntaxErrors;
		cout << "\nSemantic errors: " << semanticErrors;
	}
	else {
		cout << "Compiled successfully";
	}
	return lexicalErrors + syntaxErrors + semanticErrors;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };
	if (errorCategory == LEXICAL) {
		lexicalErrors++;
	}
	else if (errorCategory == SYNTAX) {
		syntaxErrors++;
	}
	else if (errorCategory == GENERAL_SEMANTIC) {
		semanticErrors++;
	}
	else if (errorCategory == UNDECLARED) {
		semanticErrors++;
	}
	else if (errorCategory == DUPLICATE_IDENTIFIER) {
		semanticErrors++;
	}
	//Pushes the current error on the queue for printing in displayErrors()
	errorQueue.push(messages[errorCategory] + message);
	errorFound = true;//Signals that program didn't compile successfully
}

void displayErrors()
{
	// Displays and then empties all strings in the queue (if there are any)
	while (!errorQueue.empty()) {
		cout << errorQueue.front() << endl;
		errorQueue.pop();
	}

}