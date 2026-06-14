#' Etiqueta los valores de las variables categóricas
#'
#' Convierte los códigos numéricos de las columnas categóricas en factores con
#' las etiquetas en español del diccionario del INE, para la encuesta y año
#' indicados.
#'
#' @param df Un data.frame (resultado de [get_eh()] con `as = "tibble"`, o de
#'   `collect()` / `DBI::dbGetQuery()`).
#' @param columnas Vector de nombres de columnas a etiquetar. Si `NULL`, todas
#'   las categóricas presentes.
#' @param encuesta `"eh"` (defecto) o `"ece"`.
#' @param anio Año de la encuesta. Por defecto `2024`.
#' @param trimestre Trimestre (1-4); requerido si `encuesta = "ece"`.
#'
#' @return El `df` con las columnas categóricas convertidas a `factor`. Las
#'   columnas no encontradas o no categóricas se devuelven sin cambios.
#'
#' @details
#' Las etiquetas corresponden a los nombres de variable **crudos** de cada año
#' (e.g., `s01a_02`). Si trabajas con datos armonizados de [armonizar_eh()] o
#' [get_eh_armonizada()] (nombres canónicos), las etiquetas de valor no aplican
#' directamente; etiqueta antes de armonizar o usa las propias categorías.
#'
#' @seealso [etiquetar_variables()], [codebook_valores()].
#' @export
#' @examples
#' \dontrun{
#' get_eh(2023, "persona", as = "tibble") |>
#'   etiquetar_valores(anio = 2023) |>
#'   dplyr::count(s01a_02)
#' }
etiquetar_valores <- function(df, columnas = NULL, encuesta = "eh", anio = 2024, trimestre = NULL) {
  meta <- .get_codebook(encuesta, anio, trimestre)
  cols <- if (is.null(columnas)) names(df) else columnas
  for (col in intersect(cols, names(df))) {
    idx <- which(meta$variable == col & meta$tipo == "categorica")
    if (length(idx) == 0) next
    vc <- meta$valores_codigos[[idx[1]]]
    if (is.null(vc) || nrow(vc) == 0) next
    df[[col]] <- factor(as.character(df[[col]]),
                        levels = as.character(vc$codigo),
                        labels = vc$etiqueta)
  }
  df
}

#' Etiqueta los nombres de las variables (columnas)
#'
#' Reemplaza los nombres técnicos de las columnas por sus descripciones del
#' diccionario del INE. Útil para tablas y reportes.
#'
#' @param df Un data.frame.
#' @param encuesta `"eh"` (defecto) o `"ece"`.
#' @param anio Año de la encuesta. Por defecto `2024`.
#' @param trimestre Trimestre (1-4); requerido si `encuesta = "ece"`.
#' @return El `df` con los nombres de columnas reemplazados por sus
#'   descripciones; las no encontradas conservan su nombre.
#' @seealso [etiquetar_valores()].
#' @export
#' @examples
#' \dontrun{
#' get_eh(2023, "persona", variables = "ylab", as = "tibble") |>
#'   etiquetar_variables(anio = 2023)
#' }
etiquetar_variables <- function(df, encuesta = "eh", anio = 2024, trimestre = NULL) {
  meta <- .get_codebook(encuesta, anio, trimestre)
  names(df) <- vapply(names(df), function(col) {
    idx <- which(meta$variable == col)
    if (length(idx) == 0) col else meta$etiqueta[idx[1]]
  }, character(1))
  df
}
