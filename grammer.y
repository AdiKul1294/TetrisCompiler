%debug
%define parse.error verbose
%{
#include <math.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <error.h>
#include <errno.h>
	
#include "extetrickstype.h"
	
void yyerror(const char *s)
{
fprintf(stderr,"%s\n",s);
return;
}
	
int yywrap()
{
	return 1;
}
	
char* indent(char* body) {
	char* ans = malloc(1024);
	memset(ans, 0, 1024);
	char* line = strtok(body, "\n");
	while(line != NULL) {
		sprintf(ans, "%s    %s\n", ans, line);
		line = strtok(NULL, "\n");
	}
	free(body);
	return ans;
}
const char *verbatim="from engine import *\n";
char globals[1024][1024] = {0};
int globalIndex = 0;

%}
	
%token SECTION1 SECTION2 SECTION3 NEWLINE NUM ID IF THEN ELSE END WHILE CALL WITH OR AND NOT NEG PLAY RETURN
	
%%
START :  SECTION1 NEWLINE PRIMITIVE SECTION2 NEWLINE FUNCTIONS SECTION3 NEWLINE ENGINE  { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s\n#PRIMITIVE:\n%s\n#FUNCTIONS:\n%s\n#ENGINE:\n%s\n", verbatim,$3->value.StringValue, $6->value.StringValue, $9->value.StringValue);

			printf("%s\n", $$->value.StringValue); 
		};
/* VERBATIM: {
	$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
	$$->value.StringValue = (char*)malloc(1024*sizeof(char));
	sprintf($$->value.StringValue, "%s", verbatim);
	//printf("%s\n", $$->value.StringValue);
} */
	
PRIMITIVE : ID '=' EXPR NEWLINE PRIMITIVE { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s = %s\n%s", $1->value.StringValue, $3->value.StringValue, $5->value.StringValue);
				strcpy(globals[globalIndex++], $1->value.StringValue);
				// printf("PRIMITIVE -> ID '=' EXPR NEWLINE PRIMITIVE\n"); 
			}
			| { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				strcpy($$->value.StringValue, "");
				// printf("PRIMITIVE -> #\n"); 
			}
					;
	
ENGINE : '[' PLAY ']' { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "if __name__ == '__main__':\n\tmainFunc()\n\ttetris_engine = TetrisEngine()\n");
			// printf("ENGINE -> '[' PLAY ']'\n"); 
		}
		| '[' PLAY WITH PARAM PARAMLIST ']' { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "if __name__ == '__main__':\n\tmainFunc()\n\ttetris_engine = TetrisEngine(%s%s)\n", $4->value.StringValue, $5->value.StringValue);
			// printf("ENGINE -> '[' PLAY WITH PARAM PARAMLIST ']'\n"); 
		};
	
FUNCTIONS : FUNCTION NEWLINE FUNCTIONS { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s\n%s", $1->value.StringValue, $3->value.StringValue);
				// printf("FUNCTIONS -> FUNCTION NEWLINE FUNCTIONS\n"); 
			}
			| {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				strcpy($$->value.StringValue, "");
				// printf("FUNCTIONS -> #\n"); 
			};
FUNCTION : '{' ID BODY '}'{ 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				char* body = indent($3->value.StringValue);
				sprintf($$->value.StringValue, "def %s():\n%s", $2->value.StringValue, body);
				// printf("FUNCTION -> '{' ID BODY '}'\n"); 
			}
			| '{' ID WITH '(' PARAMS ')' BODY '}' {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				char* body = indent($7->value.StringValue);
				sprintf($$->value.StringValue, "def %s(%s):\n%s", $2->value.StringValue, $5->value.StringValue, body);
				// printf("FUNCTION -> '{' ID WITH '(' PARAMS ')' BODY '}'\n"); 
				// printf("%s\n", $$->value.StringValue);
			}
			;

PARAMS : PAR PARAMS { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s, %s", $1->value.StringValue, $2->value.StringValue);
				// printf("PARAMLIST -> PARAM PARAMLIST\n"); 
			}
			| PAR { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				strcpy($$->value.StringValue, $1->value.StringValue);
				// printf("PARAMLIST -> #\n"); 
			};

PAR: ID {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		sprintf($$->value.StringValue, "%s", $1->value.StringValue);
		// printf("ITEM -> ID\n"); 
	}
		;
	
