;; Special identifiers

((identifier) @constant
 (.match? @constant "^[A-Z_][A-Z_\\d]*$"))

((shorthand_property_identifier) @constant
 (.match? @constant "^[A-Z_][A-Z_\\d]*$"))

((identifier) @constructor
 (.match? @constructor "^[A-Z]"))

((identifier) @variable.builtin
 (.match? @variable.builtin "^(arguments|module|console|window|document)$")
 (.is-not? local))

((identifier) @function.builtin
 (.eq? @function.builtin "require")
 (.is-not? local))

;; Function and method definitions

(function_expression
 name: (identifier) @function)
(function_declaration
 name: (identifier) @function)
(generator_function_declaration
 name: (identifier) @function)
(method_definition
 name: (property_identifier) @method)

(variable_declarator
 name: (identifier) @function
 value: [(function_expression) (arrow_function)])

(assignment_expression
 left: [(identifier) @function
        (member_expression property: (property_identifier) @method)]
 right: [(function_expression) (arrow_function)])

(pair key: (property_identifier) @method
      value: [(function_expression) (arrow_function)])

;; Function and method calls

(call_expression
 function: [(identifier) @function.call
            (member_expression
             property: (property_identifier) @method.call)])

;; Variables

(variable_declarator
 name: (identifier) @variable)
(assignment_expression
 left: [(identifier) @variable
        (member_expression property: (property_identifier) @variable)])
(augmented_assignment_expression
 left: [(identifier) @variable
        (member_expression property: (property_identifier) @variable)])
(for_in_statement
 left: (identifier) @variable)

(arrow_function
 parameter: (identifier) @variable.parameter)
;; TypeScript's highlighting patterns reuse this file, so the atter below must work for both
;; JavaScript and TypeScript. Since TypeScript grammar redefines `_formal_parameter`, we use
;; wildcard pattern instead of `formal_parameters`.
(arrow_function
 parameters: [(_ (identifier) @variable.parameter)
              (_ (_ (identifier) @variable.parameter))
              (_ (_ (_ (identifier) @variable.parameter)))])

;; Properties

(pair key: (property_identifier) @property.definition)
(member_expression
 property: (property_identifier) @property)
((shorthand_property_identifier) @property.definition)



;; Punctuation

(template_substitution
 "${" @punctuation.special
 (_)
 "}" @punctuation.special)

[";"
 "."
 ","] @punctuation.delimiter

["--"
 "-"
 "-="
 "&&"
 "+"
 "++"
 "+="
 "<"
 "<="
 "<<"
 "="
 "=="
 "==="
 "!"
 "!="
 "!=="
 "=>"
 ">"
 ">="
 ">>"
 "||"] @operator

["("
 ")"
 "["
 "]"
 "{"
 "}"] @punctuation.bracket

;; Keywords

["as"
 "async"
 "await"
 "break"
 "case"
 "catch"
 "class"
 "const"
 "continue"
 "debugger"
 "default"
 "delete"
 "do"
 "else"
 "export"
 "extends"
 "finally"
 "for"
 "from"
 "function"
 "get"
 "if"
 "import"
 "in"
 "instanceof"
 "let"
 "new"
 "of"
 "return"
 "set"
 "static"
 "switch"
 "target"
 "throw"
 "try"
 "typeof"
 "var"
 "void"
 "while"
 "with"
 "yield"] @keyword


;; Misc.
(statement_identifier) @label


;; Literals

[(this) (super) (true) (false)] @variable.builtin

(regex) @string.special
(number) @number

(string) @string
(comment) @comment

(template_substitution
 "${"
 (_) @embedded
 "}")

;; template strings need to be last in the file for embedded expressions
;; to work properly
(template_string) @string
