grammar R2D2;

/*
 * Parser Rules
 */

program
  : importDeclaration* interfaceDeclaration* declaration* EOF
  ;

declaration
  : moduleDeclaration
  | globalDeclaration
  | typeDeclaration
  ;

globalDeclaration
  : CONST IDENTIFIER typeExpression ASSIGN expression SEMI
  ;

importDeclaration
  : USE STRING_LITERAL SEMI
  ;

interfaceDeclaration
  : INTERFACE IDENTIFIER LBRACE (variableDeclaration* | functionDeclaration*) RBRACE
  ;

moduleDeclaration
  : MODULE IDENTIFIER (IMPLEMENTS IDENTIFIER)? LBRACE (functionDeclaration | typeDeclaration | variableDeclaration)* RBRACE
  ;

functionDeclaration
  : (EXPORT)? (PSEUDO)? FN IDENTIFIER LPAREN parameterList? RPAREN (typeExpression)? (block | SEMI)
  ;

functionCallStatement
  : functionCall SEMI
  ;

functionCall
  : (IDENTIFIER DOT)* IDENTIFIER LPAREN argumentList? RPAREN
  ;

parameterList
  : parameter (COMMA parameter)*
  ;

parameter
  : IDENTIFIER ( typeExpression )?
  ;

typeExpression
  : baseType arrayDimensions?
  | arrayDimensions? baseType
  ;

arrayDimensions
  : (LBRACK (INT_LITERAL)? RBRACK)+
  ;

baseType
  : IDENTIFIER
  | TYPE
  | genericType
  ;

genericType
  : IDENTIFIER LT typeExpression (COMMA typeExpression)* GT
  ;

typeDeclaration
  : (EXPORT)? 'type' IDENTIFIER LBRACE (variableDeclaration)* RBRACE
  ;

variableDeclaration
  : (EXPORT)? (VAR | LET | CONST) IDENTIFIER (typeExpression)? (ASSIGN expression)? SEMI
  ;

statement
  : variableDeclaration
  | functionCallStatement
  | expressionStatement
  | ifStatement
  | forStatement
  | whileStatement
  | loopStatement
  | cicleControl
  | returnStatement
  | switchStatement
  | assignmentDeclaration
  | jsStatement
  ;

expressionStatement
  : expression SEMI
  ;

ifStatement
  : IF (LPAREN)? expression (RPAREN)? (block | ARROW statement)
    (ELSE IF (LPAREN)? expression (RPAREN)? (block | ARROW statement))*
    (ELSE (block | ARROW statement))?
  ;

forStatement
  : FOR (LPAREN)? simpleFor (RPAREN)? block
  ;

assignmentDeclaration
  : assignment SEMI
  ;

assignment
  : IDENTIFIER assignmentOperator expression
  | IDENTIFIER (INCREMENT | DECREMENT)
  | IDENTIFIER LBRACK expression RBRACK assignmentOperator expression
  | IDENTIFIER LBRACK expression RBRACK (INCREMENT | DECREMENT)
  ;

assignmentOperator
  : ASSIGN
  | PLUS_ASSIGN
  | MINUS_ASSIGN
  | MULT_ASSIGN
  | DIV_ASSIGN
  | MOD_ASSIGN
  ;

simpleFor
  : (variableDeclaration | assignment SEMI)? (expression SEMI)? (assignment)?
  ;

whileStatement
  : WHILE (LPAREN)? expression (RPAREN)? block
  ;

loopStatement
  : LOOP block
  ;

cicleControl
  : (breakStatement | continueStatement)
  ;

breakStatement
  : BREAK SEMI
  ;

continueStatement
  : CONTINUE SEMI
  ;

returnStatement
  : RETURN expression? SEMI
  ; expression : literal                                                #literalExpression
  | IDENTIFIER                                             #identifierExpression
  | functionCall                                           #functionCallExpression
  | expression LBRACK expression RBRACK                    #arrayAccessExpression
  | '(' expression ')'                                     #parenthesisExpression
  | (NOT | MINUS | INCREMENT | DECREMENT) expression       #unaryExpression
  | expression (MULT | DIV | MOD) expression               #multiplicativeExpression
  | expression (PLUS | MINUS) expression                   #additiveExpression
  | expression (EQ | NEQ | LT | GT | LEQ | GEQ) expression #comparisonExpression
  | expression (AND | OR) expression                       #logicalExpression
  ;

// expression
//   : logicalExpression
//   ;
//
// logicalExpression
//   : comparisonExpression ((AND | OR) comparisonExpression)*
//   ;
//
// comparisonExpression
//   : additiveExpression ((EQ | NEQ | LT | GT | LEQ | GEQ) additiveExpression)*
//   ;
//
// additiveExpression
//   : multiplicativeExpression ((PLUS | MINUS) multiplicativeExpression)*
//   ;
//
// multiplicativeExpression
//   : unaryExpression ((MULT | DIV | MOD) unaryExpression)*
//   ;
//
// unaryExpression
//   : (NOT | MINUS | INCREMENT | DECREMENT) unaryExpression
//   | memberExpression
//   ;

