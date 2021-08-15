((variable_name) @variable.special
 (.match? @variable.special "^(PATH)$"))
(special_variable_name) @variable.special

(variable_assignment name: (_) @variable)
(case_statement
 value: (_) @variable.parameter)

(variable_name) @property

(file_descriptor) @number

(case_item
 value: (word) @constant)

((command_name
  (word) @keyword)
 (.match? @keyword "^(do|trap|type)"))
((command_name
  (word) @function.builtin)
 (.match? @function.builtin "^(alias|bg|bind|builtin|cd|command|compgen|complete|declare|dirs|disown|echo|enable|eval|export|fc|fg|getopts|hash|help|history|jobs|kill|let|local|popd|printf|pushd|pwd|read|readonly|set|shift|shopt|source|suspend|test|times|type|typeset|ulimit|umask|unalias|unset|wait)$"))
(command_name
 (word) @function.call)

((command argument: (_) @label)
 (.match? @label "^-.*="))
((command argument: (_) @constant)
 (.match? @constant "^-"))

(function_definition
 name: (word) @function)

["case"
 "do"
 "done"
 "elif"
 "else"
 "esac"
 "export"
 "fi"
 "for"
 "function"
 "if"
 "in"
 "unset"
 "while"
 "then"] @keyword

["|" "|&"
 "||" "&&"
 ">" ">>" "<"
 "<<" "<<-" "<<<"
 "==" "!="
 ";"
 ";;" ";&" ";;&"] @operator

(raw_string) @string
(comment) @comment

(simple_expansion
 "$" @punctuation.special)
(expansion
 "${" @punctuation.special
 (_) @embedded
 "}" @punctuation.special)

(string) @string

(command_substitution
 "$(" @punctuation.special
 (_) @embedded
 ")" @punctuation.special)
(command_substitution
 "`" @punctuation.special
 (_) @embedded
 "`" @punctuation.special)
(process_substitution
 ["<(" ">("] @punctuation.special
 (_) @embedded
 ")" @punctuation.special)

[(heredoc_start)
 (heredoc_body)] @string.special
