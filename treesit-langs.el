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


(defun treesit-langs--reformat-shared-objects (&rest _args)
  "tree-sitter-langs saves grammars as LANG.so, but treesit needs libtree-sitter-LANG.so"
  (dolist (file (directory-files (tree-sitter-langs--bin-dir) 'full
                                 (concat "\\" (car tree-sitter-load-suffixes) "$")))
    ;; make symlink libtree-sitter-c.so -> c.so
    (make-symbolic-link file
                        (concat (file-name-as-directory (file-name-directory file))
                                "libtree-sitter-"
                                (file-name-nondirectory file)))))

(unless (file-exists-p (concat (tree-sitter-langs--bin-dir)
                               "libtree-sitter-c"
                               (car tree-sitter-load-suffixes)))
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

(defun treesit-langs--convert-highlights (patterns)
  "Convert PATTERNS (a query string compatible with
elisp-tree-sitter) to a query string compatible with treesit."
  (with-temp-buffer
    (insert patterns)
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
    (while (search-forward ".match?" nil t)
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
    ;; TODO might need a thing for .equal? too, but no query file contains
    ;; .equal? yet
    (buffer-substring (point-min) (point-max))))

(defvar-local treesit-langs-current-patterns nil
  "Loaded query patterns for current buffer.")

(define-minor-mode treesit-langs-hl-mode
  "TODO"
  :init-value nil
  :group 'treesit
  (if treesit-langs-hl-mode
      (progn
        (let ((lang-symbol
               (alist-get major-mode tree-sitter-major-mode-language-alist)))
          (unless (and (treesit-should-enable-p)
                       (treesit-language-available-p lang-symbol))
            (error "Tree sitter isn't available"))

          (treesit-get-parser-create lang-symbol)
          (setq treesit-langs-current-patterns
                `((,lang-symbol
                   ,(treesit-langs--convert-highlights
                     (tree-sitter-langs--hl-default-patterns lang-symbol))))))

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
