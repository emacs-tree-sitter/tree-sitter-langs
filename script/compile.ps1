$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName
$lang = $args[0]

if ($lang -eq "all") {
    Push-Location $project_root
    emacs --batch `
      --directory "$project_root" `
      --eval "
      (progn
        (require 'tree-sitter-langs-build)
        (tree-sitter-langs-create-bundle))"
    Pop-Location
} else {
    Push-Location $project_root
    emacs --batch `
      --directory "$project_root" `
      --eval "
      (progn
        (require 'tree-sitter-langs-build)
        (tree-sitter-langs-compile '$lang))"
    Pop-Location
}