BODY : STATEMENT BODY { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, "%s\n%s", $1->value.StringValue, $2->value.StringValue);
			// printf("BODY -> STATEMENT BODY\n"); 
		}
		| STATEMENT { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s", $1->value.StringValue);
			// printf("BODY -> STATEMENT\n"); 
		};
	
STATEMENT : IFSTATEMENT { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s", $1->value.StringValue);
				// printf("%s", $1->value.StringValue); 
			}
			| WHILELOOP { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s", $1->value.StringValue);
				// printf("%s", $1->value.StringValue); 
			}
			| ID '=' EXPR {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
				$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
				int flag = 0;
				for(int i = 0; i < globalIndex; i++) {
					if(strcmp(globals[i], $1->value.StringValue) == 0) {
						sprintf($$->value.StringValue, "global %s\n%s = %s", $1->value.StringValue, $1->value.StringValue, $3->value.StringValue);
						flag = 1;
						break;
					}
				}
				if(flag == 0) {
					sprintf($$->value.StringValue, "%s = %s", $1->value.StringValue, $3->value.StringValue);
				}
				// printf("STATEMENT -> ID '=' EXPR: %s\n", $$->value.StringValue); 
			}
			| '[' CALL ID ']' {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s()", $3->value.StringValue);
				// printf("STATEMENT -> CALL ID\n"); 
			}
			| '[' CALL ID WITH PARAM PARAMLIST ']' {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s(%s%s)", $3->value.StringValue, $5->value.StringValue, $6->value.StringValue);
				// printf("STATEMENT -> CALL ID WITH PARAM PARAMLIST\n"); 
			}
			| RETURN EXPR { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "return %s", $2->value.StringValue);
				// printf("STATEMENT -> RETURN EXPR\n"); 
			}
			;
	
IFSTATEMENT : IF '(' EXPR ')' THEN BODY END {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
				$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
				char* stm = indent($6->value.StringValue);
				sprintf($$->value.StringValue, "if %s :\n%s", $3->value.StringValue, stm); 
				// printf("IFSTATEMENT -> IF '(' EXPR ')' THEN STATEMENT END\n"); 
			}
			| IF '(' EXPR ')' THEN STATEMENT ELSE STATEMENT END {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
				$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
				char* stm1 = indent($6->value.StringValue);
				char* stm2 = indent($8->value.StringValue);
				sprintf($$->value.StringValue, "if %s :\n%selse:\n%s", $3->value.StringValue, stm1, stm2); 
				// printf("IFSTATEMENT -> IF '(' EXPR ')' THEN STATEMENT ELSE STATEMENT END\n"); 
			}
			;
	
WHILELOOP : WHILE '(' EXPR ')' BODY END { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				char* stm = indent($5->value.StringValue);
				sprintf($$->value.StringValue, "while %s :\n%s", $3->value.StringValue, stm);
				// printf("WHILELOOP -> WHILE '(' EXPR ')' STATEMENT END\n"); 
			}
					;
	
EXPR : 	LIST {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s", $1->value.StringValue);
			// printf("EXPR -> LIST\n"); 
		}
		| ARITHLOGIC {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, "%s", $1->value.StringValue); 
			// printf("EXPR -> ARITHLOGIC: %s\n", $$->value.StringValue); 
		}
		| '"' ID '"' {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "\"%s\"", $2->value.StringValue);
			// printf("EXPR -> '\"' ID '\"'\n"); 
		}
			| '[' CALL ID ']' { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s()", $3->value.StringValue);
			// printf("EXPR -> '[' CALL ID ']'\n"); 
		}
		| '[' CALL ID WITH PARAM PARAMLIST ']' { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s(%s%s)", $3->value.StringValue, $5->value.StringValue, $6->value.StringValue);
			// printf("EXPR -> '[' CALL ID WITH PARAM PARAMLIST ']'\n"); 
		}
		;

LIST: '{' ITEMLIST '}' {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		sprintf($$->value.StringValue, "[%s]", $2->value.StringValue);
		// printf("LIST -> '[' EXPRLIST ']'\n"); 
		// printf("%s", $$->value.StringValue);
	}
		| '[' ']' {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		strcpy($$->value.StringValue, "");
		// printf("LIST -> '[' ']'\n"); 
	}
		;

ITEMLIST : ITEM ',' ITEMLIST {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "%s, %s", $1->value.StringValue, $3->value.StringValue);
				// printf("EXPRLIST -> EXPR EXPR1\n"); 
			}
			|ITEM {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				strcpy($$->value.StringValue, $1->value.StringValue);
				// printf("EXPRLIST -> #\n"); 
			};

