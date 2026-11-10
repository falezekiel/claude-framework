---
name: inicio-dia
description: Rutina de inicio de sesión en proyectos con carpeta tasks/ — lee decisiones, hallazgos y pendientes bloqueantes antes de tocar código y propone el plan del día. Usar al empezar una sesión de trabajo, o cuando el usuario dice "arrancamos", "buen día" o pregunta en qué quedamos.
---

# Inicio del día

En este paso no se toca código.

1. **Leer:**
   - `tasks/04-BITACORA.md`: decisiones vigentes (saltear las revertidas) y hallazgos.
   - `tasks/07-PENDIENTES.md`: todos los 🔴 y 🟡 abiertos.
   - El último archivo de `tasks/bitacora/`: en qué quedó la sesión anterior.
   - `tasks/00-INDEX.md`: estado de las cards y orden de ataque.
2. **Crear** `tasks/bitacora/AAAA-MM-DD.md` de hoy si no existe (plantilla en `${CLAUDE_SKILL_DIR}/../iniciar-proyecto/plantillas/BITACORA-DIA.md`).
3. **Si hay git**, mirar `git status`: si quedaron cambios sin commitear de la sesión anterior, mencionarlos.
4. **Reportar en pocas líneas:**
   - **Bloqueos:** cada 🔴 abierto, qué card bloquea y desde cuándo está abierto.
   - **Ayer:** en qué quedó (card y paso del plan).
   - **Hoy:** qué se propone atacar, siguiendo el orden de `00-INDEX` y salteando lo bloqueado. Si un 🔴 bloquea lo que se iba a hacer, decirlo y proponer el reorden.
   - **Para empujar:** los 🟡 que se acercan al camino crítico, con el texto de la consulta listo para el líder técnico.
5. **Esperar** que el usuario confirme el plan del día.
