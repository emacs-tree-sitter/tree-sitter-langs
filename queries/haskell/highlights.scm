;; ----------------------------------------------------------------------------
;; Literals and comments

(integer) @number
(exp_negation) @number
(exp_literal (float)) @float
(char) @character
(string) @string

(con_unit) @symbol  ; unit, as in ()

(comment) @comment


;; ----------------------------------------------------------------------------
;; Punctuation

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
] @punctuation.delimiter


;; ----------------------------------------------------------------------------
;; Keywords, operators, includes

(module) @type.builtin
[
  "forall"
  "∀"
] @repeat

(pragma) @comment

[
  "if"
  "then"
  "else"
  "case"
  "of"
] @keyword

[
  "import"
  "qualified"
  "module"
] @keyword

[
  (operator)
  (constructor_operator)
  (type_operator)
  (tycon_arrow)
  (qualified_module)  ; grabs the `.` (dot), ex: import System.IO
  (all_names)
  (wildcard)
  "="
  "|"
  "::"
  "=>"
  "->"
  "<-"
  "\\"
  "`"
  "@"
] @operator

(module) @namespace

[
  (where)
  "let"
  "in"
  "class"
  "instance"
  "data"
  "newtype"
  "family"
  "type"
  "as"
  "hiding"
  "deriving"
  "via"
  "stock"
  "anyclass"
  "do"
  "mdo"
  "rec"
  "infix"
  "infixl"
  "infixr"
] @keyword


;; ----------------------------------------------------------------------------
;; Functions and variables


(pat_name . (constructor) @constructor)
(pat_wildcard) @operator
;; (pat_apply . (constructor) @constructor) 
(signature name: (variable) @function)
;; (function name: (variable) @function patterns: (pat_apply) @constructor)
(function name: (variable) @function.call patterns: (patterns) @variable.parameter)
((signature (fun)) . (function (fun) @function.call))
((signature (context (fun))) . (function (fun) @variable))
((signature (forall (context (fun)))) . (function (variable) @variable))

(exp_infix (variable) @operator)  ; consider infix functions as operators

(exp_infix (exp_name (variable) @property))
(exp_apply . (exp_name (variable) @function.call))
(exp_apply . (exp_name (qualified_variable (variable) @function.call)))

(record_fields (field (variable) @constant ))
(variable) @variable

;; ----------------------------------------------------------------------------
;; Types

(type) @type
(type_variable) @type.argument

(constructor) @constructor

; True or False
((constructor) @_bool (#match? @_bool "(True|False)")) @boolean


;; ----------------------------------------------------------------------------
;; Quasi-quotes

(quoter) @function.call
; Highlighting of quasiquote_body is handled by injections.scm
