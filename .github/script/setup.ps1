iex (New-Object net.webclient).downloadstring('https://get.scoop.sh')
Join-Path (Resolve-Path ~).Path "scoop\shims" >> $env:GITHUB_PATH
scoop bucket add extras
scoop bucket add nonportable
scoop update
scoop checkup

scoop install tar
