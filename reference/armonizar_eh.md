# Armoniza un data frame de la Encuesta de Hogares a nombres canónicos

Renombra las variables del año indicado a su nombre canónico estable
según \[variable_canonica_map\]. Garantiza que existan las columnas de
diseño muestral (\`folio\`, \`upm\`, \`estrato\`, \`factor\`) necesarias
para \[diseno_eh()\].

## Usage

``` r
armonizar_eh(df, anio, solo_canonicas = FALSE)
```

## Arguments

- df:

  Un data.frame de \[get_eh()\] (con \`as = "tibble"\`).

- anio:

  Entero. Año de la encuesta de origen (necesario para resolver los
  nombres de variables, que cambian entre años).

- solo_canonicas:

  Lógico. Si \`TRUE\`, devuelve únicamente las columnas canónicas
  presentes; si \`FALSE\` (defecto), conserva todas y solo renombra las
  mapeadas.

## Value

El data.frame con las columnas renombradas a nombres canónicos.

## See also

\[get_eh_armonizada()\] para apilar varios años; \[diseno_eh()\].

## Examples

``` r
if (FALSE) { # \dontrun{
get_eh(2023, "persona", as = "tibble") |>
  armonizar_eh(2023) |>
  dplyr::count(sexo)
} # }
```
