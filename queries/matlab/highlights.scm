; attribute
; comment
; constant
; constant.builtin
; constructor
; doc
; embedded
; escape
; function
; function.builtin
; function.call
; function.macro
; function.special
; keyword
; label
; method
; method.call
; number
; operator
; property
; property.definition
; punctuation
; punctuation.bracket
; punctuation.delimiter
; punctuation.special
; string
; string.special
; tag
; type
; type.argument
; type.builtin
; type.parameter
; type.super
; variable
; variable.builtin
; variable.parameter
; variable.special

; Errors

(ERROR) @error

; Constants

(events (identifier) @constant)
(attribute (identifier) @constant)

"~" @constant.builtin

; Fields/Properties

(field_expression field: (identifier) @property)
(superclass "." (identifier) @property)
(property_name "." (identifier) @property)
(property name: (identifier) @property)

; Types

(class_definition name: (identifier) @type)
(attributes (identifier) @constant)
(enum . (identifier) @type)

; Functions

(function_definition
  "function" @keyword
  name: (identifier) @function
  [ "end" "endfunction" ]? @keyword)

(function_signature name: (identifier) @function)

(function_call name: (identifier) @function.call)

(handle_operator (identifier) @function)
(validation_functions (identifier) @function)

(command (command_name) @function.macro)
(command_argument) @string

(return_statement) @keyword

; Parameters

(lambda (arguments (identifier) @variable.parameter))
(function_arguments (identifier) @variable.parameter)

; Conditionals

(if_statement [ "if" "end" ] @keyword)
(elseif_clause "elseif" @keyword)
(else_clause "else" @keyword)
(switch_statement [ "switch" "end" ] @keyword)
(case_clause "case" @keyword)
(otherwise_clause "otherwise" @keyword)
(break_statement) @keyword

; Repeats

(for_statement [ "for" "parfor" "end" ] @keyword)
(while_statement [ "while" "end" ] @keyword)
(continue_statement) @keyword

; Exceptions

(try_statement [ "try" "end" ] @keyword)
(catch_clause "catch" @keyword)

; Punctuation

[ ";" "," "." ] @punctuation.delimiter
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket

; Literals

(escape_sequence) @escape
(formatting_sequence) @escape
(string) @string
(number) @number
(boolean) @constant.builtin

; Comments

[ (comment) (line_continuation) ] @comment @spell

; Operators

(unary_operator ["+" "-"] @number)

[
  "+"
  ".+"
  "-"
  ".*"
  "*"
  ".*"
  "/"
  "./"
  "\\"
  ".\\"
  "^"
  ".^"
  "'"
  ".'"
  "|"
  "&"
  "?"
  "@"
  "<"
  "<="
  ">"
  ">="
  "=="
  "~="
  "="
  "&&"
  "||"
  ":"
] @operator

; Assignments

(assignment left: (_) @variable)
(multioutput_variable (_) @variable)

; Keywords

[
  "arguments"
  "classdef"
  "end"
  "enumeration"
  "events"
  "global"
  "methods"
  "persistent"
  "properties"
] @keyword

