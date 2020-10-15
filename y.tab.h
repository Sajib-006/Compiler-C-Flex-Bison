/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    MAIN = 258,
    ADDOP = 259,
    PRINTLN = 260,
    IF = 261,
    FOR = 262,
    CHAR = 263,
    RETURN = 264,
    VOID = 265,
    MULOP = 266,
    FLOAT = 267,
    INT = 268,
    DOUBLE = 269,
    ELSE = 270,
    WHILE = 271,
    ASSIGNOP = 272,
    RELOP = 273,
    LOGICOP = 274,
    NOT = 275,
    LTHIRD = 276,
    INCOP = 277,
    DECOP = 278,
    COMMA = 279,
    CONST_FLOAT = 280,
    CONST_INT = 281,
    ID = 282,
    newline = 283,
    DO = 284,
    BREAK = 285,
    BITOP = 286,
    LPAREN = 287,
    RCURL = 288,
    LCURL = 289,
    RPAREN = 290,
    RTHIRD = 291,
    SEMICOLON = 292,
    LOWER_THAN_ELSE = 293
  };
#endif
/* Tokens.  */
#define MAIN 258
#define ADDOP 259
#define PRINTLN 260
#define IF 261
#define FOR 262
#define CHAR 263
#define RETURN 264
#define VOID 265
#define MULOP 266
#define FLOAT 267
#define INT 268
#define DOUBLE 269
#define ELSE 270
#define WHILE 271
#define ASSIGNOP 272
#define RELOP 273
#define LOGICOP 274
#define NOT 275
#define LTHIRD 276
#define INCOP 277
#define DECOP 278
#define COMMA 279
#define CONST_FLOAT 280
#define CONST_INT 281
#define ID 282
#define newline 283
#define DO 284
#define BREAK 285
#define BITOP 286
#define LPAREN 287
#define RCURL 288
#define LCURL 289
#define RPAREN 290
#define RTHIRD 291
#define SEMICOLON 292
#define LOWER_THAN_ELSE 293

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
