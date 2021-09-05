$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName
$lang = $args[0]

Push-Location $project_root
try {
    if ($lang -eq "all") {
        emacs --batch `
          --directory "$project_root" `
          --eval "
          (progn
            (require 'tree-sitter-langs-build)
            (tree-sitter-langs-create-bundle))"
    } else {
        emacs --batch `
          --directory "$project_root" `
          --eval "
          (progn
            (require 'tree-sitter-langs-build)
            (tree-sitter-langs-compile '$lang))"
    }
} finally {
    Pop-Location
}
