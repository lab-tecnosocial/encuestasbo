# encuestasbo 0.1.0 (en desarrollo)

Primera versión. Encuesta de Hogares (EH) 2012–2024 procesada y funcional de
punta a punta.

## Datos

* **EH 2012–2024** (13 años), niveles `persona` y `vivienda`, procesados a
  Parquet desde los `.sav` del portal ANDA del INE.
* **ECE 4T-2015 a 3T-2025** (33 trimestres; huecos en 2020–2021), nivel persona,
  procesados desde el repositorio abierto del INE (`nube.ine.gob.bo`).
* `catalogo_encuestas`: inventario maestro de EH y ECE.
* `codebook_eh_meta` y `codebook_ece_meta`: diccionarios extraídos de las
  etiquetas SPSS.
* `variable_canonica_map`: mapa de armonización de la EH a nombres canónicos.
* `metadata_encuestas` + `ficha_tecnica()`: ficha técnica oficial del INE
  (universo, cobertura, marco y diseño muestral, factor de expansión, tasa de
  respuesta) extraída de la metadata DDI de ANDA para los 32 estudios.

## Acceso

* `get_eh()` / `get_ece()` y atajos (`get_personas_eh()`, `get_viviendas_eh()`,
  `get_personas_ece()`, `get_viviendas_ece()`), con filtros por departamento y
  área y modos `"arrow"` / `"tibble"` / `"duckdb"`.
* `catalogo_eh()` / `catalogo_ece()`.
* Caché: `encuestasbo_cache_dir()`, `_info()`, `_clear()`, `update_encuestasbo()`.

## Diccionario y etiquetas

* `codebook()`, `codebook_valores()`, `etiquetar_valores()`, `etiquetar_variables()`.

## Armonización entre años

* `armonizar_eh()`, `get_eh_armonizada()`, `variables_armonizadas()`,
  `grupos_variables()`. Apoyada en variables derivadas del INE (ingresos,
  pobreza, educación, empleo) con nombres estables entre años.
* `get_eh_armonizada()` se respalda en un único Parquet armonizado precalculado
  (~5 MB, 13 años, esquema consistente) y admite `as = "tibble"/"arrow"/"duckdb"`
  para consultas cross-año perezosas (DuckDB por debajo). Corrige además el
  apilado de años con tipos mixtos (p. ej. `estrato` texto/numérico).

## Diseño muestral

* `diseno_eh()` / `diseno_ece()`: devuelven un diseño `srvyr` listo
  (`ids = upm`, `strata = estrato`, `weights = factor`, `nest = TRUE`,
  `survey.lonely.psu = "adjust"`). La tasa de pobreza 2023 estimada coincide
  con la cifra oficial del INE.

## Documentación

* Sitio pkgdown con 6 viñetas: primeros pasos; **catálogo, diccionario y ficha
  técnica (interactivo con DT)**; la Encuesta de Hogares (pobreza, ingresos,
  empleo); diseño muestral; armonización entre años; y empleo trimestral (ECE).

## Pendiente

* Publicar los microdatos en GitHub Releases (por ahora caché local).
* Armonización canónica de la ECE entre trimestres (hoy se accede con sus
  nombres nativos; el diseño muestral ya funciona).
* Armonización de clasificadores ocupacionales/actividad (COB/CAEB) entre versiones.
