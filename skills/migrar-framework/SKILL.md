---
name: migrar-framework
description: Actualiza un proyecto que usa una versión anterior de la metodología (prompt pegado + tasks/) a la versión actual del framework, sin perder ni reescribir su historia. Solo cuando el usuario lo pide.
disable-model-invocation: true
---

# Migrar framework

Para proyectos que ya tienen `tasks/` armado con una versión anterior (por ejemplo, el prompt que se pegaba al iniciar). **La historia del proyecto no se toca:** bitácora, decisiones, hallazgos, pendientes y docs de cards se conservan tal cual.

Plantillas actuales: `${CLAUDE_SKILL_DIR}/../iniciar-proyecto/plantillas/`. La versión del framework figura al final del `CLAUDE.md` de cada proyecto (`<!-- framework-claude vX.Y.Z -->`); si no está, es la versión del prompt pegado.

## 0. Diagnóstico (sin escribir nada)

Leer `tasks/` y la raíz del proyecto. Armar una tabla de lo que hay contra lo actual:

| Pieza | Qué revisar |
|---|---|
| `CLAUDE.md` | Existe, versión |
| `.claude/settings.json` | Bloqueo de `.env`, secretos y comandos destructivos |
| Protección de datos | `.respaldos/` en `.gitignore`, scripts `db:backup` / `db:restore`, Claude sin credenciales de escritura de producción |
| `.env.example` | Existe, sin valores |
| `02-ESTANDARES.md` | Comando E2E, DoD con `/code-review`, `/security-review` y evidencia |
| `03-FLUJO-GESTOR.md` | Línea "Evidencia" en el formato del comentario |
| `05-ENTREGAS.md` | Columna Evidencia |
| `06-DISENO.md` | Si hay frontend |
| `08-SEGURIDAD.md` | Existe |
| `PRUEBAS-*.md` | Columnas Tipo y Evidencia |
| `tasks/evidencias/` | Existe |
| Git | Es repo |

Mostrar el diagnóstico con el plan de cambios y **esperar el OK**.

## 1. `CLAUDE.md`

Crearlo desde la plantilla con los parámetros que ya estén en los docs (`01-CONTEXTO`, `03-FLUJO-GESTOR`) o en el prompt viejo, si el usuario lo pega. Lo que no esté, se pregunta. Si ya existe un `CLAUDE.md`, se integra: se conserva lo propio del proyecto y se agregan las secciones nuevas.

## 2. Docs existentes: agregar, no reescribir

- Se agregan columnas, filas e ítems nuevos. No se reformatea lo existente ni se renumeran D/H/P.
- Las cards en curso siguen como están: el flujo nuevo aplica desde el próximo paso o la próxima card.

## 3. Lo nuevo

- `.claude/settings.json` desde `claude-settings.json`, mostrándolo antes. Si Claude venía leyendo el `.env`, se pasa a trabajar con `.env.example`. Si el proyecto ya tenía un settings, se combinan: se suman `attribution` y las reglas nuevas sin borrar las existentes.
- Regla dura "nunca una IA como autora ni coautora": se reemplaza la versión vieja en el `CLAUDE.md` y se instala el hook `commit-msg` como en el paso 11 de `/iniciar-proyecto`. Se buscan atribuciones en la historia y se informan. No se reescribe la historia sin OK.
- `08-SEGURIDAD.md`: correr `/hardening inicial`, o dejarlo como pendiente si el usuario prefiere.
- Playwright: proponerlo según el paso 1 de `/pruebas-e2e`, con OK.
- `06-DISENO.md` si hay frontend: documentar el sistema visual existente, sin inventar uno nuevo.

## 4. Registro

- D-nn: "Migración a framework-claude vX.Y.Z", con qué cambió.
- Entrada en la bitácora del día.
- Commit solo si el usuario lo pide.
