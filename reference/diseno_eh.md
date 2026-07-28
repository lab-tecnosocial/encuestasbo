# Declara el diseño muestral de la Encuesta de Hogares (EH)

Devuelve un objeto de diseño de \`srvyr\` listo para estimaciones
estadísticamente correctas (medias, totales, proporciones con errores
estándar e intervalos de confianza válidos), con el diseño estratificado
bietápico de la EH ya declarado (\`ids = upm\`, \`strata = estrato\`,
\`weights = factor\`, \`nest = TRUE\`).

## Usage

``` r
diseno_eh(
  anio,
  tabla = "persona",
  armonizar = TRUE,
  departamento = NULL,
  area = NULL,
  verbose = TRUE
)
```

## Arguments

- anio:

  Entero. Año de la EH (\`2012\`-\`2024\`).

- tabla:

  Caracteres. \`"persona"\` (defecto) o \`"vivienda"\`.

- armonizar:

  Lógico. Si \`TRUE\` (defecto), armoniza los nombres de variables a
  canónicos antes de declarar el diseño (recomendado: hace que la
  sintaxis del diseño sea estable entre años).

- departamento, area:

  Filtros opcionales (ver \[get_eh()\]).

- verbose:

  Lógico. Mostrar progreso.

## Value

Un objeto \`tbl_svy\` de \`srvyr\` (envuelve \`survey\`). Úsalo con
\`srvyr::summarise()\` + \`survey_mean()\`, \`survey_total()\`,
\`survey_prop()\`.

## Details

El paquete fija \`options(survey.lonely.psu = "adjust")\` al cargarse
(si no lo fijaste tú), para manejar estratos con una sola UPM en la
estimación de varianza. Las encuestas se cargan en memoria (\`as =
"tibble"\`) porque \`survey\`/\`srvyr\` lo requieren; el tamaño de la EH
(~12k viviendas) lo hace viable.

## See also

\[get_eh()\], \[armonizar_eh()\], \[diseno_ece()\].

## Examples

``` r
if (FALSE) { # \dontrun{
library(srvyr)
# Tasa de pobreza nacional con error estándar
diseno_eh(2023) |>
  summarise(pobreza = survey_mean(pobre, na.rm = TRUE, vartype = "ci"))

# Ingreso medio del hogar por departamento
diseno_eh(2023) |>
  group_by(depto) |>
  summarise(ingreso = survey_mean(ingreso_hogar, na.rm = TRUE))
} # }
```
