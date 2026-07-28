# Changelog

## encuestasbo 0.2.1

Correcciones de datos y documentación surgidas de una revisión integral
del paquete (validación de las 13 series de la EH y los 40 trimestres de
la ECE contra las cifras oficiales del INE, y ejecución de todos los
ejemplos de la documentación).

### Correcciones de datos

- **`ocupado` y `desocupado` ahora existen en los 13 años** de la EH y
  con una definición única: se derivan de `condicion_actividad`
  (`condact`), la única variable de empleo estable en toda la serie.
  Antes reproducían las inconsistencias del INE: estaban `NA` para los
  inactivos en 2012–2014 y **el INE dejó de publicarlas en 2022**, así
  que
  [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md)
  las devolvía 100 % `NA` en 2022–2024. La derivación coincide
  **exactamente** (fila a fila) con las variables del INE en 2015–2021,
  donde sí las publica de forma homogénea, y no altera las tasas ya
  publicadas.
- **`tiene_seguro_salud` ya cubre 2014.** El patrón que localiza la
  pregunta en el diccionario no toleraba un errata del INE en 2014 (“los
  siguiente seguros”), así que ese año quedaba 100 % `NA` pese a existir
  la variable (`s4a_04a`, con “Ninguno” = 6). La serie de cobertura de
  salud es ahora completa 2012–2024.
- `catalogo_encuestas$catalog_id` **se rellena** con el id real del
  estudio en ANDA (antes estaba `NA` en todas las filas). Los trimestres
  4T2015–2T2019 de la ECE comparten el id del estudio consolidado; los
  de 3T2019–1T2021 quedan `NA` porque provienen del repositorio abierto
  del INE, no de ANDA.
- Se retiran del catálogo las columnas `archivo_sav`, `version_caeb` y
  `version_cob`: estaban vacías en todas las filas y no tenían fuente.
- Etiqueta canónica de `condicion_actividad`: el código 0 pasa de “Menor
  de 10 años” a “En edad de no trabajar”. El umbral de edad de la PET
  cambió en la serie (el INE documenta 14+ desde 2021), así que la
  etiqueta no lo fija.
- `grupos_variables()$empleo` incluye `desocupado`, que faltaba pese a
  ser una variable canónica armonizada.

> El Parquet `eh_armonizada.parquet` del Release `data-eh-v1` se
> regeneró con estas correcciones. Si tienes datos en caché, ejecuta
> [`encuestasbo_cache_clear()`](https://lab-tecnosocial.github.io/encuestasbo/reference/encuestasbo_cache_clear.md)
> para descargar la versión corregida.

### Correcciones de código

- Un fallo de descarga (sin conexión, release o archivo inexistente)
  mostraba `Invalid cli literal` en lugar del diagnóstico: el mensaje de
  error tenía una interpolación anidada inválida para `cli`. Ahora
  muestra el archivo, la causa y la URL de los releases.

### Documentación

- `codebook_eh_meta` decía que la lista no incluye 2020; sí lo incluye
  (la EH 2020 existe, con catálogo ANDA 88 y bases persona/vivienda).
- [`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
  documentaba los años como “2012-2019, 2021-2024”; son 2012-2024.
- [`get_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_ece.md)
  y
  [`diseno_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_ece.md)
  ofrecían `tabla = "vivienda"`, inexistente en la ECE (que solo se
  distribuye a nivel persona).
- [`armonizar_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_eh.md)
  documenta ahora la armonización de **valores** (nivel educativo,
  tenencia de la vivienda, seguro de salud y la derivación del empleo),
  y `variable_canonica_map` aclara que las columnas `vAAAA` describen el
  origen y no la disponibilidad de la columna canónica.
- [`tasa_subocupacion()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_subocupacion.md)
  devuelve `NaN` (no `NA`) antes de 2019; documentado.
- Título y descripción del paquete reflejan el alcance real (ECE hasta
  3T-2025).

## encuestasbo 0.2.0

### Nuevas funcionalidades

- [`get_ece_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_ece_armonizada.md) +
  [`variables_armonizadas_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/variables_armonizadas_ece.md):
  serie de la ECE armonizada apilada entre trimestres (formato largo con
  `anio`/`trimestre`), equivalente para la ECE de
  [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md).
  Aplica
  [`armonizar_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_ece.md)
  a cada trimestre (compatibilizando las versiones del cuestionario,
  `s2_20` hasta 2018 y `s2_18` desde 2019) y homogeneiza tipos; admite
  filtros por año/trimestre, departamento y área y modos
  `"tibble"/"arrow"/"duckdb"`. No requiere un Parquet consolidado:
  reutiliza los trimestres ya publicados.
- [`deflactar()`](https://lab-tecnosocial.github.io/encuestasbo/reference/deflactar.md) +
  dataset `ipc_bolivia`: lleva ingresos nominales a precios constantes
  de un año base con el IPC de Bolivia (media anual; fuente Banco
  Mundial / INE), para comparar ingresos entre años sin el sesgo de la
  inflación. Acepta un índice propio (p. ej. IPC por ciudad) vía
  `indice`.
- [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md)
  ahora reconoce también la serie ECE armonizada (incluida la etiqueta
  de `categoria_ocupacional`).

### Correcciones

- `get_ece(..., variables = ...)` ya conserva los factores de expansión
  de la ECE (`fact_trim_act`/`fact_mes_act`). Antes se descartaban
  silenciosamente porque la lista de columnas de diseño estaba fijada
  con los nombres de la EH; ahora se derivan del catálogo (correcto para
  cada encuesta).
- [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md)
  avisa cuando una variable pedida en `variables=` no existe (no así las
  expandidas desde `grupo=`, cuya ausencia parcial es normal).
- Se retira `get_viviendas_ece()`: la ECE se distribuye únicamente a
  nivel `persona`, por lo que ese atajo nunca podía devolver datos.

### Interno

- `stats` añadido a `Imports` (uso de
  [`stats::setNames`](https://rdrr.io/r/stats/setNames.html)).
- Documentación de datos y dev-docs actualizadas; nuevos tests para la
  serie ECE armonizada, el deflactor y la selección de variables de la
  ECE.

## encuestasbo 0.1.0

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
  `get_viviendas_ece()`), con filtros por departamento y área y modos
  `"arrow"` / `"tibble"` / `"duckdb"`.
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

- Armonización de clasificadores ocupacionales/actividad (COB/CAEB)
  entre versiones.
