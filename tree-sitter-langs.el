;;; tree-sitter-langs.el --- Grammar bundle for tree-sitter -*- lexical-binding: t; coding: utf-8 -*-

;; Copyright (C) 2021 Tuấn-Anh Nguyễn
;;
;; Author: Tuấn-Anh Nguyễn <ubolonton@gmail.com>
;; Keywords: languages tools parsers tree-sitter
;; Homepage: https://github.com/emacs-tree-sitter/tree-sitter-langs
;; Version: 0.12.163
;; Package-Requires: ((emacs "25.1") (tree-sitter "0.15.0"))
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; This is a convenient language bundle for the Emacs package `tree-sitter'. It
;; serves as an interim distribution mechanism, until `tree-sitter' is
;; widespread enough for language-specific major modes to incorporate its
;; functionalities.
;;
;; For each supported language, this package provides:
;;
;; 1. Pre-compiled grammar binaries for 3 major platforms: macOS, Linux and
;;    Windows, on x86_64. In the future, `tree-sitter-langs' may provide tooling
;;    for major modes to do this on their own.
;;
;; 2. Optional highlighting patterns. This is mainly intended for major modes
;;    that are not aware of `tree-sitter'. A language major mode that wants to
;;    use `tree-sitter' for syntax highlighting should instead provide the query
;;    patterns on its own, using the mechanisms defined by `tree-sitter-hl'.
;;
;; 3. Optional query patterns for other minor modes that provide high-level
;;    functionalities on top of `tree-sitter', such as code folding, evil text
;;    objects... As with highlighting patterns, major modes that are directly
;;    aware of `tree-sitter' should provide the query patterns on their own.


;;; Code:

