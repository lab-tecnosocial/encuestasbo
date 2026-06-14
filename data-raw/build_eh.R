# build_eh.R
# -----------------------------------------------------------------------------
# Procesa los .sav de la Encuesta de Hogares (ya descargados/extraídos en
# original-data/eh/<año>/) y produce:
#   1) Parquet crudo por (año, tabla) en data-raw/parquet/eh/   (para get_eh)
#   2) codebook_eh_meta  -> data/codebook_eh_meta.rda           (etiquetas)
#
# Los nombres de las variables de DISEÑO/GEO son consistentes entre años
# (folio, depto, area, nro, upm, estrato; factor — salvo 2012-2014 que traen
# factor_2001/factor_2014). La armonización de nombres sustantivos se aplica en
# tiempo de ejecución con armonizar_eh() + variable_canonica_map.
#
# Uso:  Rscript data-raw/build_eh.R
# -----------------------------------------------------------------------------
suppressMessages({library(haven); library(arrow)})

base    <- "original-data/eh"
out_dir <- "data-raw/parquet/eh"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
years   <- 2012:2024

# Localiza el .sav de una tabla (persona/vivienda) para un año dado.
find_sav <- function(y, kind) {
  dir <- if (y == 2023) file.path(base, "2023") else file.path(base, y, "raw")
  f <- list.files(dir, pattern = "[.]sav$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  f <- f[grepl(kind, f, ignore.case = TRUE) & !grepl("nesstar", f, ignore.case = TRUE)]
  if (length(f) == 0) return(NA_character_)
  f[which.min(nchar(f))]
}

# Clasifica el tipo de una columna labelled/haven.
clasificar_tipo <- function(x, nombre) {
  labs <- attr(x, "labels")
  if (!is.null(labs) && length(labs) > 0) return("categorica")
  if (grepl("(_cod$|_cod[0-9]|cod$)", nombre)) return("categorica")
  if (is.character(x)) return("texto")
  "numerica"
}

# Extrae el codebook de un data.frame labelled (antes de zap).
extraer_codebook <- function(d, tabla) {
  nm <- names(d)
  etq <- vapply(d, function(x) { l <- attr(x, "label"); if (is.null(l)) NA_character_ else as.character(l) }, character(1))
  tipo <- mapply(clasificar_tipo, d, nm)
  vc <- lapply(d, function(x) {
    labs <- attr(x, "labels")
    if (is.null(labs) || length(labs) == 0) return(NULL)
    data.frame(codigo = unname(labs), etiqueta = names(labs), stringsAsFactors = FALSE)
  })
  data.frame(variable = nm, etiqueta = etq, tabla = tabla, tipo = tipo,
             stringsAsFactors = FALSE) |>
    (\(df) { df$valores_codigos <- vc; df })()
}

codebook_eh_meta <- list()

for (y in years) {
  cb_year <- list()
  for (tabla in c("persona", "vivienda")) {
    f <- find_sav(y, tabla)
    if (is.na(f)) { message(sprintf("  %d/%s: SIN ARCHIVO", y, tabla)); next }
    d <- tryCatch(read_sav(f),
                  error = function(e) read_sav(f, encoding = "latin1"))
    names(d) <- tolower(names(d))
    cb_year[[tabla]] <- extraer_codebook(d, tabla)
    d <- zap_formats(zap_labels(d))
    out <- file.path(out_dir, sprintf("eh_%d_%s.parquet", y, tabla))
    write_parquet(d, out, compression = "zstd", compression_level = 6)
    message(sprintf("  %d/%-8s -> %s (%d filas x %d cols)", y, tabla, basename(out), nrow(d), ncol(d)))
  }
  codebook_eh_meta[[as.character(y)]] <- do.call(rbind, c(cb_year, make.row.names = FALSE))
}

usethis::use_data(codebook_eh_meta, overwrite = TRUE, compress = "xz")
message(sprintf("\ncodebook_eh_meta: %d años", length(codebook_eh_meta)))
