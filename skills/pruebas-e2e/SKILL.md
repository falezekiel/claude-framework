---
name: pruebas-e2e
description: Pruebas end-to-end y de API con Playwright que dejan evidencia (capturas por dispositivo, respuestas de API, trazas) en tasks/evidencias/ enlazada desde PRUEBAS-[CLAVE].md. Usar para verificar una card con UI o API antes de cerrarla, para preparar una demo, o cuando el usuario pide evidencia de que algo funciona.
argument-hint: "[CLAVE]"
---

# Pruebas E2E con evidencia

La evidencia responde "¿cómo sabemos que funciona?" con algo que se puede mostrar: una captura, una respuesta guardada, una traza. Sirve para cerrar la card, para el comentario del gestor y para las demos.

Plantillas: `${CLAUDE_SKILL_DIR}/../iniciar-proyecto/plantillas/e2e/` (`playwright.config.ts` y `evidencia.ts`).

## 1. Preparar (una vez por proyecto)

Si el proyecto todavía no tiene Playwright:

1. Proponer la instalación (paquete oficial de Microsoft en npm, solo Chromium) con los comandos exactos, y **esperar el OK** (regla dura de dependencias):
   ```
   npm i -D @playwright/test
   npx playwright install chromium
   ```
   Si el repo no es Node, proponer una carpeta `e2e/` con su propio `package.json`, o Playwright para Python si el equipo ya trabaja en Python.
2. Copiar `playwright.config.ts` a la raíz y `evidencia.ts` a `e2e/`. Ajustar `baseURL` y `webServer` al proyecto.
3. Agregar a `.gitignore`: `test-results/`, `playwright-report/`, `playwright/.auth/`.
4. Anotar el comando en `02-ESTANDARES.md` (sección Comandos) y registrar la decisión como D-nn.

## 2. De los casos a los tests

Cada fila de `tasks/PRUEBAS-[CLAVE].md` es un test en `e2e/[clave].spec.ts`, cuyo nombre empieza con el número de caso: `[CLAVE] #1 camino feliz`. Se cubre lo que aplique: camino feliz, input inválido, sin permisos, vacío, error.

- **UI:** localizadores por rol, label o texto (`getByRole`, `getByLabel`, `getByText`), no por clases CSS. Esperas automáticas de Playwright; nada de `waitForTimeout`.
- **API:** fixture `request`; se valida el status y el cuerpo.
- **Datos:** solo datos de prueba. Las credenciales salen de variables de entorno, nunca del código. Ninguna captura debe mostrar datos personales reales.

```ts
import { test, expect } from '@playwright/test';
import { capturar, guardarRespuesta } from './evidencia';

const CLAVE = 'PROJ-12';

test(`${CLAVE} #1 camino feliz: agregar al carrito`, async ({ page }) => {
  await page.goto('/productos/ejemplo');
  await page.getByRole('button', { name: 'Agregar al carrito' }).click();
  await expect(page.getByRole('status')).toContainText('Agregado');
  await capturar(page, CLAVE, '01-agregado-al-carrito');
});

test(`${CLAVE} #2 API: stock insuficiente`, async ({ request }) => {
  const res = await request.post('/api/carrito', { data: { sku: 'SIN-STOCK', cantidad: 1 } });
  guardarRespuesta(CLAVE, '02-stock-insuficiente', { status: res.status(), body: await res.json() });
  expect(res.status()).toBe(409);
});
```

## 3. Evidencia

Se captura **en el momento que prueba el criterio**, no solo cuando algo falla:

```
tasks/evidencias/[CLAVE]/AAAA-MM-DD/
  01-agregado-al-carrito-desktop.png
  01-agregado-al-carrito-mobile.png
  02-stock-insuficiente.json
```

- `capturar()` guarda una captura por proyecto (desktop/mobile) y la adjunta al reporte HTML.
- `guardarRespuesta()` guarda la respuesta y tapa automáticamente tokens, passwords, cookies y API keys.
- **Se versionan** las capturas y los JSON finales: son documentación y pesan poco.
- **No se versionan** las trazas ni los videos: quedan en `test-results/` y se adjuntan al gestor solo si hacen falta (por ejemplo, para mostrar un bug).

## 4. Correr y registrar

1. Correr `npx playwright test e2e/[clave].spec.ts` y leer la salida completa.
2. **Abrir las capturas** (leerlas como imagen) antes de darlas por buenas: tienen que mostrar lo que dicen mostrar.
3. Completar la tabla de `PRUEBAS-[CLAVE].md`: resultado (✅/❌), fecha y link a la evidencia.
4. Si algo falla, se reporta con la salida y la traza (`npx playwright show-trace <ruta>`); si la causa no es obvia, `/depurar`. Nunca se "arregla" un test aflojando la aserción.

## 5. Dónde se usa la evidencia

- `/cerrar-card`: va linkeada en el comentario del gestor y en `05-ENTREGAS.md`.
- Demos: las capturas del día respaldan el `DEMO-*.md`.
- Regresión: los tests quedan en `e2e/` y se vuelven a correr en las cards siguientes.

## Opcional: navegación interactiva (Playwright MCP)

Para que Claude explore la app en vivo (reproducir un bug, recorrer un flujo), existe el MCP oficial de Microsoft `@playwright/mcp`. Es otra instalación: se propone y solo se instala con OK. Lo que se descubra navegando se convierte en un test de `e2e/`; la navegación interactiva por sí sola no es evidencia, porque no se puede reproducir.
