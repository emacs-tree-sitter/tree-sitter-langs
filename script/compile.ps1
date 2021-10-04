$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName
$lang = $args[0]

Push-Location $project_root
try {
    if ($lang -eq "all") {
        emacs --batch `
          --directory "$project_root" `
          --load tree-sitter-langs-build `
          --eval "(tree-sitter-langs-create-bundle)"
    } else {
        emacs --batch `
          --directory "$project_root" `
          --load tree-sitter-langs-build `
          --eval "(tree-sitter-langs-compile '$lang)"
    }
} finally {
    Pop-Location
}
