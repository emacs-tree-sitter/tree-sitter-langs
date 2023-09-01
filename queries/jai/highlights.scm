;; highlights.scm

[
 (cast_expression)
 ] @type

[
 "if"
 "ifx"
 "then"
 "else"
 "for"
 "while"
 "break"
 "return"
 ] @keyword

(variable_initializer (identifier) @type)
(operator_definition) @operator

(parameter (identifier) (identifier) @type)
(trailing_return_types (parameter (identifier) @type))

[
 (expression_like_directive)
 "#assert"
 "#type_info_none"
 "#type_info_procedures_are_void_pointers"
 "#no_padding"
 "#specified"
 "#must"
 "#deprecated"
 (trailing_directive)
 "#code"
 "#complete"
 (operator_like_directive)
 "#foreign"
 "#align"
 "#module_parameters"
 (module_scope_directive)
 "#if"
 "#load"
 "#insert"
 "#program_export"
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
