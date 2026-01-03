(section_name) @tag

((section_name) @function.builtin
  (#eq? @function.builtin "include"))

((section_header
  (section_name) @function.builtin
  (subsection_name))
  (#eq? @function.builtin "includeIf"))

(variable
  (name) @property)

[
  (true)
  (false)
] @constant.builtin

(integer) @number

[
  (string)
  (subsection_name)
] @string

((string) @string.special.path
  (#match? @string.special.path "^(~|./|/)"))

[
  "["
  "]"
  "\""
] @punctuation.bracket

"=" @punctuation.delimiter

(comment) @comment
