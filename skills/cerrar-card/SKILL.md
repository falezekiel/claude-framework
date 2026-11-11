---
name: cerrar-card
description: Cierra una card — verificación contra el Definition of Done, /code-review sobre el diff, /security-review si toca superficie sensible, actualización de docs y propuesta de cierre en el gestor, preguntando siempre las horas. Usar cuando se terminó el plan de una card o el usuario pide cerrarla.
argument-hint: "[CLAVE]"
---

# Cerrar card

## 1. Verificar

Correr tests, lint, typecheck y build (comandos de `02-ESTANDARES.md`) en cada repo que tocó la card, y recorrer el Definition of Done. Mostrar la evidencia. Si algo falla, se informa con la salida y no se sigue cerrando como si nada.

Si la card tiene `PRUEBAS-[CLAVE].md`: los casos tienen que estar corridos con `/pruebas-e2e` (si no, correrlo ahora), en verde y con su evidencia en `tasks/evidencias/[CLAVE]/`. Si después hubo cambios de código, se vuelven a correr para que la evidencia corresponda a lo que se entrega.

## 2. Code review

Invocar `/code-review` sobre los cambios de la card (nivel por defecto). `/code-review` y `/security-review` trabajan sobre el diff de un repo: con varios repos, se corren una vez por cada repo tocado, apuntando a ese repo. Los hallazgos confirmados se corrigen; los que no se corrigen ahora se registran (H-nn o P-nn) y se mencionan en el comentario del gestor.

## 3. Security review (condicional)

Invocar `/security-review` si la card toca alguno de estos puntos:

- autenticación, sesiones, roles o permisos
- pagos, precios, montos, cupones, stock
- input de usuario: formularios, query params, APIs expuestas, webhooks
- uploads o manejo de archivos
- SQL o queries armadas a mano
- secretos, `.env`, configuración de CORS, CSP o cookies
- dependencias nuevas

Si no aplica, decir por qué en una línea. Los hallazgos sin resolver van como H-nn, y como P-nn si requieren la decisión de alguien.

## 4. Documentación

- Doc de la card: estado **Terminada**, plan completo, notas.
- `bitacora/` del día: qué se hizo.
- `00-INDEX.md`: estado.
- `05-ENTREGAS.md`: terminada con fecha y link a la evidencia. **No** figura como entregada hasta que esté donde el cliente la ve.
- Si hay git: proponer el mensaje de commit de cada repo tocado, con la convención de ese repo (la del equipo, si es suyo). Commitear solo si el usuario lo pide. Si hay PRs, uno por repo, siguiendo el flujo de su dueño. El comentario del gestor lista todos.
- Sin atribución a ninguna IA, en ninguna forma (regla dura del `CLAUDE.md`): ni `Co-Authored-By` u otros trailers, ni "Generated with…", ni links a sesiones. Esto vale para el commit, la descripción del PR, el comentario en el gestor y el CHANGELOG. Antes de mostrar cualquiera de esos textos, revisarlo.

## 5. Proponer el cierre en el gestor

Mostrar:

- card (clave + ID interno)
- borrador del comentario (formato de `03-FLUJO-GESTOR.md`), con la evidencia: qué capturas adjuntar y la ruta de la carpeta
- estado destino
- si hay horas: horario sugerido según las franjas y lo ya cargado hoy

## 6. Horas (si el proyecto las registra)

Preguntar textual: **«¿Cuántas horas cargo en [CARD]? ¿Y en qué horario?»** y esperar la respuesta.

Nunca calcular, estimar ni deducir horas a partir del trabajo visible. Si hay cuota diaria y es la última card del día, mostrar el remanente para que el usuario decida.

## 7. Ejecutar (con aprobación)

Orden: comentario → worklog (si aplica) → transición de estado. Si Claude no tiene acceso al gestor, entregar el texto listo para pegar.

## 8. Confirmar

Card, estado nuevo, horas, fecha/horario e ID del worklog.
