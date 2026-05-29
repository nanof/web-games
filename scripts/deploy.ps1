#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$RepoName = "web-games"
$Root = Split-Path -Parent $PSScriptRoot

Set-Location $Root

Write-Host "Comprobando autenticacion de GitHub..."
gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "No estas autenticado. Ejecuta: gh auth login"
    Write-Host "Luego vuelve a ejecutar: .\scripts\deploy.ps1"
    exit 1
}

$owner = (gh api user --jq .login)
Write-Host "Usuario: $owner"

$hasOrigin = @(git remote) -contains "origin"
if (-not $hasOrigin) {
    Write-Host "Creando repositorio $RepoName en GitHub..."
    gh repo create $RepoName --public --source=. --remote=origin --description "Portal de juegos HTML5"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host "Subiendo cambios a main..."
$prevEap = $ErrorActionPreference
$ErrorActionPreference = "Continue"
git push -u origin main 2>&1 | ForEach-Object { Write-Host $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Comprobando GitHub Pages..."
$pagesExists = $false
try {
    gh api "/repos/$owner/$RepoName/pages" 2>$null | Out-Null
    $pagesExists = ($LASTEXITCODE -eq 0)
} catch {
    $pagesExists = $false
}

if ($pagesExists) {
    Write-Host "GitHub Pages ya esta activo."
} else {
    Write-Host "Activando GitHub Pages..."
    gh api -X POST "/repos/$owner/$RepoName/pages" `
        -f "source[branch]=main" `
        -f "source[path]=/" 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        gh api -X PUT "/repos/$owner/$RepoName/pages" `
            -f "source[branch]=main" `
            -f "source[path]=/" 2>$null | Out-Null
    }
}
$ErrorActionPreference = $prevEap

$pagesUrl = "https://$owner.github.io/$RepoName/"
Write-Host ""
Write-Host "Listo. Tu sitio esta en:"
Write-Host $pagesUrl
Write-Host ""
Write-Host "Repositorio: https://github.com/$owner/$RepoName"
Write-Host ""
Write-Host "Si ves 'credential-manager-core is not a git command', ejecuta una vez:"
Write-Host "  gh auth setup-git"
