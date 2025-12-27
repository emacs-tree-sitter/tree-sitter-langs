[
  (section_header)
  (END)
  (LIST)
  (SET)
  (INCLUDE)
  (TEMPLATE)
] @keyword

[
  (ruletype)
  (ruletype_substitute_etc)
  (ruletype_parentchild)
  (ruletype_relation)
  (ruletype_relations)
  (ruletype_map_etc)
  (ruletype_addcohort)
  (ruletype_mergecohorts)
  (ruletype_move)
  (ruletype_switch)
  (ruletype_external)
] @keyword

[
  (IF)
  (TARGET)
  (TO)
  (FROM)
  (WITHCHILD)
  (NOCHILD)
  (BEFORE)
  (AFTER)
  (WITH)
  (ONCE)
  (ALWAYS)
  (context_modifier)
  (BARRIER)
  (LINK)
  (OR)
  (set_op)
  (ruleflag_name)
] @keyword

(eq) @operator

(semicolon) @punctuation.delimiter

(comment) @comment

(qtag) @string

(contextpos) @constant

(inlineset_single
  [
    "("
    ")"
  ] @punctuation.bracket)

(compotag
  [
    "("
    ")"
  ] @punctuation.bracket)

(taglist) @constant

((setname) @variable.parameter
  (.match? @variable.parameter "\\$\\$.*"))

(list
  (setname) @variable)

(set
  (setname) @variable)

[
  (special_list_name)
  (STATIC_SETS)
  (MAPPING_PREFIX)
  (SUBREADINGS)
  (PARENTHESES)
] @keyword
