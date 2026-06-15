# encuestasbo

Paquete de R para el acceso, armonización y análisis **estadísticamente
riguroso** de las encuestas del Instituto Nacional de Estadística (INE)
de Bolivia:

- **Encuesta de Hogares (EH)** — anual, **2012–2024** (13 años).
- **Encuesta Continua de Empleo (ECE)** — trimestral, **4T-2015 a
  3T-2025** (33 trimestres; con huecos en 2020–2021 por la pandemia).

Es el paquete hermano de
[`censosbo`](https://github.com/lab-tecnosocial/censosbo) y comparte su
arquitectura: Parquet + Apache Arrow (lazy), caché local y flujos estilo
`dplyr` / SQL vía DuckDB. La diferencia esencial: las encuestas son
**muestras con diseño complejo** (estratificado, bietápico, con factores
de expansión), por lo que el paquete integra `survey`/`srvyr` para
producir estimaciones e intervalos de confianza correctos.

Los microdatos están **procesados y publicados**: las funciones
descargan los Parquet desde GitHub Releases y los guardan en caché local
automáticamente.

## Instalación

``` r

# install.packages("remotes")
remotes::install_github("lab-tecnosocial/encuestasbo")
```

## Uso

``` r

library(encuestasbo)
library(dplyr)

# Inventario y ficha técnica oficial del INE (diseño muestral)
catalogo_eh()
ficha_tecnica("eh", 2023)        # universo, marco muestral, factor de expansión, ...

# Microdatos (Arrow lazy) con filtros
get_eh(2023, "persona", departamento = "Santa Cruz", area = "Urbana") |>
  count(depto) |>
  collect()

# Diccionario y etiquetas
codebook(buscar = "ingreso", anio = 2023)
get_eh(2023, "persona", as = "tibble") |> etiquetar_valores(anio = 2023)

# Armonización entre años (formato largo con columna `anio`)
# Respaldada por un único Parquet armonizado (~5 MB); modos tibble/arrow/duckdb
get_eh_armonizada(grupo = "pobreza")
get_eh_armonizada(as = "duckdb")   # consulta SQL cross-año sobre "eh_armonizada"
```

## Análisis con diseño muestral

``` r

library(srvyr)

# Tasa de pobreza nacional 2023 con IC (≈ cifra oficial del INE)
diseno_eh(2023) |>
  summarise(pobreza = survey_mean(pobre, na.rm = TRUE, vartype = "ci"))

# Ingreso medio del hogar por departamento
diseno_eh(2023) |>
  group_by(depto) |>
  summarise(ingreso = survey_mean(ingreso_hogar, na.rm = TRUE))

# Encuesta Continua de Empleo: tasa de desempleo del 4T-2023 (factor trimestral)
diseno_ece(2023, trimestre = 4) |>
  summarise(td = survey_ratio(pead, pea, na.rm = TRUE, vartype = "ci"))
```

[`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
declara el diseño (`ids = upm`, `strata = estrato`, `weights = factor`,
`nest = TRUE`) sobre datos armonizados y devuelve un objeto `srvyr`. Ver
[`vignette("diseno-muestral")`](https://lab-tecnosocial.github.io/encuestasbo/articles/diseno-muestral.md).

## Variables armonizadas

Nombres canónicos estables entre años, apoyados en las variables
derivadas del propio INE: ingresos (`ingreso_hogar`,
`ingreso_personal`), pobreza (`pobre`, `pobre_extremo`,
`linea_pobreza`), educación (`nivel_edu`, `anios_estudio`), empleo
(`condicion_actividad`, `pea`, `ocupado`), demografía (`sexo`, `edad`).

``` r

variables_armonizadas()
grupos_variables()
```

## Gestión del caché

``` r

encuestasbo_cache_dir(); encuestasbo_cache_info(); encuestasbo_cache_clear()
```

## Fuente de datos

INE Bolivia, portal ANDA:
<https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS>. Los microdatos
son de uso público; cita la fuente según las condiciones del INE.

## Licencia

MIT © 2026 Alex Ojeda Copa (Lab TecnoSocial)
