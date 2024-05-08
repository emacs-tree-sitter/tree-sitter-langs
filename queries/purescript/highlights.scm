; ------------------------------------------------------------------------------
; Literals and comments

[
  (integer)
  (exp_negation)
] @number

(exp_literal
  (number)) @float

(char) @character

[
  (string)
  (triple_quote_string)
] @string

(comment) @comment @spell

; ------------------------------------------------------------------------------
; Punctuation

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  (comma)
  ";"
  "."
] @punctuation.delimiter


; ------------------------------------------------------------------------------
; Keywords, operators, includes

[
  "if"
  "then"
  "else"
  "case"
  "of"
] @keyword

[
  "import"
  "module"
] @keyword

[
  (operator)
  (constructor_operator)
  (type_operator)
  (all_names)
  "="
  "|"
  "::"
  "∷"
  "=>"
  "⇒"
  "<="
  "⇐"
  "->"
  "→"
  "<-"
  "←"
  "\\"
  "`"
  "@"
] @operator


(module) @type.builtin

[
  (where)
  "let"
  "in"
  "class"
  "instance"
  "derive"
  "foreign"
  "data"
  "newtype"
  "type"
  "as"
  "hiding"
  "do"
  "ado"
  "forall"
  "∀"
  "infix"
  "infixl"
  "infixr"
] @keyword

(class_instance
  "else" @keyword)

(type_role_declaration
  "role" @keyword
  role: (type_role) @type.qualifier)

(hole) @character.special

; `_` wildcards in if-then-else and case-of expressions,
; as well as record updates and operator sections
(wildcard) @parameter

; ------------------------------------------------------------------------------
; Functions and variables

(variable) @variable
(exp_apply
  .
  (exp_name
    (variable) @function.call))

(exp_apply
  .
  (exp_name
    (qualified_variable
      (variable) @function.call)))

(row_field
  (field_name) @constant)

(record_field
  (field_name) @constant)

(record_field
  (field_pun) @constant)

(record_accessor
  field: [ (variable)
           (string)
           (triple_quote_string)
         ] @variable)

(exp_record_access
  field: [ (variable)
           (string)
           (triple_quote_string)
         ] @variable)

(pat_wildcard) @operator

(field_wildcard) @operator

(pat_field (field_name) @constant)

(record_update (field_name) @constant)

(signature
  name: (variable) @function)

(kind_declaration
  (class_name) @type)

(function
  name: (variable) @function.call)

(foreign_import
  (variable) @function)

(class_instance
  (instance_name) @function)

(derive_declaration
  (instance_name) @function)

((variable) @boolean
  (#any-of? @boolean "true" "false"))

(exp_ticked
  (_) @operator)

(exp_ticked
  (exp_name
    (variable) @operator))

(exp_ticked
  (exp_name
    (qualified_variable
      (variable) @operator)))

; ------------------------------------------------------------------------------
; Types

(type) @type
(type_variable) @type.argument

(constructor) @constructor
