;; Keywords

["catch"
 "class"
 "constexpr"
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
 "virtual"] @keyword

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

((namespace_identifier) @type
 (.match? @type "^[A-Za-z]"))

(namespace_definition (identifier) @type)

(auto) @type

;;; ----------------------------------------------------------------------------
;; Constants

(this) @variable.builtin
(nullptr) @constant
