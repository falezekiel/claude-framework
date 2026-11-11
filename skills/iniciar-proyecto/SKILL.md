---
name: iniciar-proyecto
description: Arranca un proyecto con la metodología de documentación viva — parámetros, CLAUDE.md del proyecto, carpeta tasks/ desde plantillas, mapa de repos del workspace (propios, del equipo, de referencia), estándares medidos de cada repo, docs por card y pendientes. Solo cuando el usuario lo pide.
disable-model-invocation: true
argument-hint: "[nombre del proyecto]"
---

# Iniciar proyecto

Las plantillas están en `${CLAUDE_SKILL_DIR}/plantillas/`. Se copian y se completan; las secciones que no aplican se borran en lugar de dejarlas vacías.

## 0. No pisar lo que existe

Si ya hay `CLAUDE.md` o `tasks/`, leerlos primero, proponer qué falta agregar y esperar el OK. Nunca sobrescribir.

## 1. Parámetros

Pedir de una sola vez los que falten:

- Gestor de tareas (Jira / ClickUp / otro / ninguno) y cómo accede Claude (MCP, CLI o manual)
- Prefijo de las cards
- ¿Se registran horas? ¿Dónde? Cuota diaria y franjas
- Líder técnico / canal de consultas a negocio
- ¿Desarrollo nuevo o sobre producción?
- ¿Tiene frontend?
- ¿Pruebas E2E/API con evidencia (Playwright)? Recomendado sí cuando hay UI o API expuesta.

Lo que se pueda deducir del repo (stack, comandos) no se pregunta: se mide.

## 2. Workspace y repos

No se asume que la raíz es un repo. Se mide:

```bash
git rev-parse --show-toplevel 2>/dev/null    # ¿la raíz es un repo, o está dentro de uno?
find . -maxdepth 3 \( -name node_modules -o -name vendor -o -name .venv -o -name dist \) -prune -o -name .git -print
```

(`.git` puede ser una carpeta, o un archivo en worktrees y submódulos: los dos cuentan como repo.)

Por cada repo encontrado:

- Remoto: `git -C <ruta> remote -v` (GitHub, Azure DevOps, GitLab…).
- Quién commitea: `git -C <ruta> shortlog -sne --all | head`.
- Reglas propias: `CLAUDE.md`, `AGENTS.md`, `.claude/`, `CONTRIBUTING*`, plantilla de PR, commitlint, `git -C <ruta> config core.hooksPath` (husky, lefthook).

Con eso se propone el **dueño** de cada repo, y el usuario lo confirma (es su decisión, no se deduce sola):

- **Propio:** solo commitea el usuario, o es un repo nuevo.
- **Equipo:** commitean varias personas, el remoto es de una organización, o ya tiene `CLAUDE.md`, `.claude/` o CI versionados.
- **Referencia:** un clon para leer, en el que el usuario no commitea (librerías, ejemplos, repos de terceros).

Según la raíz:

| Raíz | Dónde vive el framework |
|---|---|
| Es un repo **propio** | En el repo, como siempre: `CLAUDE.md`, `.claude/` y `tasks/` se versionan ahí. |
| **No es un repo** y tiene repos adentro | En la raíz. Preguntar cómo se respalda `tasks/`:<br>(a) **recomendado:** `git init` en la raíz, como repo propio de documentación, con un `.gitignore` que liste cada repo de adentro (si no, git los agrega como repos embebidos), y un remoto privado si se quiere copia fuera de la máquina;<br>(b) sin versionar: se copia a `.respaldos/` antes de cambios grandes. |
| Es un repo **del equipo** | No se meten `tasks/` ni `CLAUDE.md` en el repo. Recomendado: una carpeta de workspace que lo contenga, y seguir como en la fila anterior (mover el clon lo decide el usuario). Alternativa, solo si el repo no tiene `CLAUDE.md` ni `.claude/` propios: todo local dentro del repo, ignorado con `.git/info/exclude`. |
| No hay ningún repo | Proponer `git init` y un `.gitignore` que excluya los `.env` locales y `.respaldos/`, y esperar el OK. Sin git no funcionan `/code-review`, `/security-review` ni los puntos de restauración. |

Mostrar el mapa (repo, rol, remoto, dueño, reglas propias) y esperar el OK. Se vuelca en la sección **Workspace y repos** del `CLAUDE.md`. Las reglas propias de cada repo se leen ahora: lo que choque con el framework se anota como D-nn (qué regla gana y por qué) o se pregunta.

## 3. Leer antes de escribir

Documentación funcional disponible (HDU, minutas, transcripciones) y el código existente. Mientras se lee, anotar: lo que no está definido va a ser un P-nn; lo que no está documentado, un H-nn.

## 4. Base mínima

- `CLAUDE.md` en la raíz del workspace (paso 2), desde `plantillas/CLAUDE.md`, con los parámetros y el mapa de repos completos.
  - Sin horas: la sección **Horas** queda solo con "Este proyecto no registra horas."
  - Sin frontend: se quitan la fila de `/diseno-frontend` y la de `06-DISENO.md`.
- `tasks/00-INDEX.md`, `tasks/01-CONTEXTO.md`, `tasks/04-BITACORA.md`, `tasks/07-PENDIENTES.md`.
- `tasks/bitacora/AAAA-MM-DD.md` del día.

## 5. Medir el repo → `02-ESTANDARES.md`

Medir, no suponer. Con varios repos, se mide cada uno que no sea de referencia, con su propia sección y sus comandos; el Definition of Done es uno solo. En los repos del equipo, sus convenciones documentadas (su `CLAUDE.md`, `CONTRIBUTING`, linters) son el punto de partida. Cada fila dice cómo se midió (comando o archivos revisados):

