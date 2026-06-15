# upload_releases_eh.R
# -----------------------------------------------------------------------------
# Sube todos los Parquet de la EH (data-raw/parquet/eh/) + el armonizado a un
# único GitHub Release `data-eh-v1`, de donde get_eh()/get_eh_armonizada()
# descargan. Usa la CLI `gh` (requiere `gh auth login` con permiso de escritura).
#
# Uso:  Rscript data-raw/upload_releases_eh.R
# -----------------------------------------------------------------------------
repo   <- "lab-tecnosocial/encuestasbo"
tag    <- "data-eh-v1"
pq_dir <- "data-raw/parquet/eh"
paths  <- list.files(pq_dir, pattern = "[.]parquet$", full.names = TRUE)
stopifnot(length(paths) > 0)

# Crear el release si no existe (ignora error si ya existe)
system2("gh", c("release", "create", tag, "--repo", repo,
                "--title", shQuote("Datos EH (Parquet)"),
                "--notes", shQuote("Microdatos de la Encuesta de Hogares 2012-2024 (persona y vivienda) y la EH armonizada, en Parquet. Fuente: INE Bolivia (ANDA).")))
# Subir/actualizar assets
system2("gh", c("release", "upload", tag, shQuote(paths), "--repo", repo, "--clobber"))
message(sprintf("Subido %s: %d archivo(s)", tag, length(paths)))
