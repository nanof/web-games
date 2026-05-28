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

if (-not (git remote get-url origin 2>$null)) {
    Write-Host "Creando repositorio $RepoName en GitHub..."
    gh repo create $RepoName --public --source=. --remote=origin --description "Portal de juegos HTML5"
}

Write-Host "Subiendo cambios a main..."
git push -u origin main

Write-Host "Activando GitHub Pages..."
gh api -X POST "/repos/$owner/$RepoName/pages" `
    -f "source[branch]=main" `
    -f "source[path]=/" `
    2>$null

if ($LASTEXITCODE -ne 0) {
    gh api -X PUT "/repos/$owner/$RepoName/pages" `
        -f "source[branch]=main" `
        -f "source[path]=/" `
        2>$null
}

$pagesUrl = "https://$owner.github.io/$RepoName/"
Write-Host ""
Write-Host "Listo. Tu sitio estara disponible en unos minutos en:"
Write-Host $pagesUrl
Write-Host ""
Write-Host "Opcional: anade en games.json -> site.repo la URL del repo:"
Write-Host "https://github.com/$owner/$RepoName"
