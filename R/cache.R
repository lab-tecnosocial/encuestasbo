#' Directorio de caché local del paquete
#'
#' Devuelve la ruta donde se guardan los archivos Parquet descargados.
#' Por defecto usa el directorio estándar del sistema operativo, pero puede
#' redirigirse a cualquier ruta local (por ejemplo, dentro del proyecto actual)
#' estableciendo la opción `encuestasbo.cache_dir` antes de llamar a `get_*()`.
#'
#' @return Ruta al directorio de caché (cadena de caracteres).
#'
#' @details
#' Para guardar el caché dentro de tu proyecto en lugar del directorio del
#' sistema, añade esto al inicio de tu script o en tu `.Rprofile`:
#'
#' ```r
#' options(encuestasbo.cache_dir = "data/encuestasbo")
#' ```
#'
#' El directorio se crea automáticamente si no existe.
#'
#' @export
#' @examples
#' encuestasbo_cache_dir()
#'
#' # Cambiar a un directorio local (solo para la sesión actual)
#' \dontrun{
#' options(encuestasbo.cache_dir = "data/encuestasbo")
#' encuestasbo_cache_dir()
#' }
encuestasbo_cache_dir <- function() {
  opt <- getOption("encuestasbo.cache_dir", default = NULL)
  if (!is.null(opt)) return(as.character(opt))
  tools::R_user_dir("encuestasbo", which = "cache")
}

#' Información sobre los archivos en caché
#'
#' Muestra los archivos Parquet descargados localmente, con sus tamaños
#' y fechas de descarga.
#'
#' @return Un data.frame con columnas `archivo`, `tamanio` y `modificado`,
#'   o `NULL` invisible si el caché está vacío.
#' @export
#' @examples
#' encuestasbo_cache_info()
encuestasbo_cache_info <- function() {
  cache_dir <- encuestasbo_cache_dir()
  if (!fs::dir_exists(cache_dir)) {
    cli::cli_inform("El directorio de caché no existe aún: {.path {cache_dir}}")
    return(invisible(NULL))
  }
  files <- fs::dir_info(cache_dir, recurse = TRUE, type = "file")
  if (nrow(files) == 0) {
    cli::cli_inform("El caché está vacío. Usa {.code get_eh()} o {.code get_ece()} para descargar datos.")
    return(invisible(NULL))
  }
  result <- data.frame(
    archivo    = as.character(fs::path_rel(files$path, start = cache_dir)),
    tamanio    = format(files$size, units = "auto"),
    modificado = format(files$modification_time, "%Y-%m-%d %H:%M"),
    stringsAsFactors = FALSE
  )
  result
}

#' Limpia el caché local de datos
#'
#' Elimina todos los archivos Parquet descargados localmente. Los datos
#' se pueden volver a descargar usando las funciones `get_*()`.
#'
#' @param ask Lógico. Si `TRUE` (defecto), pide confirmación antes de borrar.
#' @return Invisible `NULL`.
#' @export
#' @examples
#' \dontrun{
#' encuestasbo_cache_clear()
#' }
encuestasbo_cache_clear <- function(ask = TRUE) {
  cache_dir <- encuestasbo_cache_dir()
  if (!fs::dir_exists(cache_dir)) {
    cli::cli_inform("No hay caché que limpiar.")
    return(invisible(NULL))
  }
  all_files <- fs::dir_ls(cache_dir, recurse = TRUE, type = "file")
  if (length(all_files) == 0) {
    cli::cli_inform("El caché ya está vacío.")
    return(invisible(NULL))
  }
  total_size <- sum(fs::file_size(all_files))
  if (ask) {
    resp <- readline(sprintf(
      "¿Eliminar %s de caché en %s? [s/N] ",
      format(total_size, units = "auto", standard = "SI"),
      cache_dir
    ))
    if (!tolower(trimws(resp)) %in% c("s", "si", "sí", "y", "yes")) {
      cli::cli_inform("Operación cancelada.")
      return(invisible(NULL))
    }
  }
  fs::dir_delete(cache_dir)
  cli::cli_alert_success("Caché eliminado ({format(total_size, units = 'auto', standard = 'SI')}).")
  invisible(NULL)
}

#' Actualiza el paquete encuestasbo y limpia el caché
#'
#' Reinstala la última versión de `encuestasbo` desde GitHub y elimina el caché
#' local de datos Parquet, para que los datos se vuelvan a descargar en su
#' versión más reciente.
#'
#' @param clear_cache Lógico. Si `TRUE` (defecto), limpia el caché local
#'   automáticamente tras actualizar el paquete.
#' @return Invisible `NULL`.
#' @export
#' @examples
#' \dontrun{
#' update_encuestasbo()
#' }
update_encuestasbo <- function(clear_cache = TRUE) {
  if (!requireNamespace("remotes", quietly = TRUE)) {
    cli::cli_abort(
      "El paquete {.pkg remotes} es necesario para actualizar encuestasbo.
       Instálalo con: {.code install.packages('remotes')}"
    )
  }
  cli::cli_h1("Actualizando encuestasbo")
  cli::cli_alert_info("Instalando la última versión desde GitHub...")
  remotes::install_github("lab-tecnosocial/encuestasbo", quiet = FALSE)
  cli::cli_alert_success("Paquete actualizado.")
  if (clear_cache) {
    cli::cli_alert_warning(
      "Se eliminará el caché local para que los datos se descarguen en su versión más reciente."
    )
    encuestasbo_cache_clear(ask = FALSE)
  }
  cli::cli_alert_success(
    "Listo. Reinicia R y vuelve a cargar el paquete con {.code library(encuestasbo)}."
  )
  invisible(NULL)
}

.cache_path <- function(filename, subdir = NULL) {
  if (is.null(subdir)) {
    fs::path(encuestasbo_cache_dir(), filename)
  } else {
    fs::path(encuestasbo_cache_dir(), subdir, filename)
  }
}

.is_cached <- function(filename, subdir = NULL) {
  fs::file_exists(.cache_path(filename, subdir = subdir))
}
