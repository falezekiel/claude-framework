---
name: iniciar-proyecto
description: Arranca un proyecto con la metodología de documentación viva — parámetros, CLAUDE.md del proyecto, carpeta tasks/ desde plantillas, estándares medidos del repo, docs por card y pendientes. Solo cuando el usuario lo pide.
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

## 2. Git

Verificar si es un repositorio git. `/code-review` y `/security-review` trabajan sobre el diff, así que sin git no funcionan. Si no hay repo, proponer `git init` y un `.gitignore` que excluya los `.env` locales y `.respaldos/`, y esperar el OK. Git es además la red de seguridad de los puntos de restauración.

## 3. Leer antes de escribir

Documentación funcional disponible (HDU, minutas, transcripciones) y el código existente. Mientras se lee, anotar: lo que no está definido va a ser un P-nn; lo que no está documentado, un H-nn.

## 4. Base mínima

- `CLAUDE.md` en la raíz, desde `plantillas/CLAUDE.md`, con los parámetros completos.
  - Sin horas: la sección **Horas** queda solo con "Este proyecto no registra horas."
  - Sin frontend: se quitan la fila de `/diseno-frontend` y la de `06-DISENO.md`.
- `tasks/00-INDEX.md`, `tasks/01-CONTEXTO.md`, `tasks/04-BITACORA.md`, `tasks/07-PENDIENTES.md`.
- `tasks/bitacora/AAAA-MM-DD.md` del día.

## 5. Medir el repo → `02-ESTANDARES.md`

Medir, no suponer. Cada fila dice cómo se midió (comando o archivos revisados):

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

Seguir el paso "Preparar" de `/pruebas-e2e`: proponer la instalación de Playwright con los comandos exactos y esperar el OK. Crear `tasks/evidencias/`.

## 11. Seguridad

- Copiar `plantillas/claude-settings.json` a `.claude/settings.json` del proyecto (bloquea lectura de `.env` reales, pide confirmación para push e instalar dependencias). Mostrarlo y confirmar con el usuario antes.
- Si no existe `.env.example`, crearlo con los nombres de las variables, sin valores.
- Correr `/hardening inicial` → `tasks/08-SEGURIDAD.md`. Lo que se resuelve con configuración desde el día uno entra en el orden de ataque de `00-INDEX`.

## 12. Equipo (si otras personas van a trabajar el proyecto con Claude)

Preguntar si el proyecto se va a compartir. Si sí, agregar al `.claude/settings.json` del proyecto el marketplace y el plugin del framework, para que quien clone el repo lo tenga referenciado:

```json
"extraKnownMarketplaces": {
  "framework-claude": { "source": { "source": "github", "repo": "<usuario>/framework-claude" } }
},
"enabledPlugins": { "framework@framework-claude": true }
```

Y en el `README` del proyecto, la instrucción para cada persona (una vez por clon): `claude plugin install framework@framework-claude --scope project`. Si el repo del framework es privado, cada persona necesita acceso de lectura en GitHub.

## 13. Cierre

Resumir: qué se creó, qué se midió de destacable, los 🔴 abiertos (con el texto de la consulta listo para el líder técnico) y la primera card sugerida.
