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

## Details

Además de renombrar, armoniza los \*\*valores\*\* que el INE codificó
distinto entre años:

\- \`nivel_edu\`: el código de "Otros" era 4, 5 o 9 según el año; se
colapsa a 4. - \`tenencia_vivienda\`: dos regímenes de códigos
(2012-2015 y 2016-2024) a un esquema canónico 1-7. -
\`tiene_seguro_salud\`: el código de la respuesta se binariza a 0/1 (0 =
ninguno), usando el código de "Ninguno" de ese año. - \`ocupado\` y
\`desocupado\`: se \*\*derivan\*\* de \`condicion_actividad\`
(\`condact\`, la única variable de empleo estable en los 13 años). El
INE las publicó de forma inconsistente —\`NA\` para los inactivos en
2012-2014, y no las publica desde 2022—, así que derivarlas da una
definición única y comparable. La derivación coincide exactamente con
las variables del INE en 2015-2021.

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