memberExpression
  : primaryExpression memberPart*
  ;

memberPart
  : LBRACK expression RBRACK
  | DOT IDENTIFIER
  | INCREMENT
  | DECREMENT
  | LPAREN argumentList? RPAREN
  ;

argumentList
  : expression (COMMA expression)*
  ;

primaryExpression
  : IDENTIFIER
  | literal
  | LPAREN expression RPAREN
  | arrayLiteral
  | functionCall
  ;

arrayLiteral
  : LBRACK (expression (COMMA expression)*)? RBRACK
  ;

literal
  : INT_LITERAL
  | FLOAT_LITERAL
  | STRING_LITERAL
  | BOOL_LITERAL
  | NULL_LITERAL
  | arrayLiteral
  ;

block
  : LBRACE statement* RBRACE
  ;

switchStatement
  : SWITCH (LPAREN)? expression (RPAREN)? LBRACE switchCase* defaultCase? RBRACE
  ;

switchCase
  : CASE expression block
  | CASE expression ARROW statement
  ;

defaultCase
  : DEFAULT block
  | DEFAULT ARROW statement
  ;

jsStatement
  : AT JS STRING_LITERAL SEMI
  ;

/*
 * Lexer Rules
 */

// Keywords
USE: 'use';
IMPORT: 'import';
FROM: 'from';
INTERFACE: 'interface';
MODULE: 'module';
IMPLEMENTS: '::';
EXPORT: 'export';
FN: 'fn';
PSEUDO: 'pseudo';
VAR: 'var';
LET: 'let';
CONST: 'const';
IF: 'if';
ELSE: 'else';
LOOP: 'loop';
FOR: 'for';
WHILE: 'while';
BREAK: 'break';
SEND: 'send';
CONTINUE: 'continue';
RETURN: 'return';
SWITCH: 'switch';
CASE: 'case';
DEFAULT: 'default';

// Operators
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
MOD: '%';
INCREMENT: '++';
DECREMENT: '--';
ASSIGN: '=';
PLUS_ASSIGN: '+=';
MINUS_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';
MOD_ASSIGN: '%=';
EQ: '==';
NEQ: '!=';
LT: '<';
GT: '>';
LEQ: '<=';
GEQ: '>=';
AND: '&&';
OR: '||';
NOT: '!';

// Delimiters
LPAREN: '(';
RPAREN: ')';
LBRACE: '{';
RBRACE: '}';
LBRACK: '[';
RBRACK: ']';
COMMA: ',';
DOT: '.';
COLON: ':';
SEMI: ';';

// Other stuff
AT      : '@';
JS      : 'js';
ARROW   : '=>';

TYPE
  : 'number'
  | 'boolean'
  | 'string'
  | 'array'
  | 'object'
  | 'void'
  ;

STRING_LITERAL
  : '"""' .*? '"""'              // Multilinha — permissiva e permite \n
  | '"' ( '\\' . | ~["\\\r\n] )* '"'  // Linha única com escapes
  ;

fragment ESCAPE_SEQUENCE : '\\' [btnr"\\];

BOOL_LITERAL
  : 'true'
  | 'false'
  ;

  NULL_LITERAL
  : 'null'
  ;

INT_LITERAL
  : DecimalIntegerLiteral
  | HexIntegerLiteral
  | OctalIntegerLiteral
  | BinaryIntegerLiteral
  ;

// Identifiers and literals
IDENTIFIER: ([a-zA-Z_][a-zA-Z_0-9]*);

fragment DecimalIntegerLiteral
  : SignPart? DecimalNumeral
  ;

fragment HexIntegerLiteral
  : '0' [xX] HexDigits
  ;

fragment OctalIntegerLiteral
  : '0' OctalDigits
  ;

fragment BinaryIntegerLiteral
  : '0' [bB] BinaryDigits
  ;

FLOAT_LITERAL
  : SignPart? DecimalNumeral '.' DecimalDigits? ExponentPart?
  | SignPart? '.' DecimalDigits ExponentPart?
  | SignPart? DecimalNumeral ExponentPart
  ;

fragment SignPart
  : [+-]
  ;

fragment DecimalNumeral
  : '0'
  | NonZeroDigit DecimalDigits?
  ;

fragment DecimalDigits
  : DecimalDigit+
  ;

fragment DecimalDigit
  : [0-9]
  ;

fragment NonZeroDigit
  : [1-9]
  ;

fragment HexDigits
  : HexDigit+
  ;

fragment HexDigit
  : [0-9a-fA-F]
  ;

fragment OctalDigits
  : OctalDigit+
  ;


fragment OctalDigit
  : [0-7]
  ;

fragment BinaryDigits
  : BinaryDigit+
  ;

fragment BinaryDigit
  : [01]
  ;

fragment ExponentPart
  : [eE] SignPart? DecimalDigits
  ;

// Comments and whitespace
COMMENT
  : '//' ~[\r\n]* -> skip
  ;

BLOCK_COMMENT
  : '/*' .*? '*/' -> skip
  ;

WHITESPACE
  : [ \t\r\n\u000C\u00A0\u2028\u2029]+ -> skip
  ;
