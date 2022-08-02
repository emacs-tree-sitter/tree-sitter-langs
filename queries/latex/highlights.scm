(line_comment) @fixed
(line_comment) @comment

"\\\\documentclass" @variable.special
(class_include
  ((brack_group_key_value (key_value_pair) @function.call))
  ((curly_group_path (path) @function.special)))

"\\\\usepackage" @constructor
(package_include) @fixed
(package_include
  ((brack_group_key_value (key_value_pair) @function.special))?
  (curly_group_path_list (path) @function))

"\\\\title" @constructor
"\\\\title" @fixed
(title_declaration
  (brack_group (text) @subtitle)?
  (curly_group (text (word) @title)))

"\\\\author" @keyword
"\\\\author" @fixed
(author_declaration
  (curly_group_author_list (author) @info))
(author_declaration
  (curly_group_author_list (author) @function))

(title_declaration
  (curly_group (text (word) @string.special)))

(generic_command
  (command_name) @keyword
  (brack_group (text) @function.call)?
  (curly_group (text) @function)?)

"\\\\begin" @keyword
"\\\\end" @keyword

(generic_environment
  (begin
    (curly_group_text
      (text (word) @function)))?
  (end
    (curly_group_text
	(text (word) @function)))?)

(listing_environment) @fixed
(listing_environment
  (begin
    (curly_group_text
      (text (word) @function)))?
  (end
    (curly_group_text
	(text (word) @function)))?)

(displayed_equation) @fixed

"\\\\item" @keyword
"\\\\item" @fixed

"\\\\section" @keyword
"\\\\section" @fixed
(section
  (curly_group (text) @level-1))
(section
  (curly_group (text) @function))

"\\\\subsection" @keyword
"\\\\subsection" @fixed
(subsection
  (curly_group (text) @level-2))
(subsection
  (curly_group (text) @function))

"\\\\subsubsection" @keyword
"\\\\subsubsection" @fixed
(subsubsection
  (curly_group (text) @level-3))
(subsubsection
  (curly_group (text) @function))

"\\\\paragraph" @keyword
"\\\\paragraph" @fixed
(paragraph
  (curly_group (text) @level-4))
(paragraph
  (curly_group (text) @function))

"\\\\bibliography" @keyword
"\\\\bibliography" @fixed
(bibtex_include
  (curly_group_path (path) @fixed))
(bibtex_include
  (curly_group_path (path) @function))
