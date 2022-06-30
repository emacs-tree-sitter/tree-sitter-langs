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
  ;; tree-sitter-hl-face:keyword -> "font-lock-keyword-face"
  (while (string-match-p "^tree-sitter-hl-face:" (symbol-name face))
    (let ((parent (face-attribute face :inherit)))
      (setq face
            (cond
             ((symbolp parent)
              parent)
             ((consp parent)
              (nth 1 parent))))))         ; TODO better solution?
  (symbol-name face))

(defun treesit-langs-transform-form-at-point (fn)
  "Bind sexp at point to VAR-NAME and replace it with the evaluation of BODY.
Leave point after the evaluation of BODY in the buffer.

Example: (| specifies point) say you have
|(a b c)
Run (treesit-langs-transform-form-at-point #'reverse), now you have
(c b a)|"
  (let* ((beg (point))
         (form (read (current-buffer)))
         (end (point))
         (evaluation (funcall fn form)))
    (delete-region beg end)
    (goto-char beg)
    (insert (replace-regexp-in-string "\\\\\\." "."
                                      (prin1-to-string evaluation)))))
(defun treesit-langs--convert-highlights (patterns)
  "Convert PATTERNS (a query string compatible with
elisp-tree-sitter) to a query string compatible with treesit."
  (with-temp-buffer
    (insert patterns)
    (goto-char (point-min))
    ;; remove comments
    (while (re-search-forward ";;.*" nil t)
      (replace-match ""))
    (goto-char (point-min))
    ;; treesit needs captures to be actual faces
    (while (re-search-forward "@\\([a-z.-]+\\)" nil t)
      (replace-match
       (concat "@"
               (treesit-langs--convert-tree-sitter-hl-face
                (intern
                 (concat "tree-sitter-hl-face:" (match-string 1)))))))
    (goto-char (point-min))
    ;; .match? becomes #match and needs its arguments swapped
    (while (re-search-forward "[.#]match\\??" nil t)
      (replace-match "#match")
      ;; delete @capture and re-add it right after the regex
      (let (capture)
        (save-excursion
          (re-search-forward "@[a-z.-]+")
          (setq capture (match-string 0))
          (replace-match ""))
        (end-of-line)
        (backward-char 2)
        (insert " " capture)))
    (goto-char (point-min))
    ;; replace #eq? with #equal
    (while (re-search-forward "[.#]eq\\??" nil t)
      (replace-match "#equal"))
    ;; replace #any-of? with calculated regex
    (while (re-search-forward "[.#]any-of\\??" nil t)
      (replace-match ".any-of?") ; `read' can't deal with "#"
      (goto-char (1- (match-beginning 0))) ; before paren
      (treesit-langs-transform-form-at-point
          (lambda (form)
            (cl-destructuring-bind (_ capture . options) form
              `(.match "AOAO" ;; ,(regexp-opt options)
                ,capture)))))
    (buffer-substring (point-min) (point-max))))

(defvar-local treesit-langs-current-patterns nil
  "Loaded query patterns for current buffer.")

;;;###autoload
(define-minor-mode treesit-langs-hl-mode
  "Minor mode to enable syntax highlighting via `treesit'."
  :init-value nil
  :group 'treesit
  (if treesit-langs-hl-mode
      (progn
        (let ((lang-symbol
               (alist-get major-mode tree-sitter-major-mode-language-alist)))
          (unless (and (treesit-should-enable-p)
                       (treesit-language-available-p lang-symbol))
            (error "Tree sitter isn't available"))

          (treesit-parser-create lang-symbol)
          (setq treesit-langs-current-patterns
                `((,lang-symbol
                   ,(treesit-langs--convert-highlights
                     (or (tree-sitter-langs--hl-default-patterns lang-symbol)
                         (error "No query patterns for %s" lang-symbol)))))))

        (setq-local indent-line-function #'treesit-indent)
        ;; (setq-local treesit-defun-query "")

        (tree-sitter-hl--minimize-font-lock-keywords)
        ;; This needs to be non-nil, because reasons
        (unless font-lock-defaults
          (setq font-lock-defaults '(nil t)))

        (setq-local treesit-font-lock-defaults
                    '((treesit-langs-current-patterns)))
        (treesit-font-lock-enable)
        ;; make font-lock refontify buffer, as this is a minor mode
        (font-lock-mode -1)
        (font-lock-mode +1))
    (tree-sitter-hl--restore-font-lock-keywords)))

(provide 'treesit-langs)
;;; treesit-langs.el ends here
