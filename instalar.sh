#!/usr/bin/env bash
# Instala o actualiza las skills del framework en ~/.claude/skills (macOS / Linux / Git Bash).
# Solo reemplaza las carpetas de skills de este repo; no toca otras skills.
# Uso: ./instalar.sh
set -euo pipefail

origen="$(cd "$(dirname "$0")" && pwd)/skills"
destino="$HOME/.claude/skills"

[ -d "$origen" ] || { echo "No se encontro la carpeta de skills: $origen" >&2; exit 1; }
mkdir -p "$destino"

for dir in "$origen"/*/; do
  nombre="$(basename "$dir")"
  rm -rf "${destino:?}/$nombre"
  cp -R "$dir" "$destino/$nombre"
  echo "  OK  $nombre"
done

echo
echo "Framework instalado en $destino"
echo "Si Claude Code estaba abierto, reinicia la sesion para tomar los cambios."
