; Keywords
[
    "if"
    "then"
    "else"
    "let"
    "in"
 ] @keyword

(case) @keyword
(of) @keyword
(colon) @keyword
(backslash) @keyword
(as) @keyword
(port) @keyword
(exposing) @keyword
(alias) @keyword
(infix) @keyword
(arrow) @keyword
(port) @keyword

;; case of
(case_of_branch (pattern (union_pattern (upper_case_qid) @constructor)))

(function_call_expr (value_expr (value_qid (upper_case_identifier) @type)))
(function_call_expr (value_expr (upper_case_qid (upper_case_identifier) @constructor)))

;; Records
(record_type (field_type (lower_case_identifier) @constant))
(record_base_identifier (lower_case_identifier) @variable)

(field_access_expr (lower_case_identifier) @constant)
(field_access_expr (value_expr (value_qid (lower_case_identifier) @variable)))
(type_alias_declaration (upper_case_identifier) @type)

(upper_case_qid) @type
(type) @keyword
(type_declaration (upper_case_identifier) @type)
(union_variant) @constructor
(type_ref) @type

(type_annotation(lower_case_identifier) @function)
(port_annotation(lower_case_identifier) @function)
(function_declaration_left(lower_case_identifier) @function.call)
(function_call_expr target: (value_expr) @function.call)

(function_declaration_left (lower_pattern (lower_case_identifier) @variable.parameter))

(field_access_expr(value_expr(value_qid)) @local.function.elm)
(lower_pattern) @local.function.elm
(record_base_identifier) @local.function.elm


(operator_identifier) @keyword
(eq) @keyword


"(" @punctuation.bracket
")" @punctuation.bracket

"|" @keyword
"," @punctuation

(import) @keyword
(module) @keyword

(number_constant_expr) @constant

(value_expr (value_qid (upper_case_identifier) @type))

; comments
(line_comment) @comment
(block_comment) @comment

; strings
(open_quote) @string
(close_quote) @string
(regular_string_part) @string

(open_char) @char
(close_char) @char



(record_pattern (lower_pattern (lower_case_identifier) @constant))

(anonymous_function_expr (pattern (lower_pattern (lower_case_identifier) @variable.parameter)))




