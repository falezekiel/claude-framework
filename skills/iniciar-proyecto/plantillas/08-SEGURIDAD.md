# Seguridad — {{PROYECTO}}

> Línea base de seguridad del proyecto. La completa `/hardening` (al iniciar y antes de cada salida a producción). Cada ✅ dice cómo se verificó; cada ❌ tiene card o P-nn.

**Última revisión:** AAAA-MM-DD · (inicial / pre-producción)

| Área | Punto | Estado | Cómo se verificó | Si falta: card / P-nn |
|---|---|---|---|---|
| Claude Code | `.claude/settings.json` bloquea `.env`, secretos y comandos destructivos | | | |
| Claude Code | Sin credenciales de escritura de producción en la máquina de desarrollo | | | |
| Claude Code | Sin atribución a IAs: `attribution` apagado, hook `commit-msg` activo, historia sin coautorías de IA | | | |
| Claude Code | `.respaldos/` en `.gitignore` y scripts `db:backup` / `db:restore` | | | |
| Secretos | `.gitignore` cubre `.env*`, claves y dumps | | | |
| Secretos | Sin secretos en código ni en historial de git | | | |
| Secretos | Nada sensible en el bundle del front | | | |
| Dependencias | Audit sin críticas/altas abiertas | | | |
| HTTP | HTTPS + HSTS | | | |
| HTTP | CSP, nosniff, Referrer-Policy, frame-ancestors | | | |
| HTTP | Cookies HttpOnly, Secure, SameSite | | | |
| HTTP | CORS con orígenes explícitos | | | |
| Auth | Passwords con bcrypt/argon2 | | | |
| Auth | Rate limiting en login, registro y recuperación | | | |
| Auth | Autorización en servidor por endpoint (sin IDOR) | | | |
| Auth | Panel admin protegido | | | |
| Entrada | Validación con esquema en servidor | | | |
| Entrada | Queries parametrizadas | | | |
| Entrada | Salida escapada (XSS) | | | |
| Entrada | Uploads validados y fuera de rutas ejecutables | | | |
| Pagos | Precio y total calculados en servidor | | | |
| Pagos | Webhooks con firma verificada e idempotentes | | | |
| Pagos | Stock y cupones con control de concurrencia | | | |
| Errores | Sin stack traces en producción | | | |
| Logs | Sin passwords, tokens ni datos de tarjeta | | | |
| Datos | Usuario de base con mínimos privilegios | | | |
| Datos | Backups automáticos (+ PITR si el proveedor lo ofrece) | | | |
| Datos | Copia del backup fuera del proveedor principal | | | |
| Datos | Restauración probada (fecha de la última prueba) | | | |
| Datos | Migraciones reversibles y soft-delete en entidades de negocio | | | |
| GitHub | Secret scanning + push protection | | | |
| GitHub | Dependabot alerts | | | |
| GitHub | Rama principal protegida | | | |

Estados: ✅ cumple · ❌ falta (🔴 antes de producción / 🟡 pronto / 🟢 mejora) · N/A no aplica (con motivo)

## Riesgos aceptados

| Riesgo | Por qué se acepta | Quién lo aceptó (D-nn) | Revisar el |
|---|---|---|---|
