import { test, type Page } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

// Fecha local (no UTC) para que la carpeta coincida con el día de trabajo.
const hoy = new Date().toLocaleDateString('sv-SE'); // AAAA-MM-DD

const CLAVES_SENSIBLES = /token|password|passwd|secret|authorization|cookie|api[-_]?key/i;

function carpetaEvidencia(clave: string): string {
  const dir = path.join('tasks', 'evidencias', clave, hoy);
  fs.mkdirSync(dir, { recursive: true });
  return dir;
}

function redactar(valor: unknown): unknown {
  if (Array.isArray(valor)) return valor.map(redactar);
  if (valor && typeof valor === 'object') {
    return Object.fromEntries(
      Object.entries(valor).map(([k, v]) => [k, CLAVES_SENSIBLES.test(k) ? '[REDACTADO]' : redactar(v)]),
    );
  }
  return valor;
}

/** Captura de página completa, una por proyecto (desktop/mobile), adjunta al reporte HTML. */
export async function capturar(page: Page, clave: string, nombre: string): Promise<string> {
  const proyecto = test.info().project.name;
  const archivo = path.join(carpetaEvidencia(clave), `${nombre}-${proyecto}.png`);
  await page.screenshot({ path: archivo, fullPage: true });
  await test.info().attach(nombre, { path: archivo, contentType: 'image/png' });
  return archivo;
}

/** Guarda una respuesta (o request + response) como JSON, con datos sensibles tapados. */
export function guardarRespuesta(clave: string, nombre: string, datos: unknown): string {
  const archivo = path.join(carpetaEvidencia(clave), `${nombre}.json`);
  fs.writeFileSync(archivo, JSON.stringify(redactar(datos), null, 2));
  return archivo;
}
