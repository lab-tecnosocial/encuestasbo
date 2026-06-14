# build_ece.R
# -----------------------------------------------------------------------------
# Procesa los .sav de la Encuesta Continua de Empleo (ECE) descargados desde el
# repositorio abierto del INE (nube.ine.gob.bo) en original-data/ece/zips/ y
# produce:
#   1) Parquet por trimestre en data-raw/parquet/ece/   (para get_ece)
#   2) codebook_ece_meta -> data/codebook_ece_meta.rda
#
# Cada zip ECE_<Q>T<AAAA>.zip contiene un único .sav a nivel persona, con las
# variables de diseño upm/estrato y factores fact_trim_act (trimestral) y
# fact_mes_act (mensual).
#
# Uso:  Rscript data-raw/build_ece.R
# -----------------------------------------------------------------------------
suppressMessages({library(haven); library(arrow)})

zip_dir <- "original-data/ece/zips"
ext_dir <- "original-data/ece/extracted"
out_dir <- "data-raw/parquet/ece"
dir.create(ext_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

clasificar_tipo <- function(x, nombre) {
  labs <- attr(x, "labels")
  if (!is.null(labs) && length(labs) > 0) return("categorica")
  if (grepl("(_cod$|cod$)", nombre)) return("categorica")
  if (is.character(x)) return("texto")
  "numerica"
}
extraer_codebook <- function(d, tabla = "persona") {
  nm <- names(d)
  etq <- vapply(d, function(x) { l <- attr(x, "label"); if (is.null(l)) NA_character_ else as.character(l) }, character(1))
  tipo <- mapply(clasificar_tipo, d, nm)
  vc <- lapply(d, function(x) {
    labs <- attr(x, "labels"); if (is.null(labs) || length(labs) == 0) return(NULL)
    data.frame(codigo = unname(labs), etiqueta = names(labs), stringsAsFactors = FALSE)
  })
  df <- data.frame(variable = nm, etiqueta = etq, tabla = tabla, tipo = tipo, stringsAsFactors = FALSE)
  df$valores_codigos <- vc
  df
}

zips <- list.files(zip_dir, pattern = "^ECE_[1-4]T[0-9]{4}[.]zip$", full.names = TRUE)
codebook_ece_meta <- list()
periodos <- list()

for (z in zips) {
  base_nm <- sub("[.]zip$", "", basename(z))                # ECE_2T2017
  mm <- regmatches(base_nm, regexec("ECE_([1-4])T([0-9]{4})", base_nm))[[1]]
  trim <- as.integer(mm[2]); anio <- as.integer(mm[3])
  bsdtar_ok <- system2("bsdtar", c("-xf", shQuote(z), "-C", shQuote(ext_dir)), stdout = FALSE, stderr = FALSE)
  sav <- list.files(ext_dir, pattern = "[.]sav$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  sav <- sav[grepl(base_nm, sav, fixed = TRUE)]
  if (length(sav) == 0) { message("SIN .sav: ", base_nm); next }
  d <- tryCatch(read_sav(sav[1]), error = function(e) read_sav(sav[1], encoding = "latin1"))
  names(d) <- tolower(names(d))
  key <- sprintf("%dt%d", anio, trim)
  codebook_ece_meta[[key]] <- extraer_codebook(d)
  d <- zap_formats(zap_labels(d))
  out <- file.path(out_dir, sprintf("ece_%dt%d_persona.parquet", anio, trim))
  write_parquet(d, out, compression = "zstd", compression_level = 6)
  periodos[[length(periodos) + 1]] <- data.frame(anio = anio, trimestre = trim,
                                                 filas = nrow(d), cols = ncol(d))
  message(sprintf("  %s -> %s (%d x %d)", base_nm, basename(out), nrow(d), ncol(d)))
}

usethis::use_data(codebook_ece_meta, overwrite = TRUE, compress = "xz")
per <- do.call(rbind, periodos)
per <- per[order(per$anio, per$trimestre), ]
saveRDS(per, "data-raw/ece_periodos.rds")
message(sprintf("\ncodebook_ece_meta: %d periodos", length(codebook_ece_meta)))
print(per)
