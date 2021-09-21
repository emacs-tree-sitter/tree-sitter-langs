;; data.aws_iam_policy_document.cluster_assume_role_policy.json
(expression
 ((variable_expr (identifier)) @keyword
  (.eq? @keyword "data"))
 . (get_attr (identifier) @type)
 . (get_attr (identifier) @function.call)
 . (get_attr (identifier) @property)?
 )

;; module.path
((expression
  ((variable_expr (identifier)) @keyword
   (.eq? @keyword "module"))
  . (get_attr) @type
  ))

((expression
  ((variable_expr (identifier)) @keyword
   (.match? @keyword "^(var|local|count|each|path)$"))
  . (get_attr)? @property
  ))

;; aws_iam_role.shared-sagemaker-execution.name
(expression
 (variable_expr (identifier)) @type
 . (get_attr) @function.call
 . (get_attr)? @property
 .)

;; TODO: Highlight `content'.
((block (identifier) @keyword
        [(string_lit (template_literal) @variable)])
 (.eq? @keyword "dynamic"))

;; ((block (identifier) @keyword
;;         [(string_lit (template_literal) @variable)]
;;         (body ((attribute (identifier) @keyword)
;;                (.eq? @keyword "for_each"))))
;;  (.eq? @keyword "dynamic"))

((block (identifier) @keyword
        . [(string_lit (template_literal) @function)
           (identifier) @function])
 (.eq? @keyword "output"))

((block (identifier) @keyword
        [(string_lit (template_literal) @variable.special)
         (identifier) @variable.special])
 (.eq? @keyword "variable"))

((block (identifier) @keyword
        [(string_lit (template_literal) @type)
         (identifier) @type])
 (.eq? @keyword "module"))

;; resource "aws_launch_template" "default"
(block (identifier)
       [(string_lit (template_literal) @type)
        (identifier) @type]
       . [(string_lit (template_literal) @function)
          (identifier) @function]
       . (block_start))

((block (identifier) @keyword)
 (.match? @keyword "(resource|data|output|locals|lifecycle)"))

((attribute (identifier) @keyword)
 (.match? @keyword "^(count|depends_on|for_each)$"))

(attribute (identifier) @variable)
(object_elem key: (_) @variable)

(block (identifier) @label . (block_start))
