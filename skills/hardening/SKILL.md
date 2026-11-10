---
name: hardening
description: Endurece la seguridad de un proyecto — revisa la línea base de la app (secretos, dependencias, headers, cookies, auth, validación, pagos y webhooks, errores, datos, repo de GitHub) y del propio Claude Code (permisos), y la registra en tasks/08-SEGURIDAD.md. Usar al iniciar un proyecto, antes de cada salida a producción, o cuando el usuario pide revisar o endurecer la seguridad.
argument-hint: "[inicial | pre-produccion]"
---

# Hardening

`/security-review` revisa los **cambios** de una card. Esta skill revisa la **línea base** del proyecto entero: las defensas y la configuración que tienen que estar siempre, aunque ninguna card las toque.

Resultado: `tasks/08-SEGURIDAD.md` (plantilla en `${CLAUDE_SKILL_DIR}/../iniciar-proyecto/plantillas/08-SEGURIDAD.md`), con cada punto en ✅ / ❌ / N/A, cómo se verificó y, si falta, la card o P-nn que lo resuelve.

## Cuándo

- **Inicial:** al arrancar el proyecto. Muchos puntos se resuelven con configuración desde el día uno y salen mucho más caros después.
- **Pre-producción:** antes de cada salida a producción o entrega importante. Lo que esté en ❌ se informa antes de entregar, no después.
- **Cambio estructural:** nuevo proveedor de pagos, nuevo sistema de auth, cambio de hosting.

## Reglas

- **Medir, no suponer:** cada ✅ dice cómo se verificó (comando, archivo, respuesta HTTP). Si no se pudo verificar, no es ✅.
- **Diagnosticar y proponer, no reescribir:** los arreglos se hacen como cards o tareas de un plan, con el flujo normal. Lo que se resuelve con una línea de configuración se puede proponer en el momento.
- **Infraestructura y repo remoto** (hosting, DNS, configuración de GitHub): se propone el cambio; lo hace o lo aprueba el usuario.
- **Nunca copiar un secreto** al chat ni a un doc. Si aparece uno, se informa archivo y línea, y se marca 🔴 para rotarlo (borrarlo del código no alcanza si ya está en el historial).

## 1. Claude Code (el entorno de trabajo)

- `.claude/settings.json` del proyecto desde `plantillas/claude-settings.json`:
  - **deny:** lectura de `.env` reales y claves; `rm -rf`, force push, `dropdb`, borrado de volúmenes de Docker, `terraform destroy`; el modo que saltea permisos (`disableBypassPermissionsMode`).
  - **ask:** cualquier `rm` o `Remove-Item`, `git push`, `reset --hard`, `clean`, `restore`, rebase, borrar ramas; instalar dependencias; clientes de base (`psql`, `mysql`, `mongosh`, `sqlite3`); comandos de migración de los ORM más comunes. Agregar los del stack del proyecto.
  - En Windows, las reglas `Bash(...)` no cubren la herramienta PowerShell: los comandos equivalentes van como `PowerShell(...)`.
- **Sin atribución a ninguna IA** (regla dura del `CLAUDE.md`):
  - `.claude/settings.json` tiene `"attribution": { "commit": "", "pr": "", "sessionUrl": false }`.
  - El hook está activo: `git config core.hooksPath` devuelve `.githooks`, y `.githooks/commit-msg` existe y es ejecutable.
  - Para verificar el hook, se prueba en un repo temporal, nunca en el del proyecto. Se commitea un mensaje con `Co-Authored-By: Claude <noreply@anthropic.com>` y el hook tiene que rechazarlo.
  - Historia limpia: `git log --all -i -E --format='%h %an <%ae> %s' --grep='co-authored-by:.*(claude|anthropic|copilot|openai|chatgpt|gemini|cursor)' --grep='generated (with|by) .*(claude|copilot|chatgpt|gemini|cursor)' --grep='claude-session:'`. Revisar también los autores: `git log --all --format='%an <%ae>' | sort -u`.
  - Lo que aparezca se informa. Si ya está pusheado, no se reescribe la historia sin OK.
- Claude trabaja con `.env.example` (nombres de variables, sin valores). Si no existe, se crea.
- `.respaldos/` en `.gitignore`, para los puntos de restauración de base y archivos.
- Si se trabaja en Linux, macOS o WSL2, evaluar `sandbox.enabled` en settings, que limita a nivel de sistema operativo lo que pueden leer y escribir los comandos.
- Estas reglas son una red, no una garantía: la documentación de Claude Code aclara que las reglas de permisos no son una barrera de seguridad (por ejemplo, un deny de `Read` no frena un `cat` hecho con otro comando). Lo que de verdad protege es que en la máquina de desarrollo no haya secretos ni credenciales de escritura de producción.

