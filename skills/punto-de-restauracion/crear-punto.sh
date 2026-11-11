#!/usr/bin/env bash
# Crea un punto de restauracion del working tree completo (incluye archivos nuevos
# no trackeados; respeta .gitignore) en refs/restauracion/<fecha-hora>.
# No toca la rama actual, el indice ni los archivos. No se pushea.
#
# Uso: bash crear-punto.sh "motivo" [ruta-del-repo]
#      (sin ruta, usa el repo de la carpeta actual)
set -euo pipefail

motivo="${1:?Falta el motivo. Uso: crear-punto.sh \"motivo\" [ruta-del-repo]}"
repo="${2:-.}"
cd "$repo" || { echo "ERROR: no existe la carpeta $repo" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "ERROR: $repo no es un repositorio git" >&2; exit 1; }

raiz="$(git rev-parse --show-toplevel)"
cd "$raiz"
id="$(date +%Y%m%d-%H%M%S)"
indice="$(git rev-parse --absolute-git-dir)/indice-restauracion-$id"
trap 'rm -f "$indice"' EXIT

if git rev-parse -q --verify HEAD >/dev/null; then
  GIT_INDEX_FILE="$indice" git read-tree HEAD
  padre=(-p HEAD)
else
  padre=()
fi
GIT_INDEX_FILE="$indice" git add -A
arbol="$(GIT_INDEX_FILE="$indice" git write-tree)"
commit="$(git commit-tree "$arbol" "${padre[@]}" -m "Punto de restauracion: $motivo")"
git update-ref "refs/restauracion/$id" "$commit"

# Verificacion: la referencia existe y su arbol coincide con lo guardado.
[ "$(git rev-parse "refs/restauracion/$id^{tree}")" = "$arbol" ] || { echo "ERROR: verificacion fallida" >&2; exit 1; }
archivos="$(git ls-tree -r --name-only "refs/restauracion/$id" | wc -l | tr -d ' ')"

echo "OK $raiz: refs/restauracion/$id ($archivos archivos) - $motivo"
echo "Restaurar un archivo: git -C \"$raiz\" restore --source=refs/restauracion/$id -- <ruta>"
echo "Restaurar todo:       git -C \"$raiz\" restore --source=refs/restauracion/$id --worktree -- ."
