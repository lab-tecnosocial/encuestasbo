# encuestasbo

Paquete de R para el acceso, armonización y análisis de las encuestas
del Instituto Nacional de Estadística (INE) de Bolivia:

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

## Fuentes de datos

Todos los microdatos provienen del **Instituto Nacional de Estadística
(INE) de Bolivia**, de dos repositorios distintos:

- **Encuesta de Hogares (EH)** — portal **ANDA** del INE (catálogo
  ENCUESTAS): <https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS>. La
  descarga de los `.sav` requiere registro/inicio de sesión y aceptar
  los términos de uso del INE.
- **Encuesta Continua de Empleo (ECE)** — página de **Metadatos y
  microdatos** del INE (acceso abierto, sin registro):
  <https://www.ine.gob.bo/index.php/metadatos-y-microdatos/> (los
  archivos se alojan en el repositorio Nextcloud del INE,
  `nube.ine.gob.bo`).

Este paquete **no** accede a esos portales en tiempo de ejecución: los
microdatos ya están procesados a Parquet y publicados en GitHub
Releases, de donde las funciones `get_*()` los descargan y cachean
automáticamente.

## Nota metodológica

Cómo se transformaron los microdatos originales del INE en los datos que
entrega este paquete:

1.  **Origen.** Se parte de los archivos SPSS (`.sav`) publicados por el
    INE: la EH desde ANDA y la ECE desde la página de metadatos y
    microdatos. No se altera ningún registro original.
2.  **Lectura con etiquetas.** Cada `.sav` se lee con
    [`haven`](https://haven.tidyverse.org/), preservando las etiquetas
    de variable y de valor (`label` / `labels`) que define el INE.
3.  **Diccionario.** De esos atributos etiquetados se extrae un
    **codebook** por encuesta y periodo (variable, etiqueta, tipo,
    categorías), que se distribuye como dato del paquete
    (`codebook_eh_meta`, `codebook_ece_meta`) y alimenta
    [`codebook()`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook.md)
    /
    [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md).
4.  **Datos numéricos + Parquet.** Tras extraer el diccionario, los
    valores se dejan como códigos numéricos
    ([`haven::zap_labels()`](https://haven.tidyverse.org/reference/zap_labels.html))
    y se escribe **un archivo Parquet por (encuesta, periodo, tabla)**
    con Apache Arrow. Las etiquetas viven en el codebook, no en los
    datos, lo que hace los archivos pequeños y rápidos. Se conservan
    intactas las **variables de diseño muestral** (`upm`, `estrato`,
    factores de expansión) necesarias para estimar con `survey`/`srvyr`.
5.  **Armonización entre periodos.** Una capa canónica
    (`variable_canonica_map`) unifica los **nombres** de variables que
    el INE cambió entre años (detectados por su etiqueta cuando el
    código de variable varía) y **recodifica los valores** cuando el INE
    alteró las categorías: p. ej. el “Otros” del nivel educativo, la
    **tenencia de la vivienda** (dos órdenes de códigos: 2012–2015 vs
    2016+) o la **categoría ocupacional** de la ECE (cuestionario 2018
    vs 2019+). La capa armonizada de la EH se materializa además en un
    único Parquet precalculado. Las variables de vivienda (nivel hogar)
    se unen a las de persona por `folio`.
6.  **Indicadores ya calculados por el INE.** Las **líneas de pobreza**,
    los **factores de expansión** y las variables derivadas (pobreza,
    ingresos, condición de actividad, nivel educativo) las calcula el
    propio INE; el paquete las expone con nombres canónicos y **no
    recalcula** esos agregados.
7.  **Publicación y verificación.** Los Parquet resultantes se publican
    en GitHub Releases (las funciones `get_*()` los descargan y
    cachean). Los resultados se han contrastado contra las cifras
    oficiales del INE, con coincidencias dentro del margen muestral.

Los límites de comparabilidad entre periodos (cambios de cuestionario,
de marco muestral o de clasificadores) se documentan en
[`vignette("armonizacion")`](https://lab-tecnosocial.github.io/encuestasbo/articles/armonizacion.md)
y en la ficha técnica de cada estudio
([`ficha_tecnica()`](https://lab-tecnosocial.github.io/encuestasbo/reference/ficha_tecnica.md)).

## Citación

Si usas `encuestasbo` en un trabajo, por favor cítalo. En R:

``` r

citation("encuestasbo")
```

> Ojeda Copa, A. (2026). *encuestasbo: Acceso, armonización y análisis
> con diseño muestral de las encuestas del INE de Bolivia*. Lab
> TecnoSocial. Paquete de R.
> <https://github.com/lab-tecnosocial/encuestasbo>

Cita además la **fuente primaria de los microdatos**: Instituto Nacional
de Estadística (INE) de Bolivia, Encuesta de Hogares / Encuesta Continua
de Empleo, según el periodo utilizado.