## 2. Secretos

- `.gitignore` cubre `.env*` (salvo `.env.example`), claves (`*.pem`, `*.key`) y dumps de base.
- Buscar secretos en el código: `git grep -nIE "(api[_-]?key|secret|passw(or)?d|token)[\"']?\s*[:=]\s*[\"'][^\"']{8,}"`.
- Buscar en el historial: `git log -p --all -G "<mismo patrón>"`.
- Revisar la configuración del front: todo lo que va al bundle del navegador es público.
- Secretos distintos por ambiente; los de producción viven solo en el hosting.

## 3. Dependencias

- `npm audit --omit=dev` (o el equivalente del stack). Las críticas y altas se resuelven con una card o se aceptan con una D-nn.
- Lockfile versionado.
- Para piezas sensibles (auth, pagos, criptografía), solo librerías mantenidas y conocidas.

## 4. HTTP y navegador

- HTTPS obligatorio + `Strict-Transport-Security`.
- Headers: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, `frame-ancestors` (o `X-Frame-Options`), `Permissions-Policy`. Verificar con `curl -sI <url>`.
- Cookies de sesión: `HttpOnly`, `Secure`, `SameSite`.
- CORS: orígenes explícitos, nunca `*` con credenciales.

## 5. Autenticación y autorización

- Passwords con hash lento (bcrypt o argon2); nunca en texto plano ni con hash rápido.
- Rate limiting y bloqueo progresivo en login, registro y recuperación de contraseña.
- Autorización verificada en el servidor en cada endpoint, no solo ocultando botones. Probar el acceso a recursos de otro usuario cambiando IDs (IDOR).
- Panel admin con rutas protegidas; idealmente 2FA.
- Recuperación de contraseña con tokens de un solo uso y con vencimiento.

## 6. Entrada y salida de datos

- Validación con esquema en el servidor (tipos, rangos, largos), aunque el front también valide.
- Queries parametrizadas u ORM; nada de SQL interpolado.
- Salida escapada contra XSS; revisar `innerHTML`, `bypassSecurityTrust*` y `dangerouslySetInnerHTML`.
- Uploads: tipo y tamaño validados en el servidor, nombre regenerado, guardados fuera de rutas ejecutables.

## 7. Pagos y lógica de negocio

- Precio y total se calculan en el servidor; nunca se confía en el monto que manda el front.
- Webhooks del proveedor de pagos: firma verificada, procesamiento idempotente, y el estado del pedido se confirma consultando al proveedor.
- Stock y cupones con control de concurrencia (transacción o bloqueo).
- Nunca se guardan datos de tarjeta: los maneja el proveedor.

## 8. Errores y logs

- En producción no se muestran stack traces ni mensajes internos.
- Logs sin passwords, tokens ni datos de tarjeta; los datos personales, al mínimo.
- Los eventos de seguridad (logins fallidos, accesos denegados) quedan registrados.

## 9. Datos e infraestructura

- La app usa un usuario de base con mínimos privilegios, no el admin.
- **Claude no tiene credenciales de escritura de producción** en esta máquina. Si necesita consultar producción, un usuario de solo lectura (o una réplica).
- Scripts `db:backup` y `db:restore` en el proyecto, revisados por el usuario, para que Claude cree puntos de restauración sin ver credenciales.
- Backups automáticos en cada ambiente con datos reales; restauración a un punto en el tiempo (PITR) si el proveedor la ofrece.
- **Redundancia:** al menos una copia del backup fuera del proveedor principal (otra cuenta, otro proveedor o almacenamiento offline). Un backup que vive en la misma cuenta que la base se pierde junto con ella.
- **Una restauración probada**, con fecha: un backup que nunca se restauró no está verificado. Repetir la prueba periódicamente.
- Migraciones reversibles (`down`) y soft-delete en entidades de negocio.
- Ambientes separados: staging no usa datos reales sin anonimizar.

## 10. Repositorio en GitHub

Funciones nativas de GitHub, no herramientas de terceros:

- Secret scanning y push protection activados.
- Dependabot alerts activado.
- Rama principal protegida (sin push directo ni force push).
- Repo privado, salvo decisión explícita.

## Cierre

- Resumen: cuántos ✅, y los ❌ por severidad (🔴 antes de producción / 🟡 pronto / 🟢 mejora).
- Cada ❌ → card propuesta o P-nn. Aceptar un riesgo es una D-nn con quién lo aceptó, y va a "Riesgos aceptados".
- En pre-producción: si queda algún 🔴, se dice claramente antes de entregar y queda anotado en `05-ENTREGAS.md`.
- Bitácora del día.
