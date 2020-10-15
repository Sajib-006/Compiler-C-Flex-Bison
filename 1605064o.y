%{
#include<stdio.h>
#include<stdlib.h>
#include<bits/stdc++.h>
#define ull unsigned long long
using namespace std;



 



#include "symbolTable2.h"
//SymbolInfo sym;
//scopeTable s_table(7,logout);








#define YYSTYPE SymbolInfo*
using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
FILE *fp;

//SymbolTable *table;
FILE *error=fopen("1605064_error.txt","w");
FILE *parsertext= fopen("1605064_log.txt","w");
vector<SymbolInfo*>perameter_list;
vector< pair< string, string> > pm_list;
list <SymbolInfo*> argument_list;
vector<SymbolInfo*>argument_list2;
vector<string>parameter_type;
vector<SymbolInfo*>id_list;



SymbolTable *table=new SymbolTable(100,parsertext);

int entry = 1;		
int line_count=1;
int error_count=0;
int var_mismatch_flag = 0;
bool declar_type = true;
void yyerror(char *s)
{
	//write your code
	fprintf(stderr,"Line no %d : %s\n",line_count,s);
}
%}

%token MAIN ADDOP PRINTLN IF FOR CHAR RETURN VOID MULOP FLOAT INT DOUBLE ELSE WHILE
%token  ASSIGNOP RELOP LOGICOP NOT LTHIRD 
%token INCOP DECOP COMMA CONST_FLOAT CONST_INT ID newline DO BREAK BITOP
%token	LPAREN RCURL LCURL RPAREN RTHIRD SEMICOLON
 
%left RELOP ADDOP LOGICOP MULOP BITOP 


%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

 

%%
	
start : CONST_INT CONST_INT ADDOP
	{
		//write your code in this block in all the similar blocks below
						fprintf(parsertext,"Line at %d : CONST_INT CONST_INT ADDOP\n\n",line_count);
                        int res=15;
                        //int res=toString($1->getName().c_str());						
						fprintf(parsertext,"%s %s %s = %d\n\n",$1->getName().c_str(),$3->getName().c_str(),$2->getName().c_str(),res); 
}|
    CONST_INT CONST_INT MULOP
	{
		//write your code in this block in all the similar blocks below
						fprintf(parsertext,"Line at %d : CONST_INT CONST_INT MULOP\n\n",line_count);
                        
                        						
						fprintf(parsertext,"%s %s %s=\n\n",$1->getName().c_str(),$3->getName().c_str(),$2->getName().c_str()); 
}|
CONST_FLOAT CONST_FLOAT ADDOP
	{
		//write your code in this block in all the similar blocks below
						fprintf(parsertext,"Line at %d : CONST_FLOAT CONST_FLOAT ADDOP\n\n",line_count);
                        
                        						
						fprintf(parsertext,"%s %s %s=\n\n",$1->getName().c_str(),$3->getName().c_str(),$2->getName().c_str()); 
}|
	CONST_FLOAT CONST_FLOAT MULOP
	{
		//write your code in this block in all the similar blocks below
						fprintf(parsertext,"Line at %d : CONST_FLOAT CONST_FLOAT MULOP\n\n",line_count);
                        
                        						
						fprintf(parsertext,"%s %s %s=\n\n",$1->getName().c_str(),$3->getName().c_str(),$2->getName().c_str()); 
}
	

	
	
	;

%%
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}
	yyin=fp;
	yyparse();
	int val =100;
	
	
	
	fclose(fp);
	fclose(parsertext);
	fclose(error);
	
	
	/*
	fp2= fopen(argv[2],"w");
	fclose(fp2);
	fp3= fopen(argv[3],"w");
	fclose(fp3);
	
	fp2= fopen(argv[2],"a");
	fp3= fopen(argv[3],"a");
	

	yyin=fp;
	yyparse();
	

	fclose(fp2);*/
return 0;
}

			
