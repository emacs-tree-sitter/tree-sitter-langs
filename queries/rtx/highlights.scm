[
  (arrow)
  (str_op)
  (and) (or)
  (not)
  "="
  (blank)
] @operator

[
  (if_tok)
  (elif_tok)
  (else_tok)
  (always_tok)
] @keyword

(comment) @comment

(weight) @constant.numeric
(reduce_rule ":" @constant.numeric)
(num) @constant.numeric

(colon) @punctuation.delimiter

(string) @constant.string

(output_rule
 pos: (ident) @variable)
(retag_rule
 src_attr: (ident) @variable
 trg_attr: (ident) @variable)
(attr_default
 src: (ident) @variable
 trg: (ident) @variable) ; (ND "") highlight trg as string
(attr_rule
 name: (ident) @variable)
