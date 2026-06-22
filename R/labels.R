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
#' Detecta automáticamente el tipo de datos:
#'
#' - **Datos crudos** (nombres por año, e.g. `s01a_02`): usa el diccionario del
#'   INE para `encuesta`/`anio` (y `trimestre` en la ECE).
#' - **Datos armonizados** de [armonizar_eh()] / [get_eh_armonizada()] (nombres
#'   canónicos como `sexo`, `nivel_edu`, `pobre`): usa las etiquetas del esquema
#'   armonizado, **estables entre años**. Se detecta por la presencia de columnas
#'   canónicas, sin necesidad de indicar `anio`.
#'
#' @seealso [etiquetar_variables()], [codebook_valores()].
#' @export
#' @examples
#' \dontrun{
#' # Datos crudos
#' get_eh(2023, "persona", as = "tibble") |>
#'   etiquetar_valores(anio = 2023) |>
#'   dplyr::count(s01a_02)
#'
#' # Datos armonizados (etiquetas canónicas estables entre años)
#' get_eh_armonizada(grupo = "pobreza") |>
#'   etiquetar_valores() |>
#'   dplyr::count(anio, pobre)
#' }
etiquetar_valores <- function(df, columnas = NULL, encuesta = "eh", anio = 2024, trimestre = NULL) {
  cols <- if (is.null(columnas)) names(df) else columnas

  # Datos armonizados (armonizar_eh / get_eh_armonizada): los códigos canónicos
  # tienen sus propias etiquetas, estables entre años, no las de un año concreto.
  if (any(.HARMONIZED_MARKERS %in% names(df))) {
    for (col in intersect(cols, names(df))) {
      labs <- .HARMONIZED_VALUE_LABELS[[col]]
      if (is.null(labs)) next
      df[[col]] <- factor(as.character(df[[col]]),
                          levels = names(labs), labels = unname(labs))
    }
    return(df)
  }

  meta <- .get_codebook(encuesta, anio, trimestre)
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
