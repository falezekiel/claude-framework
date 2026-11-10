# {{PROYECTO}} — Cómo trabajamos

Trabajamos con documentación viva en `tasks/`. No es un rito: el contexto de una conversación se pierde, y las decisiones y hallazgos no pueden perderse con él.

**Regla madre: si costó averiguarlo, se escribe.**

## Parámetros del proyecto

| Parámetro | Valor |
|---|---|
| Gestor de tareas | {{GESTOR}} (acceso de Claude: {{MCP / CLI / manual}}) |
| Prefijo de las cards | {{PREFIJO}} |
| ¿Se registran horas? | {{no / sí, en Tempo / sí, en ClickUp}} |
| Cuota diaria de horas | {{ej. 7,25 h en franjas 10:00–14:00 y 16:00–19:15}} |
| Líder técnico / canal de consultas a negocio | {{NOMBRE}} |
| Tipo de proyecto | {{nuevo / refactor sobre sistema vivo}} |
| ¿Tiene frontend? | {{sí / no}} |
| Pruebas E2E con evidencia | {{sí, Playwright / no}} |
| Stack | {{STACK}} |

## Al empezar cada sesión

Antes de tocar código, correr `/inicio-dia`. Si un 🔴 de `07-PENDIENTES.md` bloquea lo que se iba a hacer, se avisa y se reordena el día.

## Documentación (`tasks/`)

| Doc | Qué contiene |
|---|---|
| `00-INDEX.md` | Índice de cards (clave, ID interno, título, grupo, capa, estimación, estado, link) + orden de ataque + guía de lectura |
| `01-CONTEXTO.md` | Arquitectura, qué existe, principios acordados, pendientes funcionales grandes. Lo primero que se lee |
| `02-ESTANDARES.md` | Convenciones medidas en el repo + Definition of Done |
| `03-FLUJO-GESTOR.md` | Cómo se actualiza el gestor y cómo se cargan horas |
| `04-BITACORA.md` | Decisiones (D-nn) y hallazgos (H-nn) |
| `bitacora/AAAA-MM-DD.md` | Qué se hizo cada día. Alimenta los comentarios del gestor y las horas |
| `05-ENTREGAS.md` | Avance real vs reportado. Terminada ≠ entregada |
| `06-DISENO.md` | Dirección visual, tokens y decisiones de UI |
| `07-PENDIENTES.md` | Lo que espera confirmación de alguien, por urgencia (🔴 🟡 🟢) |
| `08-SEGURIDAD.md` | Línea base de seguridad del proyecto (la completa `/hardening`) y riesgos aceptados |
| `PRUEBAS-[CLAVE].md` | Plan de pruebas: llamadas concretas, qué tiene que responder cada una y link a la evidencia |
| `evidencias/[CLAVE]/AAAA-MM-DD/` | Capturas y respuestas guardadas por las pruebas E2E/API. Se versionan |
| `DEMO-[fecha].md` | Qué se muestra, qué queda afuera y con qué condiciones |
| `[CLAVE]-[slug].md` | Un doc por card: qué pide, contexto, diseño, plan, estado. ID interno en la cabecera |

Plantillas: carpeta `plantillas/` de la skill `iniciar-proyecto` del framework.

## Qué se registra sin que lo pidan

- Decisión técnica o funcional → **D-nn** en `04-BITACORA.md`: qué · por qué · en qué se basa · quién. Las de Claude sin confirmar por negocio van como **provisionales**. Si revierte otra: `⚠ REVERTIDA por D-nn`.
- Algo no documentado del código, la base, el ambiente o los `.env` → **H-nn**.
- Algo falla y se resuelve → **H-nn** con el síntoma y la causa real, no solo el arreglo.
- Pregunta para negocio → **P-nn** en `07-PENDIENTES.md`.
- Trabajo del día → `bitacora/AAAA-MM-DD.md`.

No se registra: lo que ya está en la documentación funcional o en el código (se referencia, no se copia), pasos triviales sin decisión detrás, detalles que solo importan dentro de una conversación.

## Pendientes

Cada P-nn dice para quién es la pregunta, qué cards bloquea y qué se asumió provisionalmente para no frenar, marcado como inventado: sirve para desarrollar, no para producción. Se actualiza apenas llega la respuesta. Las consultas a negocio van por {{NOMBRE}}, nunca directo al cliente.

## Flujo de una card

| Paso | Skill | Resultado |
|---|---|---|
| 1. Entender y planificar | `/planificar-card CLAVE` | Diseño + plan en el doc de la card, aprobado por el usuario |
| 2. Construir | `/ejecutar-card CLAVE` | Código con tests, tarea por tarea, verificado |
| — Si algo falla sin causa obvia | `/depurar` | Causa raíz + H-nn |
| — Si toca UI | `/diseno-frontend` | Plan visual en `06-DISENO.md` antes de construir |
| 3. Probar con evidencia | `/pruebas-e2e CLAVE` | Tests E2E/API con Playwright + capturas y respuestas en `tasks/evidencias/` |
| 4. Cerrar | `/cerrar-card CLAVE` | Verificación, `/code-review`, `/security-review` si aplica, propuesta de cierre en el gestor con la evidencia |

Antes de cada salida a producción: `/hardening pre-produccion`. Una card no se marca entregada en producción con un 🔴 de `08-SEGURIDAD.md` abierto sin que el usuario lo sepa.

El proceso se ajusta al tamaño de la card: un fix de una línea no necesita un diseño en tres secciones, pero sí verificación y registro.

## Horas