- tests: cuántos hay, si corren, cobertura si hay herramienta; tests vacíos o comentados
- linters/formatters configurados y si el código los pasa
- tipado: modo estricto, cantidad de `any` o equivalentes
- manejo de errores: excepciones genéricas, catch vacíos
- transacciones en escrituras multi-tabla
- tamaño de los archivos/services más grandes
- SQL interpolado, secretos en el código, backups versionados
- comandos reales de test, lint, build y typecheck

Con eso se define qué se respeta, qué no se replica y el Definition of Done. Si el proyecto es nuevo y no hay código, se define el estándar inicial y los comandos.

## 6. Un doc por card

Desde `plantillas/CARD.md`, con el ID interno del gestor en la cabecera. Si Claude puede leer el gestor, se sacan de ahí; si no, se piden. Cargar cada card en `00-INDEX.md` con un orden sugerido de ataque.

## 7. `03-FLUJO-GESTOR.md`

Adaptado al gestor y al esquema de horas. Incluye cómo accede Claude; si no tiene acceso, Claude prepara el texto y el usuario lo pega.

## 8. Pendientes

Volcar en `07-PENDIENTES.md` todo lo que la documentación deja sin definir, clasificado 🔴/🟡/🟢, con qué cards bloquea y qué se asume provisionalmente.

## 9. Frontend (si aplica)

Correr `/diseno-frontend` para dejar `06-DISENO.md` con la dirección visual antes de la primera card de UI. Si ya hay un sistema visual, se documenta el existente.

## 10. Pruebas E2E (si aplica)

Seguir el paso "Preparar" de `/pruebas-e2e`: proponer la instalación de Playwright con los comandos exactos y esperar el OK. Si los repos son del equipo, Playwright no se agrega a sus dependencias sin acordarlo: va en una carpeta `e2e/` propia en la raíz del workspace. Crear `tasks/evidencias/`.

## 11. Seguridad

- Copiar `plantillas/claude-settings.json` a `.claude/settings.json` de la raíz del workspace. Bloquea la lectura de `.env` reales y el salteo de hooks, apaga toda atribución de Claude Code en commits y PRs (`attribution`), y pide confirmación para push e instalar dependencias. Mostrarlo y confirmar con el usuario antes.
  - Si la raíz contiene repos del equipo con su propio `.claude/settings.json`, ese archivo **no se carga** cuando Claude Code se abre en la raíz. Leerlo y sumar sus reglas `deny` y `ask` al settings de la raíz, para no perder las protecciones que el equipo definió. El archivo del equipo no se toca.
- **Hook contra la atribución a una IA** (regla dura 4 del `CLAUDE.md`), según el dueño de cada repo y siempre con OK. El hook rechaza commits con trailers o pies de atribución a cualquier IA, o con un autor que sea una IA. Funciona igual si el commit lo hace Claude, otra herramienta o una persona. La fuente es `plantillas/githooks/commit-msg`.
  - **Repo propio:** copiarlo a `.githooks/commit-msg`, hacerlo ejecutable (`chmod +x` y `git add --chmod=+x`) y activarlo con `git config core.hooksPath .githooks`. `core.hooksPath` es configuración local: cada clon lo activa una vez, así que el comando va al `README` del repo.
  - **Repo del equipo:** solo local, sin commitear nada. Si `git -C <ruta> config core.hooksPath` está vacío, copiarlo a la carpeta que devuelve `git -C <ruta> rev-parse --git-path hooks` (`.git/hooks/`; resuelve también worktrees) y hacerlo ejecutable. Si ya hay un `commit-msg` ahí, no se pisa: el del framework se copia como `commit-msg-framework` y al existente se le agrega `"$(dirname "$0")/commit-msg-framework" "$1" || exit 1`. Si el repo usa `core.hooksPath` (husky, lefthook), los hooks locales no corren y cambiar esa configuración es del equipo. Ese repo queda sin hook: se registra como H-nn y queda cubierto por `attribution` y la regla.
  - **Repo de referencia:** no aplica, porque no se commitea.
  - Si el repo ya tiene historia, buscar atribuciones previas (ver `/hardening`) e informarlas sin reescribir nada.
- Si no existe `.env.example`, crearlo con los nombres de las variables, sin valores.
- Correr `/hardening inicial` → `tasks/08-SEGURIDAD.md`. Lo que se resuelve con configuración desde el día uno entra en el orden de ataque de `00-INDEX`.

## 12. Equipo (si otras personas van a trabajar el proyecto con Claude)

Preguntar si el proyecto se va a compartir. En un workspace cuya raíz es documentación local del usuario, el framework es personal y este paso no aplica: no se agrega nada a los repos del equipo. Si se comparte, agregar al `.claude/settings.json` del proyecto el marketplace y el plugin del framework, para que quien clone el repo lo tenga referenciado:

```json
"extraKnownMarketplaces": {
  "framework-claude": { "source": { "source": "github", "repo": "falezekiel/claude-framework" } }
},
"enabledPlugins": { "framework@framework-claude": true }
```

Y en el `README` del proyecto, la instrucción para cada persona (una vez por clon): `claude plugin install framework@framework-claude --scope project`. Si el repo del framework es privado, cada persona necesita acceso de lectura en GitHub.

## 13. Cierre

Resumir: qué se creó, qué se midió de destacable, los 🔴 abiertos (con el texto de la consulta listo para el líder técnico) y la primera card sugerida.
