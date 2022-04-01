(class_definition name: (identifier) @Class)

(class_definition
 body: (block
        [(function_definition name: (identifier) @Method)
         (expression_statement
          (assignment
           left: [(identifier) @Field
                  (pattern_list (identifier) @Field)]))]))

(function_definition
 name: (identifier) @Function)
