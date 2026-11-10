---
name: punto-de-restauracion
description: Crea un punto de restauración verificado (código con git, base de datos con dump, archivos fuera de git con copia) antes de cualquier operación destructiva o difícil de revertir — migraciones, borrados, DROP/TRUNCATE/DELETE masivos, resets de git o del ORM, reescrituras grandes. Usar siempre antes de ese tipo de operación, y cuando el usuario pide un respaldo.
argument-hint: "[motivo]"
---

# Punto de restauración

**Antes de algo que no se puede deshacer, se crea un punto desde el cual sí se puede.** Y no cuenta como punto de restauración hasta que se verificó.

Importante: `/rewind` de Claude Code solo deshace ediciones hechas con las herramientas de edición de archivos. **No** deshace lo que se hizo por comandos (borrados con `rm`, cambios en la base, `git reset`). Para eso existe esta skill.

## Cuándo es obligatorio

- Migraciones, seeds, DDL, cualquier escritura masiva en base (DELETE/UPDATE sin un WHERE acotado, TRUNCATE, DROP, reset del ORM).
- Borrar o mover archivos o carpetas, sobre todo si no están en git.
- `git reset --hard`, `git clean`, `git checkout -- .`, `git restore`, rebase, borrar ramas o stashes.
- Refactors grandes o reescritura de archivos enteros.
- Cualquier comando cuyo efecto no se pueda revertir con otro comando.

Si hay duda, se crea: cuesta segundos.

## 1. Código (git)

```bash
bash ~/.claude/skills/punto-de-restauracion/crear-punto.sh "motivo"
```

Guarda el working tree completo (cambios y archivos nuevos no trackeados, respetando `.gitignore`) en `refs/restauracion/<fecha-hora>`. **No toca la rama, el índice ni los archivos**, no crea commits en la rama y no se pushea. Verifica lo guardado e imprime cómo restaurar.

- Listar: `git for-each-ref refs/restauracion --format="%(refname:short) %(contents:subject)"`
- Restaurar un archivo: `git restore --source=refs/restauracion/<id> -- <ruta>`
- Restaurar todo: `git restore --source=refs/restauracion/<id> --worktree -- .` (se propone; se ejecuta con OK)
- Limpieza: los puntos de más de 30 días se borran solo con OK del usuario (`git update-ref -d refs/restauracion/<id>`).

Si el proyecto no es repo git, proponer `git init` antes de seguir. Sin git no hay red para el código.

## 2. Base de datos

Solo bases locales o de desarrollo: Claude no tiene credenciales de escritura de producción (ver `CLAUDE.md`).

- Usar el script del proyecto `npm run db:backup` (o equivalente). Lo define el usuario una vez, así Claude no necesita ver las credenciales. Si no existe, proponer crearlo con el comando del motor:
  - PostgreSQL: `pg_dump -Fc -f <archivo>.dump`
  - MySQL/MariaDB: `mysqldump --single-transaction --routines <base> > <archivo>.sql`
  - SQLite: `sqlite3 <base> ".backup '<archivo>.db'"`
  - MongoDB: `mongodump --archive=<archivo>.archive`
- Destino: `.respaldos/` en la raíz del proyecto (en `.gitignore`), con fecha-hora y motivo en el nombre.
- **Verificar** que el archivo exista, no esté vacío y sea legible: `pg_restore --list`, las primeras líneas del `.sql`, `sqlite3 <archivo> "PRAGMA integrity_check"`, `mongorestore --dryRun`. Sin verificación no hay punto de restauración.
- Restaurar: `npm run db:restore` o el comando del motor, siempre con OK.

## 3. Archivos fuera de git

Lo que está ignorado por git (uploads locales, configuraciones, archivos generados que costó producir) y se va a tocar: copiarlo antes a `.respaldos/AAAAMMDD-HHMMSS-<motivo>/`.

## 4. Avisar y registrar

Antes de la operación, mostrarle al usuario:

- qué se va a hacer y contra qué (archivo, base, ambiente)
- qué se pierde si sale mal
- el punto de restauración creado y el comando exacto para volver

Recién ahí pedir el OK. **Un OK vale para una operación**, no para las siguientes.

Después, en la bitácora del día: el id del punto, qué cubre y cómo restaurar.

## Lo que esto no cubre

Producción, servicios externos (emails enviados, cobros, APIs de terceros) y todo lo que esté fuera de esta máquina. Para eso: Claude no opera en producción, y los efectos externos se prueban en el sandbox del proveedor.
