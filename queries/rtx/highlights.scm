[
  (arrow)
  (str_op)
  (bool_op)
  (not)
  "="
  (blank)
] @keyword.operator

[
  (if_tok)
  (elif_tok)
  (else_tok)
  (always_tok)
] @keyword.control

(comment) @comment

(weight) @constant.numeric
(reduce_rule ":" @constant.numeric)
(num) @constant.numeric

(string) @constant.string
