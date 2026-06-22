# Indicadores con diseño muestral (EH y ECE).
#
# Envuelven diseno_eh()/diseno_ece() + srvyr para los indicadores más comunes,
# evitando el boilerplate de survey_mean/survey_ratio. Todos devuelven un tibble
# con la estimación y (por defecto) su intervalo de confianza al 95%, y aceptan
# `por =` para desagregar por una o más variables (p. ej. "depto", "sexo").

# Agrupa un diseño por las variables indicadas en `por` (NULL = sin agrupar).
.aplicar_por <- function(dsn, por) {
  if (is.null(por)) return(dsn)
  dplyr::group_by(dsn, dplyr::across(dplyr::all_of(por)))
}

#' Tasa de pobreza (EH)
#'
#' Incidencia de pobreza monetaria ponderada con el diseño muestral de la EH.
#'
#' @param anio Entero. Año de la EH.
#' @param extrema Lógico. Si `TRUE`, pobreza extrema (`pobre_extremo`); si
#'   `FALSE` (defecto), pobreza moderada (`pobre`).
#' @param por Caracteres. Variable(s) de desagregación (p. ej. `"depto"`,
#'   `"area"`, `c("depto","area")`). `NULL` (defecto) = total nacional.
#' @param vartype Tipo de varianza para `srvyr` (`"ci"` por defecto).
#' @param verbose Lógico. Mostrar progreso de descarga.
#' @return Un tibble con la(s) variable(s) de `por`, `tasa` y su varianza.
#' @seealso [diseno_eh()], [tasa_desempleo()].
#' @export
#' @examples
#' \dontrun{
#' tasa_pobreza(2023)                       # nacional
#' tasa_pobreza(2023, por = "area")         # por área
#' tasa_pobreza(2023, extrema = TRUE, por = "depto")
#' }
tasa_pobreza <- function(anio, extrema = FALSE, por = NULL,
                         vartype = "ci", verbose = FALSE) {
  v <- if (extrema) "pobre_extremo" else "pobre"
  dsn <- diseno_eh(anio, verbose = verbose)
  out <- .aplicar_por(dsn, por) |>
    srvyr::summarise(
      tasa = srvyr::survey_mean(!!rlang::sym(v), na.rm = TRUE, vartype = vartype)
    )
  dplyr::ungroup(out)
}

#' Tasa de desempleo (ECE)
#'
#' Desocupados sobre la población económicamente activa (PEA), ponderada con el
#' diseño de la ECE.
#'
#' @param anio,trimestre Periodo de la ECE.
#' @param por Caracteres. Variable(s) de desagregación (p. ej. `"sexo"`,
#'   `"depto"`). `NULL` = total.
#' @param factor `"trimestral"` (defecto) o `"mensual"`.
#' @param vartype Tipo de varianza (`"ci"` por defecto).
#' @param verbose Lógico.
#' @return Un tibble con `tasa` (proporción) y su varianza.
#' @seealso [diseno_ece()], [tasa_subocupacion()], [empleo_vulnerable()].
#' @export
#' @examples
#' \dontrun{
#' tasa_desempleo(2023, trimestre = 4)
#' tasa_desempleo(2023, trimestre = 4, por = "sexo")
#' }
tasa_desempleo <- function(anio, trimestre, por = NULL,
                           factor = c("trimestral", "mensual"),
                           vartype = "ci", verbose = FALSE) {
  factor <- match.arg(factor)
  dsn <- diseno_ece(anio, trimestre, factor = factor, verbose = verbose)
  out <- .aplicar_por(dsn, por) |>
    srvyr::summarise(
      tasa = srvyr::survey_ratio(.data$desocupado, .data$pea,
                                 na.rm = TRUE, vartype = vartype)
    )
  dplyr::ungroup(out)
}

#' Tasa de subocupación (ECE)
#'
#' Población subocupada (por insuficiencia de horas) sobre la PEA. Solo se mide
#' **desde 2019**; para periodos anteriores devuelve `NA` con una advertencia.
#'
#' @inheritParams tasa_desempleo
#' @return Un tibble con `tasa` y su varianza.
#' @seealso [tasa_desempleo()], [empleo_vulnerable()].
#' @export
#' @examples
#' \dontrun{
#' tasa_subocupacion(2023, trimestre = 4, por = "sexo")
#' }
tasa_subocupacion <- function(anio, trimestre, por = NULL,
                              factor = c("trimestral", "mensual"),
                              vartype = "ci", verbose = FALSE) {
  factor <- match.arg(factor)
  if (anio < 2019) {
    cli::cli_warn("La subocupación solo se mide desde 2019; {anio} devolverá NA.")
  }
  dsn <- diseno_ece(anio, trimestre, factor = factor, verbose = verbose)
  out <- .aplicar_por(dsn, por) |>
    srvyr::summarise(
      tasa = srvyr::survey_ratio(.data$subocupado, .data$pea,
                                 na.rm = TRUE, vartype = vartype)
    )
  dplyr::ungroup(out)
}

#' Tasa de empleo vulnerable (ECE)
#'
#' Proporción de la población **ocupada** en empleo vulnerable según la OIT:
#' trabajadores por cuenta propia y trabajadores familiares no remunerados
#' (`categoria_ocupacional` 2 y 5). Comparable entre versiones de la ECE gracias
#' a la armonización de la categoría ocupacional ([armonizar_ece()]).
#'
#' @inheritParams tasa_desempleo
#' @return Un tibble con `tasa` (sobre ocupados) y su varianza.
#' @seealso [armonizar_ece()], [tasa_desempleo()].
#' @export
#' @examples
#' \dontrun{
#' empleo_vulnerable(2023, trimestre = 4)
#' empleo_vulnerable(2023, trimestre = 4, por = "sexo")
#' }
empleo_vulnerable <- function(anio, trimestre, por = NULL,
                              factor = c("trimestral", "mensual"),
                              vartype = "ci", verbose = FALSE) {
  factor <- match.arg(factor)
  dsn <- diseno_ece(anio, trimestre, factor = factor, verbose = verbose) |>
    dplyr::filter(.data$ocupado == 1)
  out <- .aplicar_por(dsn, por) |>
    srvyr::summarise(
      tasa = srvyr::survey_mean(.data$categoria_ocupacional %in% c(2, 5),
                                na.rm = TRUE, vartype = vartype)
    )
  dplyr::ungroup(out)
}

#' Agrupa la edad en cohortes
#'
#' Utilidad para clasificar la edad en grupos etarios, útil para desagregar
#' indicadores (p. ej. pobreza por cohorte). Por defecto usa los grupos NNA
#' (0-17), jóvenes (18-24), adultos (25-64) y adultos mayores (65+).
#'
#' @param edad Vector numérico de edades.
#' @param cortes Vector de cortes (límites inferiores). Por defecto
#'   `c(0, 18, 25, 65)`.
#' @param etiquetas Etiquetas de cada grupo (una más que… no: una por intervalo).
#' @return Un factor con la cohorte de cada edad.
#' @export
#' @examples
#' grupo_edad(c(5, 20, 40, 70))
grupo_edad <- function(edad,
                       cortes = c(0, 18, 25, 65),
                       etiquetas = c("NNA (0-17)", "Jóvenes (18-24)",
                                     "Adultos (25-64)", "Adultos mayores (65+)")) {
  cut(edad, breaks = c(cortes, Inf), labels = etiquetas,
      right = FALSE, include.lowest = TRUE)
}
