;; Keywords and operators.

["alias"
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

;; Braces, when used to denote a block, have the same function as "do" and "end"
;; and should be highlighted similarly.
(block ["{" "}"] @keyword)

((identifier) @keyword
 (.match? @keyword "^(private|protected|public)$"))

((identifier) @keyword
 (.match? @keyword "^(fail|raise)$"))

["="
 "=>" ":"
 "->"
 "+"
 "-"
 "*"
 "/"
 "=~"
 ] @operator

;;; ----------------------------------------------------------------------------
;; Function calls and definitions.

"defined?" @function.builtin
(program
 (call method: (identifier) @keyword
       arguments: (argument_list (identifier) @constant))
 (.match? @keyword "^(require|require_relative|load)$"))
(call
 receiver: [(constant) @type
            (_)]
 method: [(identifier)
          (constant)] @method.call)
(call
 !receiver
 method: [(identifier)
          (constant)] @function.call)

(alias (identifier) @method)
(setter (identifier) @method)
(method name: [(identifier) @method
               (constant) @type])
(singleton_method name: [(identifier) @method
                         (constant) @type])

;;; ----------------------------------------------------------------------------
;; Types.

(class name: (constant) @type)
(module name: (constant) @type)
(superclass (constant) @type.super)

((constant) @constant
 (.match? @constant "^[A-Z\\d_]+$"))

(constant) @type

;;; ----------------------------------------------------------------------------
;; Variables & properties.

[(self)
 (super)
 ] @variable.builtin

((identifier) @constant.builtin
 (.match? @constant.builtin "^__(callee|dir|id|method|send|ENCODING|FILE|LINE)__$"))

(file) @constant.builtin
(line) @constant.builtin
(encoding) @constant.builtin

(hash_splat_nil
  "**" @operator
) @constant.builtin

(assignment
 left: [(class_variable) @variable.special
        (identifier) @variable
        (instance_variable) @variable])

(left_assignment_list
 [(identifier) @variable
  (instance_variable) @variable
  (class_variable) @variable.special])

[(class_variable)
 (instance_variable)
 ] @property

(method_parameters (identifier) @variable.parameter)
(lambda_parameters (identifier) @variable.parameter)
(block_parameters (identifier) @variable.parameter)
(splat_parameter (identifier) @variable.parameter)
(hash_splat_parameter (identifier) @variable.parameter)
(optional_parameter (identifier) @variable.parameter)
(destructured_parameter (identifier) @variable.parameter)
(block_parameter (identifier) @variable.parameter)
(keyword_parameter (identifier) @variable.parameter)
;; (identifier) @variable

;; TODO: Re-enable this once it is supported
;; ((identifier) @function
;;  (#is-not? local))

;;; ----------------------------------------------------------------------------
;; Literals.

[(bare_symbol)
 (heredoc_beginning)
 (heredoc_end)
 ] @constant

[(simple_symbol)
 (delimited_symbol)
 (hash_key_symbol)
 ] @constant

(escape_sequence) @escape

[(integer) (float)]  @number

(regex (string_content) @string.special)

[(nil)
 (true)
 (false)
 ] @constant

(comment) @comment

[","
 ";"
 "."
 ] @punctuation.delimiter

["("
 ")"
 "["
 "]"
 "{"
 "%w("
 "%i("] @punctuation.bracket

;;; ----------------------------------------------------------------------------
;; "Contexts" that may have internal highlighting and other low priority stuff.

[(string_content)
 (heredoc_content)
 "\""] @string

(interpolation
 "#{" @punctuation.special
 (_) @embedded
 "}" @punctuation.special)

;; Lower priority than interpolation's closing bracket.
"}" @punctuation.bracket

[(string)
 (bare_string)
 (subshell)
 (heredoc_body)] @string
