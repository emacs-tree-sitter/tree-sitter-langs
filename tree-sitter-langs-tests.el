;;; tree-sitter-langs-tests.el --- Tests for tree-sitter-langs.el -*- lexical-binding: t; coding: utf-8 -*-

;; Copyright (C) 2021  Tuấn-Anh Nguyễn
;;
;; Author: Tuấn-Anh Nguyễn <ubolonton@gmail.com>

;;; Commentary:

;; Tests for `tree-sitter-langs'.

;;; Code:

(require 'tree-sitter-langs)
(require 'tree-sitter-langs-build)

(require 'ert)
(require 'seq)

(eval-when-compile
  (require 'subr-x))

(defun tree-sitter-langs-tests-check-queries (lang-symbol)
  (let ((language (tree-sitter-require lang-symbol))
        (patterns (tree-sitter-langs--hl-default-patterns lang-symbol)))
    (tsc-make-query language patterns)))

;;; Tests which verify that the highlight query patterns are valid.
(let ((default-directory tree-sitter-langs--queries-dir))
  (seq-doseq (lang-name (directory-files default-directory))
    (when (file-exists-p (format "%s/highlights.scm" lang-name))
      (let ((test-symbol (intern (format "queries/%s" lang-name)))
            (lang-symbol (intern lang-name)))
        (eval
         `(ert-deftest ,test-symbol ()
            (tree-sitter-langs-tests-check-queries (quote ,lang-symbol))))))))

(tree-sitter-langs--map-repos
 (lambda (lang-name)
   (let ((test-symbol (intern (format "lang/%s" lang-name)))
         (lang-symbol (intern lang-name)))
     (eval
      `(ert-deftest ,test-symbol ()
         (tree-sitter-require (quote ,lang-symbol)))))))

;; Local Variables:
;; no-byte-compile: t
;; End:

(provide 'tree-sitter-langs-tests)
;;; tree-sitter-langs-tests.el ends here
