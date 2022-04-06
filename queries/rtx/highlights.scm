[
  (arrow)
  (str_op)
  (bool_op)
  (not)
  "="
  (blank)
] @keyword

[
  (if_tok)
  (elif_tok)
  (else_tok)
  (always_tok)
] @keyword

(comment) @comment

(weight) @constant
(reduce_rule ":" @constant)
(num) @constant

(reduce_rule_group (ident) @function)
(reduce_rule (string) @label)

(output_var_set (ident) @constant)
((clip) (str_op) (clip (ident) @string))
(str_op) @operator
(blank) @constant
(ident) @variable

(string) @string
