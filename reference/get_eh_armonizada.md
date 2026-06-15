# Serie armonizada de la Encuesta de Hogares entre años

Devuelve la EH armonizada (nombres canónicos estables) de varios años
apilada en formato largo con una columna \`anio\`. Se respalda en un
único Parquet precalculado (~5 MB con los 13 años), consultable de forma
perezosa con Arrow y DuckDB. Equivalente para encuestas de la función de
análisis temporal de censos.

## Usage

``` r
get_eh_armonizada(
  anios = NULL,
  variables = NULL,
  grupo = NULL,
  departamento = NULL,
  area = NULL,
  as = c("tibble", "arrow", "duckdb"),
  overwrite = FALSE,
  verbose = TRUE
)
```

## Arguments

- anios:

  Vector de años a incluir (por defecto todos los disponibles).

- variables:

  Vector de nombres canónicos a incluir. Si \`NULL\`, usa \`grupo\` o,
  si tampoco, todas las variables armonizadas.

- grupo:

  Nombre de un grupo temático de \[grupos_variables()\] (e.g.,
  \`"pobreza"\`, \`"empleo"\`). Ignorado si se pasa \`variables\`.

- departamento:

  Filtro opcional por departamento.

- area:

  Filtro opcional por área.

- as:

  Formato de retorno: \`"tibble"\` (defecto), \`"arrow"\` (Dataset lazy)
  o \`"duckdb"\` (conexión DBI con la tabla \`"eh_armonizada"\`).

- overwrite:

  Lógico. Si \`TRUE\`, re-descarga el Parquet armonizado.

- verbose:

  Lógico. Mostrar progreso.

## Value

Según \`as\`: un \`data.frame\` (tibble), un \`arrow::Dataset\` o una
conexión \`DBI\`. Siempre incluye la columna \`anio\` y las de diseño
(\`folio\`, \`upm\`, \`estrato\`, \`factor\`, \`depto\`, \`area\`).

## Details

Las columnas de identificación/agrupación/diseño (\`folio\`, \`upm\`,
\`estrato\`, \`depto\`, \`area\`, \`sexo\`, …) se almacenan como texto
(códigos, consistentes entre años y válidos como \`ids\`/\`strata\` en
survey); las analíticas continuas e indicadores 0/1 (\`factor\`,
\`ingreso\_\*\`, \`pobre\`, …) como numéricas.

## See also

\[grupos_variables()\], \[variables_armonizadas()\], \[diseno_eh()\].

## Examples

``` r
if (FALSE) { # \dontrun{
# Evolución de la pobreza ponderada por año
library(srvyr); library(dplyr)
get_eh_armonizada(grupo = "pobreza") |>
  group_by(anio) |>
  summarise(mean(pobre, na.rm = TRUE))

# Consulta perezosa con DuckDB
con <- get_eh_armonizada(as = "duckdb")
DBI::dbGetQuery(con, "SELECT anio, AVG(pobre) FROM eh_armonizada GROUP BY anio")
DBI::dbDisconnect(con, shutdown = TRUE)
} # }
```
