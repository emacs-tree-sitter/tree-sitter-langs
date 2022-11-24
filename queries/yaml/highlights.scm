;; keys
(block_mapping_pair
 key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @variable))
(block_mapping_pair
 key: (flow_node (plain_scalar (string_scalar) @variable)))

;; keys within inline {} blocks
(flow_mapping
 (_ key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @variable)))
(flow_mapping
 (_ key: (flow_node (plain_scalar (string_scalar) @variable))))

["[" "]" "{" "}"] @punctuation.bracket
["," "-" ":" "?" ">" "|"] @punctuation.delimiter
["*" "&" "---" "..."] @punctuation.special

[(null_scalar) (boolean_scalar)] @constant.builtin
[(integer_scalar) (float_scalar)] @number
[(double_quote_scalar) (single_quote_scalar) (block_scalar)] @string
(escape_sequence) @escape

(comment) @comment
[(anchor_name) (alias_name)] @function
(yaml_directive) @type

(tag) @type
(tag_handle) @type
(tag_prefix) @string
(tag_directive) @property
