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
	
start : program
	{
		//write your code in this block in all the similar blocks below
    }
      


	
	;

program : program unit {
						string str =$1->getName()+$2->getName();
						fprintf(parsertext,"Line at %d : program->program unit\n\n",line_count);
						$$=new SymbolInfo(str); 
						fprintf(parsertext,"%s %s\n\n",$1->getName().c_str(),$2->getName().c_str()); 
						
						}

	| unit{				string str =$1->getName();
						fprintf(parsertext,"Line at %d : program->unit\n\n",line_count);
						bool bl = true;
						SymbolInfo sm($1->getName());
						sm.set_is_void(bl);
						
						$$=new SymbolInfo(str); 
						fprintf(parsertext,"%s\n\n",$1->getName().c_str());
	
			}
 
	;
	
unit : var_declaration{	fprintf(parsertext,"Line at %d : unit->var_declaration\n\n",line_count);
						string str =$1->getName()+"\n";
						
						$$=new SymbolInfo(str); 
						bool bl = true;
						SymbolInfo sm($1->getName());
						sm.set_is_void(bl);
						fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
					
						}
     | func_declaration{
     bool bl = true;
     					string str =$1->getName()+"\n";
						fprintf(parsertext,"Line at %d : unit->func_declaration\n\n",line_count);
						$$=new SymbolInfo(str); 
						
						SymbolInfo sm($1->getName());
						sm.set_is_void(bl);
						fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
     
     
     
     
     
     
     					}
     | func_definition{
     					bool bl = true;
     					string str =$1->getName()+"\n";
						fprintf(parsertext,"Line at %d : unit->func_definition\n\n",line_count);
						$$=new SymbolInfo(str); 
						
						SymbolInfo sm($1->getName());
						sm.set_is_void(bl);
						fprintf(parsertext,"%s\n\n",$1->getName().c_str()); ;
     					}
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON{
		int k;
		fprintf(parsertext,"Line at %d : func_declaration->type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n\n",line_count);
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+"("+$4->getName()+");");
		bool bl = true;
		SymbolInfo sm2($1->getName());
		sm2.set_is_void(bl);
		fprintf(parsertext,"%s %s(%s);\n\n",$1->getName().c_str(),$2->getName().c_str(),$4->getName().c_str());
		SymbolInfo *symb=table->lookup_symbol(0,$2->getName()); 
		sm2.is_function = true;
				if(symb==0){ 
						
				
					
						SymbolInfo sm($2->getName(),"ID","Function");
						
						table->insert_symbol(0,sm);
						symb=table->lookup_symbol(0,$2->getName());
						symb->set_func();
						bool val=true;
						symb->get_func()->set_ret_type($1->getName());
						//symb->get_func()->set_is_defined(val);
						int i=0;
						while(i<perameter_list.size())
						{
							symb->get_func()->add_per(perameter_list[i]->getName(),perameter_list[i]->get_declared_type());
							i++;
						}
						
					
				}
				else{
					
				
						if(symb->get_func()->get_no_of_per() != perameter_list.size() && entry==1){
							k = error_count;
							fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
							error_count++;
						} else{
							if(symb->get_func()->get_ret_type()!=$1->getName()){
									k = error_count;
									fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
									error_count++;
							}
							parameter_type=symb->get_func()->get_per_type_list();
							int i=0;
							
							while(i<perameter_list.size() && entry==1){
									int k=0;
									if(perameter_list[i]->get_declared_type()!=parameter_type[i]){
										k = error_count;
										fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
										error_count++;
										break;
									}
									i++;
							}
							
					
						}
					k++;
					perameter_list.clear();
					
				

				} 
	
		
		
		
		
		
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON{
		fprintf(parsertext,"Line at %d : func_declaration->type_specifier ID LPAREN RPAREN SEMICOLON\n\n",line_count);
		$$=new SymbolInfo($1->getName()+" "+$2->getName()+"();");
		fprintf(parsertext,"%s %s();\n\n",$1->getName().c_str(),$2->getName().c_str());
		bool bl = true;
		SymbolInfo sm2($1->getName());
		sm2.set_is_void(bl);
		SymbolInfo *symb=table->lookup_symbol(0,$2->getName()); 
		int k;
		sm2.is_function = true;
				if(symb==0 && entry==1){ 
						
				
						sm2.is_function = false;
						SymbolInfo sm($2->getName(),"ID","Function");
						k = error_count;
						table->insert_symbol(0,sm);
						symb=table->lookup_symbol(0,$2->getName());
						symb->set_func();
						bool val=true;
						symb->get_func()->set_ret_type($1->getName());
						//symb->get_func()->set_is_defined(val);
						
						
					
				}
				else{
						
							if(symb->get_func()->get_ret_type()!=$1->getName()){
									k = error_count;
									fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
									error_count++;
							}
							if(symb->get_func()->get_no_of_per() != 0){
								k = error_count;
								fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
								error_count++;
							}
							
					}
					k++;
					
				

				
		
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN 
				{
				int k;
				SymbolInfo *symb=table->lookup_symbol(0,$2->getName()); 
				bool bl = true;
				SymbolInfo sm2($2->getName());
				sm2.set_is_void(bl);
				if(symb==0){ 
						
				
					//cout<<"hi"<<line_count;
						SymbolInfo sm($2->getName(),"ID","Function");
						sm2.is_function = false;
						table->insert_symbol(0,sm);
						symb=table->lookup_symbol(0,$2->getName());
						symb->set_func();
						bool val=true;
						symb->get_func()->set_ret_type($1->getName());
						symb->get_func()->set_is_defined(val);
						//cout<<"func: "<<line_count<<" "<<symb->isit_function()<<endl;
						int i=0;
						while(i<perameter_list.size())
						{
							pm_list.push_back(make_pair(perameter_list[i]->getName(),perameter_list[i]->get_declared_type()));
							symb->get_func()->add_per(perameter_list[i]->getName(),perameter_list[i]->get_declared_type());
							i++;
						}
						
					
				}
				else{
					//cout<<line_count<<" : "<<symb->get_func()->get_is_defined()<<endl;
					if(symb->get_func()->get_is_defined()!=0 && entry==1){
						k =error_count;
						fprintf(error,"Error at Line No.%d:  Multiple defination of function %s\n\n",line_count,$2->getName().c_str());
						error_count++;
					} 
					else{
				
						if(symb->get_func()->get_no_of_per() != perameter_list.size() && entry==1){
							k =error_count;
							fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
							error_count++;
						} else{
							if(symb->get_func()->get_ret_type()!=$1->getName()){
									k =error_count;
									fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
									error_count++;
							}
							parameter_type=symb->get_func()->get_per_type_list();
							int i=0;
							while(i<perameter_list.size() && entry==1){
									int k=0;
									if(perameter_list[i]->get_declared_type()!=parameter_type[i]){
										k =error_count;
										fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
										error_count++;
										break;
									}
									i++;
									
							}
							
					
						}
						k++;
						int val=true;
						symb->get_func()->set_is_defined(val);
						sm2.is_function = true;
					}
					
				

				} 
	
	}
	compound_statement{bool bl = true;
	fprintf(parsertext,"Line at %d : func_definition->type_specifier ID LPAREN parameter_list RPAREN compound_statement \n\n",line_count);
	
	SymbolInfo sm2($2->getName());
	sm2.set_is_void(bl);
	fprintf(parsertext,"%s %s(%s) %s \n\n",$1->getName().c_str(),$2->getName().c_str(),$4->getName().c_str(),$7->getName().c_str());
	$$=new SymbolInfo($1->getName()+" "+$2->getName()+"("+$4->getName()+")"+$7->getName()); 			
	
	}
		| type_specifier ID LPAREN RPAREN {
		int k;
		SymbolInfo *symb=table->lookup_symbol(0,$2->getName()); 
		bool bl = true;
		SymbolInfo sm2($2->getName());
		sm2.set_is_void(bl);
				if(symb==0){ 
						
				
					
						SymbolInfo sm($2->getName(),"ID","Function");
						sm2.is_function = false;
						table->insert_symbol(0,sm);
						symb=table->lookup_symbol(0,$2->getName());
						symb->set_func();
						bool val=true;
						symb->get_func()->set_ret_type($1->getName());
						symb->get_func()->set_is_defined(val);
						
						
					
				}
				else{
				//cout<<line_count<<" : "<<symb->get_func()->get_is_defined()<<endl;
					if(symb->get_func()->get_is_defined()!=0 && entry==1){
						k =error_count;
						fprintf(error,"Error at Line No.%d:  Multiple defination of function %s\n\n",line_count,$2->getName().c_str());
						error_count++;
					} 
					else{
				
						
							if(symb->get_func()->get_ret_type()!=$1->getName() && entry==1){
									k =error_count;
									fprintf(error,"Error at Line No.%d: Return Type Mismatch1 \n\n",line_count);
									error_count++;
							}
							if(symb->get_func()->get_no_of_per() != 0 && entry==1){
								k =error_count;
								fprintf(error,"Error at Line No.%d:  Invalid number of parameters \n\n",line_count);
								error_count++;
							}
							
							
					
						
						k++;
						int val=true;
						symb->get_func()->set_is_defined(val);
						sm2.is_function = true;
					}
					
				

				} 
		}
		compound_statement{bool bl = true;
		fprintf(parsertext,"Line at %d : func_definition->type_specifier ID LPAREN RPAREN compound_statement\n\n",line_count);
		
		SymbolInfo sm2($2->getName());
		sm2.set_is_void(bl);
		fprintf(parsertext,"%s %s() %s\n\n",$1->getName().c_str(),$2->getName().c_str(),$6->getName().c_str());
		$$=new SymbolInfo($1->getName()+" "+$2->getName().c_str()+"() "+$6->getName());
		
		}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID{bool bl = true;
			string str = $1->getName()+","+$3->getName()+" "+$4->getName();
			fprintf(parsertext,"Line at %d : parameter_list->parameter_list COMMA type_specifier ID\n\n",line_count);
			$$=new SymbolInfo(str);
			SymbolInfo *symb = new SymbolInfo($4->getName(),"ID",$3->getName());
			
			SymbolInfo sm2($2->getName());
			sm2.set_is_void(bl);
			perameter_list.push_back(symb);
			
			fprintf(parsertext,"%s,%s %s\n\n",$1->getName().c_str(),$3->getName().c_str(),$4->getName().c_str());
			}
		| parameter_list COMMA type_specifier{ bool bl = true;
			string str = $1->getName()+","+$3->getName();
			fprintf(parsertext,"Line at %d : parameter_list->parameter_list COMMA type_specifier\n\n",line_count);
			$$=new SymbolInfo(str);
			SymbolInfo *symb = new SymbolInfo("","ID",$3->getName());
			
			SymbolInfo sm2($2->getName());
			sm2.set_is_void(bl);
			perameter_list.push_back(symb);
			fprintf(parsertext,"%s,%s\n\n",$1->getName().c_str(),$3->getName().c_str());
			}
 		| type_specifier ID{bool bl = true;
 			string str = $1->getName()+" "+$2->getName();
 			fprintf(parsertext,"Line at %d : parameter_list->type_specifier ID\n\n",line_count);
 			$$=new SymbolInfo(str);
 			SymbolInfo *symb = new SymbolInfo($2->getName(),"ID",$1->getName());
 			
			SymbolInfo sm2($2->getName());
			sm2.set_is_void(bl);
			perameter_list.push_back(symb);
			fprintf(parsertext,"%s %s\n\n",$1->getName().c_str(),$2->getName().c_str());
 			}
		| type_specifier{bool bl = true;
			string str = $1->getName()+" ";
			fprintf(parsertext,"Line at %d : parameter_list->type_specifier\n\n",line_count);
			$$=new SymbolInfo(str);
			SymbolInfo *symb = new SymbolInfo("","ID",$1->getName());
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			perameter_list.push_back(symb);
			fprintf(parsertext,"%s \n\n",$1->getName().c_str());
			}
 		;

 		
compound_statement : LCURL {
				int i=0;
				string str = "ID";
				table->enterScope(0,100);
				int val = 100;
				//cout<<perameter_list.size()<<endl;
				while(i<perameter_list.size() && entry==1)
				{
					bool bl = true;
					SymbolInfo sm2(perameter_list[i]->getName());
					sm2.set_is_void(bl);
					SymbolInfo sm(perameter_list[i]->getName(),str,perameter_list[i]->get_declared_type());
				    table->insert_symbol(val,sm);
					i++;
				}
					
				
				perameter_list.clear();
			}
			statements RCURL{
				int val = 100;
				fprintf(parsertext,"Line at %d : compound_statement->LCURL statements RCURL\n\n",line_count);
				$$=new SymbolInfo("{\n"+$3->getName()+"\n}"); 
				
				fprintf(parsertext,"{\n%s\n}\n\n",$3->getName().c_str());
				bool bl = true;
				SymbolInfo sm2($3->getName());
				sm2.set_is_void(bl);
				table->print_all_scope_table(val);
				int val2 = 0;
				table->exitScope(val2);
			
			}
 		    | LCURL RCURL{
 		    	int i=0;
				string str = "ID";
				table->enterScope(0,100);
				int v = 100;
				while(i<perameter_list.size() && entry==1)
				{
					bool bl = true;
					SymbolInfo sm2(perameter_list[i]->getName());
					sm2.set_is_void(bl);
					SymbolInfo sm(perameter_list[i]->getName(),str,perameter_list[i]->get_declared_type());
					table->insert_symbol(v,sm);
					i++;
				}
				perameter_list.clear();
 		    	int val = 100;
				fprintf(parsertext,"Line at %d : compound_statement->LCURL statements RCURL\n\n",line_count);
				$$=new SymbolInfo("{}"); 
				fprintf(parsertext,"{\n}\n\n");
				bool bl = true;
				SymbolInfo sm2($$->getName());
				sm2.set_is_void(bl);
				table->print_all_scope_table(val);
				int val2 = 0;
				table->exitScope(val2);
 		    
 		    }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON{
			int k;
			fprintf(parsertext,"Line at %d : var_declaration->type_specifier declaration_list SEMICOLON\n\n",line_count);
			$$=new SymbolInfo($1->getName()+" "+$2->getName()+";");
			bool bl = false;
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,"%s %s;\n\n",$1->getName().c_str(),$2->getName().c_str());
			k++;
			if($1->getName()=="int " || $1->getName()=="float "){
				k=error_count;
				for(int i=0;i<id_list.size();i++){
					if(table->lookup_symbol_recent(0,id_list[i]->getName()) && declar_type==true){
						k=error_count;
						fprintf(error,"Error at Line No.%d:  Multiple Declaration of %s \n\n",line_count,id_list[i]->getName().c_str());
						error_count++;
						continue;
					}
					if(id_list[i]->getType()=="ID" && declar_type==true){
						bool val=true;
						//cout<<line_count<<"inserted: "<<id_list[i]->getName()<<","<<id_list[i]->getType()<<","<<$1->getName()<<endl;
						SymbolInfo sm(id_list[i]->getName(),id_list[i]->getType(),$1->getName());
						table->insert_symbol(0,sm);
						bool bl = false;
						SymbolInfo sm2($1->getName());
						sm2.set_is_void(bl);
						SymbolInfo *symb=table->lookup_symbol(0,id_list[i]->getName()); 
						//cout<<"After insertion:"<<symb->getName()<<" "<<symb->get_declared_type()<<endl;
						//symb->set_var();
						symb->is_id = true;
						//symb->get_var()->set_is_var(val);
					
						
					}else{
						bool val=true;	
						id_list[i]->setType(id_list[i]->getType().substr(0,id_list[i]->getType().size () - 1));
						SymbolInfo sm(id_list[i]->getName(),id_list[i]->getType(),$1->getName()+"array");
						table->insert_symbol(0,sm);
						bool bl = false;
						SymbolInfo sm2($1->getName());
						sm2.set_is_void(bl);
						SymbolInfo *symb=table->lookup_symbol(0,id_list[i]->getName()); 
						//cout<<"After insertion:"<<symb->getName()<<" "<<symb->get_declared_type()<<endl;
						//symb->set_arr();
						symb->is_array = true;
						//symb->get_arr()->set_is_arr(val);
					}}
				}
			else{
				k=error_count;												
				fprintf(error,"Error at Line No.%d: TYpe specifier can not be void \n\n",line_count);
				error_count++;
			}
			k=error_count;
			id_list.clear();
			k++;
															


}
 		 ;
 		 