ITEM: ID {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		sprintf($$->value.StringValue, "%s", $1->value.StringValue);
		// printf("ITEM -> ID\n"); 
	}
		| NUM {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		sprintf($$->value.StringValue, "%s", $1->value.StringValue);
		// printf("ITEM -> NUM\n"); 
	}
	| '"' ID '"' {
		$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
		$$->value.StringValue = (char*)malloc(1024*sizeof(char));
		sprintf($$->value.StringValue, "\"%s\"", $2->value.StringValue);
		// printf("ITEM -> '\"' ID '\"'\n"); 
	}
	;

ARITHLOGIC : TERM ARITH1 {
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
				$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
				sprintf($$->value.StringValue, "%s%s", $1->value.StringValue, $2->value.StringValue); 
				// printf("ARITHLOGIC -> TERM ARITH1: %s\n", $$->value.StringValue); 
			}
			;
	
TERM : FACTOR TERM1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, "%s%s", $1->value.StringValue, $2->value.StringValue); 
			// printf("TERM -> FACTOR TERM1: %s\n", $$->value.StringValue); 
		};
	
ARITH1 : '+' TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " + %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> '+' TERM ARITH1: %s\n", $$->value.StringValue); 
		}
		| '-' TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " - %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> '-' TERM ARITH1\n"); 
			}
		| '>' TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " > %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> '>' TERM ARITH1\n"); 
			}
		| '<' TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " < %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> '<' TERM ARITH1\n"); 
			}
		| '=' TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " == %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> '=' TERM ARITH1\n"); 
			} 
		| OR TERM ARITH1 {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			sprintf($$->value.StringValue, " || %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("ARITH1 -> OR TERM ARITH1\n"); 
			}
		| {
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); 
			$$->value.StringValue = (char*)malloc(1024*sizeof(char)); 
			strcpy($$->value.StringValue, "");
			// strcpy($$->value.StringValue, ""); printf("ARITH1 -> #\n"); 
			};
	
FACTOR : ID {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); strcpy($$->value.StringValue, $1->value.StringValue); 
				// printf("FACTOR -> ID\n"); 
				}
			| NUM {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); strcpy($$->value.StringValue, $1->value.StringValue); 
					// printf("FACTOR -> NUM: %s\n", $$->value.StringValue); 
					}
			| '(' EXPR ')' {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); sprintf($$->value.StringValue, "(%s)", $2->value.StringValue); 
								// printf("FACTOR -> '(' EXPR ')'\n"); 
								}
			| '(' NEG EXPR ')' { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, "(-%s)", $3->value.StringValue);
				// printf("FACTOR -> '(' NEG EXPR ')'\n"); 
				} 
			| '(' NOT EXPR ')' {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); sprintf($$->value.StringValue, "(not %s)", $3->value.StringValue); 
				// printf("FACTOR -> '(' NOT EXPR ')'\n"); 
			};
	
TERM1 : '*' FACTOR TERM1 {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); sprintf($$->value.StringValue, " * %s%s", $2->value.StringValue, $3->value.StringValue); 
			// printf("TERM1 -> '*' FACTOR TERM1\n"); 
			}
			| AND FACTOR TERM1 {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); sprintf($$->value.StringValue, " && %s%s", $2->value.StringValue, $3->value.StringValue); 
				// printf("TERM1 -> AND FACTOR TERM1\n"); 
			}
			| {$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType)); $$->value.StringValue = (char*)malloc(1024*sizeof(char)); strcpy($$->value.StringValue, ""); 
				// printf("TERM1 -> #\n"); 
			};
	
PARAM : ID '=' EXPR { 
			$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
			$$->value.StringValue = (char*)malloc(1024*sizeof(char));
			sprintf($$->value.StringValue, "%s = %s", $1->value.StringValue, $3->value.StringValue);
			// printf("PARAM -> ID '=' EXPR\n"); 
		}
		;
	
PARAMLIST : PARAM PARAMLIST { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				sprintf($$->value.StringValue, ", %s%s", $1->value.StringValue, $2->value.StringValue);
				// printf("PARAMLIST -> PARAM PARAMLIST\n"); 
			}
			| { 
				$$ = (ExtetricksSType)malloc(sizeof(xtetricksSType));
				$$->value.StringValue = (char*)malloc(1024*sizeof(char));
				strcpy($$->value.StringValue, "");
				// printf("PARAMLIST -> #\n"); 
			};
%%
	
int main(int argc, char *argv[])
{
yyparse();
return 0;
}