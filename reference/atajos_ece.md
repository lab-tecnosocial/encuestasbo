# Atajos de acceso a la Encuesta Continua de Empleo por nivel

Wrappers de \[get_ece()\] para los niveles de análisis más comunes.

## Usage

``` r
get_personas_ece(
  anio,
  trimestre,
  departamento = NULL,
  area = NULL,
  variables = NULL,
  as = c("arrow", "tibble", "duckdb"),
  overwrite = FALSE,
  verbose = TRUE
)

get_viviendas_ece(
  anio,
  trimestre,
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

  Entero. Año de la encuesta.

- trimestre:

  Entero (1-4). Trimestre de referencia.

- departamento:

  Vector. Código(s) \`1\`-\`9\` o nombre(s). Si \`NULL\`, todos.

- area:

  Vector. \`1\`/\`"Urbana"\` o \`2\`/\`"Rural"\`. Si \`NULL\`, ambas.

- variables:

  Vector de caracteres. Columnas a seleccionar. Si \`NULL\`, todas. Las
  columnas de diseño muestral siempre se incluyen.

- as:

  Formato de retorno: \`"arrow"\` (defecto), \`"tibble"\` o
  \`"duckdb"\`.

- overwrite:

  Lógico. Si \`TRUE\`, re-descarga aunque exista en caché.

- verbose:

  Lógico. Mostrar progreso. Por defecto \`TRUE\`.

## Value

Lo mismo que \[get_ece()\] según \`as\`.

## Examples

``` r
if (FALSE) { # \dontrun{
get_personas_ece(2022, trimestre = 3)
} # }
```
