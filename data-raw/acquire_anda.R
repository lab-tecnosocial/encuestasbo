# acquire_anda.R
# -----------------------------------------------------------------------------
# Pipeline de adquisición de microdatos desde el portal ANDA del INE.
#
# DOS PARTES:
#
#   (A) MANUAL / semi-asistido (requiere sesión logueada en Chrome del usuario):
#       1. Navegar el estudio en ANDA y confirmar su catalog_id:
#          https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS
#       2. Descargar el .zip/.sav del estudio (login + aceptar términos).
#          Guardar los .sav crudos en  original-data/<encuesta>/<periodo>/
#          (este directorio está en .gitignore; no se versiona).
#       Estos pasos se asisten con las herramientas Chrome MCP, pero la sesión
#       y la confirmación de qué estudio corresponde a qué periodo las da el humano.
#
#   (B) AUTOMATIZADO (R puro, sin login) — lo que hace este script:
#       3. Leer cada .sav con haven (preserva etiquetas `label`/`labels`).
#       4. Normalizar nombres al esquema canónico (folio, factor, upm, estrato,
#          depto, area, ...) según un mapa por año.
#       5. Extraer el codebook desde los atributos `labelled` (build_codebook_eh.R).
#       6. zap_labels() -> numérico puro; escribir Parquet.
#       7. (upload_releases_eh.R) subir el Parquet al GitHub Release con piggyback.
#
# Uso típico (una vez descargado el .sav a original-data/):
#   source("data-raw/acquire_anda.R")
#   inspeccionar_sav("original-data/eh/2023/EH2023_Persona.sav")   # ver variables
#   procesar_sav(
#     sav      = "original-data/eh/2023/EH2023_Persona.sav",
#     encuesta = "eh", anio = 2023, tabla = "persona",
#     rename   = mapa_rename_eh_2023_persona   # definido tras inspeccionar
#   )
# -----------------------------------------------------------------------------

stopifnot(requireNamespace("haven", quietly = TRUE),
          requireNamespace("arrow", quietly = TRUE))

#' Inspecciona un .sav: lista nombres, etiquetas y nº de categorías por variable.
#' Sirve para construir el mapa de renombrado canónico y verificar las variables
#' de diseño (factor/upm/estrato) y su casing real.
inspeccionar_sav <- function(sav) {
  d <- haven::read_sav(sav, n_max = 0)   # solo metadatos, sin filas
  data.frame(
    variable = names(d),
    etiqueta = vapply(d, function(x) attr(x, "label") %||% NA_character_, character(1)),
    n_cats   = vapply(d, function(x) length(attr(x, "labels")), integer(1)),
    clase    = vapply(d, function(x) class(x)[1], character(1)),
    row.names = NULL, stringsAsFactors = FALSE
  )
}

#' Lee un .sav, aplica el renombrado canónico, valida el diseño muestral,
#' convierte a numérico (zap_labels) y escribe el Parquet en la ruta esperada
#' por el catálogo. Devuelve, invisible, la ruta del Parquet escrito.
#'
#' @param rename Named character vector: c(canónico = "nombre_origen", ...).
#'   Debe mapear al menos folio, factor, upm, estrato, depto, area cuando existan.
procesar_sav <- function(sav, encuesta, anio, tabla, rename = NULL,
                         trimestre = NULL, out_dir = "data-raw/parquet") {
  d <- haven::read_sav(sav)
  names(d) <- tolower(names(d))

  if (!is.null(rename)) {
    # rename: canónico -> origen (en minúsculas). Renombra in-place.
    origen <- tolower(unname(rename))
    canon  <- names(rename)
    hit <- match(origen, names(d))
    if (anyNA(hit)) {
      faltan <- canon[is.na(hit)]
      warning("Variables de origen no encontradas para: ", paste(faltan, collapse = ", "))
    }
    names(d)[stats::na.omit(hit)] <- canon[!is.na(hit)]
  }

  # Validación de diseño muestral mínimo
  fila <- encuestasbo::catalogo_encuestas[
    encuestasbo::catalogo_encuestas$encuesta == encuesta &
    encuestasbo::catalogo_encuestas$anio == anio &
    encuestasbo::catalogo_encuestas$tabla == tabla &
    (is.na(trimestre) | encuestasbo::catalogo_encuestas$trimestre == trimestre), ]
  diseno_vars <- stats::na.omit(c(fila$factor_var[1], fila$upm_var[1], fila$estrato_var[1]))
  faltan_dis <- setdiff(diseno_vars, names(d))
  if (length(faltan_dis)) {
    warning("Faltan variables de diseño tras el renombrado: ",
            paste(faltan_dis, collapse = ", "),
            ". Revisa el mapa `rename`.")
  }

  d <- haven::zap_labels(d)   # códigos numéricos puros; etiquetas van al codebook
  d <- haven::zap_formats(d)

  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out <- file.path(out_dir, fila$archivo_parquet[1])
  arrow::write_parquet(d, out, compression = "zstd", compression_level = 6)
  message(sprintf("Parquet escrito: %s (%d filas x %d cols)", out, nrow(d), ncol(d)))
  invisible(out)
}

`%||%` <- function(x, y) if (is.null(x)) y else x
