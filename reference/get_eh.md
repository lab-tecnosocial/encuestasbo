# Accede a los microdatos de la Encuesta de Hogares (EH) del INE

Descarga y/o carga desde caché los microdatos de la Encuesta de Hogares
de Bolivia (2012-2024), con filtros opcionales por departamento y área.

## Usage

``` r
get_eh(
  anio,
  tabla = "persona",
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

- tabla:

  Caracteres. Nivel de análisis: \`"persona"\` (defecto) o
  \`"vivienda"\` (y otras bases temáticas según el año). Usa
  \[catalogo_eh()\] para ver las tablas disponibles.

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

Según \`as\`: - \`"arrow"\`: un \`arrow::Dataset\` (lazy, soporta
dplyr) - \`"tibble"\`: un \`data.frame\` con los datos en RAM -
\`"duckdb"\`: una conexión \`DBI\`; cierra con
\`DBI::dbDisconnect(con)\`.

## Details

Los microdatos provienen del portal ANDA del INE y se distribuyen como
Parquet en GitHub Releases. Para un análisis estadísticamente correcto
(con factores de expansión y errores estándar válidos) usa
\[diseno_eh()\] en lugar de operar sobre los datos crudos.

## See also

\[diseno_eh()\] para análisis con diseño muestral;
\[get_eh_armonizada()\] para series comparables entre años;
\[catalogo_eh()\] para el inventario.

## Examples

``` r
if (FALSE) { # \dontrun{
# Personas de la EH 2023 (Arrow lazy)
get_eh(2023, "persona")

# Filtrar y contar sin traer todo a RAM
library(dplyr)
get_eh(2023, "persona", departamento = "Santa Cruz") |>
  count(area) |>
  collect()

# Atajo equivalente
get_personas_eh(2023)
} # }
```
