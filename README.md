# framework-claude

Metodología para trabajar proyectos de desarrollo con Claude Code, empaquetada como skills.

Se basa en **documentación viva** (`tasks/` en cada proyecto): el contexto de una conversación se pierde, y las decisiones y hallazgos no pueden perderse con él.

> **Regla madre: si costó averiguarlo, se escribe.**

Todo está escrito a mano y no depende de plugins ni de repos de terceros. Algunas ideas se tomaron de proyectos públicos (superpowers, frontend-design) y se reescribieron desde cero.

## Instalación

```powershell
git clone <url-de-este-repo> C:\Eze\awesome\framework-claude
cd C:\Eze\awesome\framework-claude
.\instalar.ps1
```

`instalar.ps1` copia las skills a `~/.claude/skills/`. Solo reemplaza las carpetas de este repo y no toca otras skills que tengas instaladas. Si Claude Code ya estaba abierto, puede hacer falta reiniciar la sesión para que tome los cambios.

**Las mejoras se hacen en este repo**, no en `~/.claude/skills/`: lo que se edite allá se pisa en la próxima instalación. Flujo: editar acá → `.\instalar.ps1` → commit.

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
