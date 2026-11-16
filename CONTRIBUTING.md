# Contribuir

Gracias por querer mejorar el framework. Esta guía explica qué tipo de cambios encajan, cómo probarlos y cómo se publican.

## Antes de empezar

- **Cambios grandes** (una skill nueva, un cambio en el flujo de una card, una regla dura nueva o distinta): abrí primero un issue para discutirlo. Así no invertís tiempo en algo que después no entra.
- **Arreglos chicos** (un error, una instrucción ambigua, un caso que una skill no contempla): PR directo.

## Qué cambios encajan

- **Escrito a mano y sin dependencias de terceros.** El framework no instala ni depende de otros plugins, paquetes o servicios. Si una skill propone instalar algo en el proyecto del usuario, lo hace con OK explícito, como ya hacen `/pruebas-e2e` y `/hardening`.
- **Las reglas duras no se aflojan.** Commits solo a pedido, ninguna IA como autora, OK para migraciones y operaciones destructivas, horas siempre del usuario, secretos fuera del alcance de Claude. Se pueden hacer más claras o más estrictas. Si creés que una tiene que cambiar, abrí un issue.
- **Nada atado a un proyecto, cliente o empresa.** Los ejemplos usan nombres genéricos.
- **Instrucciones verificables.** Cada paso dice qué hacer y cómo se comprueba que se hizo, no solo una intención.
- **Corto.** Cada línea de una skill se carga en el contexto de Claude: si algo no cambia lo que Claude hace, sobra.

## Idioma y estilo

En español y con el tono del resto de los archivos: frases cortas, en segunda persona o impersonal, sin relleno. Los términos técnicos que Claude conoce en inglés (*root cause*, *Definition of Done*, *end-to-end*) se dejan en inglés o con el original al lado.

## Cómo probar un cambio

1. Instalá tu copia como skills personales: `.\instalar.ps1` (Windows) o `./instalar.sh` (macOS/Linux). Si tenés el framework instalado como plugin, desactivalo mientras probás, para no tener cada skill dos veces.
2. Probá la skill que cambiaste en un proyecto de prueba, no en uno real. Cubrí el caso que motivó el cambio y al menos un caso que ya funcionaba.
3. Si tocaste el hook `commit-msg`, corré `bash pruebas/commit-msg.sh` y agregá los casos nuevos a ese archivo.
4. Si tocaste un script (`.sh`, `.ps1`), probalo en Windows o en macOS/Linux, el que tengas, y decí en el PR en cuál.

## Commits y PRs

- Mensajes en español que digan qué cambia y por qué.
- **Ninguna IA como autora ni coautora:** sin `Co-Authored-By`, `Generated with…` ni links a sesiones, en los commits ni en la descripción del PR. Usar IA para escribir el cambio está bien; atribuírselo, no. Un chequeo automático rechaza el PR si encuentra alguna atribución.
- Completá la plantilla del PR y agregá tu cambio al `CHANGELOG.md`, en la sección **Sin publicar**.

## Seguridad

Quien instala el framework le da a sus skills el mismo alcance que tiene Claude en su máquina. Por eso, los cambios en scripts, en el hook, en `claude-settings.json` y en cualquier instrucción sobre permisos, secretos, borrados o comandos de red se revisan con especial cuidado. No se aceptan cambios que lean secretos, aflojen permisos o se conecten a servicios externos sin una justificación clara.

Si encontrás una vulnerabilidad, no abras un issue público: reportala por privado desde la pestaña **Security** del repo (*Report a vulnerability*).

## Publicar una versión (mantenedores)

Quien instala el framework como plugin se queda en la versión de `.claude-plugin/plugin.json` hasta que esa versión cambia. Mergear a `main` no le llega a nadie: una versión se publica a propósito.

1. Pasar las entradas de **Sin publicar** del `CHANGELOG.md` a una sección con número y fecha.
2. Subir `version` en `.claude-plugin/plugin.json` y el marcador `<!-- framework-claude vX.Y.Z -->` al final de `skills/iniciar-proyecto/plantillas/CLAUDE.md`.
3. Commit, tag `vX.Y.Z` y push del tag.
