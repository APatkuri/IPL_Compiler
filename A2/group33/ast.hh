#ifndef AST_HH
#define AST_HH

#include <iostream>
#include <vector>
#include "type.hh"

using namespace std;

class datatype{
    public:
    datatype(string btype);
    datatype(string btype, int star_count, vector<int> dimensions);
    string btype; //int or float or struct
    string str_name;
    bool iszero;
    int brace_count;
    int star_count; //no of stars
    vector<int> dimensions; //int a[3][4] 
    bool lval;
    bool isInt();
    bool isFloat();
    int zero;
};

class abstract_astnode
{
    public:
    virtual void print(int blanks) = 0;
};

/////////////////////////////////

class statement_astnode: public abstract_astnode
{
    public:
    int isempty;
};

class exp_astnode: public abstract_astnode
{
    public:
    datatype* dtype;
};
class empty_astnode: public statement_astnode
{
    public:
    empty_astnode();
    void print(int blanks);
};

class seq_astnode: public statement_astnode
{
    public:
    seq_astnode();
    seq_astnode(vector<statement_astnode*> seq_vec);
    void print(int blanks);
    vector<statement_astnode*> seq_vec;
};

class assignS_astnode: public statement_astnode
{
    public:
    assignS_astnode(exp_astnode* assignS_left, exp_astnode* assignS_right);
    void print(int blanks);
    exp_astnode* assignS_left;
    exp_astnode* assignS_right;
};

class return_astnode: public statement_astnode
{
    public:
    return_astnode(exp_astnode* return_middle);
    void print(int blanks);
    exp_astnode* return_middle;
};

class if_astnode: public statement_astnode
{
    public:
    if_astnode(exp_astnode* if_left, statement_astnode* if_middle, statement_astnode* if_right);
    void print(int blanks);
    exp_astnode* if_left;
    statement_astnode* if_middle;
    statement_astnode* if_right;
};

class while_astnode: public statement_astnode
{
    public:
    while_astnode(exp_astnode* while_left, statement_astnode* while_right);
    void print(int blanks);
    exp_astnode* while_left;
    statement_astnode* while_right;
};

class for_astnode: public statement_astnode
{
    public:
    for_astnode(exp_astnode* for_left,exp_astnode* for_middle_left, exp_astnode* for_middle_right, statement_astnode* for_right);
    void print(int blanks);
    exp_astnode* for_left;
    exp_astnode* for_middle_left;
    exp_astnode* for_middle_right;
    statement_astnode* for_right;
};

class proccall_astnode: public statement_astnode
{
    public:
    proccall_astnode(string pname);
    proccall_astnode(string pname, vector<exp_astnode*> proccall_vec);
    void print(int blanks);
    vector<exp_astnode*> proccall_vec;
    string pname;
};

/////////////////////////////////////////


class op_binary_astnode: public exp_astnode
{
    public:
    op_binary_astnode();
    op_binary_astnode(string op_binary_str, exp_astnode* op_binary_middle, exp_astnode* op_binary_right);
    void print(int blanks);
    string op_binary_str;
    exp_astnode* op_binary_middle;
    exp_astnode* op_binary_right;
};

class op_unary_astnode: public exp_astnode
{
    public:
    op_unary_astnode(string op_unary_str, exp_astnode* op_unary_middle);
    void print(int blanks);
    string op_unary_str;
    exp_astnode* op_unary_middle;
};

class assignE_astnode: public exp_astnode
{
    public:
    assignE_astnode(exp_astnode* assignE_left, exp_astnode* assignE_right);
    void print(int blanks);
    exp_astnode* assignE_left;
    exp_astnode* assignE_right;
};

class funcall_astnode: public exp_astnode
{
    public:
    void print(int blanks);
    vector<exp_astnode*> funcall_vec;
    string fcname;
    funcall_astnode();
    funcall_astnode(string fcname);
    funcall_astnode(string fcname, vector<exp_astnode*> funcall_vec);
};

class intconst_astnode: public exp_astnode
{
    public:
    intconst_astnode(int intconst_int);
    void print(int blanks);
    int intconst_int;
};

class floatconst_astnode: public exp_astnode
{
    public:
    floatconst_astnode(float floatconst_flt);
    void print(int blanks);
    float floatconst_flt;
};

class stringconst_astnode: public exp_astnode
{
    public:
    stringconst_astnode(string stringconst_str);
    void print(int blanks);
    string stringconst_str;
};

///////////////////////////////////////////

class ref_astnode: public exp_astnode
{
};

class identifier_astnode: public ref_astnode
{
    public:
    identifier_astnode(string identifier_str);
    void print(int blanks);
    string identifier_str;
};

class arrayref_astnode: public ref_astnode
{
    public:
    arrayref_astnode(exp_astnode* arrayref_left, exp_astnode* arrayref_right);
    void print(int blanks);
    exp_astnode* arrayref_left;
    exp_astnode* arrayref_right;
};

class member_astnode: public ref_astnode
{
    public:
    member_astnode(exp_astnode* member_left, identifier_astnode* member_right);
    void print(int blanks);
    exp_astnode* member_left;
    identifier_astnode* member_right;
};

class arrow_astnode: public ref_astnode
{
    public:
    arrow_astnode(exp_astnode* arrow_left, identifier_astnode* arrow_right);
    void print(int blanks);
    exp_astnode* arrow_left;
    identifier_astnode* arrow_right;
};

////////////////////////////////////////////
#endif
