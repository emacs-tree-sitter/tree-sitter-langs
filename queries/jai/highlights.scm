; highlights.scm

[
 (if_directive)
] @function.macro

[
 (cast_expression)
] @type

[
 "for"
 "while"
 "return"
 ] @keyword

(operator_definition) @operator

[
 "#import"
 "#insert"
] @function.macro

(string_literal) @string
;;(built_in_type) @type
(number) @number
;;(function_definition name: (identifier) @function)
;;(struct_decl name: (identifier) @type.user)
;;(constant_value_definition name: (identifier) @constant)
(inline_comment) @comment
(block_comment) @comment
;;(cast_expression name: (identifier) @function)
;;(function_call name: (variable_reference) @function)
;;(variable_decl name: (identifier) @variable)
;;(variable_decl names: (identifier) @variable)
;;(implicit_variable_decl name: (identifier) @variable)
;;(parameter_decl name: (identifier) @variable)
;;(for_loop name: (identifier) @variable)
;;(for_loop names: (identifier) @variable)
