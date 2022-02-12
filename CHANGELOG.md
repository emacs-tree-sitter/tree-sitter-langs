# Changelog

## Unreleased

## 0.11.3 - 2022-02-12
- Added `zig` grammar.

## 0.11.2 - 2022-02-11
- Updated `python` grammar and highlighting (add support for pattern matching).

## 0.11.1 - 2022-02-06
- Updated `cpp` grammar and highlighting.

## 0.11.0 - 2022-01-29
- Made `tree-sitter-langs-install-grammars` download platform-specific binaries (mainly for Apple Silicon).

## 0.10.15 - 2022-01-27
- Added `haskell` grammar.

## 0.10.14 - 2022-01-05
- Added `prisma` grammar.

## 0.10.13 - 2021-12-13
- Modified CI pipelines to publish additional pre-built grammar bundles. Their filenames include the platform they are built for. The files without platform in their name will eventually be deprecated.
  + `tree-sitter-grammars.x86_64-apple-darwin.v<version>.tar.gz` (same as `tree-sitter-grammars-macos-<version>.tar.gz`)
  + `tree-sitter-grammars.x86_64-unknown-linux-gnu.v<version>.tar.gz` (same as `tree-sitter-grammars-linux-<version>.tar.gz`)
  + `tree-sitter-grammars.x86_64-pc-windows-msvc.v<version>.tar.gz` (same as `tree-sitter-grammars-windows-<version>.tar.gz`)
  + `tree-sitter-grammars.aarch64-apple-darwin.v<version>.tar.gz` (new, for Apple Silicon)

## 0.10.12 - 2021-12-13
- Added `nix` grammar.

## 0.10.11 - 2021-12-09
- Upgraded `java` parser to support change to switch_expression node

## 0.10.10 - 2021-12-06
- Updated `php` highlighting to support php8 changes
- Resolve bugs with `php` preventing `evil-textobj-tree-sitter` motions from working

## 0.10.9 - 2021-12-05
- Added `d` grammar.

## 0.10.8 - 2021-12-05
- Switched to the official `elixir` grammar from `elixir-lang`.

## 0.10.7 - 2021-09-18
- Added `elixir` grammar.

## 0.10.6 - 2021-09-18
- Improved highlighting of arrow function parameters in `javascript` and `typescript`.
- Improved general highlighting for `ruby`.
- Updated `python` grammar.

## 0.10.5 - 2021-08-15
- Upgraded `ocaml` and `pgn` grammars.
- Added hl query patterns for `json`, `ocaml`.
- Improved interpolation highlighting in `python`, `ruby`, `bash`.

## 0.10.2 - 2021-08-06
- Made Python variable highlighting for robust and consistent.
- Added `hcl` grammar and hl query patterns.

## 0.10.1 - 2021-08-01
- Added `pgn` grammar (chess's Portable Game Notation).

## 0.10.0 - 2021-03-14
- Updated most language grammars to the latest version.
- Upgraded `tree-sitter` CLI version to 0.19.3.

## 0.9.2 - 2021-02-12
- Added `janet-simple` grammars.
- Added minor updates to some other grammars.

## 0.9.1 - 2021-01-14
- Updated `c-sharp` grammar.

## 0.9.0 - 2020-12-16
- Updated `javascript` and `typescript` grammars.

## 0.8.0 - 2020-12-15
- Added `elm`.
- Handled underscores in language names correctly.  This enabled using `c-sharp` instead of `c_sharp`.

## 0.7.2 - 2020-10-03
- Set `tree-sitter-hl-default-patterns` to nil if there is no query file, instead of signaling an error.

## 0.7.1 - 2020-08-09
- Improved syntax highlighting for C/C++.

## 0.7.0 - 2020-07-20
- Replaced `#` with `.` in bundled highlighting queries' predicates.

## 0.6.0 - 2020-07-06
- Fixed the issue of `tree-sitter-langs` not being able to find grammars in gccemacs.
- Added `rustic-mode` to major mode mappings.
- Revamped syntax highlighting for JavaScript, TypeScript, C++.
- Improved syntax highlighting for Python, Rust.
- Improved regexp for `@constructor`.

## 0.5.0 - 2020-06-07
- Added syntax highlighting for Java.
- Improved syntax highlighting for CSS, Python.
- Removed Haskell grammar.

## 0.4.0 - 2020-05-03
- Removed grammar binaries from package file, letting them to be downloaded upon compilation instead.

## 0.2.0
- Updated grammars.
- Added highlighting queries.

## 0.1.0
Initial release
