# Changelog

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
- Reglas duras nuevas: commits y push solo a pedido, sin dependencias ni plugins de terceros sin OK, secretos fuera del alcance de Claude.

### Evaluado y descartado

- **claude-mem:** duplica la bitácora, pero opaco, sin versionar, local a una máquina, con telemetría y con un modelo externo leyendo la actividad. La bitácora versionada cumple mejor ese rol.
- **gstack:** se solapa con el flujo propio y tiene soporte mínimo en Windows.
- **superpowers y frontend-design como plugins:** no se instalan. Sus ideas útiles se reescribieron como skills propias.
