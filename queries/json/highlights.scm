[(null) (true) (false)] @constant

(pair
 ;; @constant is better, but we stick to json-mode's conventions.
  key: (_) @keyword)

(number) @number

["{" "}" "[" "]"] @punctuation.bracket

(escape_sequence) @escape

(string) @string
