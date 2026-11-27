# Sandbox de TestQuality

Demo de inicio de sesión para probar GitHub Issues, GitHub Projects, pull requests y la importación de resultados en TestQuality. No implementa autenticación real; usa únicamente datos ficticios.

Para la validación manual del PR, usa el caso de la cuenta bloqueada y registra el resultado en el run de TestQuality vinculado al PR.

## Ejecutar en local

- Con Node.js 22: `node --test`.
- Para simular la regresión de cuenta bloqueada y generar un informe JUnit: `DEMO_REGRESSION=1 node --test --test-reporter=junit > junit.xml`. Este comando devuelve un código distinto de cero a propósito.
- Para la prueba manual: `python3 -m http.server 8000 --bind 127.0.0.1`. Abre `http://127.0.0.1:8000`. La página tiene un interruptor para simular la misma regresión.

## Prueba de aceptación

1. Abre el [tablero de evaluación](https://github.com/users/jms85/projects/2). Las tres issues de requisitos y los campos `QA Status`, `Coverage`, `Test Environment` y `TMS Reference` ya están creados.
2. Inicia la prueba de TestQuality, crea `GitHub TMS Evaluation` y vincula solo este repositorio en **Settings → Integrations → GitHub → Link Repo**. Habilita **Pull request testing** y, si quieres ver un check antes de ejecutar, **Pull request initial check**. Crea el entorno `QA`.
3. En TestQuality, abre **Tests → … → Import Tests** y elige [authentication.feature](features/authentication.feature) como Gherkin. No marques **Automated run results**: estás importando definiciones, no resultados. Crea una Story por issue y vincula un caso a cada Story. Las etiquetas `@requirement-1`, `@requirement-2` y `@requirement-3` identifican la issue correspondiente, pero no sustituyen ese vínculo. Crea el plan `Authentication Evaluation Plan` y el ciclo `PR Validation` con los tres casos.
4. Después de vincular la Story, abre un PR hacia `main` con un cambio de README. Escribe `Fixes #N` con el número real de la issue vinculada. Comprueba si se crea un run y aparece un check; si no, prueba a vincular el PR al crear el run.
5. Ejecuta los tres casos en el navegador. Activa **Simular regresión** solo para el caso de cuenta bloqueada. Registra el resultado real y adjunta evidencia ficticia al fallo. Crea un defecto `[DEMO] La cuenta bloqueada puede iniciar sesión` desde el resultado y comprueba el enlace en ambos sentidos.
6. Desde el plan, intenta llegar a la lista completa de tests y luego al detalle del fallo: paso, esperado, real, entorno, evidencia y defecto. Registra también el estado del check del PR y si cambió algún campo personalizado del tablero sin intervención manual. Un check o una etiqueta visible **no prueba** que haya sincronización de Projects v2.

| Issue de GitHub | Datos ficticios | Resultado esperado |
|---|---|---|
| El usuario activo puede iniciar sesión | `activa@example.test` / `demo-pass` | `Acceso concedido` |
| Las credenciales inválidas se rechazan | `activa@example.test` / `incorrecta` | `Acceso denegado` |
| Una cuenta bloqueada no puede iniciar sesión | `bloqueada@example.test` / `demo-pass` | `Acceso denegado` |

## GitHub Actions y TestQuality

El workflow **TestQuality evaluation** está disponible como [plantilla YAML](docs/testquality-evaluation.yml). Para activarlo, copia su contenido en `.github/workflows/testquality-evaluation.yml` en `main` con una cuenta que pueda editar workflows. Publica el resumen y el JUnit en GitHub para cada PR a `main`, cada push a `main` y cada ejecución manual. El envío a TestQuality solo se hace desde `main`, no desde los PRs.

1. Crea el ciclo `Automation Smoke` en `GitHub TMS Evaluation`.
2. Genera un token de TestQuality y guárdalo como secret de Actions `TQ_ACCESS_TOKEN`. No lo pongas en archivos, issues ni logs.
3. En **Actions → TestQuality evaluation → Run workflow**, selecciona `main` y ejecuta una vez con `simulate_regression` desactivado y otra con él activado. La segunda ejecución debe fallar y aun así publicar el informe.
4. Comprueba que el resultado importado muestra la aserción fallida. El check de Actions y el check de TestQuality asociado al PR son flujos distintos.

Al terminar la prueba, revoca el token y elimina el secret. [Documentación de la integración de GitHub](https://doc.testquality.com/integrate_with_github) · [CLI de TestQuality](https://doc.testquality.com/testquality_cli/overview).
