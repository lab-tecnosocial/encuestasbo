# Núcleo genérico: descarga (o usa caché) un archivo de un GitHub Release.
.download_release <- function(filename, subdir, release_tag, overwrite = FALSE, verbose = TRUE) {
  dest <- .cache_path(filename, subdir = subdir)

  if (.is_cached(filename, subdir = subdir) && !overwrite) {
    if (verbose) cli::cli_inform(c("v" = "Usando caché: {.file {filename}}"))
    return(invisible(as.character(dest)))
  }

  fs::dir_create(fs::path_dir(dest), recurse = TRUE)
  url <- .release_url(release_tag, filename)

  if (verbose) {
    cli::cli_progress_step(
      "Descargando {.file {filename}}...",
      msg_done = "Descargado {.file {filename}}"
    )
  }

  tryCatch(
    curl::curl_download(url, as.character(dest), quiet = TRUE),
    error = function(e) {
      if (fs::file_exists(dest)) fs::file_delete(dest)
      releases_url <- paste0("https://github.com/", .ENCUESTASBO_REPO, "/releases")
      cli::cli_abort(c(
        "Error al descargar {.file {filename}}.",
        "x" = conditionMessage(e),
        "i" = "Verifica tu conexión o que el release {.val {release_tag}} exista en {.url {releases_url}}."
      ))
    }
  )

  invisible(as.character(dest))
}

#' Descarga un Parquet de una encuesta desde su GitHub Release
#'
#' @param fila Una fila del [catalogo_encuestas] (data.frame de 1 fila) con
#'   `release_tag` y `archivo_parquet`.
#' @param overwrite Lógico. Si `TRUE`, re-descarga aunque exista en caché.
#' @param verbose Lógico. Mostrar progreso.
#' @return Ruta local al archivo (invisible).
#' @keywords internal
.download_encuesta <- function(fila, overwrite = FALSE, verbose = TRUE) {
  .download_release(fila$archivo_parquet, subdir = fila$encuesta,
                    release_tag = fila$release_tag, overwrite = overwrite, verbose = verbose)
}

# Descarga (o usa caché) el Parquet de la EH armonizada.
.download_armonizada_eh <- function(overwrite = FALSE, verbose = TRUE) {
  a <- .ARMONIZADA_EH
  .download_release(a$filename, subdir = a$subdir, release_tag = a$release_tag,
                    overwrite = overwrite, verbose = verbose)
}
