# Atajos por nivel: wrappers finos sobre get_eh() / get_ece() para los niveles
# de análisis más usados. Más legibles que get_eh(anio, "persona").

#' Atajos de acceso a la Encuesta de Hogares por nivel
#'
#' Wrappers de [get_eh()] para los niveles de análisis más comunes.
#'
#' @inheritParams get_eh
#' @return Lo mismo que [get_eh()] según `as`.
#' @name atajos_eh
#' @examples
#' \dontrun{
#' get_personas_eh(2023, departamento = "La Paz")
#' get_viviendas_eh(2023)
#' }
NULL

#' @rdname atajos_eh
#' @export
get_personas_eh <- function(anio, departamento = NULL, area = NULL,
                            variables = NULL, as = c("arrow", "tibble", "duckdb"),
                            overwrite = FALSE, verbose = TRUE) {
  get_eh(anio, "persona", departamento = departamento, area = area,
         variables = variables, as = match.arg(as), overwrite = overwrite,
         verbose = verbose)
}

#' @rdname atajos_eh
#' @export
get_viviendas_eh <- function(anio, departamento = NULL, area = NULL,
                             variables = NULL, as = c("arrow", "tibble", "duckdb"),
                             overwrite = FALSE, verbose = TRUE) {
  get_eh(anio, "vivienda", departamento = departamento, area = area,
         variables = variables, as = match.arg(as), overwrite = overwrite,
         verbose = verbose)
}

#' Atajos de acceso a la Encuesta Continua de Empleo por nivel
#'
#' Wrapper de [get_ece()]. La ECE se distribuye únicamente a nivel `persona`.
#'
#' @inheritParams get_ece
#' @return Lo mismo que [get_ece()] según `as`.
#' @name atajos_ece
#' @examples
#' \dontrun{
#' get_personas_ece(2022, trimestre = 3)
#' }
NULL

#' @rdname atajos_ece
#' @export
get_personas_ece <- function(anio, trimestre, departamento = NULL, area = NULL,
                             variables = NULL, as = c("arrow", "tibble", "duckdb"),
                             overwrite = FALSE, verbose = TRUE) {
  get_ece(anio, trimestre, "persona", departamento = departamento, area = area,
          variables = variables, as = match.arg(as), overwrite = overwrite,
          verbose = verbose)
}
