[
  (block_comment)
  (line_comment)
] @comment

((block_comment)+ @comment.documentation
  (#match? @comment.documentation "^;;;\\s+.*"))

[
  "array"
  "block"
  "catch"
  "catch_ref"
  "catch_all"
  "catch_all_ref"
  "data"
  "declare"
  "elem"
  "else"
  "end"
  "export"
  "field"
  "final"
  "func"
  "global"
  "if"
  "import"
  "item"
  "local"
  "loop"
  "memory"
  "module"
  "mut"
  "null"
  "offset"
  "pagesize"
  "param"
  "rec"
  "ref"
  "result"
  "shared"
  "start"
  "struct"
  "sub"
  "table"
  "tag"
  "then"
  "try_table"
  "type"
  "unshared"
] @keyword

[
  (integer)
  (float)
] @number

(instr_name) @operator

[
  "("
  ")"
] @punctuation.bracket

(string) @string

[
  (num_type)
  (vec_type)
  (packed_type)
] @type.builtin

((ref_type) @type.builtin
  (#match? @type.builtin "^(any|eq|i31|struct|array|null|(null)?func|(null)?exn|(null)?extern)ref$"))

((heap_type) @type.builtin
  (#match? @type.builtin "^(any|eq|i31|struct|array|null|(null)?func|(null)?exn|(null)?extern)$"))

(identifier) @variable

(index) @variable

(module_field_func
  (identifier) @function)

(extern_type_func
  (identifier) @function)

(module_field_start
  (index
    [
      (identifier)
      (uinteger)
    ] @function))

(plain_instr
  ((instr_name) @operator
    (#match? @operator "^(return_)?call$"))
  [
    (identifier)
    (integer)
  ] @function)
