#include "type.hh"
#include <iostream>
#include <string>
#include <vector>
#include <map>
using namespace std;

class SymbTab;

class symbol{
    public:
    string symname;
    string varfun;
    string scope;
    int size;
    int offset;
    string returntype;
    SymbTab* symbtab;  
    symbol(string symname,string scope,string varfun,string returntype,int size,int offset,SymbTab* symbtab) ;

};

class SymbTab{
    public:
    void print();
    void printgst();

    map<string, symbol*> Entries;
};