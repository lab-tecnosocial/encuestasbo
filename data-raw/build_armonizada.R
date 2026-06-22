# build_armonizada.R
# -----------------------------------------------------------------------------
# Materializa la EH armonizada (todos los años, columnas canónicas, esquema
# consistente) en un único Parquet pequeño (~5 MB) para consultas cross-año
# rápidas con Arrow/DuckDB.
#
#   data-raw/parquet/eh/eh_armonizada.parquet
#
# Se sube a un Release propio (data-eh-armonizada-v1) y lo consume
# get_eh_armonizada(). Reconstruir tras regenerar los Parquet por año.
#
# Uso:  Rscript data-raw/build_armonizada.R
# -----------------------------------------------------------------------------
suppressMessages({library(arrow); library(dplyr)})
devtools::load_all(".", quiet = TRUE)
options(encuestasbo.cache_dir = file.path(getwd(), "data-raw/parquet"))

# Variables canónicas de nivel VIVIENDA: se arman aparte y se unen a persona por folio.
viv_canon <- variable_canonica_map$variable[variable_canonica_map$tabla == "vivienda"]

anios <- sort(unique(catalogo_eh(tabla = "persona")$anio))
partes <- lapply(anios, function(y) {
  df <- get_eh(y, "persona", as = "tibble", verbose = FALSE)
  df <- armonizar_eh(df, y, solo_canonicas = TRUE)
  df <- encuestasbo:::.coerce_canonicas(df)   # tipos consistentes entre años

  # Une atributos de la vivienda (tipo, tenencia) por folio, si existen ese año.
  viv <- tryCatch(
    armonizar_eh(get_eh(y, "vivienda", as = "tibble", verbose = FALSE), y),
    error = function(e) NULL
  )
  if (!is.null(viv) && "folio" %in% names(viv)) {
    cols <- intersect(viv_canon, names(viv))
    if (length(cols)) {
      viv <- encuestasbo:::.coerce_canonicas(viv[, c("folio", cols), drop = FALSE])
      viv <- viv[!duplicated(viv$folio), , drop = FALSE]  # 1 fila por vivienda
      df <- dplyr::left_join(df, viv, by = "folio")
    }
  }
  # Garantiza las columnas de vivienda aunque ese año no las tenga (p. ej. 2020).
  for (cc in viv_canon) if (!cc %in% names(df)) df[[cc]] <- NA_character_

  df$anio <- as.integer(y)
  df
})
arm <- dplyr::bind_rows(partes)

out <- "data-raw/parquet/eh/eh_armonizada.parquet"
write_parquet(arm, out, compression = "zstd", compression_level = 6)
message(sprintf("eh_armonizada.parquet: %d filas x %d cols, %.2f MB",
                nrow(arm), ncol(arm), file.size(out) / 1e6))
