# Changelog

## encuestasbo 0.1.0 (en desarrollo)

Primera versión. Encuesta de Hogares (EH) 2012–2024 procesada y
funcional de punta a punta.

### Datos

- **EH 2012–2024** (13 años). Además de `persona` y `vivienda`, ahora se
  incluyen todas las **bases temáticas** del INE según disponibilidad
  por año: `equipamiento`, `gastos_alimentarios`,
  `gastos_no_alimentarios`, `seguridad_alimentaria`, `discriminacion`,
  `turismo`, `cultura` y `defunciones`. Se acceden con
  `get_eh(anio, tabla = "...")`; ver las tablas de cada año con
  [`catalogo_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_eh.md).
- **ECE 4T-2015 a 3T-2025** (40 trimestres, serie completa), nivel
  persona, procesados desde el repositorio abierto del INE
  (`nube.ine.gob.bo`). En 2020 (T2–T4) la ECE fue de cobertura **solo
  urbana** por la pandemia: esos trimestres se marcan con
  `cobertura = "urbana"` en
  [`catalogo_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_ece.md)
  y emiten un aviso al usarse.
- `catalogo_encuestas`: inventario maestro de EH y ECE.
- `codebook_eh_meta` y `codebook_ece_meta`: diccionarios extraídos de
  las etiquetas SPSS.
- `variable_canonica_map`: mapa de armonización de la EH a nombres
  canónicos.
- `metadata_encuestas` +
  [`ficha_tecnica()`](https://lab-tecnosocial.github.io/encuestasbo/reference/ficha_tecnica.md):
  ficha técnica oficial del INE (universo, cobertura, marco y diseño
  muestral, factor de expansión, tasa de respuesta) extraída de la
  metadata DDI de ANDA para los 32 estudios.

### Acceso

- [`get_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh.md)
  /
  [`get_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_ece.md)
  y atajos
  ([`get_personas_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_eh.md),
  [`get_viviendas_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_eh.md),
  [`get_personas_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_ece.md),
  [`get_viviendas_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_ece.md)),
  con filtros por departamento y área y modos `"arrow"` / `"tibble"` /
  `"duckdb"`.
- [`catalogo_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_eh.md)
  /
  [`catalogo_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_ece.md).
- Caché:
  [`encuestasbo_cache_dir()`](https://lab-tecnosocial.github.io/encuestasbo/reference/encuestasbo_cache_dir.md),
  `_info()`, `_clear()`,
  [`update_encuestasbo()`](https://lab-tecnosocial.github.io/encuestasbo/reference/update_encuestasbo.md).

### Diccionario y etiquetas

- [`codebook()`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook.md),
  [`codebook_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook_valores.md),
  [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md),
  [`etiquetar_variables()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_variables.md).

### Armonización entre años

- [`armonizar_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_eh.md),
  [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md),
  [`variables_armonizadas()`](https://lab-tecnosocial.github.io/encuestasbo/reference/variables_armonizadas.md),
  [`grupos_variables()`](https://lab-tecnosocial.github.io/encuestasbo/reference/grupos_variables.md).
  Apoyada en variables derivadas del INE (ingresos, pobreza, educación,
  empleo) con nombres estables entre años.
- [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md)
  se respalda en un único Parquet armonizado precalculado (~5 MB, 13
  años, esquema consistente) y admite `as = "tibble"/"arrow"/"duckdb"`
  para consultas cross-año perezosas (DuckDB por debajo). Corrige además
  el apilado de años con tipos mixtos (p. ej. `estrato` texto/numérico).
- Las variables categóricas armonizadas tienen **etiquetas estables
  entre años**;
  [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md)
  las detecta automáticamente en datos armonizados (sin indicar año).
  Además se unifican valores que cambiaban de código entre años
  (`nivel_edu`: “Otros” era 4/5/9 según el año → ahora siempre 4).
- [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md)
  ahora también etiqueta `depto` con los nombres de los nueve
  departamentos (1 = Chuquisaca … 9 = Pando) en datos armonizados.
- Nuevas variables armonizadas de **vivienda** y **salud**:
  `tipo_vivienda`, `tenencia_vivienda` (recodificada a un esquema
  canónico; el INE usó dos órdenes de códigos, 2012-2015 vs 2016+) y
  `tiene_seguro_salud` (afiliación a algún seguro, 0/1). Las de vivienda
  se unen a la capa persona por `folio`. Nuevos grupos `"vivienda"` y
  `"salud"` en
  [`grupos_variables()`](https://lab-tecnosocial.github.io/encuestasbo/reference/grupos_variables.md).
  Validadas contra ARU (tenencia propia ~62 %, casa ~75 %, sin seguro
  2023 = 14,3 %).

### Indicadores con diseño muestral

- Nuevos atajos que envuelven el diseño + `srvyr` y devuelven la
  estimación con intervalo de confianza, con desagregación opcional vía
  `por =`:
  [`tasa_pobreza()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_pobreza.md)
  (EH),
  [`tasa_desempleo()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_desempleo.md),
  [`tasa_subocupacion()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_subocupacion.md)
  y
  [`empleo_vulnerable()`](https://lab-tecnosocial.github.io/encuestasbo/reference/empleo_vulnerable.md)
  (ECE). Utilidad
  [`grupo_edad()`](https://lab-tecnosocial.github.io/encuestasbo/reference/grupo_edad.md)
  para cohortes etarias.
- Validados contra estudios de terceros (Fundación ARU) que usan los
  mismos microdatos del INE: pobreza por área, subocupación por
  sexo/departamento y empleo vulnerable coinciden con las cifras
  publicadas.

### Armonización de la ECE

- [`armonizar_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_ece.md)
  ahora añade variables canónicas estables entre versiones del
  cuestionario (cambió en 2019): `sexo`, `categoria_ocupacional`
  (mapeada desde `s2_20` hasta 2018 y `s2_18` desde 2019, con
  codificaciones distintas), `ocupado`, `desocupado` y `subocupado`.
  Esto hace comparables indicadores como el empleo vulnerable a lo largo
  de toda la serie.

### Diseño muestral

- [`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
  /
  [`diseno_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_ece.md):
  devuelven un diseño `srvyr` listo (`ids = upm`, `strata = estrato`,
  `weights = factor`, `nest = TRUE`, `survey.lonely.psu = "adjust"`). La
  tasa de pobreza 2023 estimada coincide con la cifra oficial del INE.

### Documentación

- Sitio pkgdown con 6 viñetas: primeros pasos; **catálogo, diccionario y
  ficha técnica (interactivo con DT)**; la Encuesta de Hogares (pobreza,
  ingresos, empleo); diseño muestral; armonización entre años; y empleo
  trimestral (ECE).

### Distribución

- Microdatos publicados en GitHub Releases: `data-eh-v1` (EH +
  armonizada) y `data-ece-v1` (ECE). Las funciones `get_*` descargan y
  cachean automáticamente.

### Pendiente

- Armonización canónica de la ECE entre trimestres (hoy se accede con
  sus nombres nativos; el diseño muestral ya funciona).
- Armonización de clasificadores ocupacionales/actividad (COB/CAEB)
  entre versiones.
