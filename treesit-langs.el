;;; treesit-langs.el --- TODO -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Yoav Marco
;;
;; Author: Yoav Marco <https://github.com/ymarco>
;; Maintainer: Yoav Marco <yoavm448@gmail.com>
;; Created: May 14, 2022
;; Modified: May 14, 2022
;; Version: 0.0.1
;; Keywords: languages tools parsers tree-sitter
;; Homepage: https://github.com/emacs-tree-sitter/tree-sitter-langs
;; Package-Requires: ((emacs "29.0.50"))
;; SPDX-License-Identifier: MIT
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  TODO
;;
;;; Code:

(require 'treesit)
(require 'tree-sitter-langs)


(defun treesit-langs--reformat-shared-objects ()
  "Make symlinks so *.so files are aliased to libtree-sitter-*.so in `tree-sitter-langs--bin-dir' .

Rationale: tree-sitter-langs saves grammars as LANG.so, but
treesit needs libtree-sitter-LANG.so."
  (dolist (file (directory-files (tree-sitter-langs--bin-dir) 'full
                                 (concat (regexp-opt (list module-file-suffix)) "$")))
    ;; make a symlink so that libtree-sitter-c.so points to c.so
    (make-symbolic-link file
                        (concat (file-name-as-directory (file-name-directory file))
                                "libtree-sitter-"
                                (file-name-nondirectory file)))))

;; don't make symlinks *again*, we don't want stuff like
;; libtree-sitterlibtree-sitter-c.so
(unless (directory-files (tree-sitter-langs--bin-dir) 'full
                         (concat
                          "libtree-sitter-c"
                          (regexp-opt (list module-file-suffix))))
  (treesit-langs--reformat-shared-objects))

(cl-pushnew (tree-sitter-langs--bin-dir) treesit-extra-load-path
            :test #'string-equal)

(defun treesit-langs--convert-tree-sitter-hl-face (face)
  "Return the face FACE inherits from, as a string.
e.g `tree-sitter-hl-face:keyword' -> \"font-lock-keyword-face\".

This is used in treesit-langs because we can't use faces with
colons as capture names, so we use their parent face."
  (while (string-match-p "^tree-sitter-hl-face:" (symbol-name face))
    (let ((parent (face-attribute face :inherit)))
      (setq face
            (cond
             ((symbolp parent)
              parent)
             ((consp parent)
              (nth 1 parent))))))       ; TODO better solution?
  (symbol-name face))

(defun treesit-langs--convert-highlights (patterns)
  "Convert PATTERNS (a query string compatible with
elisp-tree-sitter) to a query string compatible with treesit."
  (cl-labels ((transform
               (exp)
               (pcase-exhaustive exp
                 ;; .match has its args flipped
                 ((or `(.match?  ,capture ,regexp)
                      `(\#match? ,capture ,regexp))
                  `(.match ,(transform regexp) ,(transform capture)))
                 ;; .equal becomes .eq
                 ((or `(.eq?  ,a ,b)
                      `(\#eq? ,a ,b))
                  `(.equal ,(transform a) ,(transform b)))
                 ;; .any-of becomes .match with regexp-opt
                 ((or `(.any-of?  ,capture . ,options)
                      `(\#any-of? ,capture . ,options))
                  `(.match ,(regexp-opt options) ,(transform capture)))
                 ;; @capture => @parent face of tree-sitter-hl-face:capture
                 ((pred symbolp)
                  (let ((name (symbol-name exp)))
                    (if (string-prefix-p "@" name)
                        (intern
                         (concat
                          "@"
                          (treesit-langs--convert-tree-sitter-hl-face
                           (intern (concat "tree-sitter-hl-face:" (substring name 1))))))
                      exp)))
                 ;; handle other cases
                 ((pred listp)
                  (mapcar #'transform exp))
                 ((pred vectorp)
                  (apply #'vector (mapcar #'transform exp)))
                 ((pred stringp)
                  exp)))
              (prin1exp
               (exp)
               (let (print-level print-length)
                 (mapconcat #'prin1-to-string exp "\n"))))
    (thread-last
      patterns
      (format "(%s)")
      ;; `read' can't handle unescaped symbols that start with "#"
      (replace-regexp-in-string "(#" "(\\\\#")
      (read-from-string)
      (car)
      (transform)
      (prin1exp)
      ;; `prin1' likes to prefix symbols that start with . with a backslash,
      ;; but the tree-sitter query parser does diffrentiate.
      (replace-regexp-in-string (regexp-quote "\\.") "."))))

(defvar-local treesit-langs--current-treesit-settings nil
  "Font-lock settings for the current buffer.")

;;;###autoload
(define-minor-mode treesit-langs-hl-mode
  "Minor mode to enable syntax highlighting via `treesit'."
  :init-value nil
  :group 'treesit
  (if treesit-langs-hl-mode
      (progn
        (let ((lang-symbol
               (alist-get major-mode tree-sitter-major-mode-language-alist)))
          (unless (and (treesit-can-enable-p)
                       (treesit-language-available-p lang-symbol))
            (error "Tree sitter isn't available"))

          (treesit-parser-create lang-symbol)
          (setq treesit-langs--current-treesit-settings
                (treesit-font-lock-rules
                 :language lang-symbol
                 (treesit-langs--convert-highlights
                  (or (tree-sitter-langs--hl-default-patterns lang-symbol)
                      (error "No query patterns for %s" lang-symbol))))))

        (setq-local indent-line-function #'treesit-indent)
        ;; (setq-local treesit-defun-query "")

        (tree-sitter-hl--minimize-font-lock-keywords)
        ;; This needs to be non-nil, because reasons
        (unless font-lock-defaults
          (setq font-lock-defaults '(nil t)))

        (setq-local treesit-font-lock-settings
                    treesit-langs--current-treesit-settings)
        (treesit-font-lock-enable)
        ;; make font-lock refontify buffer, as this is a minor mode
        (font-lock-mode -1)
        (font-lock-mode +1))
    (tree-sitter-hl--restore-font-lock-keywords)))

(provide 'treesit-langs)
;;; treesit-langs.el ends here
