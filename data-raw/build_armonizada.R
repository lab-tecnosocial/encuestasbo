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

anios <- sort(unique(catalogo_eh(tabla = "persona")$anio))
partes <- lapply(anios, function(y) {
  df <- get_eh(y, "persona", as = "tibble", verbose = FALSE)
  df <- armonizar_eh(df, y, solo_canonicas = TRUE)
  df <- encuestasbo:::.coerce_canonicas(df)   # tipos consistentes entre años
  df$anio <- as.integer(y)
  df
})
arm <- dplyr::bind_rows(partes)

out <- "data-raw/parquet/eh/eh_armonizada.parquet"
write_parquet(arm, out, compression = "zstd", compression_level = 6)
message(sprintf("eh_armonizada.parquet: %d filas x %d cols, %.2f MB",
                nrow(arm), ncol(arm), file.size(out) / 1e6))
