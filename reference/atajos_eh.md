# Atajos de acceso a la Encuesta de Hogares por nivel

Wrappers de \[get_eh()\] para los niveles de análisis más comunes.

## Usage

``` r
get_personas_eh(
  anio,
  departamento = NULL,
  area = NULL,
  variables = NULL,
  as = c("arrow", "tibble", "duckdb"),
  overwrite = FALSE,
  verbose = TRUE
)

get_viviendas_eh(
  anio,
  departamento = NULL,
  area = NULL,
  variables = NULL,
  as = c("arrow", "tibble", "duckdb"),
  overwrite = FALSE,
  verbose = TRUE
)
```

## Arguments

- anio:

  Entero. Año de la encuesta (\`2012\`-\`2024\`).

- departamento:

  Vector. Código(s) \`1\`-\`9\` o nombre(s) del departamento (e.g.,
  \`"Santa Cruz"\`). Si \`NULL\`, incluye todos.

- area:

  Vector. \`1\`/\`"Urbana"\` o \`2\`/\`"Rural"\`. Si \`NULL\`, incluye
  ambas.

- variables:

  Vector de caracteres. Nombres de columnas a seleccionar. Si \`NULL\`,
  devuelve todas. Las columnas de identificación, geografía y diseño
  muestral (\`folio\`, \`depto\`, \`area\`, \`factor\`, \`upm\`,
  \`estrato\`) siempre se incluyen.

- as:

  Formato de retorno: \`"arrow"\` (lazy, por defecto), \`"tibble"\`
  (RAM) o \`"duckdb"\` (conexión DBI con la tabla registrada).

- overwrite:

  Lógico. Si \`TRUE\`, re-descarga aunque exista en caché.

- verbose:

  Lógico. Mostrar mensajes de progreso. Por defecto \`TRUE\`.

## Value

Lo mismo que \[get_eh()\] según \`as\`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_personas_eh(2023, departamento = "La Paz")
get_viviendas_eh(2023)
} # }
```
