---
name: planificar-card
description: Entiende una card antes de codear — aclara lo que falta, propone enfoques, escribe el diseño y un plan de tareas chicas y verificables en el doc de la card, y espera aprobación. Usar al empezar cualquier card o funcionalidad nueva, antes de escribir código.
argument-hint: "[CLAVE]"
---

# Planificar card

**No se escribe código de producción hasta que el usuario apruebe el plan.**

## 1. Contexto

Leer el doc de la card (`tasks/[CLAVE]-*.md`), la fuente funcional que referencia, las D-nn y P-nn que la afectan, y el código que va a tocar. Si la card está bloqueada por un 🔴, decirlo antes de seguir.

## 2. Aclarar

- Preguntas **de a una**, preferentemente con opciones. Solo las que cambian el diseño.
- Las preguntas técnicas se le hacen al usuario.
- Las preguntas **de negocio** no se contestan inventando: se crea un P-nn para el líder técnico, se propone una suposición provisional marcada como tal y se sigue.

## 3. Enfoques

Si hay más de una forma razonable, presentar 2 o 3 con sus trade-offs y una recomendación. Preferir la más simple que cumple lo pedido: nada que la card no pida. La elegida, si no es obvia, se registra como D-nn.

## 4. Diseño

Escribirlo en la sección **Diseño** del doc de la card: qué piezas se tocan o se crean, la responsabilidad de cada una, datos y contratos, manejo de errores, cómo se prueba. Si es largo, mostrarlo por partes y validar cada una.

Si toca UI, pasar antes por `/diseno-frontend`.

## 5. Plan

En la sección **Plan** del doc de la card, tareas chicas (de 2 a 10 minutos cada una), y cada una con:

- archivos que toca
- el test que la demuestra (o por qué no lleva test)
- cómo se verifica (comando y resultado esperado)

Orden: primero lo que destraba lo demás. Las migraciones van como tarea explícita marcada **"requiere OK"** (regla dura). Si la card tiene UI o API, crear `tasks/PRUEBAS-[CLAVE].md` con los casos que demuestran que cumple lo pedido (camino feliz, inválido, sin permisos, vacío/error). Esos casos son los que después `/pruebas-e2e` automatiza y respalda con evidencia; los que no se pueden automatizar se marcan como manuales, con el motivo.

## 6. Aprobación

Mostrar el resumen del plan y esperar el OK. Con el OK: estado de la card a **En curso** (doc + `00-INDEX`) y seguir con `/ejecutar-card`.

## Escala

El proceso se ajusta al tamaño. Un fix chico puede tener un diseño de dos líneas y un plan de tres tareas. Lo que no se saltea nunca: entender antes de tocar y dejar el plan escrito.
