# build_metadata.R
# -----------------------------------------------------------------------------
# Descarga la metadata oficial DDI (JSON) de cada estudio en ANDA y construye
# `metadata_encuestas`: la ficha técnica estructurada de cada encuesta
# (universo, cobertura, marco y diseño muestral, factor de expansión, modo de
# recolección, tasa de respuesta, periodo de referencia).
#
# Fuente: https://anda.ine.gob.bo/index.php/metadata/export/<id>/json
# Uso:    Rscript data-raw/build_metadata.R
# -----------------------------------------------------------------------------
suppressMessages(library(jsonlite))
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x
UA <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/120 Safari/537.36"

# Estudios en ANDA: catalog_id -> (encuesta, anio, trimestre)
estudios <- rbind(
  data.frame(id = c(51,39,38,53,54,55,78,84,88,93,106,108,163),
             encuesta = "eh",
             anio = c(2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024),
             trimestre = NA_integer_),
  # ECE: bundle 2015-2019 (id 82) + trimestres individuales
  data.frame(id = 82, encuesta = "ece", anio = NA_integer_, trimestre = NA_integer_),  # bundle 4T2015-2T2019
  data.frame(
    id        = c(91,94,95, 96,97,100,101, 103,104,105,107, 109,110,231,232, 131,170,254),
    encuesta  = "ece",
    anio      = c(2021,2021,2021, 2022,2022,2022,2022, 2023,2023,2023,2023, 2024,2024,2024,2024, 2025,2025,2025),
    trimestre = c(2,3,4, 1,2,3,4, 1,2,3,4, 1,2,3,4, 1,2,3)
  )
)

g <- function(x) { if (is.null(x)) return(NA_character_); x <- unlist(x); v <- paste(x, collapse = " "); trimws(gsub("\\s+", " ", v)) }

fetch_meta <- function(id) {
  url <- sprintf("https://anda.ine.gob.bo/index.php/metadata/export/%d/json", id)
  tmp <- tempfile(fileext = ".json")
  ok <- tryCatch({ download.file(url, tmp, quiet = TRUE, headers = c("User-Agent" = UA)); TRUE },
                 error = function(e) FALSE)
  if (!ok) return(NULL)
  j <- tryCatch(fromJSON(tmp, simplifyVector = FALSE), error = function(e) NULL)
  unlink(tmp); j
}

filas <- list()
for (i in seq_len(nrow(estudios))) {
  e <- estudios[i, ]
  j <- fetch_meta(e$id)
  if (is.null(j)) { message("FALLO id ", e$id); next }
  sd <- j$study_desc; si <- sd$study_info; dc <- sd$method$data_collection
  # fechas de recolección -> periodo legible
  fechas <- tryCatch({
    cd <- si$coll_dates
    rng <- vapply(cd, function(d) paste0(d$start %||% "", "/", d$end %||% ""), character(1))
    paste(rng, collapse = "; ")
  }, error = function(z) NA_character_)
  filas[[length(filas) + 1]] <- data.frame(
    encuesta            = e$encuesta,
    anio                = e$anio,
    trimestre           = e$trimestre,
    catalog_id          = e$id,
    idno                = g(sd$title_statement$idno) %||% g(j$doc_desc$title_stmt$idno),
    titulo              = g(sd$title_statement$title),
    universo            = g(si$universe),
    unidad_analisis     = g(si$analysis_unit),
    cobertura_geografica= g(si$geog_coverage),
    periodo_referencia  = g(si$time_periods),
    marco_diseno_muestral = g(dc$sampling_procedure),
    factor_expansion    = g(dc$weight),
    modo_recoleccion    = g(dc$coll_mode),
    muestra_respuesta   = g(dc$sampling_deviation),
    fechas_recoleccion  = fechas,
    stringsAsFactors = FALSE
  )
  message(sprintf("ok %s %s%s (id %d)", e$encuesta, e$anio %||% "2015-2019",
                  ifelse(is.na(e$trimestre), "", paste0(" T", e$trimestre)), e$id))
}

metadata_encuestas <- do.call(rbind, filas)
usethis::use_data(metadata_encuestas, overwrite = TRUE, compress = "xz")
message(sprintf("\nmetadata_encuestas: %d estudios (EH %d, ECE %d)",
                nrow(metadata_encuestas),
                sum(metadata_encuestas$encuesta == "eh"),
                sum(metadata_encuestas$encuesta == "ece")))
