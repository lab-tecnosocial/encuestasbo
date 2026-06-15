# Muestra los valores codificados de una variable categórica

Muestra los valores codificados de una variable categórica

## Usage

``` r
codebook_valores(variable, encuesta = "eh", anio = 2024, trimestre = NULL)
```

## Arguments

- variable:

  Nombre de la variable.

- encuesta:

  \`"eh"\` (defecto) o \`"ece"\`.

- anio:

  Año de la encuesta. Por defecto \`2024\`.

- trimestre:

  Trimestre (1-4); requerido si \`encuesta = "ece"\`.

## Value

Un data.frame con columnas \`codigo\` y \`etiqueta\`, o \`NULL\`
invisible si la variable no es categórica.

## Examples

``` r
if (FALSE) { # \dontrun{
codebook_valores("s01a_02", anio = 2023)  # sexo
} # }
```
