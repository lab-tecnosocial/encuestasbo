# Primeros pasos con encuestasbo

`encuestasbo` da acceso a los microdatos de **dos encuestas** del INE de
Bolivia, con diccionarios, ficha técnica oficial y análisis con diseño
muestral:

- **Encuesta de Hogares (EH)** — anual, **2012–2024**. Niveles `persona`
  y `vivienda`. Es la principal fuente de pobreza, ingresos, educación y
  empleo.
- **Encuesta Continua de Empleo (ECE)** — trimestral, **4T-2015 a
  3T-2025** (con huecos en 2020–2021). Nivel persona; mercado laboral
  urbano y nacional.

La diferencia esencial con un censo: son **muestras con diseño
complejo** (estratificado, bietápico, con factores de expansión). Por
eso, para estimaciones correctas se usa
[`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
/
[`diseno_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_ece.md) +
`srvyr` (ver la viñeta *“Diseño muestral”*).

``` r

library(encuestasbo)
```

## Inventario

``` r

catalogo_eh()                       # años y tablas de la EH
catalogo_ece()                      # años y trimestres de la ECE
catalogo_ece(anio = 2023)
```

## Ficha técnica (metadata oficial del INE)

Universo, cobertura, marco y diseño muestral, factor de expansión, tasa
de respuesta. Disponible para ambas encuestas:

``` r

ficha_tecnica("eh", 2023)
ficha_tecnica("ece", 2023, trimestre = 4)
```

## Acceso a microdatos

Mismas funciones para cada encuesta; devuelven Arrow (lazy), tibble o
DuckDB.

``` r

library(dplyr)

# Encuesta de Hogares
get_eh(2023, "persona", departamento = "Santa Cruz", area = "Urbana") |>
  count(depto) |>
  collect()
get_personas_eh(2023); get_viviendas_eh(2023)        # atajos

# Encuesta Continua de Empleo (trimestral)
get_ece(2023, trimestre = 4, departamento = "La Paz") |>
  count(area) |>
  collect()
get_personas_ece(2023, trimestre = 4)                # atajo
```

`departamento`: 1–9 o nombre (“La Paz”, “Santa Cruz”, …). `area`:
1/“Urbana” o 2/“Rural”.

## Diccionario y etiquetas

``` r

# EH (por año) y ECE (por año + trimestre)
codebook(buscar = "ingreso", anio = 2023)
codebook(buscar = "desocupad", encuesta = "ece", anio = 2023, trimestre = 4)

get_eh(2023, "persona", as = "tibble") |>
  etiquetar_valores(anio = 2023)
```

## Análisis con diseño muestral

Cada encuesta tiene su declarador de diseño. Ver la viñeta *“Diseño
muestral”*.

``` r

library(srvyr)
diseno_eh(2023)  |> summarise(pobreza = survey_mean(pobre, na.rm = TRUE))
diseno_ece(2023, trimestre = 4) |> summarise(td = survey_ratio(pead, pea, na.rm = TRUE))
```

## ¿Por dónde seguir?

- **[`vignette("encuesta-hogares")`](https://lab-tecnosocial.github.io/encuestasbo/articles/encuesta-hogares.md)**
  — análisis temáticos de la EH (pobreza, ingresos, educación, empleo) y
  evolución entre años.
- **[`vignette("ece-empleo")`](https://lab-tecnosocial.github.io/encuestasbo/articles/ece-empleo.md)**
  — empleo trimestral con la ECE.
- **[`vignette("diseno-muestral")`](https://lab-tecnosocial.github.io/encuestasbo/articles/diseno-muestral.md)**
  — estimaciones con errores estándar correctos (EH y ECE).
- **[`vignette("armonizacion")`](https://lab-tecnosocial.github.io/encuestasbo/articles/armonizacion.md)**
  — nombres canónicos y series largas de la EH.
- **[`vignette("catalogo-diccionario")`](https://lab-tecnosocial.github.io/encuestasbo/articles/catalogo-diccionario.md)**
  — catálogo, diccionario y ficha técnica interactivos.

## Caché

Los microdatos se descargan una vez y se guardan en caché:

``` r

encuestasbo_cache_dir()
encuestasbo_cache_info()
```
