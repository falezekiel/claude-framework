---
name: depurar
description: Depuración sistemática por causa raíz — reproducir, aislar, una hipótesis por vez, test que reproduce el bug y registro del hallazgo. Usar ante cualquier error, test que falla o comportamiento inesperado cuya causa no sea obvia, antes de proponer un arreglo.
---

# Depurar

**No se arregla nada sin entender la causa.** Probar cambios al azar hasta que algo pase tapa el problema y suele romper otra cosa.

## 1. Reproducir

- Leer el error **completo**: mensaje, stack trace, logs. La respuesta suele estar ahí.
- Reproducirlo de forma confiable, con los pasos mínimos. Si no se reproduce, juntar más datos antes de seguir.

## 2. Aislar

- ¿Qué cambió? `git diff`, `git log`, dependencias, `.env`, datos.
- Buscar algo parecido que sí funcione y comparar diferencia por diferencia.
- Si hay varias capas (front → API → servicio → base), instrumentar los bordes para ver en cuál se rompe el dato.
- Seguir el valor malo hacia atrás hasta su origen: el arreglo va ahí, no donde explota.

## 3. Hipótesis

Una sola por vez y explícita: "creo que X porque Y". Probarla con el cambio más chico posible. Si no se confirma, se descarta (se revierte el cambio) y se vuelve al paso 2 con lo aprendido. No se apilan arreglos.

## 4. Arreglar

1. Test que reproduce el bug y falla.
2. Arreglo en el origen.
3. Ese test en verde + suite relacionada en verde.

## Freno

Después de **tres intentos fallidos**, parar. Probablemente el problema es de diseño o falta información: contarle al usuario qué se probó, qué se descartó y qué se sospecha, antes de un cuarto intento.

## Registro

Siempre un **H-nn** en `04-BITACORA.md`: síntoma, causa real, dónde, qué se hizo. Si la causa era algo del ambiente o de los datos que no estaba documentado, eso es lo más valioso del registro.