(require 'cl-lib)

(require 'tree-sitter)
(require 'tree-sitter-load)
(require 'tree-sitter-hl)

(require 'tree-sitter-langs-build)

(eval-when-compile
  (require 'pcase))

;; Not everyone uses a package manager that properly checks dependencies. We check it ourselves, and
;; ask users to upgrade `tree-sitter' if necessary. Otherwise, they would get `tsc-lang-abi-too-new'
;; errors, without an actionable message.
(let ((min-version "0.15.0"))
  (when (version< tsc-dyn--version min-version)
    (display-warning 'tree-sitter-langs
                     (format "Please upgrade `tree-sitter'. This bundle requires version %s or later." min-version)
                     :emergency)))

(defgroup tree-sitter-langs nil
  "Grammar bundle for `tree-sitter'."
  :group 'tree-sitter)

(defvar tree-sitter-langs--testing)
(eval-and-compile
  (unless (bound-and-true-p tree-sitter-langs--testing)
    (tree-sitter-langs-install-grammars :skip-if-installed)))

(defun tree-sitter-langs-ensure (lang-symbol)
  "Return the language object identified by LANG-SYMBOL.
If it cannot be loaded, this function tries to compile the grammar.

This function also tries to copy highlight query from the language repo, if it
exists.

See `tree-sitter-langs-repos'."
  (unwind-protect
      (condition-case nil
          (tree-sitter-require lang-symbol)
        (error
         (display-warning 'tree-sitter-langs
                          (format "Could not load grammar for `%s', trying to compile it"
                                  lang-symbol))
         (tree-sitter-langs-compile lang-symbol)
         (tree-sitter-require lang-symbol)))
    (tree-sitter-langs--copy-query lang-symbol)))

;;;###autoload
(defun tree-sitter-langs--init-load-path (&rest _args)
  "Add the directory containing compiled grammars to `tree-sitter-load-path'."
  (cl-pushnew (tree-sitter-langs--bin-dir) tree-sitter-load-path
              :test #'string-equal)
  (advice-remove 'tree-sitter-load #'tree-sitter-langs--init-load-path))

;;;###autoload
(advice-add 'tree-sitter-load :before #'tree-sitter-langs--init-load-path)

;;;###autoload
(defun tree-sitter-langs--init-major-mode-alist (&rest _args)
  "Link known major modes to languages provided by the bundle."
  (dolist
      (entry (reverse
              '((actionscript-mode      . actionscript)
                (ada-mode               . ada)
                (agda-mode              . agda)
                (agda2-mode             . agda)
                (arduino-mode           . arduino)
                (astro-mode             . astro)
                (fish-mode              . fish)
                (asm-mode               . asm)
                (fasm-mode              . asm)
                (masm-mode              . asm)
                (nasm-mode              . asm)
                (gas-mode               . asm)
                (sh-mode                . bash)
                (beancount-mode         . beancount)
                (bibtex-mode            . bibtex)
                (c-mode                 . c)
                (caml-mode              . ocaml)
                (clojure-mode           . clojure)
                (lisp-mode              . commonlisp)
                (lisp-interaction-mode  . commonlisp)
                (csharp-mode            . c-sharp)
                (c++-mode               . cpp)
                (cmake-mode             . cmake)
                (d-mode                 . d)
                (dart-mode              . dart)
                (dockerfile-mode        . dockerfile)
                (css-mode               . css)
                (csv-mode               . csv)
                (elm-mode               . elm)
                (elixir-mode            . elixir)
                (emacs-lisp-mode        . elisp)
                (erlang-mode            . erlang)
                (ess-r-mode             . r)
                (fennel-mode            . fennel)
                (f90-mode               . fortran)
                (fortran-mode           . fortran)
                (gdscript-mode          . gdscript)
                (git-commit-mode        . gitcommit)
                (git-rebase-mode        . git-rebase)
                (gitattributes-mode     . gitattributes)
                (gitignore-mode         . gitignore)
                (gleam-mode             . gleam)
                (glsl-mode              . glsl)
                (go-mode                . go)
                (groovy-mode            . groovy)
                (jenkinsfile-mode       . groovy)
                (haskell-mode           . haskell)
                (haxe-mode              . haxe)
                (hcl-mode               . hcl)
                (terraform-mode         . hcl)
                (heex-mode              . heex)
                (hlsl-mode              . hlsl)
                (html-mode              . html)
                (markdown-mode          . markdown)
                (mhtml-mode             . html)
                (nix-mode               . nix)
                (jai-mode               . jai)
                (java-mode              . java)
                (javascript-mode        . javascript)
                (js-mode                . javascript)
                (js2-mode               . javascript)
                (js3-mode               . javascript)
                (json-mode              . json)
                (jsonc-mode             . json)
                (jsonnet-mode           . jsonnet)
                (julia-mode             . julia)
                (kotlin-mode            . kotlin)
                (latex-mode             . latex)
                (llvm-mode              . llvm)
                (llvm-mir-mode          . llvm-mir)
                (lua-mode               . lua)
                (magik-mode             . magik)
                (makefile-mode          . make)
                (makefile-automake-mode . make)
                (makefile-gmake-mode    . make)
                (makefile-makepp-mode   . make)
                (makefile-bsdmake-mode  . make)
                (makefile-imake-mode    . make)
                (matlab-mode            . matlab)
                (mermaid-mode           . mermaid)
                (meson-mode             . meson)
                (ninja-mode             . ninja)
                (noir-mode              . noir)
                (ocaml-mode             . ocaml)
                (org-mode               . org)
                (pascal-mode            . pascal)
                (perl-mode              . perl)
                (cperl-mode             . perl)
                (php-mode               . php)
                (qss-mode               . css)
                (prisma-mode            . prisma)
                (python-mode            . python)
                (pygn-mode              . pgn)
                (racket-mode            . racket)
                (rjsx-mode              . javascript)
                (rst-mode               . rst)
                (ruby-mode              . ruby)
                (rust-mode              . rust)
                (rustic-mode            . rust)
                (scala-mode             . scala)
                (scheme-mode            . scheme)
                (solidity-mode          . solidity)
                (smithy-mode            . smithy)
                (sql-mode               . sql)
                (svelte-mode            . svelte)
                (swift-mode             . swift)
                (tablegen-mode          . tablegen)
                (toml-mode              . toml)
                (conf-toml-mode         . toml)
                (tcl-mode               . tcl)
                (tuareg-mode            . ocaml)
                (twig-mode              . twig)
                (typescript-mode        . typescript)
                (typescript-tsx-mode    . tsx)
                (typst-mode             . typst)
                (verilog-mode           . verilog)
                (vhdl-mode              . vhdl)
                (nxml-mode              . xml)
                (yaml-mode              . yaml)
                (k8s-mode               . yaml)
                (zig-mode               . zig))))
    (cl-pushnew entry tree-sitter-major-mode-language-alist
                :key #'car))
  (advice-remove 'tree-sitter--setup #'tree-sitter-langs--init-major-mode-alist))

;;;###autoload
(advice-add 'tree-sitter--setup :before #'tree-sitter-langs--init-major-mode-alist)
;;; Normal load.
(tree-sitter-langs--init-major-mode-alist)

(defun tree-sitter-langs--hl-query-path (lang-symbol &optional mode)
  "Return the highlighting query file for LANG-SYMBOL.
If MODE is non-nil, return the file containing additional MODE-specfic patterns
instead. An example is `terraform-mode'-specific highlighting patterns for HCL."
  (concat (file-name-as-directory
           (concat tree-sitter-langs--queries-dir
                   (symbol-name lang-symbol)))
          (if mode
              (format "highlights.%s.scm" mode)
            "highlights.scm")))

(defun tree-sitter-langs--hl-default-patterns (lang-symbol &optional mode)
  "Return the bundled default syntax highlighting patterns for LANG-SYMBOL.
Return nil if there are no bundled patterns."
  (condition-case nil
      (with-temp-buffer
        ;; TODO: Make this less ad-hoc.
        (dolist (sym (cons lang-symbol
                           (pcase lang-symbol
                             ('arduino    '(cpp c))
                             ('astro      '(html))
                             ('cpp        '(c))
                             ('csv        '(tsv))
                             ('hlsl       '(cpp c))
                             ('typescript '(javascript))
                             ('tsx        '(typescript javascript))
                             (_           nil))))
          (when mode
            (ignore-error 'file-missing
              (insert-file-contents (tree-sitter-langs--hl-query-path sym mode))
              (goto-char (point-max))
              (insert "\n")))
          (insert-file-contents (tree-sitter-langs--hl-query-path sym))
          (goto-char (point-max))
          (insert "\n"))
        (buffer-string))
    (file-missing nil)))

;;;###autoload
(defun tree-sitter-langs--set-hl-default-patterns (&rest _args)
  "Use syntax highlighting patterns provided by `tree-sitter-langs'."
  (unless tree-sitter-hl-default-patterns
    (let ((lang-symbol (tsc--lang-symbol tree-sitter-language)))
      (setq tree-sitter-hl-default-patterns
            (tree-sitter-langs--hl-default-patterns lang-symbol major-mode)))))

;;;###autoload
(advice-add 'tree-sitter-hl--setup :before
            #'tree-sitter-langs--set-hl-default-patterns)

(provide 'tree-sitter-langs)
;;; tree-sitter-langs.el ends here
