$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName
$lang = $args[0]

Push-Location $project_root
try {
    switch ($lang) {
        'all' { $code = "(tree-sitter-langs-create-bundle)" }
        'changed' {
            $base = $args[1]
            if (!$base) {
                $base = "origin/master"
            }
            $code = "(tree-sitter-langs-compile-changed-or-all \`"$base\`")"
        }
        default { $code = "(tree-sitter-langs-compile '$lang)" }
    }
    emacs --batch `
      --directory "$project_root" `
      --load tree-sitter-langs-build `
      --eval "$code"
} finally {
    Pop-Location
}
