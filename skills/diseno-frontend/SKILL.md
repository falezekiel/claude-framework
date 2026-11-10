---
name: diseno-frontend
description: Dirección visual con criterio para interfaces — producto y audiencia primero, plan de tokens en tasks/06-DISENO.md, lista de señales de UI genérica a evitar, piso de accesibilidad y revisión visual del resultado. Usar antes de construir o rediseñar cualquier pantalla, componente visual o landing.
---

# Diseño frontend

El objetivo es una interfaz que parezca pensada para este producto, no salida de una plantilla.

## 1. Entender el producto

Antes de elegir un color: qué es, para quién, y cuál es la tarea principal de la pantalla. La dirección visual sale del mundo del producto (su rubro, sus objetos, sus materiales, su vocabulario, cómo se ve en el mundo físico), no de la moda de las apps. Si no está claro, proponer una lectura y confirmarla.

**Si el proyecto ya tiene un sistema visual**, se respeta y se mejora desde adentro: es una convención del proyecto, igual que en `02-ESTANDARES.md`. Se documenta el existente en vez de inventar otro.

## 2. Plan antes de construir → `tasks/06-DISENO.md`

(plantilla en `~/.claude/skills/iniciar-proyecto/plantillas/06-DISENO.md`)

- **Dirección:** una frase sobre qué tiene que sentir quien lo usa.
- **Color:** 4 a 6 colores con nombre y uso (fondo, superficie, texto, acento, estados). Contraste AA como mínimo.
- **Tipografía:** una familia, o dos claramente distintas, elegidas a propósito. Escala definida (tamaños, pesos, interlineado). Líneas de texto de menos de ~75 caracteres.
- **Espaciado y radios:** una escala, no valores sueltos.
- **Layout:** wireframes ASCII de las pantallas clave, con la jerarquía visible.
- **Movimiento:** dónde hay y para qué.

Una vez escrito, revisarlo contra la lista de abajo y corregir lo genérico. Recién entonces mostrárselo al usuario y esperar el OK. Lo acordado se registra como D-nn.

## 3. Señales de UI genérica a evitar

Cada una es aceptable solo como decisión justificada, nunca por defecto:

- Grilla de tarjetas idénticas con borde redondeado y sombra suave.
- Degradados decorativos de fondo (sobre todo violeta/azul).
- Hero con número gigante + etiqueta + tres estadísticas.
- Una palabra del título resaltada en otro color.
- Etiquetas en mayúsculas sobre cada título que no aportan información.
- Emojis como íconos.
- Todo centrado.
- Vidrio esmerilado, brillos y bordes luminosos como decoración.
- Paletas de moda sin relación con el producto (crema + terracota, negro + un solo neón).
- Animación de entrada en cada elemento.
- Numeración (01, 02, 03) en contenido que no es secuencial.
- Textos de relleno: "Descubrí", "Potenciá", "Llevá tu X al siguiente nivel".

La decoración que no informa se saca. Bordes, divisores y numeración tienen que comunicar algo.

## 4. Piso de calidad (no negociable)

- Mobile-first y responsive: probar en ~375px y en escritorio.
- Foco visible y todo usable con teclado.
- Todos los estados: hover, foco, deshabilitado, carga, vacío, error.
- `prefers-reduced-motion` respetado.
- Imágenes con `alt` útil, formularios con `label`.
- Tokens como variables (CSS custom properties o el sistema del framework): nada de colores ni medidas sueltas en el código.

## 5. Textos

Desde el punto de vista de quien usa, en voz activa y claros. Los errores dicen qué pasó y cómo resolverlo. Los estados vacíos invitan a la acción siguiente.

## 6. Revisar el resultado

Mirarlo de verdad en móvil y escritorio: si el proyecto tiene Playwright, sacar las capturas con `capturar()` de `/pruebas-e2e` (proyectos desktop y mobile) y abrirlas; si no, con el navegador. Compararlo con `06-DISENO.md` y con la lista de señales genéricas. Hacer al menos una vuelta de crítica y ajuste antes de darlo por terminado; las capturas finales quedan como evidencia de la card.
