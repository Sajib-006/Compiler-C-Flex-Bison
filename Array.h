#include<stdio.h>
#include<stdlib.h>
#include<bits/stdc++.h>
#define ull unsigned long long
using namespace std;

class Array{
public:
    bool is_arr;
    string idx;
    Array()
    {
        is_arr = false;
        idx ="";
    }
    void set_is_arr(bool b){ is_arr=true;}
    void set_idx(string s){ idx=s;}
    bool get_is_arr(){return is_arr;}
    string get_idx(){ return idx; }


};
