#ifndef AST_CPP
#define AST_CPP

#include "ast.hh"
using namespace std;

datatype::datatype(string btype){
    star_count = 0;
    this -> btype = btype;
    this -> star_count = 0;
    this -> zero = 0;
}

datatype::datatype(string btype, int star_count, vector<int> dimensions){
    this -> btype = btype;
    this -> star_count = star_count;
    this -> dimensions = dimensions;
    this -> zero = 0;
}

bool datatype::isInt(){
    if (this->btype == "int" && this->star_count == 0 && this->dimensions.size() == 0) {
        return 1;
    }
    return 0;
}

bool datatype::isFloat(){
    if (this->btype == "float" && this->star_count == 0 && this->dimensions.size() == 0) {
        return 1;
    }
    return 0;
}

// string datatype::type_concat(){
//     string f = this -> btype;
//     for(int i= 0; i < this -> star_count; i++){
//         f = f + "*";
//     }
//     for(int i= 0; i < this -> brace_count; i++){
//         f = f + "[" + dimensions[i] + "]";
//     }
//     return f;
// }

void seq_astnode::print(int blanks) {
    cout<<"\"seq\": [";
    long unsigned int c = 0;
    for(auto sta: this -> seq_vec){
        c++;
        if(sta -> isempty){
            sta->print(0);
        }
        else{
            cout<<"{";
            sta->print(0);
            cout<<"}";
        }
        if(c < this->seq_vec.size()){
            cout<<",";
        }
    }
    cout<<"]";
}

seq_astnode::seq_astnode(vector<statement_astnode*> seq_vec){
    this -> seq_vec = seq_vec;
    isempty = 0;
}

seq_astnode::seq_astnode(){
    isempty = 0;
}

void proccall_astnode::print(int blanks) {
    cout<<"\"proccall\": {";
    cout<<"\"fname\":";
    cout<<"{";
    cout<<"\"identifier\": "<<"\""<<this->pname<<"\"";
    cout<<"}";
    cout<<",";
    cout<<"\"params\": [";
    long unsigned int pc = 0;
    for(auto pro: this -> proccall_vec){
        pc++;
        cout<<"{";
        pro->print(0);
        cout<<"}";
        if(pc < this->proccall_vec.size()){
            cout<<",";
        }
    }
    cout<<"]";
    cout<<"}";
} 

proccall_astnode::proccall_astnode(string pname){
    this -> pname = pname;
    isempty = 0;
}

proccall_astnode::proccall_astnode(string pname, vector<exp_astnode*> proccall_vec){
    this -> pname = pname;
    this -> proccall_vec = proccall_vec;
    isempty = 0;
}

void assignS_astnode::print(int blanks) {
    cout<<"\"assignS\": {";
    cout<<"\"left\" : {";
    this -> assignS_left ->print(0);
    cout<<"},";
    cout<<"\"right\" : {";
    this -> assignS_right ->print(0);
    cout<<"}";
    cout<<"}";
}

assignS_astnode::assignS_astnode(exp_astnode* assignS_left, exp_astnode* assignS_right){
    this -> assignS_left = assignS_left;
    this -> assignS_right = assignS_right;
    isempty = 0;
}

void while_astnode::print(int blanks) {
    cout<<"\"while\": {";
    cout<<"\"cond\" : {";
    this -> while_left ->print(0);
    cout<<"},";
    if(isempty == 1){
       cout<<"\"stmt\" : ";
        this -> while_right ->print(0);
        cout<<""; 
    }
    else{
        cout<<"\"stmt\" : {";
        this -> while_right ->print(0);
        cout<<"}";
    }
    cout<<"}";
}

while_astnode::while_astnode(exp_astnode* while_left, statement_astnode* while_right){
    this -> while_left = while_left;
    this -> while_right = while_right;
    isempty = 0;
}

