$here = $PSScriptRoot
$project_root = (Get-Item $here).Parent.FullName

Push-Location $project_root
cask emacs --batch `
  -l ert `
  -l tree-sitter-langs-tests.el `
  -f ert-run-tests-batch-and-exit
Pop-Location
