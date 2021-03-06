%{
#include <stdio.h>
#include <stdlib.h>

#define YYDEBUG 1 
%}

%token AND
%token OR
%token NOT
%token IF
%token ELSE
%token ELIF
%token WHILE
%token FOR
%token READ
%token WRITE
%token INTEGER
%token STRING
%token CHAR
%token BOOL
%token RETURN
%token PROGRAM
%token IDENTIFIER
%token CONSTANT
%token SEMI_COLON
%token COMMA
%token DOT
%token OPEN_CURLY_BRACKET
%token CLOSED_CURLY_BRACKET
%token OPEN_SQUARE_BRACKET
%token CLOSED_SQUARE_BRACKET
%token OPEN_ROUND_BRACKET
%token CLOSED_ROUND_BRACKET
%token PLUS
%token MINUS
%token MUL
%token DIV
%token PERCENT
%token LT
%token GT
%token LE
%token GE
%token ATRIB
%token EQ
%token NOT_EQ

%left '+' '-' '*' '/'


%start program_stmt

%%

program_stmt : PROGRAM compound_stmt {printf("program end\n");}
             ;

compound_stmt : OPEN_CURLY_BRACKET stmt_list CLOSED_CURLY_BRACKET {printf("compound stmt\n");}
              ;

stmt_list : stmt stmt_temp
          ;

stmt_temp : /* empty */
          | stmt_list
          ;

stmt : simple_stmt
     | complex_stmt
     ;

simple_stmt : decl_stmt {printf("declaration stmt\n");}
          | assign_stmt SEMI_COLON {printf("assign stmt\n");}
          | return_stmt SEMI_COLON {printf("return stmt\n");}
          | IO_stmt SEMI_COLON {printf("IO stmt\n");}
          ;

complex_stmt : if_stmt {printf("if stmt\n");}
            | loop_stmt 
            ;

IO_stmt : READ OPEN_ROUND_BRACKET IDENTIFIER CLOSED_ROUND_BRACKET {printf("read IO\n");}
        | WRITE OPEN_ROUND_BRACKET expression write_expressions {printf("write IO\n");}
             ;

write_expressions : COMMA expression write_expressions 
                  | CLOSED_ROUND_BRACKET
                  ;

decl_stmt : type IDENTIFIER NZidentifier
          | type IDENTIFIER ATRIB expression NZEidentifier 
          | type IDENTIFIER ATRIB OPEN_CURLY_BRACKET CONSTANT array_values
          ;

array_values : COMMA CONSTANT array_values
             | CLOSED_CURLY_BRACKET SEMI_COLON
             ;

NZidentifier : COMMA IDENTIFIER NZidentifier 
             | SEMI_COLON
             ;

NZEidentifier : COMMA IDENTIFIER ATRIB expression NZEidentifier 
              | SEMI_COLON
              ;

type : primary_types 
     | array_types
     ;

primary_types : INTEGER
              | CHAR 
              | STRING 
              | BOOL
              ;

array_types : primary_types OPEN_SQUARE_BRACKET CONSTANT CLOSED_SQUARE_BRACKET
            ;

assign_stmt : IDENTIFIER ATRIB expression 
            ;

expression : term operator expression
           | term
           ;

operator : PLUS
         | MINUS
         ;

term : factor MUL term
     | factor DIV term
     | factor
     ;

factor : OPEN_ROUND_BRACKET expression CLOSED_ROUND_BRACKET
       | IDENTIFIER
       | IDENTIFIER OPEN_SQUARE_BRACKET expression CLOSED_SQUARE_BRACKET
       | CONSTANT
       ;

return_stmt : RETURN expression 
            ;

if_stmt : IF OPEN_ROUND_BRACKET condition CLOSED_ROUND_BRACKET compound_stmt {printf("simple if\n");}
        | IF OPEN_ROUND_BRACKET condition CLOSED_ROUND_BRACKET compound_stmt elif_stmt {printf("if with elif/else\n");}
        ;

elif_stmt : ELIF OPEN_ROUND_BRACKET condition CLOSED_ROUND_BRACKET compound_stmt elif_stmt 
          | ELIF OPEN_ROUND_BRACKET condition CLOSED_ROUND_BRACKET compound_stmt 
          | ELSE compound_stmt
          ;

loop_stmt : for_stmt {printf("for stmt\n");}
          | while_stmt {printf("while stmt\n");}
          ;

for_stmt : FOR OPEN_ROUND_BRACKET for_first condition SEMI_COLON assign_stmt CLOSED_ROUND_BRACKET compound_stmt {printf("larger stmt\n");}
         | FOR OPEN_ROUND_BRACKET for_first condition CLOSED_ROUND_BRACKET compound_stmt {printf("shorter for\n");}
         ;

for_first : decl_stmt 
          | assign_stmt SEMI_COLON
          ;

while_stmt : WHILE OPEN_ROUND_BRACKET condition CLOSED_ROUND_BRACKET compound_stmt
           ;

condition : expression relational_operator expression conditional_operator condition 
          | NOT expression relational_operator expression conditional_operator condition 
          | expression relational_operator expression 
          | NOT expression relational_operator expression

relational_operator : GT 
                    | LT 
                    | GE 
                    | LE 
                    | EQ 
                    | NOT_EQ
                    ;

conditional_operator : AND 
                     | OR
                     ;

%%


yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

main(int argc, char **argv)
{
  if (argc > 1) 
    yyin = fopen(argv[1], "r");
  if ( (argc > 2) && ( !strcmp(argv[2], "-d") ) ) 
    yydebug = 1;
  if ( !yyparse() ) 
    fprintf(stderr,"No errors detected\n");
}