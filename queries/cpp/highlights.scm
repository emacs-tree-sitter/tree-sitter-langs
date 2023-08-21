;; Keywords

[
 "catch"
 "class"
 "co_await"
 "co_return"
 "co_yield"
 "constexpr"
 "constinit"
 "consteval"
 "delete"
 "explicit"
 "final"
 "friend"
 "mutable"
 "namespace"
 "noexcept"
 "new"
 "override"
 "private"
 "protected"
 "public"
 "template"
 "throw"
 "try"
 "typename"
 "using"
 "virtual"
 "concept"
 "requires"
] @keyword

;;; ----------------------------------------------------------------------------
;; Functions

(call_expression
 function: (qualified_identifier name: (_) @function.call))

(template_function
 name: [(identifier) @function.call
        (qualified_identifier name: (_) @function.call)])

(template_method
 name: (field_identifier) @method.call)

(function_declarator
 declarator: [(field_identifier) @function
              (qualified_identifier name: (_) @function)])

;;; ----------------------------------------------------------------------------
;; Types

(namespace_identifier) @namespace

((namespace_identifier) @type
 (.match? @type "^[A-Za-z]"))

(using_declaration . "using" . "namespace" . [(qualified_identifier) (identifier)] @namespace)

(auto) @type

;;; ----------------------------------------------------------------------------
;; Constants

(this) @variable.builtin
(null "nullptr" @constant)
