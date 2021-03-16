;; (expansion
;;  (variable_name) @variable)

((variable_name) @variable.special
 (.match? @variable.special "^(PATH)$"))

(special_variable_name) @keyword

;; (case_statement
;;  value: (_) @variable.parameter)

(case_item
 value: (word) @constant)

(function_definition
 name: (word) @function)

((command_name
  (word) @keyword)
 (.match? @keyword "^(do|trap|type)"))

((command_name
  (word) @function.builtin)
 (.match? @function.builtin "^(alias|bg|bind|builtin|cd|command|compgen|complete|declare|dirs|disown|echo|enable|eval|export|fc|fg|getopts|hash|help|history|jobs|kill|let|local|popd|printf|pushd|pwd|read|readonly|set|shift|shopt|source|suspend|test|times|type|typeset|ulimit|umask|unalias|unset|wait)$"))

(command_name
 (word) @function.call)

((word) @label
 (.match? @label "^--"))

(raw_string) @string

["|" "|&"
 "||" "&&"
 "==" "!="
 ";"
 ";;" ";&" ";;&"] @operator


(simple_expansion
 "$" @punctuation.special
 (_) @embedded)

(expansion
 "${" @punctuation.special
 (_) @embedded
 "}" @punctuation.special)

(string) @string

(comment) @comment

(command_substitution
 "$(" @punctuation.special
 (_) @embedded
 ")" @punctuation.special)

(command_substitution
 "`" @punctuation.special
 (_) @embedded
 "`" @punctuation.special)
