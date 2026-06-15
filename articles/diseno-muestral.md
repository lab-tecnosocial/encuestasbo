# Diseño muestral: estimaciones correctas con la EH

La Encuesta de Hogares (EH) del INE es una **muestra con diseño
complejo**: estratificada y bietápica (UPM dentro de estrato), con
factores de expansión. Calcular medias o proporciones ignorando el
diseño produce **errores estándar incorrectos** y, sin ponderar, también
estimaciones puntuales sesgadas.

`encuestasbo` integra `srvyr`/`survey` para hacerlo bien.

## Datos crudos vs diseño declarado

``` r

library(encuestasbo)
library(srvyr)
library(dplyr)

# Diseño muestral de la EH 2023 (ids = upm, strata = estrato, weights = factor)
des <- diseno_eh(2023)

# Tasa de pobreza nacional con intervalo de confianza
des |>
  summarise(pobreza = survey_mean(pobre, na.rm = TRUE, vartype = "ci"))
#> # A tibble: 1 × 3
#>   pobreza pobreza_low pobreza_upp
#>     <dbl>       <dbl>       <dbl>
#> 1   0.365       0.351       0.379
```

La estimación ponderada (~36.5 %) coincide con la cifra oficial del INE.
La media **sin** ponderar difiere y, sobre todo, no permite calcular el
intervalo de confianza correctamente.

## Desagregaciones

``` r

# Ingreso medio del hogar por área
diseno_eh(2023) |>
  group_by(area) |>
  summarise(ingreso = survey_mean(ingreso_hogar, na.rm = TRUE, vartype = "ci"))

# Pobreza por departamento
diseno_eh(2023) |>
  group_by(depto) |>
  summarise(pobreza = survey_mean(pobre, na.rm = TRUE))
```

> Cuidado con las desagregaciones: el INE recomienda evaluar el
> coeficiente de variación. Estimaciones para subgrupos pequeños pueden
> no ser significativas.

## La ECE y sus factores

La Encuesta Continua de Empleo tiene factores **trimestral** y
**mensual** distintos.
[`diseno_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_ece.md)
usa el trimestral por defecto:

``` r

diseno_ece(2022, trimestre = 3, factor = "trimestral")
```

## Por qué `nest = TRUE` y `lonely.psu`

[`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
declara `nest = TRUE` (las UPM están anidadas dentro de estratos) y fija
`options(survey.lonely.psu = "adjust")` para manejar estratos con una
sola UPM sin romper la estimación de varianza. Lo restaura al terminar.
