;; Built-ins.

((identifier) @constant.builtin
 (.match? @constant.builtin "^(__all__|__doc__|__name__|__package__|NotImplemented|Ellipsis)$"))

;; XXX: Not really a keyword, but it's sort of a tradition.
((identifier) @keyword
 (.eq? @keyword "self"))

;; Function definitions.

(class_definition
 body: (block (function_definition name: (identifier) @method)))
(function_definition
 name: (identifier) @function)

;; Types.
([(type [(identifier) @type.builtin
         (subscript (identifier) @type.builtin)
         (tuple [(identifier) @type.builtin
                 (subscript (identifier) @type.builtin)])])
  (class_definition superclasses: (_ (identifier) @type.builtin))]
 ;; TODO: Include built-in exception types.
 (.match? @type.builtin "^(bool|bytearray|bytes|dict|float|int|list|object|set|str|tuple|unicode)$"))
(type [(subscript
        value: (identifier) @type
        subscript: (identifier) @type.argument)
       (identifier) @type
       (string) @type
       (tuple [(identifier) @type
               (subscript
                value: (identifier) @type
                subscript: (identifier) @type.argument)])])
(class_definition
 name: (identifier) @type
 superclasses: (argument_list (identifier) @type.super))

;; Variables.
;; TODO: Add @variable.use

(parameter/identifier) @variable.parameter
(parameter/typed_parameter (identifier) @variable.parameter)
(parameter/typed_default_parameter name: (identifier) @variable.parameter)
(parameter/default_parameter name: (identifier) @variable.parameter)
;; TODO: Make splat parameters more visually distinct.
(parameter/list_splat_pattern (identifier) @variable.parameter)
(parameter/dictionary_splat_pattern (identifier) @variable.parameter)

(pattern/identifier) @variable
(pattern/attribute attribute: (identifier) @variable)
(pattern/subscript subscript: [(identifier) (string)] @variable)

(named_expression name: (identifier) @variable)

(keyword_argument name: (identifier) @label)

;; Literals.

[(none) (true) (false)] @constant.builtin
[(integer) (float)] @number

;; Identifier naming conventions.

((identifier) @constant
 (.match? @constant "^[A-Z_][A-Z_\\d]*$"))

((identifier) @constructor
 (.match? @constructor "^[A-Z]"))

;; Function calls.

((call
  function: (identifier) @function.builtin)
 (.match?
   @function.builtin
   "^(abs|all|any|ascii|bin|bool|breakpoint|bytearray|bytes|callable|chr|classmethod|compile|complex|delattr|dict|dir|divmod|enumerate|eval|exec|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|isinstance|issubclass|iter|len|list|locals|map|max|memoryview|min|next|object|oct|open|ord|pow|print|property|range|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|vars|zip|__import__)$"))
(call function: [(attribute attribute: (identifier) @method.call)
                 (identifier) @function.call])

;; Properties.

(attribute attribute: (identifier) @property)

;; Operators.

["-"
 "-="
 "!="
 "@"
 "@="
 "*"
 "**"
 "**="
 "*="
 "/"
 "//"
 "//="
 "/="
 "&"
 "&="
 "%"
 "%="
 "^"
 "^="
 "+"
 "+="
 "<"
 "<<"
 "<="
 "<>"
 ":="
 "="
 "=="
 ">"
 ">="
 ">>"
 "|"
 "|="
 "~"
 "and"
 "in"
 "is"
 "not"
 "or"] @operator

;; Keywords.

["as"
 "assert"
 "async"
 "await"
 "break"
 "class"
 "continue"
 "def"
 "del"
 "elif"
 "else"
 "except"
 "exec"
 "finally"
 "for"
 "from"
 "global"
 "if"
 "import"
 "lambda"
 "nonlocal"
 "pass"
 "print"
 "raise"
 "return"
 "try"
 "while"
 "with"
 "yield"
 "match"
 "case"] @keyword

;; "Contexts" may have internal highlighting -> low priority.

(comment) @comment
(string) @string
(escape_sequence) @escape

(interpolation
 "{" @punctuation.special
 (_) @embedded
 "}" @punctuation.special)

((string) @doc
 (.match? @doc "^(\"\"\"|r\"\"\")"))

(decorator) @function.special