void if_astnode::print(int blanks) {
    cout<<"\"if\": {";
    cout<<"\"cond\" : {";
    this -> if_left ->print(0);
    cout<<"},";
    if(if_middle -> isempty){
        cout<<"\"then\" : ";
        this -> if_middle ->print(0);
        cout<<",";
    }
    else{
        cout<<"\"then\" : {";
        this -> if_middle ->print(0);
        cout<<"},";
    }
    if(if_right -> isempty){
        cout<<"\"else\" : ";
        this -> if_right ->print(0);
        cout<<"";
    }
    else{
        cout<<"\"else\" : {";
        this -> if_right ->print(0);
        cout<<"}";
    }
    cout<<"}";
}

if_astnode::if_astnode(exp_astnode* if_left, statement_astnode* if_middle, statement_astnode* if_right){
    this -> if_left = if_left;
    this -> if_middle = if_middle;
    this -> if_right = if_right;
    isempty = 0;
}

void for_astnode::print(int blanks) {
    cout<<"\"for\": {";
    cout<<"\"init\" : {";
    this -> for_left ->print(0);
    cout<<"},";
    cout<<"\"guard\" : {";
    this -> for_middle_left ->print(0);
    cout<<"},";
    cout<<"\"step\" : {";
    this -> for_middle_right ->print(0);
    cout<<"},";
    if(for_right -> isempty){
        cout<<"\"body\" : ";
        this -> for_right ->print(0);
        cout<<"";
    }
    else{
        cout<<"\"body\" : {";
        this -> for_right ->print(0);
        cout<<"}";
    }
    cout<<"}";
}

for_astnode::for_astnode(exp_astnode* for_left,exp_astnode* for_middle_left, exp_astnode* for_middle_right, statement_astnode* for_right){
    this -> for_left = for_left;
    this -> for_middle_left = for_middle_left;
    this -> for_middle_right = for_middle_right;
    this -> for_right = for_right;
    isempty = 0;
}

void return_astnode::print(int blanks) {
    cout<<"\"return\": {";
    this -> return_middle ->print(0);
    cout<<"}";
}

return_astnode::return_astnode(exp_astnode* return_middle){
    this -> return_middle = return_middle;
    isempty = 0;
}

void empty_astnode:: print(int blanks) {
    cout<<"\"empty\"";
}

empty_astnode::empty_astnode(){
    isempty = 1;
}
////////////////////////////////////////////////////////////////

void op_binary_astnode::print(int blanks) {
    cout<<"\"op_binary\": {";
    cout<<"\"op\" : ";
    cout<<"\""<<op_binary_str<<"\""<<",";
    cout<<"\"left\" : {";
    this -> op_binary_middle ->print(0);
    cout<<"},";
    cout<<"\"right\" : {";
    this -> op_binary_right ->print(0);
    cout<<"}";
    cout<<"}";
}

op_binary_astnode::op_binary_astnode(string op_binary_str, exp_astnode* op_binary_middle, exp_astnode* op_binary_right){
    this -> dtype = new datatype("int");
    this -> op_binary_str = op_binary_str;
    this -> op_binary_middle = op_binary_middle;
    this -> op_binary_right = op_binary_right;
}

void op_unary_astnode::print(int blanks) {
    cout<<"\"op_unary\": {";
    cout<<"\"op\" : ";
    cout<<"\""<<op_unary_str<<"\""<<",";
    cout<<"\"child\" : {";
    this -> op_unary_middle ->print(0);
    cout<<"}";
    cout<<"}";
}

op_unary_astnode::op_unary_astnode(string op_unary_str, exp_astnode* op_unary_middle){
    this -> dtype = new datatype("int");
    this -> op_unary_str = op_unary_str;
    this -> op_unary_middle = op_unary_middle;
}

void assignE_astnode::print(int blanks) {
    cout<<"\"assignE\": {";
    cout<<"\"left\" : {";
    this -> assignE_left ->print(0);
    cout<<"},";
    cout<<"\"right\" : {";
    this -> assignE_right ->print(0);
    cout<<"}";
    cout<<"}";
}

