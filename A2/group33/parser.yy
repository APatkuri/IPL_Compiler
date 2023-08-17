%skeleton "lalr1.cc"
%require  "3.0.1"

%defines 
%define api.namespace {IPL}
%define api.parser.class {Parser}

%define parse.trace

%code requires{
  #include "ast.hh"
  #include "location.hh"
  #include "symbtab.hh"
  #include "type.hh"

   namespace IPL {
      class Scanner;
   }

  // # ifndef YY_NULLPTR
  // #  if defined __cplusplus && 201103L <= __cplusplus
  // #   define YY_NULLPTR nullptr
  // #  else
  // #   define YY_NULLPTR 0
  // #  endif
  // # endif

}

%printer { std::cerr << $$; } STRUCT
%printer { std::cerr << $$; } VOID
%printer { std::cerr << $$; } INT
%printer { std::cerr << $$; } FLOAT
%printer { std::cerr << $$; } RETURN
%printer { std::cerr << $$; } WHILE
%printer { std::cerr << $$; } IF
%printer { std::cerr << $$; } ELSE
%printer { std::cerr << $$; } FOR
%printer { std::cerr << $$; } IDENTIFIER
%printer { std::cerr << $$; } INT_CONSTANT
%printer { std::cerr << $$; } FLOAT_CONSTANT
%printer { std::cerr << $$; } STRING_LITERAL
%printer { std::cerr << $$; } OR_OP
%printer { std::cerr << $$; } AND_OP
%printer { std::cerr << $$; } EQ_OP
%printer { std::cerr << $$; } NE_OP
%printer { std::cerr << $$; } LE_OP
%printer { std::cerr << $$; } GE_OP
%printer { std::cerr << $$; } INC_OP
%printer { std::cerr << $$; } PTR_OP


%parse-param { Scanner  &scanner  }
%locations
%code{
   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   #include <string>
   
   
   #include "scanner.hh"
   int nodeCount = 0;
   string curr_func = "";
   string curr_struct = "";
   SymbTab *curr_symbtab = new SymbTab();
   extern SymbTab gst;
   std::map<string,abstract_astnode*> ast;
    int off_struct = 0;
    int off_funvar = 0;
    vector<int> param_offsets;
    bool is_function;

    map<string, datatype*> variable_types;
    map<string, datatype*> function_return_types;
    datatype* curr_fun_dtype;


#undef yylex
#define yylex IPL::Parser::scanner.yylex

}




%define api.value.type variant
%define parse.assert

%start translation_unit



%token '\n'
%token <std::string> STRUCT OTHERS
%token <std::string> VOID
%token <std::string> INT
%token <std::string> FLOAT
%token <std::string> RETURN
%token <std::string> WHILE
%token <std::string> IF
%token <std::string> ELSE
%token <std::string> FOR
%token <std::string> INT_CONSTANT
%token <std::string> FLOAT_CONSTANT
%token <std::string> STRING_LITERAL
%token <std::string> IDENTIFIER
%token <std::string> OR_OP 
%token <std::string> AND_OP 
%token <std::string> EQ_OP 
%token <std::string> NE_OP 
%token <std::string> LE_OP 
%token <std::string> GE_OP
%token <std::string> INC_OP
%token <std::string> PTR_OP
%token '{' '}' ';' '*' '(' ')' ',' '[' ']' '=' '>' '<' '+' '-' '/' '!' '&' '.' ':' 


%nterm <abstract_astnode*> translation_unit;
%nterm <abstract_astnode*> struct_specifier;
%nterm <abstract_astnode*> function_definition;

%nterm <std::string> type_specifier; 
%nterm <declarator_class*> declarator_arr;
%nterm <declarator_class*> declarator;
%nterm <declaration_class*> declaration; 
%nterm <declarator_list_class*> declarator_list; 
%nterm <declaration_list_class*> declaration_list; 

%nterm <exp_astnode*> expression;
%nterm <fun_declarator_class*> fun_declarator; 
%nterm <parameter_list_class*> parameter_list;
%nterm <parameter_declaration_class*> parameter_declaration; 
%nterm <statement_astnode*> statement;
%nterm <assignS_astnode*> assignment_statement;


