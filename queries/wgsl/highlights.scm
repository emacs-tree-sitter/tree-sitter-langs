(int_literal) @number

(float_literal) @float

(bool_literal) @boolean

(type_declaration
  [
    "bool"
    "u32"
    "i32"
    "f16"
    "f32"
  ] @type.builtin)

(type_declaration) @type

(function_declaration
  (identifier) @function)

(parameter
  (variable_identifier_declaration
    (identifier) @parameter))

(struct_declaration
  (identifier) @structure)

(struct_declaration
  (struct_member
    (variable_identifier_declaration
      (identifier) @field)))

(attribute
  (identifier) @attribute)

(identifier) @variable

(type_constructor_or_function_call_expression
  (type_declaration) @function.call)

[
  "struct"
  "bitcast"
  "discard"
  "enable"
  "fallthrough"
  "let"
  "type"
  "var"
  "override"
  (texel_format)
] @keyword

[
  "private"
  "storage"
  "uniform"
  "workgroup"
] @storageclass

[
  "read"
  "read_write"
  "write"
] @type.qualifier

"fn" @keyword.function

"return" @keyword.return

[
  ","
  "."
  ":"
  ";"
  "->"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  "loop"
  "for"
  "while"
  "break"
  "continue"
  "continuing"
] @repeat

[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @conditional

[
  "&"
  "&&"
  "/"
  "!"
  "="
  "=="
  "!="
  ">"
  ">="
  ">>"
  "<"
  "<="
  "<<"
  "%"
  "-"
  "+"
  "|"
  "||"
  "*"
  "~"
  "^"
  "@"
  "++"
  "--"
] @operator

[
  (line_comment)
  (block_comment)
] @comment

(ERROR) @error
