# Etiqueta los valores de las variables categóricas

Convierte los códigos numéricos de las columnas categóricas en factores
con las etiquetas en español del diccionario del INE, para la encuesta y
año indicados.

## Usage

``` r
etiquetar_valores(
  df,
  columnas = NULL,
  encuesta = "eh",
  anio = 2024,
  trimestre = NULL
)
```

## Arguments

- df:

  Un data.frame (resultado de \[get_eh()\] con \`as = "tibble"\`, o de
  \`collect()\` / \`DBI::dbGetQuery()\`).

- columnas:

  Vector de nombres de columnas a etiquetar. Si \`NULL\`, todas las
  categóricas presentes.

- encuesta:

  \`"eh"\` (defecto) o \`"ece"\`.

- anio:

  Año de la encuesta. Por defecto \`2024\`.

- trimestre:

  Trimestre (1-4); requerido si \`encuesta = "ece"\`.

## Value

El \`df\` con las columnas categóricas convertidas a \`factor\`. Las
columnas no encontradas o no categóricas se devuelven sin cambios.

## Details

Las etiquetas corresponden a los nombres de variable \*\*crudos\*\* de
cada año (e.g., \`s01a_02\`). Si trabajas con datos armonizados de
\[armonizar_eh()\] o \[get_eh_armonizada()\] (nombres canónicos), las
etiquetas de valor no aplican directamente; etiqueta antes de armonizar
o usa las propias categorías.

## See also

\[etiquetar_variables()\], \[codebook_valores()\].

## Examples

``` r
if (FALSE) { # \dontrun{
get_eh(2023, "persona", as = "tibble") |>
  etiquetar_valores(anio = 2023) |>
  dplyr::count(s01a_02)
} # }
```
