# add_eh_bases.R
# -----------------------------------------------------------------------------
# Procesa las bases TEMÁTICAS de la EH que faltaban (además de persona/vivienda):
# equipamiento, gastos_alimentarios, gastos_no_alimentarios, seguridad_alimentaria,
# discriminacion, turismo, cultura, defunciones. Para cada .sav en
# original-data/eh/<año>/: escribe un Parquet eh_<año>_<base>.parquet y añade su
# codebook a codebook_eh_meta. Reusa la lógica de build_eh.R.
#
# Uso:  Rscript data-raw/add_eh_bases.R
# -----------------------------------------------------------------------------
suppressMessages({ library(haven); library(arrow) })

base_dir <- "original-data/eh"
out_dir  <- "data-raw/parquet/eh"
years    <- 2012:2024

# Normaliza el nombre de archivo a una "tabla" canónica (NA = persona/vivienda/omitir).
clasificar_base <- function(fn) {
  k <- tolower(gsub("[ _-]", "", fn))
  if (grepl("nesstar", k)) return(NA_character_)
  if (grepl("persona|personas", k) && !grepl("gasto", k)) return(NA_character_)  # ya procesada
  if (grepl("vivienda", k)) return(NA_character_)                                # ya procesada
  if (grepl("noalim", k))                       return("gastos_no_alimentarios")
  if (grepl("equipam", k))                      return("equipamiento")           # incl. "GASTOS EQUIPAMIENTO" 2015
  if (grepl("gasto", k) && grepl("alim", k))    return("gastos_alimentarios")
  if (grepl("segurid", k))                      return("seguridad_alimentaria")
  if (grepl("discrimin", k))                    return("discriminacion")
  if (grepl("turismo", k))                      return("turismo")
  if (grepl("cultura", k))                      return("cultura")
  if (grepl("defunci", k))                      return("defunciones")
  NA_character_
}

clasificar_tipo <- function(x, nombre) {
  labs <- attr(x, "labels")
  if (!is.null(labs) && length(labs) > 0) return("categorica")
  if (grepl("(_cod$|_cod[0-9]|cod$)", nombre)) return("categorica")
  if (is.character(x)) return("texto")
  "numerica"
}
extraer_codebook <- function(d, tabla) {
  nm <- names(d)
  etq <- vapply(d, function(x) { l <- attr(x, "label"); if (is.null(l) || length(l) == 0) NA_character_ else as.character(l)[1] }, character(1))
  tipo <- mapply(clasificar_tipo, d, nm)
  vc <- lapply(d, function(x) {
    labs <- attr(x, "labels"); if (is.null(labs) || length(labs) == 0) return(NULL)
    data.frame(codigo = unname(labs), etiqueta = names(labs), stringsAsFactors = FALSE)
  })
  df <- data.frame(variable = nm, etiqueta = etq, tabla = tabla, tipo = tipo, stringsAsFactors = FALSE)
  df$valores_codigos <- vc
  df
}

load("data/codebook_eh_meta.rda")   # lista por año (persona/vivienda)
inv <- list()                         # inventario (anio, tabla) de lo nuevo

for (y in years) {
  ydir <- file.path(base_dir, as.character(y))
  if (!dir.exists(ydir)) next
  savs <- list.files(ydir, pattern = "[.]sav$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  # codebook del año: conservar persona/vivienda ya existentes
  cb_y <- codebook_eh_meta[[as.character(y)]]
  if (!is.null(cb_y)) cb_y <- cb_y[cb_y$tabla %in% c("persona", "vivienda"), ]
  nuevas <- list()
  for (f in savs) {
    tabla <- clasificar_base(basename(f))
    if (is.na(tabla)) next
    if (tabla %in% names(nuevas)) next  # si hay duplicados, usa el primero
    d <- tryCatch(read_sav(f), error = function(e) read_sav(f, encoding = "latin1"))
    names(d) <- tolower(names(d))
    nuevas[[tabla]] <- extraer_codebook(d, tabla)
    d <- zap_formats(zap_labels(d))
    out <- file.path(out_dir, sprintf("eh_%d_%s.parquet", y, tabla))
    write_parquet(d, out, compression = "zstd", compression_level = 6)
    inv[[length(inv) + 1]] <- data.frame(anio = y, tabla = tabla)
    message(sprintf("  %d/%-22s -> %s (%d x %d)", y, tabla, basename(out), nrow(d), ncol(d)))
  }
  codebook_eh_meta[[as.character(y)]] <- do.call(rbind, c(list(cb_y), nuevas, make.row.names = FALSE))
}

usethis::use_data(codebook_eh_meta, overwrite = TRUE, compress = "xz")
inv <- do.call(rbind, inv)
saveRDS(inv, "data-raw/eh_bases_extra.rds")
message(sprintf("\nListo. Bases nuevas: %d. codebook_eh_meta: %d años.", nrow(inv), length(codebook_eh_meta)))
print(table(inv$tabla))
