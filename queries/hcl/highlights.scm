("for" @keyword (identifier) @variable)

;; (attribute (identifier) @variable)
;; (object_elem key: (_) @variable)
(attribute (identifier) @property)
(object_elem key: (_) @property)

(get_attr (identifier) @property)

(block (identifier) @type)
;; (one_line_block (identifier) @type)

(function_call (identifier) @function.call)

[
 ;; (string_lit)
 (quoted_template_start)
 (quoted_template_end)
 (template_literal)
 ;; (heredoc)
 ] @string

(numeric_lit) @number

[(bool_lit)
 (null_lit)
 ] @constant.builtin

(comment) @comment

["("
 ")"
 "["
 "]"
 "{"
 "}"
 ]  @punctuation.bracket

["&&" "?" ":" "!=" "==" "=>"] @operator

["if" "in"] @keyword

;; "." @punctuation.special

(template_interpolation
 (template_interpolation_start) @punctuation.special
 (expression) @embedded
 (template_interpolation_end) @punctuation.special)