assignE_astnode::assignE_astnode(exp_astnode* assignE_left, exp_astnode* assignE_right){
    this -> dtype = new datatype("int");
    this -> assignE_left = assignE_left;
    this -> assignE_right = assignE_right;
}

void funcall_astnode::print(int blanks) {
    cout<<"\"funcall\": {";
    cout<<"\"fname\":";
    cout<<"{";
    cout<<"\"identifier\": "<<"\""<<this->fcname<<"\"";
    cout<<"}";
    cout<<",";
    cout<<"\"params\": [";
    long unsigned int f = 0;
    for(auto fun: this -> funcall_vec){
        f++;
        cout<<"{";
        fun->print(0);
        cout<<"}";
        if(f < this->funcall_vec.size()){
            cout<<",";
        }
    }
    cout<<"]";
    cout<<"}";
}

funcall_astnode::funcall_astnode(string fcname, vector<exp_astnode*> funcall_vec){
    this -> dtype = new datatype("int");
    this -> fcname = fcname;
    this -> funcall_vec = funcall_vec;
}

funcall_astnode::funcall_astnode(string fcname){
   this -> dtype = new datatype("int");
    this -> fcname = fcname;
}

void floatconst_astnode::print(int blanks) {
    cout<<"\"floatconst\": " <<floatconst_flt;
}

floatconst_astnode::floatconst_astnode(float floatconst_flt){
    this -> dtype = new datatype("float");
    this -> floatconst_flt = floatconst_flt;
}

void intconst_astnode::print(int blanks) {
    cout<<"\"intconst\": "<<intconst_int;
}

intconst_astnode::intconst_astnode(int intconst_int){
    this -> dtype = new datatype("int");
    this -> intconst_int = intconst_int;
}

void stringconst_astnode::print(int blanks) {
    cout<<"\"stringconst\": "<<stringconst_str;
}

stringconst_astnode::stringconst_astnode(string stringconst_str){
    this -> dtype = new datatype("string");
    this -> stringconst_str = stringconst_str;
}

///////////////////////////////////////////////////

void member_astnode::print(int blanks) {
    cout<<"\"member\": {";
    cout<<"\"struct\" : {";
    this -> member_left ->print(0);
    cout<<"},";
    cout<<"\"field\" : {";
    this -> member_right ->print(0);
    cout<<"}";
    cout<<"}";
}

member_astnode::member_astnode(exp_astnode* member_left, identifier_astnode* member_right){
    this -> dtype = new datatype("int");
    this -> member_left = member_left;
    this -> member_right = member_right;
}

void arrow_astnode::print(int blanks) {
    cout<<"\"arrow\": {";
    cout<<"\"pointer\" : {";
    this -> arrow_left ->print(0);
    cout<<"},";
    cout<<"\"field\" : {";
    this -> arrow_right ->print(0);
    cout<<"}";
    cout<<"}";
}

arrow_astnode::arrow_astnode(exp_astnode* arrow_left, identifier_astnode* arrow_right){
    this -> dtype = new datatype("int");
    this -> arrow_left = arrow_left;
    this -> arrow_right = arrow_right;
}

void identifier_astnode::print(int blanks) {
    cout<<"\"identifier\": "<<"\""<<identifier_str<<"\"";
}

identifier_astnode::identifier_astnode(string identifier_str){
    this -> identifier_str = identifier_str;
}

void arrayref_astnode::print(int blanks) {
    cout<<"\"arrayref\": {";
    cout<<"\"array\" : {";
    this -> arrayref_left ->print(0);
    cout<<"},";
    cout<<"\"index\" : {";
    this -> arrayref_right ->print(0);
    cout<<"}";
    cout<<"}";
}

arrayref_astnode::arrayref_astnode(exp_astnode* arrayref_left, exp_astnode* arrayref_right){
    this -> dtype = new datatype("int");
    this -> arrayref_left = arrayref_left;
    this -> arrayref_right = arrayref_right;
}

#endif