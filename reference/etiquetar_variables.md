# Etiqueta los nombres de las variables (columnas)

Reemplaza los nombres técnicos de las columnas por sus descripciones del
diccionario del INE. Útil para tablas y reportes.

## Usage

``` r
etiquetar_variables(df, encuesta = "eh", anio = 2024, trimestre = NULL)
```

## Arguments

- df:

  Un data.frame.

- encuesta:

  \`"eh"\` (defecto) o \`"ece"\`.

- anio:

  Año de la encuesta. Por defecto \`2024\`.

- trimestre:

  Trimestre (1-4); requerido si \`encuesta = "ece"\`.

## Value

El \`df\` con los nombres de columnas reemplazados por sus
descripciones; las no encontradas conservan su nombre.

## See also

\[etiquetar_valores()\].

## Examples

``` r
if (FALSE) { # \dontrun{
get_eh(2023, "persona", variables = "ylab", as = "tibble") |>
  etiquetar_variables(anio = 2023)
} # }
```
