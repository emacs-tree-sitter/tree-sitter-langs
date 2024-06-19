(line_comment) @comment @spell

[
 (container_doc_comment)
 (doc_comment)
 ] @doc @spell

;; [
;;  variable: (IDENTIFIER)
;;            variable_type_function: (IDENTIFIER)
;;            ] @variable

parameter: (IDENTIFIER) @parameter

[
 field_member: (IDENTIFIER)
               field_access: (IDENTIFIER)
               ] @field

;; assume TitleCase is a type
(
 [
  variable_type_function: (IDENTIFIER)
                          field_access: (IDENTIFIER)
                          parameter: (IDENTIFIER)
                          ] @type
                            (#match? @type "^[A-Z]+([a-z]+[A-Za-z0-9]*)*$")
                            )

;; assume camelCase is a function
(
 [
  variable_type_function: (IDENTIFIER)
                          field_access: (IDENTIFIER)
                          parameter: (IDENTIFIER)
                          ] @function
                            (#match? @function "^[a-z]+([A-Z]+[a-z0-9]*)+$")
                            )

;; assume all CAPS_1 is a constant
(
 [
  variable_type_function: (IDENTIFIER)
                          field_access: (IDENTIFIER)
                          ] @constant
                            (#match? @constant "^[A-Z]+[A-Z_0-9]+$")
                            )

function: (IDENTIFIER) @function

function_call: (IDENTIFIER) @function.call

exception: "!" @punctuation

((IDENTIFIER) @variable.builtin
 (#eq? @variable.builtin "_"))

(PtrTypeStart "c" @variable.builtin)

((ContainerDeclType
  [
   (ErrorUnionExpr)
   "enum"
   ])
 (ContainerField (IDENTIFIER) @constant))

field_constant: (IDENTIFIER) @constant

(BUILTINIDENTIFIER) @function.builtin

((BUILTINIDENTIFIER) @include
 (#any-of? @include "@import" "@cImport"))

(INTEGER) @number
(FLOAT) @number

[
 "true"
 "false"
 ] @boolean

[
 (LINESTRING)
 (STRINGLITERALSINGLE)
 ] @string @spell

(CHAR_LITERAL) @string
(EscapeSequence) @string.escape
(FormatSequence) @string.special

(BreakLabel (IDENTIFIER) @label)
(BlockLabel (IDENTIFIER) @label)

[
 "asm"
 "defer"
 "errdefer"
 "test"
 "struct"
 "union"
 "enum"
 "opaque"
 "error"
 ] @keyword

[
 "async"
 "await"
 "suspend"
 "nosuspend"
 "resume"
 ] @keyword

[
 "fn"
 ] @keyword

[
 "and"
 "or"
 "orelse"
 ] @keyword

[
 "return"
 ] @keyword

[
 "if"
 "else"
 "switch"
 ] @conditional

[
 "for"
 "while"
 "break"
 "continue"
 ] @repeat

[
 "usingnamespace"
 ] @include

[
 "try"
 "catch"
 ] @exception

[
 "anytype"
 (BuildinTypeExpr)
 ] @keyword

[
 "const"
 "var"
 "volatile"
 "allowzero"
 "noalias"
 ] @keyword

[
 "addrspace"
 "align"
 "callconv"
 "linksection"
 ] @keyword

[
 "comptime"
 "export"
 "extern"
 "inline"
 "noinline"
 "packed"
 "pub"
 "threadlocal"
 ] @keyword

[
 "null"
 "unreachable"
 "undefined"
 ] @constant.builtin

[
 (CompareOp)
 (BitwiseOp)
 (BitShiftOp)
 (AdditionOp)
 (AssignOp)
 (MultiplyOp)
 (PrefixOp)
 "*"
 "**"
 "->"
 ".?"
 ".*"
 "?"
 ] @operator

[
 ";"
 "."
 ","
 ":"
 ] @punctuation.delimiter

[
 ".."
 "..."
 ] @punctuation.special

[
 "["
 "]"
 "("
 ")"
 "{"
 "}"
 (Payload "|")
 (PtrPayload "|")
 (PtrIndexPayload "|")
 ] @punctuation.bracket

;; Error
(ERROR) @error
