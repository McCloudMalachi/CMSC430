    /* 
    Malachi McCloud
    09/25/2023
    CSMC 430
    Project 3 Scanner.l
    */  
%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap
/* went through and adjusted and labeled needed reqs from project 2 -> 3 */
ws		[ \t\r]+
comment		\-\-.*\n
comment2    \/\/.*\n
line		[\n]
real		{digit}+\.{digit}*([Ee][+-]?{digit}+)?
id		[A-Za-z][A-Za-z_0-9]*
digit		[0-9]
bool		(true|false)
int		{digit}+
punc		[\(\),:;]
%%



{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}


	/*Here are the relational and arth additions*/

"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREAT; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQ; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP);}
">="		{ ECHO; yylval.oper = GREATEQ; return(RELOP);}
"/="		{ ECHO; yylval.oper = NOTEQ; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = MINUS; return(ADDOP);}
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/" 		{ ECHO; yylval.oper = DIVIDE; return(MULOP);}
rem             { ECHO; yylval.oper = REM; return(REMOP); }
"**"		{ ECHO; yylval.oper = EXPON; return(EXPOP);}
"=>"            { ECHO; yylval.oper = ARROW; return(ARROWOP); }

	/*Literals, case, else, endif, if and so on.*/

{bool}		{ ECHO; yylval.oper = BOOL; return(BOOL_LITERAL);}
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
    /* case */
case		{ ECHO; return(CASE);  }
    /* else */
else 		{ ECHO; return(ELSE);  }
    /* Endcase */
endcase		{ ECHO; return(ENDCASE); }
    /* Endif */
endif		{ ECHO; return(ENDIF);  }       
    /* If */
if		{ ECHO; return(IF);  }
others 		{ ECHO; return(OTHERS) ;}
real 		{ ECHO; return(REAL)  ;}
then		{ ECHO; return(THEN) ;}
when 		{ ECHO; return(WHEN) ;}
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP);  }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }

	/* real was changed to include new atof operation */
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
{real}          { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%