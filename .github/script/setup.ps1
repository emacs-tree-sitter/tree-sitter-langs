# iex (New-Object net.webclient).downloadstring('https://get.scoop.sh')

# XXX: https://github.com/ScoopInstaller/Scoop/issues/4783#issuecomment-1061446902
# iwr -useb https://raw.githubusercontent.com/ScoopInstaller/Install/7bcdf996f0f4597ef69f4c48c219024a9512113c/install.ps1 | iex

# XXX: https://github.com/ScoopInstaller/Install#for-admin
iwr -useb https://get.scoop.sh -outfile 'install.ps1'
.\install.ps1 -RunAsAdmin

Join-Path (Resolve-Path ~).Path "scoop\shims" >> $env:GITHUB_PATH
scoop bucket add extras
scoop bucket add nonportable
scoop update
scoop checkup

scoop install tar
