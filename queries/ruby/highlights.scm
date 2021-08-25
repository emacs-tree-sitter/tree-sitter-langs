; Keywords

[
 "alias"
 "begin"
 "break"
 "class"
 "def"
 "do"
 "end"
 "ensure"
 "module"
 "next"
 "rescue"
 "if"
 "retry"
 "then"

 ;; return
 "return"
 "yield"

 ;;
 "and"
 "&&"
 "or"
 "||"
 "in"

 ;;
 "case"
 "else"
 "elsif"
 "if"
 "unless"
 "when"

 ;; repeat
 "for"
 "until"
 "while"
 ] @keyword


(constant) @type

((identifier) @keyword
 (.match? @keyword "^(private|protected|public)$"))

[
 "rescue"
 "ensure"
 ] @exception

((identifier) @keyword
 (.match? @keyword "^(fail|raise)$"))

; Function calls

"defined?" @variable.builtin

(program
 (call
  (identifier) @keyword)
 (.match? @keyword "^(require|require_relative|load)$"))

(call
   receiver: (constant)? @type
   method: [
            (identifier)
            (constant)
            ] @function.method
   )

; Function definitions

(alias (identifier) @function.method)
(setter (identifier) @function.method)

(method name: [
               (identifier) @function.method
               (constant) @type
               ])

(singleton_method name: [
                         (identifier) @function.method
                         (constant) @type
                         ])

(class name: (constant) @type)
(module name: (constant) @type)
(superclass (constant) @type)

; Identifiers
[
 (class_variable)
 (instance_variable)
 ] @property

((identifier) @constant.builtin
 (.match? @constant.builtin "^__(callee|dir|id|method|send|ENCODING|FILE|LINE)__$"))

((constant) @type
 (.match? @type "^[A-Z\\d_]+$"))

[
 (self)
 (super)
 ] @variable.builtin

(method_parameters (identifier) @variable.parameter)
(lambda_parameters (identifier) @variable.parameter)
(block_parameters (identifier) @variable.parameter)
(splat_parameter (identifier) @variable.parameter)
(hash_splat_parameter (identifier) @variable.parameter)
(optional_parameter (identifier) @variable.parameter)
(destructured_parameter (identifier) @variable.parameter)
(block_parameter (identifier) @variable.parameter)
(keyword_parameter (identifier) @variable.parameter)
(identifier) @variable


; TODO: Re-enable this once it is supported
; ((identifier) @function
;  (#is-not? local))

; Literals

[
 (string)
 (bare_string)
 (subshell)
 ] @string

[
 (bare_symbol)
 (heredoc_beginning)
 (heredoc_end)
 ] @constant

[(string_content)
 (heredoc_content)
 "\""] @string

(interpolation
 "#{" @punctuation.special
 (_) @embedded
 "}" @punctuation.special)

"}" @punctuation.bracket

[
 (simple_symbol)
 (delimited_symbol)
 (hash_key_symbol)
 ] @property

;; (pair key: (simple_symbol) ":" @constant)
(pair key: (hash_key_symbol) ":" @constant)
(regex) @property
(regex (string_content) @property)
(escape_sequence) @string.escape
(integer) @number
(float) @float

[
 (nil)
 (true)
 (false)
 ] @boolean

(comment) @comment

; Operators

[
 "="
 "=>"
 "->"
 "+"
 "-"
 "*"
 "/"
 "=~"
 ] @operator

[
 ","
 ";"
 "."
 ] @punctuation.delimiter

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
 "%w("
 "%i("
 ] @property

(ERROR) @error
