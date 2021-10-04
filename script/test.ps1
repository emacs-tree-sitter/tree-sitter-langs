$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName
$lang = $args[0]

if ("all",$null -contains $lang) {
    $selector = 'nil'
} else {
    $selector = "\`"/${lang}\`""
}

Push-Location $project_root
try {
    cask emacs --batch `
      -l ert `
      -l tree-sitter-langs-tests.el `
      --eval "(ert-run-tests-batch-and-exit ${selector})"
} finally {
    Pop-Location
}