%nterm <abstract_astnode*> compound_statement; 
%nterm <seq_astnode*> statement_list;
%nterm <assignE_astnode*> assignment_expression;
%nterm <exp_astnode*> logical_and_expression;
%nterm <exp_astnode*> equality_expression;
%nterm <exp_astnode*> relational_expression; 
%nterm <exp_astnode*> additive_expression;
%nterm <exp_astnode*> multiplicative_expression; 
%nterm <exp_astnode*> unary_expression;
%nterm <exp_astnode*> postfix_expression;
%nterm <exp_astnode*> primary_expression;
%nterm <std::string> unary_operator; 
%nterm <vector<exp_astnode*>*> expression_list;
%nterm <proccall_astnode*> procedure_call;
%nterm <statement_astnode*> selection_statement; 
%nterm <statement_astnode*> iteration_statement;
%%
translation_unit: 
       struct_specifier
       { 
        
       } 
       | function_definition
       {
         
       }
       | translation_unit struct_specifier
       {
         
       }
       | translation_unit function_definition
       {
         
       }
       ;

struct_specifier: 
         STRUCT IDENTIFIER 
         {
           curr_func = "";
           curr_struct = "struct " + $2;
         }
         '{' declaration_list '}' ';'
       { 
         ast[curr_struct] = new seq_astnode();
         int sz = 0;
         for(auto entry: curr_symbtab->Entries){
           sz += entry.second->size;
         }
         gst.Entries[curr_struct] = new symbol(curr_struct, "global", "struct", "-", sz, 0, curr_symbtab);
         curr_struct = "";
         curr_symbtab = new SymbTab();
         off_struct = 0;

       }
       ;

function_definition:
         type_specifier fun_declarator
         {
          curr_func = $2 -> fun_declarator_class_str;
          curr_struct = "";
          curr_fun_dtype = new datatype($1);
         }
         compound_statement 
       { 
	       ast[curr_func] = $4;
         gst.Entries[curr_func] = new symbol(curr_func, "global", "fun", $1, 0, 0, curr_symbtab);
         curr_func = "";
         curr_symbtab = new SymbTab();
         off_funvar = 0;
         variable_types.clear();
       } 
       ;

type_specifier:
         VOID
       {
       	 $$ = "void";
       }
       | INT
       {
	       $$ = "int";
       }
       | FLOAT
       {
         $$ = "float";
       }
       | STRUCT IDENTIFIER
       {
         $$ = "struct " + $2;
       }
       ;

fun_declarator:
         IDENTIFIER '(' parameter_list ')'
       { 
         off_funvar += 12;
         for (long unsigned int i = 0; i < $3->parameter_list_class_vec.size(); i++) {
           string param_name = $3->parameter_list_class_vec[i]->parameter_declaration_class_middle->declarator_class_str;
           off_funvar -= curr_symbtab->Entries[param_name]->size;
           curr_symbtab->Entries[param_name]->offset = off_funvar;
         }
	       $$ = new fun_declarator_class($1, $3);
         off_funvar = 0;
       }
       | IDENTIFIER '(' ')'
       { 
	       $$ = new fun_declarator_class($1);
       }
       ;
       
parameter_list:
         parameter_declaration
       {
         $$ = new parameter_list_class();
         $$ -> parameter_list_class_vec.push_back($1);
       }
       | parameter_list ',' parameter_declaration
       {
         $$ = $1;
         $$ -> parameter_list_class_vec.push_back($3);
       }
       ;

parameter_declaration:
         type_specifier declarator
       {        
         if($1 == "void" && $2 -> star_count == 0){
           error(@$, "Cannot declare variable of type void");
         }
         $$ = new parameter_declaration_class($1, $2);
         string pd_str = $2-> declarator_class_str;
         int sz = 1;
         for(auto it1: $2->declarator_class_vec){
           sz *= it1;
         }
         if ($1 == "int" || $1 == "float" || $2->star_count > 0) {
           sz *= 4;
         }
         else {
           int struct_size = gst.Entries[$1]->size;
           sz *= struct_size;
         }
         variable_types[pd_str] = new datatype($1, $2->star_count, $2->declarator_class_vec);
         off_funvar += sz;
         curr_symbtab->Entries[pd_str] = new symbol(pd_str, "param", "var", $2->get_type($1), sz, 0, nullptr);
       }
       ;