type_specifier	: INT{	fprintf(parsertext,"Line at %d : type_specifier	: INT\n\n",line_count);
						$$->setName("int ");
						string str ="int";
						fprintf(parsertext,"int \n\n");
						
					}
 		| FLOAT{
 						fprintf(parsertext,"Line at %d : type_specifier	: FLOAT\n\n",line_count);
 						$$->setName("float ");
 						string str ="float";
						fprintf(parsertext,"float \n\n");
						
				}
 		| VOID{
 						fprintf(parsertext,"Line at %d : type_specifier	: VOID\n\n",line_count);
 						$$->setName("void ");
 						string str ="void";
						fprintf(parsertext,"void \n\n");
						
				}
 		;
 		
declaration_list : declaration_list COMMA ID{
			bool bl = false;
			fprintf(parsertext,"Line at %d : declaration_list->declaration_list COMMA ID\n\n",line_count);
			$$=new SymbolInfo($1->getName()+","+$3->getName());
			fprintf(parsertext,"%s,%s\n\n",$1->getName().c_str(),$3->getName().c_str());
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			SymbolInfo *symb = new SymbolInfo($3->getName(),"ID");
			id_list.push_back(symb);
			
											


			}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD{
 		  	bool bl = false;
 		    $$=new SymbolInfo($1->getName()+","+$3->getName()+"["+$5->getName()+"]"); 
 		    fprintf(parsertext,"Line at %d : declaration_list->declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
 		    
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
		    fprintf(parsertext,"%s,%s[%s]\n\n",$1->getName().c_str(),$3->getName().c_str(),$5->getName().c_str());
		    SymbolInfo *symb = new SymbolInfo($3->getName(),"Array");
			id_list.push_back(symb);
												
 		  
 		  
 		  }
 		  | ID{bool bl = false;
 		  	$$=new SymbolInfo($1->getName()); 
 		  	fprintf(parsertext,"Line at %d : declaration_list->ID\n\n",line_count);
		   	fprintf(parsertext,"%s\n\n",$1->getName().c_str());
		   	
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
		   	SymbolInfo *symb = new SymbolInfo($1->getName(),"ID");
			id_list.push_back(symb);
			
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD{bool bl = false;
 		  	$$=new SymbolInfo($1->getName()+"["+$3->getName()+"]");
 		  	fprintf(parsertext,"Line at %d : declaration_list->ID LTHIRD CONST_INT RTHIRD\n\n",line_count);
 		  	
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
		   	fprintf(parsertext,"%s[%s]\n\n",$1->getName().c_str(),$3->getName().c_str());
		   	SymbolInfo *symb = new SymbolInfo($1->getName(),"Array");
			id_list.push_back(symb);
		   	

 		  
 		  
 		  }
 		  ;
 		  
statements : statement{bool bl = false;
			string str = $1->getName();
			fprintf(parsertext,"Line at %d : statements->statement\n\n",line_count);
			$$=new SymbolInfo(str);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,"%s\n\n",$1->getName().c_str());


		}
	   | statements statement{bool bl = false;
	   		string str = $1->getName();
	   		string str2 = $2->getName();
			fprintf(parsertext,"Line at %d : statements->statements statement\n\n",line_count);
			$$=new SymbolInfo(str+"\n"+str2);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,"%s %s\n\n",$1->getName().c_str(),$2->getName().c_str()); 
	   
	   
	   
	   }
	   ;
	   
