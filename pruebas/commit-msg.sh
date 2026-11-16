#!/usr/bin/env bash
# Pruebas del hook commit-msg: lo que tiene que rechazar y lo que tiene que dejar pasar.
# Uso: bash pruebas/commit-msg.sh [ruta-al-hook]
set -uo pipefail

hook="$(cd "$(dirname "${1:-skills/iniciar-proyecto/plantillas/githooks/commit-msg}")" && pwd)/$(basename "${1:-commit-msg}")"
[ -f "$hook" ] || { echo "No existe el hook: $hook" >&2; exit 2; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
git -C "$tmp" init -q
git -C "$tmp" config user.name "Dev Humano"
git -C "$tmp" config user.email dev@example.com
cd "$tmp"

fallas=0
prueba() { # prueba <pasa|rechaza> <descripcion> <mensaje> [nombre-autor email-autor]
  esperado="$1"; desc="$2"; printf '%b\n' "$3" > msg
  if GIT_AUTHOR_NAME="${4:-Dev Humano}" GIT_AUTHOR_EMAIL="${5:-dev@example.com}" sh "$hook" msg 2>/dev/null; then r=pasa; else r=rechaza; fi
  if [ "$r" = "$esperado" ]; then echo "ok    $desc"; else echo "FALLA $desc (dio $r, esperaba $esperado)"; fallas=$((fallas+1)); fi
}

prueba rechaza "Co-Authored-By de Claude"   'Arregla parser\n\nCo-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>'
prueba rechaza "Co-authored-by de Copilot"  'Arregla parser\n\nCo-authored-by: Copilot <175728472+Copilot@users.noreply.github.com>'
prueba rechaza "Co-Authored-By de IA genérica" 'Arregla parser\n\nCo-Authored-By: AI <ai@example.com>'
prueba rechaza "pie Generated with Claude Code" 'Arregla parser\n\n🤖 Generated with [Claude Code](https://claude.com/claude-code)'
prueba rechaza "trailer Claude-Session"     'Arregla parser\n\nClaude-Session: https://claude.ai/code/session_123'
prueba rechaza "Assisted-by"                'Arregla parser\n\nAssisted-by: Gemini'
prueba rechaza "Generated with ChatGPT"     'Arregla parser\n\nGenerated with ChatGPT'
prueba rechaza "autor con identidad de IA"  'Commit normal' "Claude" "noreply@anthropic.com"
prueba pasa    "IAs mencionadas como tema"  'Integra la API de Claude para resumir pedidos\n\nAgrega cliente de OpenAI como fallback.'
prueba pasa    "coautor humano"             'Arregla parser\n\nCo-authored-by: Juan Perez <juan@example.com>'
prueba pasa    "coautora con \"ai\" dentro de una palabra" 'Ajusta mail\n\nCo-authored-by: Ana Maidana <ana@example.com>'
prueba pasa    "línea comentada por git"    'Commit normal\n\n# Co-Authored-By: Claude'

[ "$fallas" -eq 0 ] && echo "Todas las pruebas pasan." || { echo "$fallas prueba(s) fallaron."; exit 1; }
