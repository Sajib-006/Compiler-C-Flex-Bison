#include<stdio.h>
#include<stdlib.h>
#include<bits/stdc++.h>
#define ull unsigned long long
using namespace std;




#include "Array.h"

extern int cur_id = 0;
extern int idx=0;
extern int pos=0;
extern int e_scope_id = 0;
class Variable{
public:

    bool is_var;
    Variable()
    {
    	is_var = false;
    }
    void set_is_var(bool b){ is_var=true;}
    bool get_is_var(){return is_var;}

};

class Function{
public:
    int no_of_per;
    string ret_type;
    bool is_defined;
    bool is_void_not;
    vector<string> per_list;
    vector<string> per_type_list;
    Function(){
                no_of_per=0;
                ret_type="";
                is_defined=false;
                is_void_not=false;
                per_list.clear();
                per_type_list.clear();


            }

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
        is_void_not = false;
        per_list.push_back(name);
        per_type_list.push_back(type);
        no_of_per= per_list.size();

    }



};
class SymbolInfo{
public:
    string name;
    string type;
    string declared_type;
    bool is_void;
    bool is_function;
    bool is_array;
    bool is_id;
    SymbolInfo *sym_ptr;
    Function *func;
    //Array arr;
    //Variable var;
    SymbolInfo()
    {
        sym_ptr = 0;
        name=type= "";
        func = 0;
        //arr = 0;
        //var= 0;
        declared_type ="";
        is_function = false;
        is_array =  false;
        is_id = false;
    }
    SymbolInfo(string _name)
    {
        sym_ptr = 0;
        name= _name;
        type= "";
        declared_type ="";
        func = 0;
        is_function = false;
        is_array =  false;
        is_id = true;
        //arr = 0;
        //var= 0;
    }
    SymbolInfo(string _name, string _type)
    {
        sym_ptr = 0;
        name= _name;
        type = _type;
        func = 0;
        is_function = false;
         is_array =  false;
        is_id = true;
        //arr = 0;
        //var= 0;
        declared_type ="";
    }
    SymbolInfo(string _name, string _type, string _dectype)
    {
        sym_ptr = 0;
        name= _name;
        type = _type;
        func = 0;
        is_function = false;
         is_array =  false;
        is_id = true;
        //arr = 0;
       	//var= 0;
        declared_type = _dectype;
    }
    void set_is_void(bool val)
    {
    	is_void = val;
    }
    bool get_is_void()
    {
    	return is_void;
    }
    void set_declared_type(string _dectype)
    {
        declared_type = _dectype;
    }
    void set_func()
    {
        is_function = true;
        func = new Function;
    }
    Function* get_func()
    {
        return func;
    }
    bool isit_function()
    {
    	return is_function;
    }
     bool isit_array()
    {
    	return is_array;
    }
    string get_declared_type()
    {
        return declared_type;
    }
    /*void set_arr()
    {
       arr = new Array();
    }
    Array* get_arr()
    {
        return arr;
    }
    void set_var()
    {
       var = new Variable();
    }
    Variable* get_var()
    {
        return var;
    }*/
    void setName(string str)
    {
    	name = str;
    }
    void setType(string str)
    {
    	type = str;
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
class scopeTable{

    SymbolInfo **scope_table;
public:
	FILE *logout;
    int k;
    int id;
    int cur_sz;
    int total_sz;
    bool scope;
    scopeTable *parent_scope;
    scopeTable()
    {
        scope =true;
        id = ++cur_id;
        parent_scope = NULL;
        cur_sz = total_sz = 0;


    }

    scopeTable(int n)
    {
     	logout = 0;
	 scope =true;
        id = ++cur_id;
        parent_scope = NULL;
        scope_table = new SymbolInfo *[n];
        int cnt=0;
        while(cnt<n)
        {
            scope_table[cnt] = 0;
            cnt++;
        }
        cur_sz = 0;
        total_sz = n;

    }

    scopeTable(int n, FILE *file)
    {
     	logout = file;
	 scope =true;
        id = ++cur_id;
        parent_scope = NULL;
        scope_table = new SymbolInfo *[n];
        int cnt=0;
        while(cnt<n)
        {
            scope_table[cnt] = 0;
            cnt++;
        }
        cur_sz = 0;
        total_sz = n;

    }
    int hashFunction (string str)
    {

        int hash_val = 0;
        for(int i = 0; i < str.length(); i++)
        {
            hash_val = ((hash_val * 101) + str[i])%total_sz;
        }
        //return (113*hash_val^2+ 4561*hash_val^3)%total_sz ;
        return hash_val;
    }


    bool insert(int tab, SymbolInfo s)
    {
        SymbolInfo * new_symb = new SymbolInfo(s.name,s.type,s.declared_type) ;
        if(lookup(tab,s.name) != 0)
            return false;
        int hash_val = hashFunction(s.name);
        pos = hash_val;
        idx = 0;




        if(scope_table[hash_val] == NULL)
        {
            k=tab;
            if(scope==true){
                 scope_table[hash_val] = new_symb;
            }

        }
        else
        {
            SymbolInfo *t = new SymbolInfo();
            t = scope_table[hash_val];
            while(t->sym_ptr)
           {
               t= t->sym_ptr;

           }
           t->sym_ptr = new_symb;
           idx++;
        }
        if(scope==true){
            cur_sz++;
        }
        return true;
    }

    SymbolInfo* lookup(int tab,string _name)
    {
        SymbolInfo *t;
        idx = 0;
        int hash_val;
        hash_val = hashFunction(_name);
        k=tab;
        pos = hash_val;

        if(scope==true){
                t = scope_table[hash_val];
        }
        k=0;
        while(t!=0)
        {
            k=tab;
            if (t->name == _name)
            {
                k=0;
                return t ;
            }
            if(scope==true){
                idx ++;
                t = t->sym_ptr ;
            }

        }
        k=0;
        return 0;
    }
    bool _delete(int tab, string _name)
    {
        idx = 0;
        int hash_val;
        SymbolInfo *t, *prev_node ;
        hash_val = hashFunction(_name);
        pos = hash_val;
        if(scope==true){
            t = scope_table[hash_val] ;
        }

        while (t != 0)
        {
            int k=tab;
            if (t->name == _name)
                break ;
            idx++;
            prev_node = t;
            k=0;
            if(scope==true)
                t = t->sym_ptr ;

        }
         if (t == 0)
        {
            k=0;
           return false ;
        }


        else if (t == scope_table[hash_val])
        {
            cur_sz--;
            if(scope==true){
                scope_table[hash_val] = scope_table[hash_val]->sym_ptr ;
            }
            else {
                k=cur_sz;
            }
            delete t;
            return true;

        }

        else
        {
            cur_sz--;
            if(scope==true){
                prev_node->sym_ptr = t->sym_ptr ;
            }
            else {
                k=cur_sz;
            }
            delete t;
            return true;

        }


    }
    void print(int tab)
    {

        int i=0;
        SymbolInfo *t;

            //fprintf(logout," ScopeTable#1\n ");

        while( i<total_sz)
        {
            t = scope_table[i];
            int k=0;
	if(t!=0)
		{
                //cout<<i<<"-->";
            fprintf(logout," %d --> ",i);
            while(t!=0)
            {
                k=i;
                //cout << " < " << t->name << " , " << t->type << " > ";

                fprintf(logout,"< %s , %s >", t->name.c_str(), t->type.c_str());
                k=tab;
                t = t->sym_ptr;
            }
            fprintf(logout,"\n");
            //cout<<endl;
		}
            i++;
        }
        // cout<<endl;
	fprintf(logout,"\n");


    }
};


class SymbolTable{
public:
    scopeTable *cur_scope;
    int k;
    FILE *logout;
    SymbolTable(FILE *f)
    {
        k=0;
        logout = f;
        cur_scope = NULL;
    }
    SymbolTable(int n,FILE *f)
    {
        k=0;
        logout = f;
        cur_scope = NULL;
        enterScope(0,n);
    }
    void enterScope(int tab,int n)
    {
        k=n;
        
        scopeTable *new_scope = new scopeTable(k,logout);
        new_scope->parent_scope = cur_scope;
        k=0;
        cur_scope = new_scope;
        if(cur_scope->id!=1)
        fprintf(logout,"New ScopeTable with id %d created\n",cur_scope->id );
        e_scope_id = cur_scope->id;

    }
    bool exitScope(int tab)
    {
        k=tab;
        fprintf(logout,"ScopeTable with id %d removed\n",cur_scope->id );
        e_scope_id = cur_scope->id;
        scopeTable *temp_scope = cur_scope;
        cur_scope = cur_scope->parent_scope;
        
        delete temp_scope;
        k=0;
        
        if(!cur_scope) return false;
        else return true;

    }
    bool insert_symbol(int tab,SymbolInfo s)
    {
        int scope_id;
        scope_id = cur_scope->id;
        if(cur_scope->insert(tab,s)==true)
        {
            //printf("Inserted in ScopeTable# %d at position %d , %d\n\n",scope_id,pos,idx);
            //if(tab==100) cout<<"hi";
            return true;
        }
        else
        {
        	//if(tab==100) cout<<"hi2";
            //printf("already exists in current ScopeTable\n\n");
            return false;
        }
    }
    bool remove_symbol(int tab,string _name)
    {
        int scope_id;
        scope_id = cur_scope->id;
        if(cur_scope->_delete(tab,_name)==true)
        {
           // printf("Found in ScopeTable# %d at position %d , %d\nDeleted entry at %d , %d from current ScopeTable\n\n",scope_id,pos,idx,pos,idx);
            return true;
        }
        else{
           //printf("Not found.\n\n");
           return false;
        }
    }
	
	SymbolInfo* lookup_symbol_recent(int tab,string _name)
	{
		return cur_scope->lookup(tab, _name);
	}
    SymbolInfo* lookup_symbol(int tab,string _name)
    {
        int scope_id;
        scopeTable * temp_scope = cur_scope;
        SymbolInfo * t;

        while(temp_scope)
        {
            t = temp_scope->lookup(tab, _name);
            scope_id = temp_scope->id;
            int k=0;
            if(t == 0)
            {
                temp_scope = temp_scope->parent_scope;
            }
            else
            {
                //printf("Found in ScopeTable# %d at position %d , %d\n\n",scope_id,pos,idx);
                return t;
            }
        }
        return 0;
    }


    void print_cur_scope_table(int tab)
    {
        int k=0;
        cur_scope->print(tab);
    }
    void print_all_scope_table(int tab)
    {
        scopeTable * t = cur_scope;
        while(t!=0)
        {
            int scope_id = t->id;
            //printf("ScopeTable # %d\n",scope_id);
            fprintf(logout," ScopeTable # %d \n ",scope_id);
            t->print(tab);
            t = t->parent_scope;
        }
        cout << "\n";
    }


};
//SymbolInfo sym;
//scopeTable s_table(7,logout);


