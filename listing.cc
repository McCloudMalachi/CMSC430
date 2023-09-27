// Compiler Theory and Design
// Malachi McCloud
// Date: 2023 - 09 - 26
// This file contains the bodies of the functions that produces the compilation



#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static string errorQueue = "";
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntacticErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors != 0) {
		printf("Lexical Errors: %d", lexicalErrors);
		printf("\nSyntactic Errors: %d", syntacticErrors);
		printf("\nSemantic Errors: %d", semanticErrors);
		printf("\nTotal Number of Errors: %d\n\n", totalErrors);
	}
	else {
		printf("Compiled Successfully.\n\n");
	}
	return totalErrors;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
	errorQueue += (error + "\n");
	totalErrors++;
	if (errorCategory == 0) {
		lexicalErrors++;
	}
	else if (errorCategory == 1) {
		syntacticErrors++;
	}
	else {
		semanticErrors++;
	}
}

void displayErrors()
{
	if (error != "") {
		printf("\n%s\n", errorQueue.c_str());
	}
	error = "";
	errorQueue = "";
}