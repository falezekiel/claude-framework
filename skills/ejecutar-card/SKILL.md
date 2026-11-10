---
name: ejecutar-card
description: Implementa el plan aprobado de una card tarea por tarea, con tests primero y verificación real antes de dar algo por hecho. Usar cuando hay un plan aprobado en el doc de la card y toca escribir código.
argument-hint: "[CLAVE]"
---

# Ejecutar card

Requiere un plan aprobado en el doc de la card. Si no lo hay, primero `/planificar-card`.

## Por cada tarea del plan

1. **Test que falla.** Escribir el test de lo que la tarea agrega o corrige. Correrlo y ver que falla **por el motivo esperado** (no por un import roto o un typo).
2. **Código mínimo** para que pase. Nada que la tarea no pida.
3. **Correrlo y ver que pasa**, junto con los tests relacionados.
4. **Refactor** si hace falta, con los tests en verde.
5. Marcar la tarea `[x]` en el plan y anotarla en la bitácora del día.

**Sin test, cuando corresponde:** configuración, estilos visuales, scripts de una sola vez, o partes del sistema sin infraestructura de tests (según `02-ESTANDARES.md`). Se dice explícitamente y se verifica de otra forma (correrlo, mirarlo, llamarlo). La lógica de negocio nueva lleva test siempre: si el repo no tiene infraestructura, se escribe como función pura y se testea aislada.

## Verificar antes de afirmar

Antes de decir "listo", "anda" o "pasa": correr el comando, leer la salida completa y citar el resultado. Nada de "debería funcionar". Si algo falla, se dice con la salida.

## Cuando el plan no alcanza

Si aparece algo que el plan no contemplaba (el código no es como se pensaba, un cambio de alcance, una dependencia inesperada): parar, explicar y ajustar el plan con el usuario. No improvisar en silencio.

- Algo no documentado → H-nn en el momento.
- Una decisión nueva → D-nn.
- Una duda de negocio → P-nn, suposición provisional y seguir si no bloquea.
- Un error sin causa obvia → `/depurar`.

## Subagentes

Las tareas independientes y bien especificadas pueden delegarse a subagentes, con todo el contexto que necesitan en el pedido (archivos, estándares, criterio de verificación). Lo que devuelven se revisa y se verifica corriéndolo; no se acepta a ciegas.

## Reglas duras

- Migraciones, seeds estructurales o DDL: `/punto-de-restauracion` + preview + base destino + esperar OK.
- Cualquier operación destructiva (borrados, resets, escrituras masivas, reescrituras grandes): `/punto-de-restauracion` primero, avisar qué se pierde y esperar OK.
- Nada de commits ni push sin que el usuario lo pida.
- Dependencias nuevas: se proponen con justificación, no se instalan sin OK.

## Al terminar el plan

Si la card tiene `PRUEBAS-[CLAVE].md`, correr `/pruebas-e2e` para automatizar los casos y dejar la evidencia. Después, `/cerrar-card`.
