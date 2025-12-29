;; -*- mode: eask; lexical-binding: t -*-

(package "tree-sitter-langs"
         "0.13.0"
         "Grammar bundle for tree-sitter")

(website-url "https://github.com/emacs-tree-sitter/tree-sitter-langs")
(keywords "languages" "tools" "parsers" "tree-sitter")

(package-file "tree-sitter-langs.el")

(files "tree-sitter-langs.el"
       "tree-sitter-langs-build.el"
       ;; XXX: Figure out how to include only .scm files under a level of directories.
       "queries"
       "queries/*")

(script "test" "echo \"Error: no test specified\" && exit 1")

(source 'gnu)
(source 'melpa)

(depends-on "emacs" "26.1")
(depends-on "tree-sitter")

;; (depends-on "tsc"
;;             :fetcher 'github
;;             :repo "emacs-tree-sitter/elisp-tree-sitter"
;;             :files '("core/*.el"
;;                      "core/Cargo.toml"
;;                      "core/Cargo.lock"
;;                      "core/src"))
;; (depends-on "tree-sitter"
;;             :fetcher 'github
;;             :repo "emacs-tree-sitter/elisp-tree-sitter")

(setq network-security-level 'low)  ; see https://github.com/jcs090218/setup-emacs-windows/issues/156#issuecomment-932956432

;; Use GNU tar in Windows
(when (memq system-type '(cygwin windows-nt ms-dos))
  (setq package-build-tar-executable "C:/Program Files/Git/usr/bin/tar.exe"))
