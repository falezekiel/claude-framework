# Estándares — {{PROYECTO}}

> Construido midiendo el repo el AAAA-MM-DD, no suponiendo. Se vuelve a medir si el repo cambia mucho.
>
> Con varios repos: las secciones "Punto de partida medido", "Convenciones", "Lo que no se replica" y "Comandos" se repiten una vez por repo (`## backend/`, `## frontend/`…). En los repos del equipo, el punto de partida son sus convenciones documentadas. El Definition of Done es uno solo para todos.

## Punto de partida medido

| Aspecto | Medición | Cómo se midió |
|---|---|---|
| Tests: cantidad, si corren, cobertura | | |
| Tests vacíos o comentados | | |
| Linter / formatter activos | | |
| Tipado estricto / cantidad de `any` | | |
| Manejo de errores (genéricos, catch vacíos) | | |
| Transacciones en escrituras multi-tabla | | |
| Archivos / services más grandes | | |
| Duplicaciones notables | | |
| SQL interpolado | | |
| Secretos en código / backups versionados | | |

## Convenciones que se respetan

(idioma de los nombres, prefijos, casing, sufijos, estructura de carpetas, columnas de auditoría…)

## Lo que no se replica

| Práctica encontrada | Dónde | Qué hacemos en su lugar |
|---|---|---|
| | | |

## Comandos

| Para | Comando |
|---|---|
| Tests | |
| Lint | |
| Typecheck | |
| Build | |
| E2E / API (Playwright) | `npx playwright test` |
| Levantar local | |

## Definition of Done

- [ ] Lo que pide la card está hecho y verificado corriéndolo (no "debería funcionar")
- [ ] Tests nuevos para la lógica nueva; suite completa en verde (o fallas preexistentes documentadas como H-nn)
- [ ] Lint, typecheck y build sin errores nuevos
- [ ] Casos de `PRUEBAS-[CLAVE].md` corridos con `/pruebas-e2e`: en verde y con evidencia en `tasks/evidencias/[CLAVE]/` (los manuales, con el motivo de por qué no se automatizaron)
- [ ] `/code-review` sobre el diff: hallazgos resueltos o registrados
- [ ] `/security-review` si toca auth, pagos, input de usuario, uploads, SQL, secretos o dependencias nuevas
- [ ] Si toca UI: revisado en móvil y escritorio, con teclado, contra `06-DISENO.md`
- [ ] Decisiones (D-nn) y hallazgos (H-nn) registrados
- [ ] Doc de la card, bitácora del día, `00-INDEX` y `05-ENTREGAS` actualizados
