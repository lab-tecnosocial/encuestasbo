# upload_releases_eh.R
# -----------------------------------------------------------------------------
# Sube los Parquet de la EH (data-raw/parquet/eh/) a GitHub Releases, un tag por
# año (data-eh-<año>-v1), para que get_eh() los descargue públicamente.
#
# REQUISITOS: repo lab-tecnosocial/encuestasbo creado, paquete `piggyback`,
# y un token de GitHub (gh auth / GITHUB_PAT) con permiso de escritura.
#
# NOTA: el repo aún no se ha creado (decisión del usuario). Ejecutar este script
# es el paso de publicación; hasta entonces el paquete funciona con caché local:
#   options(encuestasbo.cache_dir = "<ruta>/data-raw/parquet")
#
# Uso:  Rscript data-raw/upload_releases_eh.R
# -----------------------------------------------------------------------------
stopifnot(requireNamespace("piggyback", quietly = TRUE))
repo    <- "lab-tecnosocial/encuestasbo"
pq_dir  <- "data-raw/parquet/eh"
load("data/catalogo_encuestas.rda")

eh <- catalogo_encuestas[catalogo_encuestas$encuesta == "eh", ]
for (tag in unique(eh$release_tag)) {
  files <- eh$archivo_parquet[eh$release_tag == tag]
  paths <- file.path(pq_dir, files)
  paths <- paths[file.exists(paths)]
  if (!length(paths)) next
  # crear release si no existe
  try(piggyback::pb_release_create(repo = repo, tag = tag), silent = TRUE)
  piggyback::pb_upload(paths, repo = repo, tag = tag, overwrite = TRUE)
  message(sprintf("Subido %s: %d archivo(s)", tag, length(paths)))
}

# EH armonizada (un único Parquet, todos los años) en su Release propio.
arm <- file.path(pq_dir, "eh_armonizada.parquet")
if (file.exists(arm)) {
  tag <- "data-eh-armonizada-v1"
  try(piggyback::pb_release_create(repo = repo, tag = tag), silent = TRUE)
  piggyback::pb_upload(arm, repo = repo, tag = tag, overwrite = TRUE)
  message("Subido ", tag)
}
