# Flujo con el gestor — {{GESTOR}}

## Acceso de Claude

{{MCP / CLI / manual}}. Si es manual, Claude prepara el texto exacto y el usuario lo pega.

## Estados

| Estado en el gestor | Cuándo se usa | Equivale en `05-ENTREGAS` |
|---|---|---|
| | | |

## Cierre de card, paso a paso

1. **Claude propone:** qué card es, borrador del comentario, a qué estado la pasaría (+ horario sugerido si hay horas).
2. **Claude pregunta y espera.** Si hay horas: «¿Cuántas horas cargo en [CARD]? ¿Y en qué horario?» No avanza sin respuesta.
3. **El usuario decide:** horas y horario, y aprueba o corrige comentario y estado.
4. **Claude ejecuta en orden:** comentario → worklog (si aplica) → transición de estado.
5. **Claude confirma:** card, estado nuevo, horas, fecha/horario, ID del worklog.

## Formato del comentario

```
Qué se hizo: …
Decisiones: D-nn (si hubo)
Pendiente / fuera de alcance: … (P-nn)
Cómo probarlo: PRUEBAS-[CLAVE].md o pasos
Evidencia: tasks/evidencias/[CLAVE]/AAAA-MM-DD/ (adjuntar las capturas clave si el gestor lo permite)
```

## Horas

- Herramienta: {{Tempo / ClickUp / no aplica}}
- Cuota diaria: {{CUOTA}}
- Franjas: {{FRANJAS}}
- El día cierra en la cuota exacta; la última card del día absorbe el remanente.
- **Las horas las decide el usuario. Claude nunca las calcula ni las estima.**
