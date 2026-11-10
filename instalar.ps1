# Instala o actualiza las skills del framework en ~/.claude/skills.
# Solo reemplaza las carpetas de skills de este repo; no toca otras skills.
# Uso: .\instalar.ps1

$ErrorActionPreference = 'Stop'

$origen  = Join-Path $PSScriptRoot 'skills'
$destino = Join-Path $HOME '.claude\skills'

if (-not (Test-Path $origen)) { throw "No se encontro la carpeta de skills: $origen" }
New-Item -ItemType Directory -Force -Path $destino | Out-Null

Get-ChildItem -Path $origen -Directory | ForEach-Object {
    $dest = Join-Path $destino $_.Name
    if (Test-Path $dest) { Remove-Item -Path $dest -Recurse -Force -Confirm:$false }
    Copy-Item -Path $_.FullName -Destination $dest -Recurse
    Write-Host "  OK  $($_.Name)"
}

Write-Host ""
Write-Host "Framework instalado en $destino"
Write-Host "Si Claude Code estaba abierto, reinicia la sesion para tomar los cambios."
