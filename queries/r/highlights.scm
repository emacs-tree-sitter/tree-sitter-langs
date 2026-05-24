; highlights.scm
; Literals
(integer) @number

(float) @number

(complex) @number

(string) @string

(string
  (string_content
    (escape_sequence) @string.escape))

; Comments
(comment) @comment

; Operators
[
  "?"
  ":="
  "="
  "<-"
  "<<-"
  "->"
  "->>"
  "~"
  "|>"
  "||"
  "|"
  "&&"
  "&"
  "<"
  "<="
  ">"
  ">="
  "=="
  "!="
  "+"
  "-"
  "*"
  "/"
  "::"
  ":::"
  "**"
  "^"
  "$"
  "@"
  ":"
  "special"
] @operator

; Punctuation
[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
  "[["
  "]]"
] @punctuation.bracket

(comma) @punctuation.delimiter

; Functions
(binary_operator
  lhs: (identifier) @function
  operator: "<-"
  rhs: (function_definition))

(binary_operator
  lhs: (identifier) @function
  operator: "="
  rhs: (function_definition))

; Calls
(call
  function: (identifier) @function)

; - `return` is just a regular identifier in our grammar (#189), but people
;   expect `return()` to be highlighted
; - We feel confident that we can use `#eq?` here, as other grammars use
;   `#eq?` and `#match?` predicates already, even though support for predicates
;   is dependent on the library that binds to tree-sitter's C library, not the
;   C library itself.
;   https://github.com/tree-sitter/tree-sitter-javascript/blob/58404d8cf191d69f2674a8fd507bd5776f46cb11/queries/highlights.scm#L65-L67
;   https://github.com/tree-sitter/tree-sitter-rust/blob/77a3747266f4d621d0757825e6b11edcbf991ca5/queries/highlights.scm#L9-L11
; - Placed after `(call function: (identifier) @function)` for correct precedence
((call function: (identifier) @keyword)
 (#eq? @keyword "return"))

; Parameters
(parameters
  (parameter
    name: (identifier) @variable.parameter))

(arguments
  (argument
    name: (identifier) @variable.parameter))

; Variables
(binary_operator
  lhs: (identifier) @variable
  operator: "="
  rhs: (_))

(binary_operator
  lhs: (identifier) @variable
  operator: "<-"
  rhs: (_))

; Namespace
(namespace_operator
  lhs: (identifier) @namespace)

(call
  function: (namespace_operator
    rhs: (identifier) @function))

; Keywords
(function_definition
  name: "function" @keyword.function)

(function_definition
  name: "\\" @operator)

[
  "in"
  (next)
  (break)
] @keyword

[
  "if"
  "else"
] @conditional

[
  "while"
  "repeat"
  "for"
] @repeat

[
  (true)
  (false)
] @boolean

[
  (null)
  (inf)
  (nan)
  (na)
  (dots)
  (dot_dot_i)
] @constant.builtin

; Error
(ERROR) @error
