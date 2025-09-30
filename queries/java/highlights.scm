; Methods

(package_declaration (scoped_identifier (identifier) @constant))

((identifier) @constant (.match? @constant "^[A-Z_][A-Z_\\d]*$"))
(scoped_identifier (identifier) @type (.match?  @type "^[A-Z]") )
(scoped_identifier (scoped_identifier) @constant)
(scoped_identifier (identifier) @property)

(field_access ( identifier ) @type (.match?  @type "^[A-Z]"))
(field_access ( identifier ) @property)

(formal_parameter (identifier) @variable.parameter)
(method_declaration name: (identifier) @function.method)
(super) @function.builtin

; Annotations

(annotation (identifier) @constructor)
(marker_annotation (identifier) @constructor)

"@" @constant

(annotation_argument_list (element_value_pair (identifier) @variable.parameter))

; Types

(interface_declaration (identifier) @type)
(class_declaration (identifier) @type)
(enum_declaration (identifier) @type)


(constructor_declaration (identifier) @constructor)

(type_identifier) @type
(variable_declarator (identifier) @constant)
(boolean_type) @type.builtin
(integral_type) @type.builtin
(floating_point_type) @type.builtin
(void_type) @type.builtin

; Variables


(this) @variable.builtin

; Literals

(hex_integer_literal) @number
(decimal_integer_literal) @number
(octal_integer_literal) @number
(decimal_floating_point_literal) @number
(hex_floating_point_literal) @number
(character_literal) @string
(string_literal) @string
(true) @constant
(false) @constant
(null_literal) @constant.builtin

(line_comment) @comment
(block_comment) @comment

; Keywords

"abstract" @keyword
"assert" @keyword
"break" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"continue" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"exports" @keyword
"extends" @keyword
"final" @keyword
"finally" @keyword
"for" @keyword
"if" @keyword
"implements" @keyword
"import" @keyword
"instanceof" @keyword
"interface" @keyword
"module" @keyword
"native" @keyword
"new" @keyword
"open" @keyword
"opens" @keyword
"package" @keyword
"private" @keyword
"protected" @keyword
"provides" @keyword
"public" @keyword
"requires" @keyword
"return" @keyword
"static" @keyword
"strictfp" @keyword
"switch" @keyword
"synchronized" @keyword
"throw" @keyword
"throws" @keyword
"to" @keyword
"transient" @keyword
"transitive" @keyword
"try" @keyword
"uses" @keyword
"volatile" @keyword
"while" @keyword
"with" @keyword
"=" @operator
"==" @operator
"!" @operator
"->" @operator
"?" @operator
":" @operator
"::" @operator
"&&" @operator

[
 "("
 ")"
 "{"
 "}"
 "["
 "]"
 ] @punctuation.bracket

(lambda_expression (identifier) @variable.parameter)
(((method_invocation (identifier) @type)) . (.match? @type "^[A-Z]"))
(method_invocation ( argument_list ( identifier ) @constant))

(method_invocation name: (identifier) @function.call)

((identifier) @constant (.match? @constant "^[A-Z_][A-Z_\\d]*$"))
