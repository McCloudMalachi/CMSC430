/* 
Malachi McCloud
09/25/2023
Project 3
*/


%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
	/* Changed to double */
Symbols<double> symbols;
	/* Changed to double */
double result;
double * params;
int countParams = 0;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	/* Changed to double */
  double value;
}
	/* Litterals Added */
%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL FALSE TRUE BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP ARROWOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <value> body statement_ statement reductions expression expression2
  relation term factor exponent unary primary case
%type <oper> operator

%%

function:
	function_header optional_variable body {result = $3;} ;

	/* Incorporated from Project 3 the new setup but, changed some of the labeling to reduce confusion */
	
function_header:
	FUNCTION IDENTIFIER RETURNS type ';' ; |
  FUNCTION IDENTIFIER parameters RETURNS type ';' |
  error ';' ;

parameters:
  parameter optional_parameter ;

optional_parameter:
  optional_parameter ',' parameter |
  ;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, params[countParams]); countParams++;} ;

optional_variable:
	optional_variable variable |
  error ';' |
	;

variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;


body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;

 	/* Statement body includedes endif if then and case */

statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = evaluateIfElse($2, $4, $6);} |
	CASE expression {storeCaseExpression($2);} IS optional_case OTHERS ARROWOP
  statement_ ENDCASE {$$ = evaluateOthers($8);} ;

	/* Removed Relop was throwing error */
operator:
	ADDOP |
	MULOP ;

 	/* reductions */

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

optional_case:
	optional_case case |
	;

case:
  WHEN INT_LITERAL ARROWOP statement_ {$$ = evaluateCase($2, $4);} ;

expression:
	expression OROP expression2 {$$ = $1 || $3;} |
	expression2 ;

expression2:
	expression2 ANDOP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;

factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
  factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

 	/* Exponent seperated from Primary */

exponent:
  unary EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
  unary ;

unary:
  NOTOP primary {$$ = !$2;} |
  primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL {$$ = $1 - 261;} |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
  params = new double[argc - 1];
  for (int i = 1; i < argc; i++) {
    params[i - 1] = atof(argv[i]);
  }
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
}