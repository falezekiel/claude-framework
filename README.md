# framework-claude

Metodología para trabajar proyectos de desarrollo con Claude Code, empaquetada como skills.

Se basa en **documentación viva** (`tasks/` en cada proyecto): el contexto de una conversación se pierde, y las decisiones y hallazgos no pueden perderse con él.

> **Regla madre: si costó averiguarlo, se escribe.**

Todo está escrito a mano y no depende de plugins ni de repos de terceros. Algunas ideas se tomaron de proyectos públicos (superpowers, frontend-design) y se reescribieron desde cero.

## Instalación

Elegí **una** de las dos formas: si instalás las dos, cada skill aparece dos veces.

### A. Como plugin (para usarlo: un comando, se actualiza desde GitHub)

Dentro de Claude Code:

```
/plugin marketplace add falezekiel/claude-framework
/plugin install framework@framework-claude
```

O desde la terminal:

```
claude plugin marketplace add falezekiel/claude-framework --scope user
claude plugin install framework@framework-claude --scope user
```

Las skills quedan con el prefijo del plugin: `/framework:iniciar-proyecto`, `/framework:cerrar-card`, etc. Las instrucciones internas las nombran sin prefijo, y Claude las resuelve igual.

**Actualizar:** `/plugin marketplace update framework-claude` (o activar la actualización automática en `/plugin` → Marketplaces). Llega una versión nueva cuando cambia `version` en `.claude-plugin/plugin.json`, no con cada push.

### B. Como skills personales (para desarrollar el framework)

```powershell
git clone <url-de-este-repo>
cd framework-claude
.\instalar.ps1        # Windows
./instalar.sh         # macOS / Linux
```

Copia las skills a `~/.claude/skills/` con nombres cortos (`/cerrar-card`). Solo reemplaza las carpetas de este repo y no toca otras skills que tengas. Si Claude Code ya estaba abierto, reiniciá la sesión.

**Las mejoras se hacen en este repo**, no en `~/.claude/skills/`: lo que se edite allá se pisa en la próxima instalación. Flujo: editar acá → instalar → commit → push (quien lo use como plugin lo recibe al actualizar).

## Usarlo en un proyecto

Abrir Claude Code en la carpeta del proyecto y:

| Situación | Comando |
|---|---|
| Proyecto nuevo, o existente que nunca usó el framework | `/iniciar-proyecto` |
| Proyecto que usa la versión anterior (el prompt pegado, o una v2 más vieja) | `/migrar-framework` |
| Proyecto que ya tiene el framework actual | Nada: Claude lee el `CLAUDE.md` del proyecto y arrancás con `/inicio-dia` |

**Ninguna IA figura como autora ni coautora** de nada: commits, PRs, issues, código ni documentos. Es una regla dura del `CLAUDE.md` del proyecto, y no queda solo escrita. `/iniciar-proyecto` apaga la atribución de Claude Code en `.claude/settings.json` e instala un hook `commit-msg` que rechaza cualquier commit con atribución a una IA, lo haga quien lo haga. En los repos propios el hook se versiona, y en cada clon nuevo se activa una vez con `git config core.hooksPath .githooks`. En los repos del equipo se instala solo en tu clon (`.git/hooks/`), sin commitear nada.

**No hace falta que la raíz sea un repo.** El framework vive en la carpeta donde abrís Claude Code, que puede ser el repo o una carpeta con varios repos adentro (backend, frontend, clones de referencia). `/iniciar-proyecto` detecta los repos y propone el dueño de cada uno:
- **propio:** se versiona todo;
- **equipo:** el código se trabaja normal, pero su `CLAUDE.md`, `.claude/` y configuración no se tocan sin acordarlo;
- **referencia:** solo lectura.

El mapa queda en el `CLAUDE.md` y las demás skills trabajan repo por repo: `git status`, puntos de restauración, `/code-review`, commits y PRs.

Para que un equipo comparta el framework en un proyecto, `/iniciar-proyecto` puede dejar el marketplace referenciado en el `.claude/settings.json` del proyecto. Cada persona igual corre una vez `claude plugin install framework@framework-claude --scope project`: Claude Code no instala plugins solo.

## Skills

