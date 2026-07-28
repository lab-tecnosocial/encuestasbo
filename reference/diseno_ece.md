# Declara el diseño muestral de la Encuesta Continua de Empleo (ECE)

Análogo a \[diseno_eh()\] para la ECE trimestral. La ECE tiene factores
de expansión \*\*trimestral\*\* y \*\*mensual\*\* distintos; por defecto
usa el trimestral. No deben mezclarse en un mismo análisis.

## Usage

``` r
diseno_ece(
  anio,
  trimestre,
  tabla = "persona",
  factor = c("trimestral", "mensual"),
  armonizar = TRUE,
  departamento = NULL,
  area = NULL,
  verbose = TRUE
)
```

## Arguments

- anio:

  Entero. Año.

- trimestre:

  Entero (1-4).

- tabla:

  Caracteres. La ECE se distribuye solo a nivel \`"persona"\` (defecto);
  se expone el argumento por simetría con \[diseno_eh()\].

- factor:

  Cuál factor de expansión usar: \`"trimestral"\` (defecto) o
  \`"mensual"\`.

- armonizar:

  Lógico. Armonizar nombres antes de declarar el diseño.

- departamento, area:

  Filtros opcionales.

- verbose:

  Lógico. Mostrar progreso.

## Value

Un objeto \`tbl_svy\` de \`srvyr\`.

## See also

\[diseno_eh()\], \[get_ece()\].

## Examples

``` r
if (FALSE) { # \dontrun{
diseno_ece(2022, trimestre = 3) |>
  srvyr::summarise(tasa = srvyr::survey_mean(desocupado, na.rm = TRUE))
} # }
```
