#include "type.hh"
#include "symbtab.hh"
// void declaration_class::declaration_class(){

// }

declarator_class::declarator_class(string declarator_class_str){
    this -> declarator_class_str = declarator_class_str;
    vector<int> temp;
    this -> declarator_class_vec = temp;
}

declarator_list_class::declarator_list_class(vector<declarator_class*> declarator_list_class_vec){
    this -> declarator_list_class_vec = declarator_list_class_vec;
}

declaration_class::declaration_class(string declaration_class_type_str, declarator_list_class* declaration_class_middle){
    this -> declaration_class_type_str = declaration_class_type_str;
    this -> declaration_class_middle = declaration_class_middle;
}

parameter_declaration_class::parameter_declaration_class(string parameter_declaration_class_str, declarator_class* parameter_declaration_class_middle){
    this -> parameter_declaration_class_str = parameter_declaration_class_str;
    this -> parameter_declaration_class_middle = parameter_declaration_class_middle;
}

fun_declarator_class::fun_declarator_class(string fun_declarator_class_str, parameter_list_class* fun_declarator_class_middle){
    this -> fun_declarator_class_str = fun_declarator_class_str;
    this -> fun_declarator_class_middle = fun_declarator_class_middle;
}

fun_declarator_class::fun_declarator_class(string fun_declarator_class_str){
    this -> fun_declarator_class_str = fun_declarator_class_str;
}

parameter_list_class::parameter_list_class(){

}

declarator_list_class::declarator_list_class(){

}

declaration_list_class::declaration_list_class(){
    
}

// vector<string> declaration_class::get_type(string declaration_class_type_str, declarator_list_class* declaration_class_middle){
//     vector<string> types;
//     for(long unsigned int i=0;i<declaration_class_middle.size();i++){
//         string s = "";
//         s += declaration_class_type_str;
//         int n= fun_declarator_class_middle[i].star_count;
//         for(int j=0;j<n;j++){
//             s += "*";
//         }
//         vector<int> arr =  fun_declarator_class_middle[i].declarator_class_vec;
//         for(int j=0;j<arr.size();j++){
//             s += "["+arr[j]+"]";
//         }
//     }
// }



string declarator_class::get_type(string type_spec){

        string s = "";
        s += type_spec;
        int n= this->star_count;
        for(int j=0;j<n;j++){
            s += "*";
        }
        vector<int> arr =  this->declarator_class_vec;
        for(long unsigned int j=0;j<arr.size();j++){
            s += "[" + to_string(arr[j]) +"]";
        }
        return s;
}