| Skill | Para qué | Quién la dispara |
|---|---|---|
| `/iniciar-proyecto` | Arranca un proyecto: parámetros, `CLAUDE.md`, `tasks/`, estándares medidos, seguridad | Solo el usuario |
| `/migrar-framework` | Lleva un proyecto de una versión anterior a la actual sin tocar su historia | Solo el usuario |
| `/inicio-dia` | Lee bitácora y pendientes bloqueantes, propone el plan del día | Usuario o Claude |
| `/planificar-card` | Aclara, propone enfoques, escribe diseño + plan + casos de prueba | Usuario o Claude |
| `/ejecutar-card` | Implementa el plan con tests primero y verificación real | Usuario o Claude |
| `/depurar` | Depuración por causa raíz, con registro del hallazgo | Usuario o Claude |
| `/pruebas-e2e` | Playwright con evidencia (capturas y respuestas) en `tasks/evidencias/` | Usuario o Claude |
| `/diseno-frontend` | Dirección visual con criterio, evita la UI genérica | Usuario o Claude |
| `/cerrar-card` | DoD, `/code-review`, `/security-review`, docs y cierre en el gestor (las horas las decide el usuario) | Usuario o Claude |
| `/hardening` | Línea base de seguridad del proyecto → `08-SEGURIDAD.md` | Usuario o Claude |
| `/punto-de-restauracion` | Respaldo verificado (git + base + archivos) antes de lo destructivo | Usuario o Claude |

`/code-review` y `/security-review` vienen incluidas en Claude Code.

## Flujo de una card

```
/inicio-dia
   └─ /planificar-card CLAVE ──► /ejecutar-card CLAVE ──► /pruebas-e2e CLAVE ──► /cerrar-card CLAVE
                                    │        │
                                    │        └─ /punto-de-restauracion (antes de lo destructivo)
                                    └─ /depurar (si algo falla)     /diseno-frontend (si hay UI)

Antes de cada salida a producción: /hardening pre-produccion
```

## Qué queda en cada proyecto

```
CLAUDE.md                  reglas del proyecto (Claude lo lee en cada sesión)
.claude/settings.json      permisos: bloquea secretos y comandos destructivos
tasks/
  00-INDEX.md              cards, orden de ataque
  01-CONTEXTO.md           arquitectura y principios
  02-ESTANDARES.md         medido del repo + Definition of Done
  03-FLUJO-GESTOR.md       gestor de tareas y horas
  04-BITACORA.md           decisiones (D-nn) y hallazgos (H-nn)
  05-ENTREGAS.md           terminada vs entregada, con evidencia
  06-DISENO.md             dirección visual (si hay frontend)
  07-PENDIENTES.md         preguntas abiertas (P-nn) por urgencia
  08-SEGURIDAD.md          línea base de seguridad y riesgos aceptados
  [CLAVE]-[slug].md        un doc por card
  PRUEBAS-[CLAVE].md       casos de prueba
  bitacora/AAAA-MM-DD.md   qué se hizo cada día
  evidencias/[CLAVE]/      capturas y respuestas de las pruebas
```

## Protección contra pérdidas

1. Claude no tiene credenciales de escritura de producción.
2. Antes de cualquier operación destructiva hay un punto de restauración verificado (`/punto-de-restauracion`). `/rewind` de Claude Code no deshace comandos ni cambios en la base.
3. Se avisa qué se pierde y se pide OK por operación.
4. Se prefiere lo reversible: mover antes que borrar, migraciones con `down`, soft-delete.
5. Redundancia: git + GitHub; backups con copia fuera del proveedor y restauración probada.
6. `.claude/settings.json` bloquea o pide confirmación para lo destructivo. Es una red, no una garantía.

## Versionado

La versión va al final del `CLAUDE.md` de cada proyecto (`<!-- framework-claude vX.Y.Z -->`), así `/migrar-framework` sabe desde dónde migrar. Los cambios se registran en [CHANGELOG.md](CHANGELOG.md).

## Contribuir

Los issues y los PRs son bienvenidos. Antes de abrir un PR, leé [CONTRIBUTING.md](CONTRIBUTING.md): explica qué cambios encajan, cómo probarlos y cómo se publica una versión. Para reportar una vulnerabilidad, usá la pestaña **Security** del repo, no un issue público.

## Licencia

[MIT](LICENSE).
