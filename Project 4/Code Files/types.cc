// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{
		
		if (lValue == INT_TYPE && rValue == REAL_TYPE)
		{
			//If int is being forced into real then it is narrowing so specify
			appendError(GENERAL_SEMANTIC, "Illegal narrowing occured on " + message);
		}
		else if (lValue == REAL_TYPE && rValue == INT_TYPE)
		{
			//Widening is allowed so do nothing
		}
		else 
		{
			//In any other cases it is a mismatch
			appendError(GENERAL_SEMANTIC, "Type mismatch on " + message);
		}
		
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer type required");
		return MISMATCH;
	} 
	else if (left == REAL_TYPE && (right == REAL_TYPE || right == INT_TYPE))
	{
		//Reals can have value of integer or real
		return REAL_TYPE;
	}
	return INT_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean type required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkRemainder(Types left, Types right)
{
	//Only integers can be used with rem so if either aren't an int then it is a mismatch
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Integer type required to use rem");
		return MISMATCH;
	}
		return INT_TYPE;
	return MISMATCH;
}

Types checkIfStatement(Types condition, Types ifTrue, Types ifFalse)
{
	//If any of these satements are true it is a mismatch, but check in case both cases are true
	if (condition != BOOL_TYPE || ifTrue != ifFalse)
	{
		if (condition != BOOL_TYPE)
		{
			//If the head is not boolean that's an error
			appendError(GENERAL_SEMANTIC, "The type of the if expression must be boolean.");
		}
		if (ifTrue != ifFalse)
		{
			//If the if and else don't match that's an error
			appendError(GENERAL_SEMANTIC, "Both statements (if/else) must be the same type");
		}
		return MISMATCH;
	}
		return ifTrue;
	return MISMATCH;
}

Types checkCaseHead(Types headCase)
{
	//If the head case is not an int then display error and return mismatch
	if (headCase != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "The type of case expression must be an integer");
		return MISMATCH;
	}
	return INT_TYPE;
}
