;; Adapted from nvim-treesitter
;; Keywords


[
 "goto"
 "in"
 "local"
 "return"
] @keyword

(label_statement) @label

(break_statement) @keyword

(do_statement
[
  "do"
  "end"
] @keyword)

(while_statement
[
  "while"
  "do"
  "end"
] @keyword)

(repeat_statement
[
  "repeat"
  "until"
] @keyword)

(if_statement
[
  "if"
  "elseif"
  "else"
  "then"
  "end"
] @keyword)

(elseif_statement
[
  "elseif"
  "then"
  "end"
] @keyword)

(else_statement
[
  "else"
  "end"
] @keyword)

(for_statement
[
  "for"
  "do"
  "end"
] @keyword)

(function_declaration
[
  "function"
  "end"
] @keyword)

(function_definition
[
  "function"
  "end"
] @keyword)

;; Operators

[
 "and"
 "not"
 "or"
] @operator

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "^"
  "#"
  "=="
  "~="
  "<="
  ">="
  "<"
  ">"
  "="
  "&"
  "~"
  "|"
  "<<"
  ">>"
  "//"
  ".."
] @operator

;; Punctuations

[
  ";"
  ":"
  ","
  "."
] @punctuation.delimiter

;; Brackets

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
] @punctuation.bracket

;; Variables

(assignment_statement (variable_list
                       [(identifier) @variable
                        (dot_index_expression table: (identifier) @variable)
                        (bracket_index_expression table: (identifier) @variable)]))
(variable_declaration (variable_list (identifier) @variable))

((identifier) @variable.builtin
 (#eq? @variable.builtin "self"))

;; Constants

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z_0-9]*$"))

(vararg_expression) @constant

(nil) @constant.builtin

[
  (false)
  (true)
] @constant.builtin

;; Tables

(field name: (identifier) @label)

(dot_index_expression field: (identifier) @property)

(table_constructor
[
  "{"
  "}"
] @constructor)

;; Functions

(parameters (identifier) @variable.parameter)

(function_call name: (identifier) @function.call)
(function_declaration name: (identifier) @function)

(function_call name: (dot_index_expression field: (identifier) @function.call))
(function_declaration name: (dot_index_expression field: (identifier) @function))
(function_call name: (method_index_expression method: (identifier) @method.call))


(function_call
  (identifier) @function.builtin
  (#any-of? @function.builtin
    ;; built-in functions in Lua 5.1
    "assert" "collectgarbage" "dofile" "error" "getfenv" "getmetatable" "ipairs"
    "load" "loadfile" "loadstring" "module" "next" "pairs" "pcall" "print"
    "rawequal" "rawget" "rawset" "require" "select" "setfenv" "setmetatable"
    "tonumber" "tostring" "type" "unpack" "xpcall"))

;; Others

(comment) @comment

(hash_bang_line) @comment

(number) @number

(string) @string

;; Error TODO
;;(ERROR) @error
