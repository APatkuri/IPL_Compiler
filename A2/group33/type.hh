#ifndef TYPE_HH
#define TYPE_HH

#include <vector>
#include <iostream>
#include <string>
#include <map>

using namespace std;

class declarator_class
{
    public:
    string declarator_class_str;
    vector<int> declarator_class_vec ;
    int star_count=0;
    declarator_class(string declarator_class_str);
    string get_type(string type_spec);

};

class declarator_list_class
{
    public:
    vector<declarator_class*> declarator_list_class_vec;
    declarator_list_class();
    declarator_list_class(vector<declarator_class*> declarator_list_class_vec);
};

class declaration_class
{
    public:
    string declaration_class_type_str;
    declarator_list_class* declaration_class_middle;
    declaration_class(string declaration_class_type_str, declarator_list_class* declaration_class_middle);
    vector<string> get_type(string declaration_class_type_str, declarator_list_class* declaration_class_middle);

};


class declaration_list_class
{
    public:
    vector<declaration_class*> declaration_list_class_vec;
    declaration_list_class();
    declaration_list_class(vector<declaration_class*> declaration_list_class_vec);
};

/////////////////////////////////////////


class parameter_declaration_class
{
    public:
    parameter_declaration_class(string parameter_declaration_class_str, declarator_class* parameter_declaration_class_middle);  
    string parameter_declaration_class_str;
    declarator_class* parameter_declaration_class_middle;

};

class parameter_list_class
{
    public:
    vector<parameter_declaration_class*> parameter_list_class_vec;
    parameter_list_class();
};

class fun_declarator_class
{
    public:
    string fun_declarator_class_str;
    parameter_list_class* fun_declarator_class_middle;
    fun_declarator_class(string fun_declarator_class_str);
    fun_declarator_class(string fun_declarator_class_str, parameter_list_class* fun_declarator_class_middle);
};

#endif