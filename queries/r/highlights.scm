; highlights.scm

; Literals

(integer) @number
(float) @number
(complex) @number

(string) @string
(string (string_content (escape_sequence) @string.escape))

; Comments

(comment) @comment

; Operators

[
  "?" ":=" "=" "<-" "<<-" "->" "->>"
  "~" "|>" "||" "|" "&&" "&"
  "<" "<=" ">" ">=" "==" "!="
  "+" "-" "*" "/" "::" ":::"
  "**" "^" "$" "@" ":"
  "special"
] @operator

; Punctuation

[
  "("  ")"
  "{"  "}"
  "["  "]"
  "[[" "]]"
] @punctuation.bracket

(comma) @punctuation.delimiter

; Functions

(binary_operator
    lhs: (identifier) @function
    operator: "<-"
    rhs: (function_definition)
)

(binary_operator
    lhs: (identifier) @function
    operator: "="
    rhs: (function_definition)
)

; Calls

(call function: (identifier) @function)

; Parameters

(parameters (parameter name: (identifier) @variable.parameter))
(arguments (argument name: (identifier) @variable.parameter))

; Variables

(binary_operator
    lhs: (identifier) @variable
    operator: "="
    rhs: (_)
)

(binary_operator
    lhs: (identifier) @variable
    operator: "<-"
    rhs: (_)
)

; Namespace

(namespace_operator lhs: (identifier) @namespace)

(call
    function: (namespace_operator rhs: (identifier) @function)
)

; Keywords

(function_definition name: "function" @keyword.function)
(function_definition name: "\\" @operator)

[
  "in"
  (return)
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
