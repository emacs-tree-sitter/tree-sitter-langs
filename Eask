(package "tree-sitter-langs"
         "0.12.18"
         "Grammar bundle for tree-sitter")

(website-url "https://github.com/emacs-tree-sitter/tree-sitter-langs")
(keywords "languages" "tools" "parsers" "tree-sitter")

(package-file "tree-sitter-langs.el")

(script "test" "echo \"Error: no test specified\" && exit 1")

(source 'melpa)

(files "tree-sitter-langs.el"
       "tree-sitter-langs-build.el"
       ;; XXX: Figure out how to include only .scm files under a level of directories.
       "queries"
       "queries/*")

(depends-on "emacs" "25.1")
(depends-on "tree-sitter")

(setq network-security-level 'low)  ; see https://github.com/jcs090218/setup-emacs-windows/issues/156#issuecomment-932956432

;; Use GNU tar in Windows
(when (memq system-type '(cygwin windows-nt ms-dos))
  (setq package-build-tar-executable "C:/Program Files/Git/usr/bin/tar.exe"))
