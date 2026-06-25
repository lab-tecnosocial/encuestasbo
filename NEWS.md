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
* Las variables categóricas armonizadas tienen **etiquetas estables entre años**;
  `etiquetar_valores()` las detecta automáticamente en datos armonizados (sin
  indicar año). Además se unifican valores que cambiaban de código entre años
  (`nivel_edu`: "Otros" era 4/5/9 según el año → ahora siempre 4).
* `etiquetar_valores()` ahora también etiqueta `depto` con los nombres de los
  nueve departamentos (1 = Chuquisaca … 9 = Pando) en datos armonizados.
* Nuevas variables armonizadas de **vivienda** y **salud**: `tipo_vivienda`,
  `tenencia_vivienda` (recodificada a un esquema canónico; el INE usó dos órdenes
  de códigos, 2012-2015 vs 2016+) y `tiene_seguro_salud` (afiliación a algún
  seguro, 0/1). Las de vivienda se unen a la capa persona por `folio`. Nuevos
  grupos `"vivienda"` y `"salud"` en `grupos_variables()`. Validadas contra ARU
  (tenencia propia ~62 %, casa ~75 %, sin seguro 2023 = 14,3 %).

## Indicadores con diseño muestral

* Nuevos atajos que envuelven el diseño + `srvyr` y devuelven la estimación con
  intervalo de confianza, con desagregación opcional vía `por =`:
  `tasa_pobreza()` (EH), `tasa_desempleo()`, `tasa_subocupacion()` y
  `empleo_vulnerable()` (ECE). Utilidad `grupo_edad()` para cohortes etarias.
* Validados contra estudios de terceros (Fundación ARU) que usan los mismos
  microdatos del INE: pobreza por área, subocupación por sexo/departamento y
  empleo vulnerable coinciden con las cifras publicadas.

## Armonización de la ECE

* `armonizar_ece()` ahora añade variables canónicas estables entre versiones del
  cuestionario (cambió en 2019): `sexo`, `categoria_ocupacional` (mapeada desde
  `s2_20` hasta 2018 y `s2_18` desde 2019, con codificaciones distintas),
  `ocupado`, `desocupado` y `subocupado`. Esto hace comparables indicadores como
  el empleo vulnerable a lo largo de toda la serie.

## Diseño muestral

* `diseno_eh()` / `diseno_ece()`: devuelven un diseño `srvyr` listo
  (`ids = upm`, `strata = estrato`, `weights = factor`, `nest = TRUE`,
  `survey.lonely.psu = "adjust"`). La tasa de pobreza 2023 estimada coincide
  con la cifra oficial del INE.

## Documentación

* Sitio pkgdown con 6 viñetas: primeros pasos; **catálogo, diccionario y ficha
  técnica (interactivo con DT)**; la Encuesta de Hogares (pobreza, ingresos,
  empleo); diseño muestral; armonización entre años; y empleo trimestral (ECE).

## Distribución

* Microdatos publicados en GitHub Releases: `data-eh-v1` (EH + armonizada) y
  `data-ece-v1` (ECE). Las funciones `get_*` descargan y cachean automáticamente.

## Pendiente

* Armonización canónica de la ECE entre trimestres (hoy se accede con sus
  nombres nativos; el diseño muestral ya funciona).
* Armonización de clasificadores ocupacionales/actividad (COB/CAEB) entre versiones.
