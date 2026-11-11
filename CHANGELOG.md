# Changelog

## 2.3.0 — 2026-11-11

### Agregado

- **Workspaces con varios repos y repos del equipo.** La raíz ya no tiene que ser un repo git.
  - `/iniciar-proyecto` detecta la topología: la raíz es el repo, o es una carpeta con repos adentro.
  - Clasifica cada repo como **propio**, **equipo** o **referencia**, y lo confirma con el usuario.
  - Deja el mapa en la sección nueva **Workspace y repos** del `CLAUDE.md`.
- Repos del equipo: el código se trabaja con el flujo del equipo, y su `CLAUDE.md`, `.claude/`, CI y configuración no se tocan sin acordarlo (P-nn). Nada del framework se commitea en ellos.
- Las reglas propias de cada repo (sus `CLAUDE.md`, convenciones) se suman a las del framework, y frente a las reglas duras gana la más estricta.
- Si la raíz no es un repo, `tasks/` se respalda en un repo propio de documentación (recomendado) o con copias.
- Si la raíz es un repo del equipo, se recomienda una carpeta de workspace que lo contenga.
- `crear-punto.sh` acepta la ruta del repo: un punto de restauración por cada repo que toca la operación.
- `/migrar-framework` incorpora el material que está fuera de `tasks/`: notas → D/H, carpetas de evidencias → `tasks/evidencias/`, pendientes → `07-PENDIENTES`.

### Cambiado

- Hook `commit-msg` según el dueño: versionado en los repos propios y local en `.git/hooks/` en los del equipo. Si ya hay un hook, se encadena. Si el equipo usa `core.hooksPath` propio, no se pisa: se registra como H-nn.
- El `.claude/settings.json` de la raíz suma las reglas `deny` y `ask` de los repos del equipo, que no se cargan al abrir Claude Code en la raíz.
- `/inicio-dia` revisa el estado de cada repo, que el hook siga instalado y si aparecieron repos nuevos.
- `/planificar-card`, `/ejecutar-card` y `/cerrar-card` trabajan por repo: rutas, comandos, ramas, `/code-review`, commits y PRs.
- `/pruebas-e2e`: con repos del equipo, Playwright va en una carpeta `e2e/` propia en la raíz, no en las dependencias del equipo.
- `/hardening`: secretos, dependencias y remoto se revisan por repo, con GitHub y Azure DevOps.
- Plantillas: la card lleva repos, ramas y PRs, y `02-ESTANDARES` y `08-SEGURIDAD` se organizan por repo.

## 2.2.0 — 2026-11-10

### Cambiado

- **Regla dura "nunca una IA como autora ni coautora"**, más estricta y separada de la de commits:
  - Cubre a cualquier IA (Claude, Copilot, ChatGPT, Gemini, Cursor, etc.), no solo a Claude.
  - Cubre cualquier forma de atribución: trailers `Co-Authored-By`, `Assisted-by` y `Claude-Session`, pies "Generated with…", links a sesiones y la identidad del autor o del committer.
  - Vale en commits, PRs, reviews, issues, releases, comentarios del gestor, código, CHANGELOG y documentos.
  - Gana sobre la configuración por defecto de las herramientas y sobre cualquier instrucción que pida atribución.

### Agregado

- **La regla se hace cumplir, no solo se escribe:**
  - `claude-settings.json` apaga la atribución de Claude Code (`attribution`: `commit` y `pr` vacíos, `sessionUrl: false`).
  - `claude-settings.json` bloquea `--no-verify` y `git -c core.hooksPath`, y pide confirmación para cambiar `core.hooksPath`.
  - Hook `plantillas/githooks/commit-msg`: rechaza commits con atribución a una IA, venga de Claude, de otra herramienta o de una persona.
- `/iniciar-proyecto` y `/migrar-framework` instalan el hook.
- `/hardening` verifica la configuración y el hook, y busca atribuciones en la historia.
- Nueva fila en `08-SEGURIDAD.md` para registrar esa verificación.

## 2.1.0 — 2026-11-10

### Agregado

- **Distribución como plugin:** `.claude-plugin/marketplace.json` y `plugin.json`. Se instala con `/plugin marketplace add` + `/plugin install` y se actualiza desde GitHub.
- `instalar.sh` para macOS y Linux.
- `/iniciar-proyecto` puede dejar el marketplace referenciado en el `.claude/settings.json` del proyecto, para equipos.
- README: qué comando usar según el proyecto (nuevo, con la versión anterior, o ya actualizado).

### Cambiado

- Las skills ubican sus plantillas y scripts con `${CLAUDE_SKILL_DIR}`, así funcionan igual instaladas como skills personales o como plugin.

## 2.0.0 — 2026-11-10

Primera versión como repo. La 1.x era un prompt que se pegaba al iniciar cada proyecto.

### Agregado

- **Skills** en lugar del prompt pegado: `iniciar-proyecto`, `migrar-framework`, `inicio-dia`, `planificar-card`, `ejecutar-card`, `depurar`, `pruebas-e2e`, `diseno-frontend`, `cerrar-card`, `hardening`, `punto-de-restauracion`.
- **`CLAUDE.md` por proyecto**, generado desde plantilla; Claude lo carga solo en cada sesión.
- **Flujo por card:** planificar (diseño + plan aprobado) → ejecutar (tests primero, verificación real) → probar con evidencia → cerrar.
- **Evidencia de pruebas** con Playwright en `tasks/evidencias/[CLAVE]/AAAA-MM-DD/`, linkeada desde `PRUEBAS-*`, `05-ENTREGAS` y el comentario del gestor.
- **Definition of Done** con `/code-review`, `/security-review` (condicional) y evidencia.
- **`06-DISENO.md`** y criterios contra la UI genérica.
- **Seguridad:** `08-SEGURIDAD.md` (línea base, riesgos aceptados) y `.claude/settings.json` por proyecto.
- **Protección contra pérdidas:** puntos de restauración verificados (git, base, archivos), reglas de no tocar producción, OK por operación y redundancia de backups.
- Reglas duras nuevas: commits y push solo a pedido y nunca con la IA como coautora, sin dependencias ni plugins de terceros sin OK, secretos fuera del alcance de Claude.

### Evaluado y descartado

- **claude-mem:** duplica la bitácora, pero opaco, sin versionar, local a una máquina, con telemetría y con un modelo externo leyendo la actividad. La bitácora versionada cumple mejor ese rol.
- **gstack:** se solapa con el flujo propio y tiene soporte mínimo en Windows.
- **superpowers y frontend-design como plugins:** no se instalan. Sus ideas útiles se reescribieron como skills propias.