declarator_arr:
         IDENTIFIER
      {
        $$ = new declarator_class($1);
      }
      | declarator_arr '[' INT_CONSTANT ']'
      {
        $$ = $1;
        $$ -> declarator_class_vec.push_back(stoi($3));
      }
      ;

declarator:
         declarator_arr
       {        
         $$ = $1;
       }
       | '*' declarator
       {
         $$ = $2;
         $$ -> star_count++;
       }
       ;

compound_statement:
        '{' '}'
       {        
         $$ = new seq_astnode();
       }
       | '{' statement_list '}'
       {
         $$ = $2;
       }
       | '{' declaration_list '}'
       {
         $$ = new seq_astnode();
       }
       | '{' declaration_list statement_list '}'
       {
         $$ = $3;
       }
       ;

statement_list:
         statement
       {        
          $$ = new seq_astnode();
          $$ -> seq_vec.push_back($1);
       }
       | statement_list statement
       {
         $$ = $1;
         $$ -> seq_vec.push_back($2);
       }
       ;  

statement:
         ';'
       {        
         $$ = new empty_astnode();
       }
       | '{' statement_list '}'
       {
         $$ = $2;
       }
       | selection_statement
       {
         $$ = $1;
       }
       | iteration_statement
       {
         $$ = $1;
       }
       | assignment_statement
       {
         $$ = $1;
       }
       | procedure_call
       {
         $$ = $1;
       }
       | RETURN expression ';'
       {
         if ($2->dtype->isFloat() && curr_fun_dtype->isInt()) {
           $$ = new return_astnode(new op_unary_astnode("TO_INT", $2)); 
         }
         else if ($2->dtype->isInt() && curr_fun_dtype->isFloat()) {
           $$ = new return_astnode(new op_unary_astnode("TO_FLOAT", $2)); 
         }
         else {
          $$ = new return_astnode($2); 
         }
       }
       ;    

assignment_expression:
         unary_expression '=' expression
       {        
         if($1 -> dtype -> star_count >0 && $1 -> dtype -> dimensions.size() == 0 && $3 -> dtype -> isInt() && !($3 ->dtype -> zero)){
           error(@$, "Cannot assign non zero int to a pointer");
         }

         $$ = new assignE_astnode($1,$3);  
         $$ -> dtype = $1 -> dtype;
       }
       ;     

assignment_statement:
         assignment_expression ';'
       {        
          $$ = new assignS_astnode($1 -> assignE_left, $1 -> assignE_right);
       }
       ; 

procedure_call:
         IDENTIFIER '(' ')' ';'
       {        
         $$ = new proccall_astnode($1);
       }
       | IDENTIFIER '(' expression_list ')' ';'
       {
         $$ = new proccall_astnode($1, *($3));
       }
       ;

expression:
         logical_and_expression
       {        
          $$ = $1;
       }
       | expression OR_OP logical_and_expression
       {
          $$ = new op_binary_astnode("OR_OP", $1, $3);
       }
       ;

logical_and_expression:
         equality_expression
       {        
         $$ = $1;
       }
       | logical_and_expression AND_OP equality_expression
       {
          $$ = new op_binary_astnode("AND_OP", $1, $3);
       }
       ;

equality_expression:
         relational_expression
       {        
          $$ = $1;
       }
       | equality_expression EQ_OP relational_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("EQ_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("EQ_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("EQ_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("EQ_OP_INT", $1, $3);
          }
       }
       | equality_expression NE_OP relational_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("NE_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("NE_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("NE_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("NE_OP_INT", $1, $3);
          }
       }
       ;