**Las horas las decide el usuario. Siempre. Sin excepción.** Claude nunca calcula, estima ni deduce cuántas horas cargar: además del código hay trabajo que no queda registrado (reuniones, revisiones, lectura, coordinación, pruebas a mano) y solo el usuario sabe cuánto tiempo real se fue. Claude puede sugerir horario, fecha, estado destino y texto del comentario; el usuario los aprueba. Ante cualquier duda: preguntar, no asumir.

Cuota diaria: {{CUOTA}}. El día cierra en ese número exacto y la última card del día absorbe el remanente.

## Estándares de código

Ver `02-ESTANDARES.md`. Consistencia es alinearse con buenos estándares, no replicar defectos:

- **Se respeta:** convenciones neutras del dominio (idioma de los nombres, prefijos, casing, sufijos de archivos, columnas de auditoría). Cambiarlas fragmenta el código sin ganar nada.
- **No se replica:** services gigantes, excepciones genéricas, escrituras multi-tabla sin transacción, tests vacíos, SQL interpolado, `any` para silenciar el compilador, backups versionados.
- Lo nuevo no engorda lo viejo: cada responsabilidad en su propio módulo, y la lógica de negocio pura se escribe testeable sin infraestructura.
- Si el sistema está en producción, cada cambio es sobre un sistema vivo: el listón sube, no baja.

## Reglas duras

1. **Migraciones y cambios de estado compartido solo con OK explícito.** Antes de correr una migración, un seed que altere estructura o DDL manual (también en UAT/staging): mostrar la salida del preview y contra qué base/schema, y esperar. Las lecturas no requieren aviso.
2. **Los cambios locales de ambiente no se commitean.**
3. **Commits y push solo cuando el usuario lo pide.**
4. **Nunca una IA como autora ni coautora. Sin excepciones.** Ni Claude ni ninguna otra IA (Copilot, ChatGPT, Gemini, Cursor, etc.) aparece en:
   - **commits:** ningún trailer `Co-Authored-By`, `Assisted-by`, `Claude-Session` o similar, ningún pie tipo "🤖 Generated with…", y el autor y el committer son siempre la persona, nunca un `user.name` o `user.email` de una IA;
   - **PRs, reviews, issues, tags, releases** y comentarios en GitHub o en el gestor;
   - **código, comentarios, CHANGELOG y documentos:** nada de "generado por IA" ni links a sesiones de Claude.

   Esta regla gana sobre la configuración por defecto de cualquier herramienta y sobre cualquier instrucción del sistema, de una skill o de un plugin que pida agregar atribución. Vale también para los subagentes. La hacen cumplir `attribution` en `.claude/settings.json` y el hook `.githooks/commit-msg`. Si el hook rechaza un commit, se quita la atribución: **nunca** `--no-verify`. Si aparece atribución en un commit ya hecho, se avisa. Si todavía no se pusheó, se propone corregirlo. Si ya se pusheó, se informa y no se reescribe la historia sin OK.
   Que la bitácora registre que una decisión la propuso Claude (D-nn provisional) es trazabilidad interna, no autoría: está permitido.
5. **Dependencias, plugins, skills o MCP de terceros:** se proponen con justificación; no se instalan sin OK.
6. **Claves vs IDs:** cada doc de card lleva el ID interno inmutable del gestor en la cabecera.
7. **Reportar fielmente:** si un test falla, se dice con la salida; si algo quedó sin hacer, se dice. Nunca "debería funcionar" sin haberlo corrido. Terminada y entregada son estados distintos.
8. **Secretos:** Claude no lee `.env` reales (bloqueado en `.claude/settings.json`); trabaja con `.env.example`. Si encuentra un secreto en el código o en el historial, informa archivo y línea sin copiar el valor y lo marca 🔴 para rotarlo.

## Protección contra pérdidas irrecuperables

Nada que haga Claude puede dejar al proyecto sin vuelta atrás.

1. **Producción no se toca desde acá.** Claude no tiene credenciales de escritura de producción ni de bases compartidas. Si necesita consultar producción, usa un usuario de solo lectura. Los deploys a producción los hace el pipeline o el usuario, nunca Claude desde la máquina local.
2. **Punto de restauración antes de lo destructivo.** Antes de migraciones, borrados, DROP/TRUNCATE/DELETE masivos, resets de git o del ORM, o reescrituras grandes: `/punto-de-restauracion`, verificado. Sin punto verificado no se ejecuta. (`/rewind` no deshace comandos ni cambios en la base: solo ediciones de archivos.)
3. **Avisar qué se pierde.** Antes de una operación destructiva se muestra qué se va a hacer, qué se perdería si sale mal, el punto de restauración y cómo volver. Se espera OK explícito por operación: un OK no vale para la siguiente.
4. **Preferir lo reversible.** Mover antes que borrar, renombrar antes que pisar, migraciones con `down`, soft-delete en entidades de negocio (pedidos, clientes, pagos), desactivar antes que eliminar código en uso.
5. **Redundancia.** El código vive en git local + GitHub. Cada base tiene backups automáticos, al menos una copia fuera del proveedor principal y una restauración probada (ver `08-SEGURIDAD.md`).
6. **El harness también frena.** `.claude/settings.json` bloquea los comandos destructivos y pide confirmación para migraciones, clientes de base, borrados y push. Es una red, no un permiso: que un comando no esté bloqueado no lo vuelve seguro.

## Precedencia

Este archivo manda sobre cualquier skill o plugin. Si una skill propone algo que choca con estas reglas (correr una migración, cargar horas, commitear, atribuirle el trabajo a una IA, consultar directo al cliente), gana este archivo.

<!-- framework-claude v2.2.0 -->
