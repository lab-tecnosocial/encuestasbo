# Catálogo, diccionario y ficha técnica (interactivo)

Esta guía es **interactiva**: las tablas se pueden buscar, ordenar y
filtrar. Toda la información proviene de los datos del propio paquete
(no requiere descargar microdatos).

``` r

library(DT)
tabla <- function(x, ...) DT::datatable(x, rownames = FALSE,
  options = list(pageLength = 10, scrollX = TRUE, language = list(
    url = "//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json")), ...)
```

## 1. Catálogo de encuestas

Qué encuestas, años, trimestres y tablas hay disponibles, y con qué
variables de diseño muestral (`upm`, `estrato`, factor de expansión).

### Encuesta de Hogares

``` r

tabla(catalogo_eh()[, c("anio", "tabla", "archivo_parquet",
                        "factor_var", "upm_var", "estrato_var")])
```

### Encuesta Continua de Empleo

``` r

tabla(catalogo_ece()[, c("anio", "trimestre", "factor_var", "factor_var_alt",
                         "upm_var", "estrato_var")])
```

## 2. Diccionario de variables

Busca cualquier variable por nombre, etiqueta, tabla o tipo. Ejemplo:
diccionario de la **EH 2023** (persona y vivienda).

``` r

cb <- codebook(anio = 2023)
cb$tiene_categorias <- vapply(cb$valores_codigos,
                              function(v) !is.null(v) && nrow(v) > 0, logical(1))
tabla(cb[, c("variable", "etiqueta", "tabla", "tipo", "tiene_categorias")],
      filter = "top")
```

Para ver los **códigos** de una variable categórica:

``` r

codebook_valores("s01a_02", anio = 2023)   # sexo: 1 = Hombre, 2 = Mujer
#>   codigo  etiqueta
#> 1      1 1. Hombre
#> 2      2  2. Mujer
```

> El diccionario de la ECE se consulta con
> `codebook(encuesta = "ece", anio = ..., trimestre = ...)`. Las
> variables de la EH cambian de nombre entre años; usa la capa
> armonizada
> ([`vignette("armonizacion")`](https://lab-tecnosocial.github.io/encuestasbo/articles/armonizacion.md))
> para series comparables.

## 3. Ficha técnica (diseño muestral oficial del INE)

Resumen de la metadata DDI de cada estudio: universo, cobertura, marco y
diseño muestral, factor de expansión, modo de recolección y tasa de
respuesta.

``` r

tabla(metadata_encuestas[, c("encuesta", "anio", "trimestre", "titulo",
                             "modo_recoleccion", "muestra_respuesta")])
```

Ficha completa de un estudio concreto:

``` r

ficha_tecnica("eh", 2023)
```