relational_expression:
         additive_expression
       {        
          $$ = $1;
       }
       | relational_expression '<' additive_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("LT_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("LT_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("LT_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("LT_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("LT_OP_INT", $1, $3);
          }
       }
       | relational_expression '>' additive_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("GT_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("GT_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("GT_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("GT_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("GT_OP_INT", $1, $3);
          }
       }
       | relational_expression LE_OP additive_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("LE_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("LE_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("LE_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("LE_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("LE_OP", $1, $3);
          }
       }
       | relational_expression GE_OP additive_expression
       {
        if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("GE_OP_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("GE_OP_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("GE_OP_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("GE_OP_FLOAT", $1, $3);
          }
          else {
            $$ = new op_binary_astnode("GE_OP_INT", $1, $3);
          }
       }
       ;

additive_expression:
         multiplicative_expression
       {        
         $$ = $1;
       }
       | additive_expression '+' multiplicative_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("PLUS_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("PLUS_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("PLUS_FLOAT", $1, $3);
            $$ ->dtype = new datatype("float");
          }
          else if($1 -> dtype -> star_count + $1 ->dtype ->dimensions.size() >0 && $3 ->dtype -> isInt()){
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
            $$ -> dtype = $1 -> dtype;
          }
          else if($3 -> dtype -> star_count + $1 ->dtype ->dimensions.size() >0 && $1 ->dtype -> isInt()){
            $$ = new op_binary_astnode("PLUS_INT", $1, $3);
            $$ -> dtype = $3 -> dtype;
          }
          else {
            error(@$, "invalid operands to binary +");
          }
       }
       | additive_expression '-' multiplicative_expression
       {
         if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("MINUS_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("MINUS_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
            $$ ->dtype = new datatype("float"); 
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("MINUS_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("MINUS_FLOAT", $1, $3);
            $$ ->dtype = new datatype("float");
          }
          else {
            $$ = new op_binary_astnode("MINUS_INT", $1, $3);
          }
       }
       ;

unary_expression:
         postfix_expression
       {        
         $$ = $1;
       }
       | unary_operator unary_expression
       {
          $$ = new op_unary_astnode($1, $2);  
          if($1 == "UMINUS"){
            $$ ->dtype = $2 -> dtype;
          }
          else if($1 == "NOT"){
            $$ -> dtype = new datatype("int");
          }
          else if($1 == "DEREF"){
            if($2->dtype->star_count + $2->dtype->dimensions.size() == 0){
              error(@$, "Invalid operand to *");
            }
          }
       }
       ;

multiplicative_expression:
         unary_expression
       {        
          $$ = $1;
       }
       | multiplicative_expression '*' unary_expression
       {
          if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("MULT_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("MULT_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("MULT_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("MULT_FLOAT", $1, $3);
            $$ ->dtype = new datatype("float");
          }
          else {
            $$ = new op_binary_astnode("MULT_INT", $1, $3);
          }
       }
       | multiplicative_expression '/' unary_expression
       {
          if ($1->dtype->isInt() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("DIV_INT", $1, $3);
          }
          else if ($1->dtype->isInt() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("DIV_FLOAT", new op_unary_astnode("TO_FLOAT", $1), $3);
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isInt()) {
            $$ = new op_binary_astnode("DIV_FLOAT", $1, new op_unary_astnode("TO_FLOAT", $3));
            $$ ->dtype = new datatype("float");
          }
          else if ($1->dtype->isFloat() && $3->dtype->isFloat()) {
            $$ = new op_binary_astnode("DIV_FLOAT", $1, $3);
            $$ ->dtype = new datatype("float");
          }
          else {
            $$ = new op_binary_astnode("DIV_INT", $1, $3);
          }
       }
       ;

postfix_expression:
         primary_expression
       {        
          $$ = $1; 
       }
       | postfix_expression '[' expression ']'
       {
         $$ = new arrayref_astnode($1, $3);
       } 
       | IDENTIFIER '(' ')'
       {
         $$ = new funcall_astnode($1);
       }
       | IDENTIFIER '(' expression_list ')'
       {
          $$ = new funcall_astnode($1, *($3));

       }
       | postfix_expression '.' IDENTIFIER
       {
         $$ = new member_astnode($1, new identifier_astnode($3));
       }
       | postfix_expression PTR_OP IDENTIFIER
       {
         $$ = new arrow_astnode($1, new identifier_astnode($3));
       }
       | postfix_expression INC_OP
       {
         $$ = new op_unary_astnode("PP", $1);
         $$ ->dtype = $1 ->dtype;
       }
       ;

primary_expression:
         IDENTIFIER
       {        
          $$ = new identifier_astnode($1);
          if(variable_types.count($1) == 0){
            error(@$, "variable "+$1+" not declared" );
          }
          $$->dtype = variable_types[$1];
          
       }
       | INT_CONSTANT
       {
          $$ = new intconst_astnode(stoi($1));
          $$ -> dtype = new datatype("int");
          if($1 == "0"){
            $$ -> dtype -> zero = 1;
          }
       }
       | FLOAT_CONSTANT
       {
          $$ = new floatconst_astnode(stof($1));
          $$ -> dtype = new datatype("float");
       }
       | STRING_LITERAL
       {
         $$ = new stringconst_astnode($1);
         $$ -> dtype = new datatype("string");
       }
       | '(' expression ')'
       {
         $$ = $2;
       }
       ;

expression_list:
         expression
       {        
          $$ = new vector<exp_astnode*>;
          $$->push_back($1);
       }
       | expression_list ',' expression
       {
          $$ = $1;
          $$ -> push_back($3);
       }
       ;

unary_operator:
         '-'
       {        
         $$ = "UMINUS";
       }
       | '!'
       {
         $$ = "NOT";
       }
       | '&'
       {
         $$ = "ADDRESS";
       }
       | '*'
       {
         $$ = "DEREF";
       }
       ;

selection_statement:
         IF '(' expression ')' statement ELSE statement
       {        
          $$ = new if_astnode($3,$5,$7);
       }
       ;

iteration_statement:
         WHILE '(' expression ')' statement
       {        
         $$ = new while_astnode($3,$5);
       }
       | FOR '(' assignment_expression ';' expression ';' assignment_expression ')' statement
       {
         $$ = new for_astnode($3,$5,$7,$9);
       }
       ;

declaration_list:
         declaration
       {        
          $$ = new declaration_list_class();
          $$ -> declaration_list_class_vec.push_back($1); 
       }
       | declaration_list declaration
       {
          $$ = $1;
          $$ -> declaration_list_class_vec.push_back($2);
       }
       ;

declaration:
         type_specifier declarator_list ';'
       {        
         $$ = new declaration_class($1, $2);
         for(auto it : $2->declarator_list_class_vec){

           if($1 == "void" && it -> star_count == 0){
             error(@$, "Cannot declare variable of type void");
           }

           int sz=1;
           int off;
           for(auto it1 : it-> declarator_class_vec){
             sz*=it1;
           }
           if ($1 == "int" || $1 == "float" || it->star_count > 0) {
             sz *= 4;
           }
           else {
            int struct_size = gst.Entries[$1]->size;
            sz  *= struct_size;
           }

           if(curr_struct != ""){
             off = off_struct;
           }
           else{
             off_funvar -= sz;
             off = off_funvar;
           }
           curr_symbtab->Entries[it->declarator_class_str] = new symbol(it->declarator_class_str,"local","var",it->get_type($1),sz,off,nullptr);
           if(curr_struct != ""){
             off_struct += sz;
           }
           variable_types[it->declarator_class_str] = new datatype($1, it->star_count, it->declarator_class_vec);
         }
       }

       ;

declarator_list:
         declarator
       {        
         $$ = new declarator_list_class();
         $$ -> declarator_list_class_vec.push_back($1);
       }
       | declarator_list ',' declarator
       {
         $$= $1;
         $$ -> declarator_list_class_vec.push_back($3);  
       }
       ;
%%
void IPL::Parser::error( const location_type &l, const std::string &err_message )
{
   std::cout << "Error at line " << l.begin.line << ": " << err_message << "\n";
   exit(1);
}


