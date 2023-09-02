;;; tree-sitter-langs-build.el --- Building grammar bundle -*- lexical-binding: t; coding: utf-8 -*-

;; Copyright (C) 2021 Tuấn-Anh Nguyễn
;;
;; Author: Tuấn-Anh Nguyễn <ubolonton@gmail.com>
;; SPDX-License-Identifier: MIT

;;; Commentary:

;; This file contains utilities to obtain and build `tree-sitter' grammars.

;; TODO: Split this into 2 libraries: one for building, which is to be used only
;; within a git checkout, and another one for downloading.

;;; Code:

(require 'seq)
(require 'pp)
(require 'url)
(require 'tar-mode)

(eval-when-compile
  (require 'subr-x)
  (require 'pcase)
  (require 'cl-lib))

(declare-function dired-omit-mode "dired-x" (&optional arg))
(declare-function magit-get-current-tag "magit-git" (&optional rev with-distance))
(declare-function magit-rev-parse "magit-git" (&rest args))

(defconst tree-sitter-langs--dir
  (file-name-directory (locate-library "tree-sitter-langs.el"))
  "The directory where the library `tree-sitter-langs' is located.")

;; TODO: Separate build-time settings from run-time settings.
(defcustom tree-sitter-langs-grammar-dir tree-sitter-langs--dir
  "The root data directory of `tree-sitter-langs'.
The 'bin' directory under this directory is used to stored grammar
binaries (either downloaded, or compiled from source).

This should be set before the grammars are downloaded, e.g. before
`tree-sitter-langs' is loaded."
  :group 'tree-sitter-langs
  :type 'directory)

(defun tree-sitter-langs--bin-dir ()
  "Return the directory to stored grammar binaries.
This used for both compilation and downloading."
  (concat (file-name-as-directory tree-sitter-langs-grammar-dir) "bin/"))

;; ---------------------------------------------------------------------------
;;; Utilities.

(defvar tree-sitter-langs--out nil)

(defmacro tree-sitter-langs--with-temp-buffer (&rest body)
  "Execute BODY with `tree-sitter-langs--out' bound to the temporary buffer."
  (declare (indent 0))
  `(with-temp-buffer
     (let* ((tree-sitter-langs--out (current-buffer)))
       ,@body)))

;;; TODO: Use (maybe make) an async library, with a proper event loop, instead
;;; of busy-waiting.
(defun tree-sitter-langs--call (program &rest args)
  "Call PROGRAM with ARGS, using BUFFER as stdout+stderr.
If BUFFER is nil, `princ' is used to forward its stdout+stderr."
  (let* ((command `(,program . ,args))
         (_ (message "[tree-sitter-langs] Running %s in %s" command default-directory))
         (base `(:name ,program :command ,command))
         (output (if tree-sitter-langs--out
                     `(:buffer ,tree-sitter-langs--out)
                   `(:filter (lambda (proc string)
                               (princ string)))))
         (proc (let ((process-environment (cons (format "TREE_SITTER_DIR=%s"
                                                        tree-sitter-langs-grammar-dir)
                                                process-environment)))
                 (apply #'make-process (append base output))))
         (exit-code (progn
                      (while (not (memq (process-status proc)
                                        '(exit failed signal)))
                        (sleep-for 0.1))
                      (process-exit-status proc)))
         ;; Flush buffered output. Not doing this caused
         ;; `tree-sitter-langs-git-dir' to be set incorrectly, and
         ;; `tree-sitter-langs-create-bundle's output to be unordered.
         (_ (accept-process-output proc)))
    (unless (= exit-code 0)
      (error "Error calling %s, exit code is %s" command exit-code))))

(defun tree-sitter-langs--buffer (name)
  "Return a buffer from NAME, as the DESTINATION of `call-process'.
In batch mode, return nil, so that stdout is used instead."
  (unless noninteractive
    (let ((buf (get-buffer-create name)))
      (pop-to-buffer buf)
      (delete-region (point-min) (point-max))
      (redisplay)
      buf)))

;; ---------------------------------------------------------------------------
;;; Managing language submodules.

(declare-function straight--repos-dir "straight" (&rest segments))

(defcustom tree-sitter-langs-git-dir
  (if (featurep 'straight)
      (straight--repos-dir "tree-sitter-langs")
    (let* ((inhibit-message t)
           (truename (file-truename (file-name-as-directory tree-sitter-langs--dir)))
           (toplevel (ignore-errors
                       (file-truename
                        (file-name-as-directory
                         (tree-sitter-langs--with-temp-buffer
                           (let ((default-directory tree-sitter-langs--dir))
                             (tree-sitter-langs--call "git" "rev-parse" "--show-toplevel"))
                           (goto-char 1)
                           (buffer-substring-no-properties 1 (line-end-position))))))))
      (if (string= truename toplevel)
          (file-name-as-directory tree-sitter-langs--dir)
        (message "The directory %s doesn't seem to be a git working dir. Grammar-building functions will not work."
                 tree-sitter-langs--dir)
        nil)))
  "The git working directory of the repository `tree-sitter-langs'.
It needs to be set for grammar-building functionalities to work.

This is automatically set if you are using `straight.el', or are building from a
git checkout."
  :group 'tree-sitter-langs
  :type 'directory)

(defun tree-sitter-langs--repos-dir ()
  "Return the directory to store grammar repos, for compilation."
  (unless tree-sitter-langs-git-dir
    (user-error "Grammar-building functionalities require `tree-sitter-langs-git-dir' to be set"))
  (file-name-as-directory
   (concat tree-sitter-langs-git-dir "repos")))

(defun tree-sitter-langs--source (lang-symbol)
  "Return a plist describing the source of the grammar for LANG-SYMBOL."
  (let* ((default-directory tree-sitter-langs-git-dir)
         (name (symbol-name lang-symbol))
         (dir (concat (tree-sitter-langs--repos-dir) name))
         (sub-path (format "repos/%s" name)))
    (when (file-directory-p dir)
      (list
       :repo (tree-sitter-langs--with-temp-buffer
               (let ((inhibit-message t))
                 (tree-sitter-langs--call
                  "git" "config" "--file" ".gitmodules"
                  "--get" (format "submodule.%s.url" sub-path)))
               (goto-char 1)
               (buffer-substring-no-properties 1 (line-end-position)))
       :version (tree-sitter-langs--with-temp-buffer
                  (let ((inhibit-message t))
                    (tree-sitter-langs--call
                     "git" "submodule" "status" "--cached" sub-path))
                  (buffer-substring-no-properties 2 9))
       :paths (pcase lang-symbol
                ;; XXX
                ('typescript '("typescript" ("tsx" . tsx)))
                ('ocaml '("ocaml" ("interface" . ocaml-interface)))
                (_ '("")))))))

(defun tree-sitter-langs--repo-status (lang-symbol)
  "Return the git submodule status for LANG-SYMBOL."
  (tree-sitter-langs--with-temp-buffer
    (let ((default-directory tree-sitter-langs-git-dir)
          (inhibit-message t))
      (tree-sitter-langs--call
       "git" "submodule" "status" "--" (format "repos/%s" lang-symbol)))
    (pcase (char-after 1)
      (?- :uninitialized)
      (?+ :modified)
      (?U :conflicts)
      (?  :synchronized)
      (unknown-status unknown-status))))

(defun tree-sitter-langs--map-repos (fn)
  "Call FN in each of the language repositories."
  (let ((repos-dir (tree-sitter-langs--repos-dir)))
    (thread-last (directory-files repos-dir)
      (seq-map (lambda (name)
                 (unless (member name '("." ".."))
                   (let ((dir (concat repos-dir name)))
                     (when (file-directory-p dir)
                       `(,name . ,dir))))))
      (seq-filter #'identity)
      (seq-map (lambda (d)
                 (pcase-let ((`(,name . ,default-directory) d))
                   (funcall fn name)))))))

(defun tree-sitter-langs--update-repos ()
  "Update lang repos' remotes."
  (tree-sitter-langs--map-repos
   (lambda (_) (tree-sitter-langs--call "git" "remote" "update"))))

(defun tree-sitter-langs--get-latest (type)
  "Return the latest tags/commits of the language repositories.
TYPE should be either `:commits' or `:tags'. If there's no tag, return the
latest commit."
  (require 'magit)
  (tree-sitter-langs--map-repos
   (lambda (name)
     `(,name ,(pcase type
                (:commits (magit-rev-parse "--short=7" "origin/master"))
                (:tags (or (magit-get-current-tag "origin/master")
                           (magit-rev-parse "--short=7" "origin/master"))))))))

(defun tree-sitter-langs--changed-langs (&optional base)
  "Return languages that have changed since git revision BASE (as symbols)."
  (let* ((base (or base "origin/master"))
         (default-directory tree-sitter-langs-git-dir)
         (changed-files (thread-first
                            (format "git --no-pager diff --name-only %s" base)
                          shell-command-to-string
                          string-trim split-string))
         grammar-changed queries-changed)
    (dolist (file changed-files)
      (let ((segs (split-string file "/")))
        (pcase (car segs)
          ("repos" (cl-pushnew (intern (cadr segs)) grammar-changed))
          ("queries" (cl-pushnew (intern (cadr segs)) queries-changed)))))
    (cl-union grammar-changed queries-changed)))

;; ---------------------------------------------------------------------------
;;; Building language grammars.

(defconst tree-sitter-langs--bundle-version "0.12.36"
  "Version of the grammar bundle.
This should be bumped whenever a language submodule is updated, which should be
infrequent (grammar-only changes). It is different from the version of
`tree-sitter-langs', which can change frequently (when queries change).")

(defconst tree-sitter-langs--bundle-version-file "BUNDLE-VERSION")

(defconst tree-sitter-langs--os
  (pcase system-type
    ('darwin "macos")
    ('gnu/linux "linux")
    ('windows-nt "windows")
    (_ (error "Unsupported system-type %s" system-type))))

(defconst tree-sitter-langs--suffixes '(".dylib" ".dll" ".so")
  "List of suffixes for shared libraries that define tree-sitter languages.")

(defconst tree-sitter-langs--langs-with-deps
  '(cpp typescript toml)
  "Languages that depend on another, thus requiring 'npm install'.")

(defun tree-sitter-langs--bundle-file (&optional ext version os)
  "Return the grammar bundle file's name, with optional EXT.
If VERSION and OS are not spcified, use the defaults of
`tree-sitter-langs--bundle-version' and `tree-sitter-langs--os'."
  (setq os (or os tree-sitter-langs--os)
        version (or version tree-sitter-langs--bundle-version)
        ext (or ext ""))
  (if (version<= "0.10.13" version)
      (format "tree-sitter-grammars.%s.v%s.tar%s"
              ;; FIX: Implement this correctly, refactoring 'OS' -> 'platform'.
              (pcase os
                ("windows" "x86_64-pc-windows-msvc")
                ("linux" "x86_64-unknown-linux-gnu")
                ("macos" (if (string-prefix-p "aarch64" system-configuration)
                             "aarch64-apple-darwin"
                           "x86_64-apple-darwin")))
              version ext)
    (tree-sitter-langs--old-bundle-file
     ext version os)))

;; This is for compatibility with old downloading code. TODO: Remove it.
(defun tree-sitter-langs--old-bundle-file (&optional ext version os)
  (setq os (or os tree-sitter-langs--os)
        version (or version tree-sitter-langs--bundle-version)
        ext (or ext ""))
  (format "tree-sitter-grammars-%s-%s.tar%s"
          os version ext))

(defun tree-sitter-langs-compile (lang-symbol &optional clean target)
  "Download and compile the grammar for LANG-SYMBOL.
This function requires git and tree-sitter CLI.

If the optional arg CLEAN is non-nil, compile from the revision recorded in this
project (through git submodules), and clean up afterwards. Otherwise, compile
from the current state of the grammar repo, without cleanup."
  (message "[tree-sitter-langs] Processing %s" lang-symbol)
  (unless (executable-find "git")
    (error "Could not find git (needed to download grammars)"))
  (unless (executable-find "tree-sitter")
    (error "Could not find tree-sitter executable (needed to compile grammars)"))
  (setq target
        (pcase (format "%s" target)
          ;; Rust's triple -> system toolchain's triple
          ("aarch64-apple-darwin" "arm64-apple-macos11")
          ("nil" nil)
          (_ (error "Unsupported cross-compilation target %s" target))))
  (let* ((source (tree-sitter-langs--source lang-symbol))
         (dir (if source
                  (file-name-as-directory
                   (concat (tree-sitter-langs--repos-dir)
                           (symbol-name lang-symbol)))
                (error "Unknown language `%s'" lang-symbol)))
         (sub-path (format "repos/%s" lang-symbol))
         (status (tree-sitter-langs--repo-status lang-symbol))
         (paths (plist-get source :paths))
         (bin-dir (tree-sitter-langs--bin-dir))
         (tree-sitter-langs--out (tree-sitter-langs--buffer
                                  (format "*tree-sitter-langs-compile %s*" lang-symbol))))
    (let ((default-directory tree-sitter-langs-git-dir))
      (pcase status
        (:uninitialized
         (tree-sitter-langs--call "git" "submodule" "update" "--init" "--checkout" "--" sub-path))
        (:modified
         (when clean
           (let ((default-directory dir))
             (tree-sitter-langs--call "git" "stash" "push"))
           (tree-sitter-langs--call "git" "submodule" "update" "--init" "--checkout" "--force" "--" sub-path)))
        (:conflicts
         (error "Unresolved conflicts in %s" dir))
        (:synchronized nil)
        (_
         (error "Weird status from git-submodule '%s'" status))))
    (let ((default-directory dir))
      (when (member lang-symbol tree-sitter-langs--langs-with-deps)
        (tree-sitter-langs--call "npm" "set" "progress=false")
        (with-demoted-errors "Failed to run 'npm install': %s"
          (tree-sitter-langs--call "npm" "install")))
      ;; A repo can have multiple grammars (e.g. typescript + tsx).
      (dolist (path-spec paths)
        (let* ((path (or (car-safe path-spec) path-spec))
               (lang-symbol (or (cdr-safe path-spec) lang-symbol))
               (default-directory (file-name-as-directory (concat dir path))))
          (tree-sitter-langs--call "tree-sitter" "generate")
          (cond
           ((and (memq system-type '(gnu/linux))
                 (file-exists-p "src/scanner.cc"))
            ;; XXX: Modified from
            ;; https://github.com/tree-sitter/tree-sitter/blob/v0.20.0/cli/loader/src/lib.rs#L351
            (tree-sitter-langs--call
             "g++" "-shared" "-fPIC" "-fno-exceptions" "-g" "-O2"
             "-static-libgcc" "-static-libstdc++"
             "-I" "src"
             "src/scanner.cc" "-xc" "src/parser.c"
             "-o" (format "%sbin/%s.so" tree-sitter-langs-grammar-dir lang-symbol)))
           ;; XXX: This is a hack for cross compilation (mainly for Apple Silicon).
           (target (cond
                    ((file-exists-p "src/scanner.cc")
                     (tree-sitter-langs--call
                      "c++" "-shared" "-fPIC" "-fno-exceptions" "-g" "-O2"
                      "-I" "src"
                      "src/scanner.cc" "-xc" "src/parser.c"
                      "-o" (format "%sbin/%s.so" tree-sitter-langs-grammar-dir lang-symbol)
                      "-target" target))
                    ((file-exists-p "src/scanner.c")
                     (tree-sitter-langs--call
                      "cc" "-shared" "-fPIC" "-g" "-O2"
                      "-I" "src"
                      "src/scanner.c" "src/parser.c"
                      "-o" (format "%sbin/%s.so" tree-sitter-langs-grammar-dir lang-symbol)
                      "-target" target))
                    (:default
                     (tree-sitter-langs--call
                      "cc" "-shared" "-fPIC" "-g" "-O2"
                      "-I" "src"
                      "src/parser.c"
                      "-o" (format "%sbin/%s.so" tree-sitter-langs-grammar-dir lang-symbol)
                      "-target" target))))
           (:default (tree-sitter-langs--call "tree-sitter" "test")))))
      ;; Replace underscores with hyphens. Example: c_sharp.
      (let ((default-directory bin-dir))
        (dolist (file (directory-files default-directory))
          (when (and (string-match "_" file)
                     (cl-some (lambda (s) (string-suffix-p s file))
                              tree-sitter-langs--suffixes))
            (let ((new-name (replace-regexp-in-string "_" "-" file)))
              (when (file-exists-p new-name)
                (delete-file new-name))
              (rename-file file new-name)))))
      ;; On macOS, rename .so => .dylib, because we will make a "universal"
      ;; bundle.
      (when (eq system-type 'darwin)
        ;; This renames existing ".so" files as well.
        (let ((default-directory bin-dir))
          (dolist (file (directory-files default-directory))
            (when (string-suffix-p ".so" file)
              (let ((new-name (concat (file-name-base file) ".dylib")))
                (when (file-exists-p new-name)
                  (delete-file new-name))
                (rename-file file new-name))))))
      (when clean
        (tree-sitter-langs--call "git" "reset" "--hard" "HEAD")
        (tree-sitter-langs--call "git" "clean" "-f")))))

(cl-defun tree-sitter-langs-create-bundle (&optional clean target)
  "Create a bundle of language grammars.
The bundle includes all languages tracked in git submodules.

If the optional arg CLEAN is non-nil, compile from the revisions recorded in
this project (through git submodules), and clean up afterwards. Otherwise,
compile from the current state of the grammar repos, without cleanup."
  (unless (executable-find "tar")
    (error "Could not find tar executable (needed to bundle compiled grammars)"))
  (let ((errors (thread-last
                    (tree-sitter-langs--map-repos
                     (lambda (name)
                       (message "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                       (let ((lang-symbol (intern name)))
                         (condition-case err
                             (tree-sitter-langs-compile lang-symbol clean target)
                           (error `[,lang-symbol ,err])))))
                  (seq-filter #'identity))))
    (message "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    (unwind-protect
        (let* ((tar-file (concat (file-name-as-directory
                                  (expand-file-name default-directory))
                                 (tree-sitter-langs--old-bundle-file) ".gz"))
               (default-directory (tree-sitter-langs--bin-dir))
               (tree-sitter-langs--out (tree-sitter-langs--buffer "*tree-sitter-langs-create-bundle*"))
               (files (cons tree-sitter-langs--bundle-version-file
                            (seq-filter (lambda (file)
                                          (when (seq-some (lambda (ext) (string-suffix-p ext file))
                                                          tree-sitter-langs--suffixes)
                                            file))
                                        (directory-files default-directory))))
               ;; Disk names in Windows can confuse tar, so we need this option. BSD
               ;; tar (macOS) doesn't have it, so we don't set it everywhere.
               ;; https://unix.stackexchange.com/questions/13377/tar/13381#13381.
               (tar-opts (pcase system-type
                           ('windows-nt '("--force-local")))))
          (with-temp-file tree-sitter-langs--bundle-version-file
            (let ((coding-system-for-write 'utf-8))
              (insert tree-sitter-langs--bundle-version)))
          (apply #'tree-sitter-langs--call "tar" "-zcvf" tar-file (append tar-opts files)))
      (when errors
        (message "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        (error "Could not compile grammars:\n%s" (pp-to-string errors))))))

(defun tree-sitter-langs-compile-changed-or-all (&optional base target)
  "Compile languages that have changed since git revision BASE.
If no language-specific change is detected, compile all languages."
  (let ((lang-symbols (tree-sitter-langs--changed-langs base))
        errors)
    (if (null lang-symbols)
        (progn
          (message "[tree-sitter-langs] Compiling all langs, since there's no change since %s" base)
          (tree-sitter-langs-create-bundle nil target))
      (message "[tree-sitter-langs] Compiling langs changed since %s: %s" base lang-symbols)
      (dolist (lang-symbol lang-symbols)
        (message "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        (condition-case err
            (tree-sitter-langs-compile lang-symbol nil target)
          (error (setq errors (append errors `([,lang-symbol ,err]))))))
      (when errors
        (message "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        (error "Could not compile grammars:\n%s" (pp-to-string errors))))))

;; ---------------------------------------------------------------------------
;;; Download and installation.

(defconst tree-sitter-langs--queries-dir
  (file-name-as-directory
   (concat tree-sitter-langs--dir "queries")))

(defun tree-sitter-langs--bundle-url (&optional version os)
  "Return the URL to download the grammar bundle.
If VERSION and OS are not specified, use the defaults of
`tree-sitter-langs--bundle-version' and `tree-sitter-langs--os'."
  (format "https://github.com/emacs-tree-sitter/tree-sitter-langs/releases/download/%s/%s"
          version
          (tree-sitter-langs--bundle-file ".gz" version os)))

;;;###autoload
(defun tree-sitter-langs-install-grammars (&optional skip-if-installed version os keep-bundle)
  "Download and install the specified VERSION of the language grammar bundle.
If VERSION or OS is not specified, use the default of
`tree-sitter-langs--bundle-version' and `tree-sitter-langs--os'.

This installs the grammar bundle even if the same version was already installed,
unless SKIP-IF-INSTALLED is non-nil.

The download bundle file is deleted after installation, unless KEEP-BUNDLE is
non-nil."
  (interactive (list
                nil
                (read-string "Bundle version: " tree-sitter-langs--bundle-version)
                tree-sitter-langs--os
                nil))
  (let* ((bin-dir (tree-sitter-langs--bin-dir))
         (_ (unless (unless (file-directory-p bin-dir)
                      (make-directory bin-dir))))
         (version (or version tree-sitter-langs--bundle-version))
         (default-directory bin-dir)
         (bundle-file (tree-sitter-langs--bundle-file ".gz" version os))
         (current-version (when (file-exists-p
                                 tree-sitter-langs--bundle-version-file)
                            (with-temp-buffer
                              (let ((coding-system-for-read 'utf-8))
                                (insert-file-contents
                                 tree-sitter-langs--bundle-version-file)
                                (string-trim (buffer-string)))))))
    (cl-block nil
      (if (string= version current-version)
          (if skip-if-installed
              (progn (message "tree-sitter-langs: Grammar bundle v%s was already installed; skipped" version)
                     (cl-return))
            (message "tree-sitter-langs: Grammar bundle v%s was already installed; reinstalling" version))
        (message "tree-sitter-langs: Installing grammar bundle v%s (was v%s)" version current-version))
      ;; FIX: Handle HTTP errors properly.
      (url-copy-file (tree-sitter-langs--bundle-url version os)
                     bundle-file 'ok-if-already-exists)
      (tree-sitter-langs--call "tar" "-xvzf" bundle-file)
      ;; FIX: This should be a metadata file in the bundle itself.
      (with-temp-file tree-sitter-langs--bundle-version-file
        (let ((coding-system-for-write 'utf-8))
          (insert version)))
      (unless keep-bundle
        (delete-file bundle-file 'trash))
      (when (and (called-interactively-p 'any)
                 (y-or-n-p (format "Show installed grammars in %s? " bin-dir)))
        (with-current-buffer (find-file bin-dir)
          (when (bound-and-true-p dired-omit-mode)
            (dired-omit-mode -1)))))))

(defun tree-sitter-langs--copy-query (lang-symbol &optional force)
  "Copy highlights.scm file of LANG-SYMBOL to `tree-sitter-langs--queries-dir'.
This assumes the repo has already been set up, for example by
`tree-sitter-langs-compile'.

If the optional arg FORCE is non-nil, any existing file will be overwritten."
  (let ((src (thread-first (tree-sitter-langs--repos-dir)
               (concat (symbol-name lang-symbol))
               file-name-as-directory (concat "queries")
               file-name-as-directory (concat "highlights.scm"))))
    (when (file-exists-p src)
      (let ((dst-dir  (file-name-as-directory
                       (concat tree-sitter-langs--queries-dir
                               (symbol-name lang-symbol)))))
        (unless (file-directory-p dst-dir)
          (make-directory dst-dir t))
        (let ((default-directory dst-dir))
          (if (file-exists-p "highlights.scm")
              (when force
                (copy-file src dst-dir :force))
            (message "Copying highlights.scm for %s" lang-symbol)
            (copy-file src dst-dir)))))))

(defun tree-sitter-langs--copy-queries ()
  "Copy highlights.scm files to `tree-sitter-langs--queries-dir'.
This assumes the repos have already been cloned set up, for example by
`tree-sitter-langs-create-bundle'."
  (tree-sitter-langs--map-repos
   (lambda (name)
     (tree-sitter-langs--copy-query (intern name) :force))))

(provide 'tree-sitter-langs-build)
;;; tree-sitter-langs-build.el ends here
