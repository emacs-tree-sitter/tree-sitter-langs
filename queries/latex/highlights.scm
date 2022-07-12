(line_comment) @comment

\\documentclass @variable.special
(class_include
  ((brack_group_key_value (key_value_pair) @function.special))
  ((curly_group_path (path) @string.special)))

\\usepackage @constructor
(package_include
  ((brack_group_key_value (key_value_pair) @function.special))?
  (curly_group_path_list (path) @function.call))
(package_include) @command

\\title @constructor
(title_declaration
  (curly_group (text (word) @title)))

(title_declaration
  (curly_group (text (word) @string.special)))

(generic_command
  (command_name) @keyword
  (brack_group (text) @function.call)?
  (curly_group (text) @function)?)

\\begin @keyword
\\end @keyword

((generic_environment
  (begin
    (curly_group_text
      (text (word) @function)))?
  (end
    (curly_group_text
	(text (word) @function)))?))
