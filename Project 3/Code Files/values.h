/*
Name: Ben Sutter
Date: April 22nd, 2021
Class: CMSC 430
Purpose: Changed parameters from ints to doubles. Added more operators, and added evaluateBoolean and evaluateReal.
*/

typedef char* CharPtr;
enum Operators {LESS, ADD, MULTIPLY, EQUALS, DOESNOTEQUAL, GREATER, EQUALORGREATER, EQUALORLESS, SUBTRACT, DIVIDE, REMAINDER, EXPONENT };

double evaluateReduction(Operators operator_, double head, double tail, bool skipDivision);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateBoolean(CharPtr boolean);
double evaluateReal(CharPtr real);