# Accede a los microdatos de la Encuesta Continua de Empleo (ECE) del INE

Descarga y/o carga desde caché los microdatos trimestrales de la
Encuesta Continua de Empleo de Bolivia (4T-2015 a 3T-2025, serie
completa). En \*\*2020-T2/T3/T4\*\* la ECE fue de cobertura \*\*solo
urbana\*\* (la pandemia impidió el levantamiento rural); esos trimestres
emiten un aviso y se marcan como \`cobertura = "urbana"\` en
\[catalogo_ece()\]. Con filtros opcionales por departamento y área. Cada
trimestre es un archivo único a nivel persona.

## Usage

``` r
get_ece(
  anio,
  trimestre,
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

  Entero. Año de la encuesta.

- trimestre:

  Entero (1-4). Trimestre de referencia.

- tabla:

  Caracteres. La ECE se distribuye únicamente a nivel \`"persona"\`
  (defecto). Usa \[catalogo_ece()\] para ver lo disponible.

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

Según \`as\`: un \`arrow::Dataset\`, un \`data.frame\` o una conexión
\`DBI\`.

## Details

La ECE tiene factores de expansión \*\*mensual y trimestral\*\*
distintos; no deben mezclarse. Para análisis trimestrales usa
\[diseno_ece()\] con el factor trimestral (por defecto). El periodo
IV-2015 a II-2019 se distribuyó como un único estudio en ANDA; en el
paquete se accede por trimestre individual.

## See also

\[diseno_ece()\] para análisis con diseño muestral; \[catalogo_ece()\].

## Examples

``` r
if (FALSE) { # \dontrun{
get_ece(2022, trimestre = 3, tabla = "persona")
} # }
```
