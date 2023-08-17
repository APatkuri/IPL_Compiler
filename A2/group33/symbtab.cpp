#include "symbtab.hh"

void SymbTab::print(){
    cout<<"[";
    for (auto it = this -> Entries.begin(); it != this -> Entries.end(); ++it){
        if(it != this -> Entries.begin()){
            cout<<",";
        }
        cout<<"[";
        cout<<"\""<< it -> second->symname <<"\""<<",";
        cout<<"\""<< it -> second ->varfun <<"\""<<",";
        cout<<"\""<< it -> second->scope <<"\""<<",";
        cout<< it -> second->size <<",";
        if(it -> second->scope == "global" && it -> second ->varfun == "struct"){
            cout<<"\"-\""<<",";
        }
        else{
            cout<< it -> second->offset <<",";
        }
        cout<<"\""<< it -> second ->returntype <<"\"";
        cout<<"]";
    }
    cout<<"]";
}

void SymbTab::printgst(){
    this -> print();
}

symbol::symbol(string symname,string scope,string varfun,string returntype,int size,int offset,SymbTab* symbtab){
    this->symname = symname;
    this->scope = scope;
    this->varfun = varfun;
    this->returntype = returntype;
    this->offset = offset;
    this->size = size;
    this->symbtab =symbtab;
}