statement : var_declaration{bool bl = false;
			string str = $1->getName();
			fprintf(parsertext,"Line at %d : statement -> var_declaration\n\n",line_count);
			$$=new SymbolInfo(str);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,"%s\n\n",$1->getName().c_str());
			
	  }
	  | expression_statement{bool bl = false;
	  		string str = $1->getName();
			fprintf(parsertext,"Line at %d : statement -> expression_statement\n\n",line_count);
			$$=new SymbolInfo(str);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,"%s\n\n",$1->getName().c_str());
	  }
	  | compound_statement{bool bl = false;
	  		string str = $1->getName();
			fprintf(parsertext,"Line at %d : statement->compound_statement\n\n",line_count);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			$$=new SymbolInfo(str);
			fprintf(parsertext,"%s\n\n",$1->getName().c_str());
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement{
	  		int k;
	  		fprintf(parsertext,"Line at %d : statement ->FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n",line_count);
	  		
	  		$$=new SymbolInfo("for("+$3->getName()+$4->getName()+$5->getName()+")\n"+$5->getName());
	  		bool bl = false;
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		fprintf(parsertext,"for(%s %s %s)\n%s \n\n",$3->getName().c_str(),$4->getName().c_str(),$5->getName().c_str(),$7->getName().c_str());
	  		
	  		 if($2->get_declared_type()=="int "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("int "); 
			}
			else if($2->get_declared_type()=="float " && declar_type==true){
				k=error_count;
				$$->set_declared_type("float "); 
			}
			else if($2->get_declared_type()=="void "  && declar_type==true){
				k=error_count;
				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
				error_count++;
				$$->set_declared_type("void "); 
			}
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE{
	  		int k;
	  		bool bl = false;
	  		fprintf(parsertext,"Line at %d : statement->IF LPAREN expression RPAREN statement\n\n",line_count);
	  		
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		$$=new SymbolInfo("if("+$3->getName()+")\n"+$5->getName());
	  		fprintf(parsertext,"if(%s)\n%s\n\n",$3->getName().c_str(),$5->getName().c_str());
	  		
	  		
	  		  if($3->get_declared_type()=="int "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("int "); 
			}
			else if($3->get_declared_type()=="float "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("float "); 
			}
			else if($3->get_declared_type()=="void "  && declar_type==true){
				k=error_count;
				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
				error_count++;
				$$->set_declared_type("void "); 
			}
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement{
	  		int k;
	  		bool bl = false;
	  		fprintf(parsertext,"Line at %d : statement->IF LPAREN expression RPAREN statement ELSE statement\n\n",line_count);
	  		
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		$$=new SymbolInfo("if("+$3->getName()+")\n"+$5->getName()+" else \n"+$7->getName());
	  		fprintf(parsertext,"if(%s)\n%s\n else \n %s\n\n",$3->getName().c_str(),$5->getName().c_str(),$7->getName().c_str());
	  		
	  		
	  		  if($3->get_declared_type()=="int "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("int "); 
			}
			else if($3->get_declared_type()=="float "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("float "); 
			}
			else if($3->get_declared_type()=="void "  && declar_type==true){
				k=error_count;
				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
				error_count++;
				$$->set_declared_type("void "); 
			}
	  }
	  | WHILE LPAREN expression RPAREN statement{
	  		int k;
	  		bool bl = false;
	  		fprintf(parsertext,"Line at %d : statement->WHILE LPAREN expression RPAREN statement\n\n",line_count);
	  		
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		$$=new SymbolInfo("while("+$3->getName()+")\n"+$5->getName());
	  		fprintf(parsertext,"while(%s)\n%s\n\n",$3->getName().c_str(),$5->getName().c_str());
	  		
	  		  if($3->get_declared_type()=="int "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("int "); 
			}
			else if($3->get_declared_type()=="float "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("float "); 
			}
			else if($3->get_declared_type()=="void "  && declar_type==true){
				k=error_count;
				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
				error_count++;
				$$->set_declared_type("void "); 
			}
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON{
	  		bool bl = false;
	  		fprintf(parsertext,"Line at %d : statement->PRINTLN LPAREN ID RPAREN SEMICOLON\n\n",line_count);
	  		$$=new SymbolInfo("\n("+$3->getName()+")");
	  		
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		fprintf(parsertext,"\n (%s);\n\n",$3->getName().c_str());
			
	  }
	  | RETURN expression SEMICOLON{
	  		int k;
	  		bool bl = false;
	  		fprintf(parsertext,"Line at %d : statement->RETURN expression SEMICOLON\n\n",line_count);
	  		$$=new SymbolInfo("return "+$2->getName()+";");
	  		
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
	  		fprintf(parsertext,"return %s;\n\n",$2->getName().c_str());
	  		 if($2->get_declared_type()=="int "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("int "); 
			}
			else if($2->get_declared_type()=="float "  && declar_type==true){
				k=error_count;
				$$->set_declared_type("float "); 
			}
			else if($2->get_declared_type()=="void "  && declar_type==true){
				k=error_count;
				fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
				error_count++;
				$$->set_declared_type("int "); 
			}
									 
	  
	  }
	  ;
	  
expression_statement 	: SEMICOLON	{
			string str = ";";
			bool bl = false;
			fprintf(parsertext,"Line at %d : expression_statement->SEMICOLON\n\n",line_count);
			$$=new SymbolInfo(str);
			
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			fprintf(parsertext,";\n\n"); 			
			}
			| expression SEMICOLON {
			string str = $1->getName()+";";
			fprintf(parsertext,"Line at %d : expression_statement->expression SEMICOLON\n\n",line_count);
			bool bl = false;
			SymbolInfo sm2($1->getName());
			sm2.set_is_void(bl);
			$$=new SymbolInfo(str);
			fprintf(parsertext,"%s;\n\n",$1->getName().c_str());
			
			}
			;
	  
variable : ID {
				int k;
				bool bl = false;
				fprintf(parsertext,"Line at %d : variable->ID\n\n",line_count);
				$$=new SymbolInfo($1->getName());
				fprintf(parsertext,"%s\n\n",$1->getName().c_str());
				
				SymbolInfo sm2($1->getName());
				sm2.set_is_void(bl);
				if(table->lookup_symbol(0,$1->getName())==0){
						k=error_count;
						SymbolInfo sm($1->getName());
						fprintf(error,"Error at Line No.%d:  Undeclared Variable: %s \n\n",line_count,$1->getName().c_str());
						 error_count++;
					}
					else if(table->lookup_symbol(0,$1->getName())->get_declared_type()=="int array" || table->lookup_symbol(0,$1->getName())->get_declared_type()=="float array"){
						k=error_count;
						SymbolInfo sm($1->getName());
						fprintf(error,"Error at Line No.%d: Type Mismatch %s \n\n",line_count);
						error_count++;
						var_mismatch_flag = 1;
						$$->setName("error");
					}
					if(table->lookup_symbol(0,$1->getName())!=0){
						k=error_count;
						SymbolInfo sm($1->getName());
						//cout<<line_count<<"ID: "<<table->lookup_symbol(0,$1->getName())->getName()<<" "<<table->lookup_symbol(0,$1->getName())->get_declared_type()<<endl;
						$$->set_declared_type(table->lookup_symbol(0,$1->getName())->get_declared_type()); 
					}
				}
	 | ID LTHIRD expression RTHIRD {
	 								int k;
	 								string str = $1->getName()+"["+$3->getName()+"]";
	 								bool bl = false;
	 								fprintf(parsertext,"Line at %d : variable->ID LTHIRD expression RTHIRD\n\n",line_count);
	 								$$=new SymbolInfo(str);
	 								fprintf(parsertext,"%s[%s]\n\n",$1->getName().c_str(),$3->getName().c_str());
	 								
									SymbolInfo sm2($1->getName());
									sm2.set_is_void(bl);
	 								if(table->lookup_symbol(0,$1->getName())==0){
	 									k=error_count;
										SymbolInfo sm($1->getName());
										error_count++;
										fprintf(error,"Error at Line No.%d:  Undeclared Variable: %s \n\n",line_count,$1->getName().c_str());
									}
									//cout<<line_count<<"array: "<<$3->get_declared_type()<<endl;
									if($3->get_declared_type()=="float "||$3->get_declared_type()=="void "){
										 SymbolInfo sm($1->getName());
											k=error_count;
										
										 //cout<<"hi";
										fprintf(error,"Error at Line No.%d:  Non-integer Array Index  \n\n",line_count);
										 error_count++;
									}
									if(table->lookup_symbol(0,$1->getName())!=0 && declar_type==true){
										
										if(table->lookup_symbol(0,$1->getName())->get_declared_type()!="int array" && table->lookup_symbol(0,$1->getName())->get_declared_type()!="float array" && declar_type==true)
										{
									//cout<<"hii";
											k=error_count;
											SymbolInfo sm($1->getName());
											
											fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
											error_count++;	
										}
										
										if(table->lookup_symbol(0,$1->getName())->get_declared_type()!="int array" && declar_type==true){
											k=error_count;
											SymbolInfo sm($1->getName());
											$1->set_declared_type("int ");
										}
										if(table->lookup_symbol(0,$1->getName())->get_declared_type()!="float array" && declar_type==true){
											k=error_count;
											SymbolInfo sm($1->getName());
											$1->set_declared_type("float ");
										}
										k++;
										$$->is_id =true;
										$$->set_declared_type($1->get_declared_type()); 
										
									}	
									}
	 ;
	 
 expression : logic_expression	{bool bl = false;
 								fprintf(parsertext,"Line at %d : expression->logic_expression\n\n",line_count);
 								$$=new SymbolInfo($1->getName());
 								fprintf(parsertext,"%s\n\n",$1->getName().c_str());
 								
								SymbolInfo sm2($1->getName());
								sm2.set_is_void(bl);
 								$$->set_declared_type($1->get_declared_type()); 
 								}
	   | variable ASSIGNOP logic_expression {
	   							int k;
	   							bool bl = false;
	   							fprintf(parsertext,"Line at %d : expression->variable ASSIGNOP logic_expression\n\n",line_count);
	   							$$=new SymbolInfo($1->getName()+"="+$3->getName());
	   							fprintf(parsertext,"%s=%s\n\n",$1->getName().c_str(),$3->getName().c_str());
	   							
								SymbolInfo sm2($1->getName());
								sm2.set_is_void(bl);
	   							if($1->get_declared_type()=="int " && $3->get_declared_type()=="float " && declar_type==true)
	   							{
	   							//cout<<line_count<<"$1: "<<$1->get_declared_type()<<"$3: "<<$3->get_declared_type()<<endl;
	   								k = error_count;
	   								fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
	   								error_count++;
	   							}
	   							k++;
								$$->set_declared_type($1->get_declared_type()); 
	   							}	
	   ;
			
logic_expression : rel_expression 	{bool bl = false;
									$$=new SymbolInfo($1->getName());
									fprintf(parsertext,"Line at %d : logic_expression->rel_expression\n\n",line_count);
									
									SymbolInfo sm2($1->getName());
									sm2.set_is_void(bl);
									fprintf(parsertext,"%s\n\n",$1->getName().c_str());
									$$->set_declared_type($1->get_declared_type()); 
									
									}	
		 | rel_expression LOGICOP rel_expression {
		 		int k;
		 		bool bl = false;
		 		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName());
		 		fprintf(parsertext,"Line at %d : logic_expression->rel_expression LOGICOP rel_expression\n\n",line_count);
		 		
				SymbolInfo sm2($1->getName());
				sm2.set_is_void(bl);
				fprintf(parsertext,"%s%s%s\n\n",$1->getName().c_str(),$2->getName().c_str(),$3->getName().c_str());
				 if($3->get_declared_type()=="void " && declar_type==true){
									
									string str = "int ";
									fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
									$$->set_declared_type(str); 
									k = error_count;
									error_count++;
								}
								else if(table->lookup_symbol(0,$1->getName())!=0 && declar_type==true ) {
									if(table->lookup_symbol(0,$3->getName())->get_declared_type()!=$1->get_declared_type()){
										k = error_count;
										fprintf(error,"Error at Line No.%d: Type Mismatch \n\n",line_count);
										error_count++;
									}
								}
								k++;
								$$->set_declared_type($1->get_declared_type()); 
				}	
		 ;
			
rel_expression	: simple_expression {bool bl = false;
				$$=new SymbolInfo($1->getName());
				fprintf(parsertext,"Line at %d : rel_expression->simple_expression\n\n",line_count);
				
				SymbolInfo sm2($1->getName());
				sm2.set_is_void(bl);
				fprintf(parsertext,"%s\n\n",$1->getName().c_str());
				$$->set_declared_type($1->get_declared_type()); 
				
				 }
		| simple_expression RELOP simple_expression	{
		int k;
		bool bl = false;
		$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName());
		fprintf(parsertext,"Line at %d : rel_expression->simple_expression RELOP simple_expression\n\n",line_count);
		
		SymbolInfo sm2($1->getName());
		sm2.set_is_void(bl);
		fprintf(parsertext,"%s%s%s\n\n",$1->getName().c_str(),$2->getName().c_str(),$3->getName().c_str());
		if($1->get_declared_type()=="void " &&entry==1){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				else if($3->get_declared_type()=="void " && entry==1){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				k++;
				$$->set_declared_type("int "); 											
		}
		;
				
simple_expression : term {	bool bl = false;
							$$=new SymbolInfo($1->getName());
							fprintf(parsertext,"Line at %d : simple_expression->term\n\n",line_count);
							
							SymbolInfo sm2($1->getName());
							sm2.set_is_void(bl);
							fprintf(parsertext,"%s\n\n",$1->getName().c_str());
							$$->set_declared_type($1->get_declared_type()); 
						}
		  | simple_expression ADDOP term {bool bl = false;
		  int k;
		  $$=new SymbolInfo($1->getName()+$2->getName()+$3->getName()); 
		  fprintf(parsertext,"Line at %d : simple_expression->simple_expression ADDOP term\n\n",line_count);
		  
		  SymbolInfo sm2($1->getName());
		  sm2.set_is_void(bl);
		  fprintf(parsertext,"%s%s%s\n\n",$1->getName().c_str(),$2->getName().c_str(),$3->getName().c_str());
		  if($1->get_declared_type()=="void " && entry==1){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				else if($3->get_declared_type()=="void " &&entry==1){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				k++;
				$$->set_declared_type("int "); 							
		  }
		  ;
					
term :	unary_expression{
						bool bl = false;
						$$=new SymbolInfo($1->getName());
						fprintf(parsertext,"Line at %d : term->unary_expression\n\n",line_count);
						
						SymbolInfo sm2($1->getName());
						sm2.set_is_void(bl);
						fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
						$$->set_declared_type($1->get_declared_type()); 
						 }
     |  term MULOP unary_expression{
    					int k;
    					bool bl = false;
     					$$=new SymbolInfo($1->getName()+$2->getName()+$3->getName());
     					fprintf(parsertext,"Line at %d : term->term MULOP unary_expression\n\n",line_count);
     					
						SymbolInfo sm2($1->getName());
						sm2.set_is_void(bl);
	 					fprintf(parsertext,"%s%s%s\n\n",$1->getName().c_str(),$2->getName().c_str(),$3->getName().c_str());
	 					if($1->get_declared_type()=="void "){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				else if($3->get_declared_type()=="void " && entry==1){
					fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
					k=error_count;
					$$->set_declared_type("int "); 
					error_count++;
					
				}
				else if($2->getName()=="/" && entry==1){
	 					if($1->get_declared_type()=="void "){
						fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
						k=error_count;
						$$->set_declared_type("int "); 
						error_count++;
					
						}
						else if($3->get_declared_type()=="void "){
							fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
							k=error_count;
							$$->set_declared_type("int "); 
							error_count++;
					
						}
						else  if($1->get_declared_type()=="float " || $3->get_declared_type()=="float ")
						{
							k=error_count;
							$$->set_declared_type("float "); 
						} 
						else {
							k=error_count;
							$$->set_declared_type("int "); 
						}
							
										
				}
				else if($2->getName()=="%" && entry==1){
					 if($1->get_declared_type()!="int " ||$3->get_declared_type()!="int "){
						
						fprintf(error,"Error at Line No.%d:  Integer operand on modulus operator  \n\n",line_count);
						k=error_count;
						error_count++;
						}
						k++; 
						$$->set_declared_type("int "); 
										
				 }
				
				else if($1->get_declared_type()=="float " && entry==1){
					k=error_count;
					$$->set_declared_type("float "); 
				}
				else if($3->get_declared_type()=="float "){
					k=error_count;
					$$->set_declared_type("float "); 
				}
				else{
					k=error_count;
					$$->set_declared_type("int "); 
				}
				
	 					}
     ;

unary_expression : ADDOP unary_expression{bool bl = false;
					$$=new SymbolInfo($1->getName()+$2->getName());
					fprintf(parsertext,"Line at %d : unary_expression->ADDOP unary_expression\n\n",line_count);
					fprintf(parsertext,"%s%s\n\n",$1->getName().c_str(),$2->getName().c_str());
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					if($2->get_declared_type()=="int " ||$2->get_declared_type()=="float "){
						bool val= false;
		 				$$->set_is_void(val);
						$$->set_declared_type($2->get_declared_type()); 
						
												
					}else {
						bool val= true;
		 				$$->set_is_void(val);
						$$->set_declared_type("int "); 
						fprintf(error,"Error at Line No.%d:  Type Mismatch \n\n",line_count);
						error_count++;
						
						
					}
								
					}  
		 | NOT unary_expression {bool val= false;
		 			$$=new SymbolInfo("!"+$2->getName());
		 			
		 			$$->set_is_void(val);
					fprintf(parsertext,"Line at %d : unary_expression->NOT unary_expression\n\n",line_count);
					bool bl = false;
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					$$->set_declared_type($2->get_declared_type()); 
					fprintf(parsertext,"!%s\n\n",$2->getName().c_str());
					 }
		 | factor {	bool val= false;
		 			$$=new SymbolInfo($1->getName());
					
		 			$$->set_is_void(val);
		 			fprintf(parsertext,"Line at %d : unary_expression->factor\n\n",line_count);
		 			bool bl = false;
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
		 			$$->set_declared_type($1->get_declared_type()); 
		 			//cout<<line_count <<"dec: unary"<<$$->get_declared_type()<<endl;
		 			fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
					}
		 ;
	
factor	: variable {bool bl = false;
					$$=new SymbolInfo($1->getName());
					fprintf(parsertext,"Line at %d : factor->variable\n\n",line_count);
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					$$->is_id=true;
					$$->set_declared_type($1->get_declared_type()); 
					fprintf(parsertext,"%s\n\n",$1->getName().c_str());
					}
	| ID LPAREN argument_list RPAREN{bool bl = false;
					int k;
					$$=new SymbolInfo($1->getName()+"("+$3->getName()+")");
					fprintf(parsertext,"Line at %d : factor->ID LPAREN argument_list RPAREN\n\n",line_count);
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					$$->is_id=true;
					fprintf(parsertext,"%s(%s)\n\n",$1->getName().c_str(),$3->getName().c_str());
					SymbolInfo* symb=table->lookup_symbol(0,$1->getName());
					if(symb==0 && entry==1){
										
						fprintf(error,"Error at Line No.%d:  Undefined Function \n\n",line_count);
						error_count++;
						$$->set_declared_type("int "); 
					}
					else
					{
						if(symb->get_func()!=0 && entry==1)
						{
							$$->set_declared_type(symb->get_func()->get_ret_type());
							int pm=symb->get_func()->get_no_of_per();
							k=error_count;
							if(symb->get_func()->get_is_defined()==0 && entry==1){
								k=error_count;
								fprintf(error,"Error at Line No.%d:  Undeclared Function \n\n",line_count);
								error_count++;
							}
							
								
								//cout<<line_count<<"fun:"<<symb->isit_function()<<endl;		
								//cout<<"pm"<<pm<<" arg"<<argument_list.size();		
								if(pm==argument_list.size()){
											k=error_count;
											vector<string>para_list=symb->get_func()->get_per_list();
											vector<string>para_type=symb->get_func()->get_per_type_list();
											list<SymbolInfo*>:: iterator i;
											int j;
       								 for(i=argument_list.begin(),j=0;i!=argument_list.end() && j<para_type.size();i++,j++){
		   								 if((*i)->get_declared_type()!=para_type[j]){
									//for(int i=0;i<argument_list2.size();i++){
										//if(argument_list2[i]->get_declared_type()!=para_type[i]){	
											if(var_mismatch_flag==0){		
												fprintf(error,"Error at Line No.%d: Type Mismatch1 \n\n",line_count);
												k=error_count;
												error_count++;
												break;
											}
											else 
											{
												var_mismatch_flag=0;
												break;
											}
										}
       								 }
        
            							

								}
								else{
									fprintf(error,"Error at Line No.%d:  Invalid number of arguments \n\n",line_count);
									k=error_count;
									error_count++;
								}
						}
						else if(symb->get_func()==0){
										k=error_count;
										fprintf(error,"Error at Line No.%d:  Not A Function \n\n",line_count);
										error_count++;
										$$->set_declared_type("int "); 
						}
						else{
							k=error_count;
							
						
						}
						/*else if(symb->get_func()==0 && symb->get_arr()==0 && symb->get_var()==0){
							error_count++;
							fprintf(error,"Error at Line No.%d:  Not A Function or array or variable. \n\n",line_count);
							$$->set_declared_type("int "); 
						}
						else if(symb->get_func()==0 && symb->get_arr()!=0 && symb->get_var()==0){
							error_count++;
							fprintf(error,"Error at Line No.%d:  Not A Function but an array. \n\n",line_count);
							$$->set_declared_type("int "); 
						}
						else if(symb->get_func()==0 && symb->get_arr()==0 && symb->get_var()!=0){
							error_count++;
							fprintf(error,"Error at Line No.%d:  Not A Function but a variable. \n\n",line_count);
							$$->set_declared_type("int "); 
						}*/
					
					}
					}
	| LPAREN expression RPAREN{bool bl = true;
					$$=new SymbolInfo("("+$2->getName()+")");
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"Line at %d : factor->LPAREN expression RPAREN\n\n",line_count);
					$$->set_declared_type($2->get_declared_type());
					fprintf(parsertext,"(%s)\n\n",$2->getName().c_str()); 
					}
	| CONST_INT { bool bl = true;
					$$=new SymbolInfo($1->getName());
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"Line at %d : factor->CONST_INT\n\n",line_count);
					$$->set_declared_type("int "); 
					fprintf(parsertext,"%s\n\n",$1->getName().c_str());
					 }
	| CONST_FLOAT{	
					bool bl = true;
					$$=new SymbolInfo($1->getName());
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"Line at %d : factor->CONST_FLOAT\n\n",line_count);
					$$->set_declared_type("float ");
					//cout<<line_count <<"dec: "<<$$->get_declared_type()<<endl;
					fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
					 }
	| variable INCOP {
					
					bool bl = true;
					$$=new SymbolInfo($1->getName()+"++");
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"Line at %d : factor->variable INCOP\n\n",line_count);
					$$->set_declared_type($1->get_declared_type());
					fprintf(parsertext,"%s++\n\n",$1->getName().c_str()); 
					 }
	| variable DECOP{
					bool bl = true;
					$$=new SymbolInfo($1->getName()+"--");
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"Line at %d : factor->variable DECOP\n\n",line_count);
					$$->set_declared_type($1->get_declared_type());
					fprintf(parsertext,"%s--\n\n",$1->getName().c_str());
					 }
	;
	
argument_list : arguments{
					 
					fprintf(parsertext,"Line at %d : argument_list->arguments\n\n",line_count);
					bool bl = true;
					$$=new SymbolInfo($1->getName());
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"%s\n\n",$1->getName().c_str());
					}
			  |	%empty{ bool bl = true;
			  		$$=new SymbolInfo(""); 
			  		
					SymbolInfo sm2("");
					sm2.set_is_void(bl);
			  		fprintf(parsertext,"Line at %d : argument_list-> \n\n",line_count);
			 		 }
			  ;
	
arguments : arguments COMMA logic_expression{bool bl = true;
					$$=new SymbolInfo($1->getName()+","+$3->getName());
					fprintf(parsertext,"Line at %d : arguments->arguments COMMA logic_expression \n\n",line_count);
					
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
					fprintf(parsertext,"%s,%s\n\n",$1->getName().c_str(),$3->getName().c_str());
					argument_list.push_back($3);
					argument_list2.push_back($3);
					}
	      | logic_expression{bool bl = true;
	      			$$=new SymbolInfo($1->getName());
	      			SymbolInfo* symb=new SymbolInfo($1->getName(),$1->getType(),$1->get_declared_type());
		  			fprintf(parsertext,"Line at %d : arguments->logic_expression\n\n",line_count);
		  			
					SymbolInfo sm2($1->getName());
					sm2.set_is_void(bl);
		  			argument_list.push_back(symb);
		  			argument_list2.push_back(symb);
		  			fprintf(parsertext,"%s\n\n",$1->getName().c_str()); 
		  			
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
	fprintf(parsertext,"    Symbol Table : \n\n");
	table->print_all_scope_table(val);
	fprintf(parsertext,"Total Lines : %d \n\n",line_count);
	fprintf(parsertext,"Total Errors : %d \n\n",error_count);
	fprintf(error,"Total Errors : %d \n\n",error_count);
	
	
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
	

	fclose(fp2);
	fclose(fp3);*/
	
	return 0;
}

