/*
Name: Ben Sutter
Date: April 22nd, 2021
Class: CMSC 430
Purpose: Changed parameters from ints to doubles. Added boolean to evaluateReduction. 
Added evaluateBoolean and evaluateReal to parse BOOL and REAL LITERALS
*/

#include <string>
#include <vector>
#include <cmath>
#include <iostream>
#include <sstream>

using namespace std;

#include "values.h"
#include "listing.h"


//compare() returns 0 when they are equal. 0 also means false.
//This means that when compare() is true it is "false" so !compare() makes it true
//Could have probably done std::string(boolean).compare("true") == 0 but oh well.
double evaluateBoolean(CharPtr boolean) {
	if (!std::string(boolean).compare("true")) {
		return 1;
	}
	return 0;
}

//Method taken from https://www.oreilly.com/library/view/c-cookbook/0596007612/ch03s06.html
double evaluateReal(CharPtr real) {
	std::string s(real);
	stringstream ss(s);
	double d = 0;
	ss >> d;

	if (ss.fail()) {
		string s = "Unable to format real literal properly";
		throw (s);
	}

	return (d);
}

double evaluateReduction(Operators operator_, double head, double tail, bool skipDivision)
{
	if (operator_ == ADD) {
		return head + tail;
	} else if (operator_ == SUBTRACT) {
		return head - tail;
	} else if (operator_ == DIVIDE) {
		//If it is necessary to skip divisio, return tail without dividing it.
		if (skipDivision) {
			return tail;
		}
		return head / tail;
	}
	return head * tail;//If it is not add, subtract, or divide it is multiply
}


double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case LESS:
		result = left < right;
		break;
	case EQUALS:
		result = left == right;
		break;
	case DOESNOTEQUAL:
		result = left != right;
		break;
	case GREATER:
		result = left > right;
		break;
	case EQUALORGREATER:
		result = left >= right;
		break;
	case EQUALORLESS:
		result = left <= right;
		break;
	}
	return result;
}

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case ADD:
		result = left + right;
		break;
	case MULTIPLY:
		result = left * right;
		break;
	case SUBTRACT:
		result = left - right;
		break;
	case DIVIDE:
		result = left / right;
		break;
	case REMAINDER:
		//Usual % does not work for remainders with doubles
		result = remainder(left, right);
		break;
	case EXPONENT:
		result = pow(left, right);
		break;
	}
	return result;
}