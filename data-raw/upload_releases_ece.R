# upload_releases_ece.R
# -----------------------------------------------------------------------------
# Sube todos los Parquet de la ECE (data-raw/parquet/ece/) a un único GitHub
# Release `data-ece-v1`, de donde get_ece() descarga. Usa la CLI `gh`.
#
# Uso:  Rscript data-raw/upload_releases_ece.R
# -----------------------------------------------------------------------------
repo   <- "lab-tecnosocial/encuestasbo"
tag    <- "data-ece-v1"
pq_dir <- "data-raw/parquet/ece"
paths  <- list.files(pq_dir, pattern = "[.]parquet$", full.names = TRUE)
stopifnot(length(paths) > 0)

system2("gh", c("release", "create", tag, "--repo", repo,
                "--title", shQuote("Datos ECE (Parquet)"),
                "--notes", shQuote("Microdatos de la Encuesta Continua de Empleo 4T2015-3T2025 (nivel persona), en Parquet. Fuente: INE Bolivia.")))
system2("gh", c("release", "upload", tag, shQuote(paths), "--repo", repo, "--clobber"))
message(sprintf("Subido %s: %d archivo(s)", tag, length(paths)))
