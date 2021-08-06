/*
Name: Ben Sutter
Date: May 6th, 2021
Class: CMSC 430
Purpose: Adds ability to check for real, remainder operator, and if statements, and case head
*/

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkIfStatement(Types condition, Types ifTrue, Types ifFalse);
Types checkCaseHead(Types headCase);