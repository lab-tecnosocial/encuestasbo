# upload_releases_ece.R
# -----------------------------------------------------------------------------
# Sube los Parquet de la ECE (data-raw/parquet/ece/) a GitHub Releases, un tag
# por trimestre (data-ece-<año>t<trim>-v1), para que get_ece() los descargue.
#
# REQUISITOS: repo lab-tecnosocial/encuestasbo, paquete `piggyback`, token con
# permiso de escritura. (El repo aún no se ha creado: ver upload_releases_eh.R.)
#
# Uso:  Rscript data-raw/upload_releases_ece.R
# -----------------------------------------------------------------------------
stopifnot(requireNamespace("piggyback", quietly = TRUE))
repo   <- "lab-tecnosocial/encuestasbo"
pq_dir <- "data-raw/parquet/ece"
load("data/catalogo_encuestas.rda")

ece <- catalogo_encuestas[catalogo_encuestas$encuesta == "ece", ]
for (i in seq_len(nrow(ece))) {
  tag  <- ece$release_tag[i]
  path <- file.path(pq_dir, ece$archivo_parquet[i])
  if (!file.exists(path)) next
  try(piggyback::pb_release_create(repo = repo, tag = tag), silent = TRUE)
  piggyback::pb_upload(path, repo = repo, tag = tag, overwrite = TRUE)
  message(sprintf("Subido %s", tag))
}
