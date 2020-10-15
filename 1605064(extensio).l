

%{
#include<stdio.h>
#include<stdlib.h>
#include<bits/stdc++.h>
#define ull unsigned long long
using namespace std;






 //#include "symbolTable.h"
//SymbolInfo sym;
//scopeTable s_table(7,logout);

class Function{
public:
    int no_of_per;
    string ret_type;
    bool is_defined;
    bool is_void_not;
    vector<string> per_list;
    vector<string> per_type_list;
    string get_ret_type(){ return ret_type;}
    int get_no_of_per(){ return no_of_per;}
    bool get_is_defined(){ return is_defined;}
    vector<string> get_per_list(){ return per_list;}
    vector<string> get_per_type_list(){ return per_type_list;}
    void set_no_of_per(){ no_of_per= per_list.size();}
    void set_ret_type(string s){ ret_type=s;}
    void set_is_defined(bool b){ is_defined=b;}
    void add_per(string name,string type)
    {
        no_of_per= per_list.size();
        per_list.push_back(name);
        per_type_list.push_back(type);

    }



};
class SymbolInfo{
public:
    string name;
    string type;
    string declared_type;
    SymbolInfo *sym_ptr;
    Function *func;
    SymbolInfo()
    {
        sym_ptr = 0;
        name=type= "";
        func = 0;
        declared_type ="";
    }
    SymbolInfo(string _name)
    {
        sym_ptr = 0;
        name= _name;
        type= "";
        declared_type ="";
    }
    SymbolInfo(string _name, string _type)
    {
        sym_ptr = 0;
        name= _name;
        type = _type;
        func = 0;
        declared_type ="";
    }
    SymbolInfo(string _name, string _type, string _dectype)
    {
        sym_ptr = 0;
        name= _name;
        type = _type;
        func = 0;
        declared_type = _dectype;
    }
    void set_declared_type(string _dectype)
    {
        declared_type = _dectype;
    }
    void set_func()
    {
        func = new Function;
    }
    Function* get_func()
    {
        return func;
    }
    string get_declared_type()
    {
        return declared_type;
    }
    string getName()
    {
    	return name;
    }
    string getType()
    {
    	return type;
    }

};


//SymbolInfo sym;
//scopeTable s_table(7,logout);


#define YYSTYPE SymbolInfo*
#include "y.tab.h"




extern YYSTYPE yylval;
//extern SymbolTable *table;
void yyerror(char *);
extern int line_count;
extern int error_count;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
FLOAT [-]?[0-9]*\.[0-9]*(E[+-]?[0-9]+)?

IDENTIFIER [A-Za-z_][A-Za-z0-9_]*



%%

{NEWLINE} {line_count++;}


"if"	{
			return IF;
			
		}
		
"else"	{
			return ELSE;

		}

"for"	{
			return FOR;

		}

"while"	{
			return WHILE;

		}

"do"	{
			return DO;
		}

"break"	{
			return BREAK;

		}

"int"	{SymbolInfo *s= new SymbolInfo(yytext,"INT");
				yylval = (YYSTYPE)s;

		return INT;}
{FLOAT}	{SymbolInfo *s= new SymbolInfo(yytext,"CONST_FLOAT");
				yylval = (YYSTYPE)s;

		return CONST_FLOAT;}




"float" {SymbolInfo *s= new SymbolInfo(yytext,"FLOAT");
				yylval = (YYSTYPE)s;

		return FLOAT;}

"double" {return DOUBLE;}

"void"	{SymbolInfo *s= new SymbolInfo(yytext,"VOID");
				yylval = (YYSTYPE)s;

		return VOID;}

"return"	{SymbolInfo *s= new SymbolInfo(yytext,"RETURN");
				yylval = (YYSTYPE)s;

		return RETURN;}



{IDENTIFIER}  {
	SymbolInfo *s= new SymbolInfo(yytext,"ID");
				yylval = (YYSTYPE)s;
							
				return ID;
			}



"+"		|

"-"		{
			SymbolInfo *s= new  SymbolInfo(yytext,"ADDOP");
			yylval = (YYSTYPE)s;
			return ADDOP;
		}

"*"		|

"/"		|

"%"    {	SymbolInfo *s= new  SymbolInfo(yytext, "MULOP");
			yylval = (YYSTYPE)s;
			return MULOP;
		}
"++"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"INCOP");
			yylval = (YYSTYPE)s;
			return INCOP;
		}

"--"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"DECOP");
			yylval = (YYSTYPE)s;
			return DECOP;
		}

"<"		|
"<="	|
">"		|
">="	|
"=="	|
"!="	{
			SymbolInfo *s= new  SymbolInfo(yytext,"RELOP");
			yylval = (YYSTYPE)s;
			return RELOP;
		}

"="		{
			SymbolInfo *s= new  SymbolInfo(yytext,"ASSIGNOP");
			yylval = (YYSTYPE)s;
			return ASSIGNOP;
		}

"&&"	|
"||"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"LOGICOP");
			yylval = (YYSTYPE)s;
			return LOGICOP;
		}
"&"		|
"|"		|
"^"		|
"<<"	|
">>"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"BITOP");
			yylval = (YYSTYPE)s;
			return BITOP;
		}

"!"	{
			SymbolInfo *s= new  SymbolInfo(yytext,"NOT");
			yylval = (YYSTYPE)s;
			return NOT;
		}
";" 	{ return SEMICOLON;}
"," 	{return COMMA;}
"(" 	{return LPAREN;}
")" 	{return RPAREN;}
"{" 	{return LCURL;}
"}" 	{return RCURL;}
"[" 	{return LTHIRD;}
"]" 	{return RTHIRD;}




		
{DIGIT}+ 	{
				SymbolInfo *s= new  SymbolInfo(yytext, "CONST_INT");
				yylval = (YYSTYPE)s;
				return CONST_INT;
			}






%%

int yywrap(void)
{
	return 1;
}
