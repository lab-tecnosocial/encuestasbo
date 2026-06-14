# Declara el diseño muestral con srvyr a partir de un data frame armonizado.
# La EH del INE es estratificada y bietápica: UPM dentro de estrato, con factor
# de expansión. Se usa nest = TRUE (UPM anidadas en estrato) y se ajustan los
# estratos con una sola UPM (lonely PSU) para no romper la estimación de varianza.
.declarar_diseno <- function(df, weights_var = "factor") {
  faltan <- setdiff(c("upm", "estrato", weights_var), names(df))
  if (length(faltan)) {
    cli::cli_abort(c(
      "Faltan variables de diseño muestral: {.val {faltan}}.",
      "i" = "Usa datos armonizados (armonizar_eh()) que garantizan upm/estrato/factor."
    ))
  }
  old <- options(survey.lonely.psu = "adjust")
  on.exit(options(old), add = TRUE)
  srvyr::as_survey_design(
    df,
    ids     = "upm",
    strata  = "estrato",
    weights = !!rlang::sym(weights_var),
    nest    = TRUE
  )
}

#' Declara el diseño muestral de la Encuesta de Hogares (EH)
#'
#' Devuelve un objeto de diseño de `srvyr` listo para estimaciones
#' estadísticamente correctas (medias, totales, proporciones con errores
#' estándar e intervalos de confianza válidos), con el diseño estratificado
#' bietápico de la EH ya declarado (`ids = upm`, `strata = estrato`,
#' `weights = factor`, `nest = TRUE`).
#'
#' @param anio Entero. Año de la EH (`2012`-`2019`, `2021`-`2024`).
#' @param tabla Caracteres. `"persona"` (defecto) o `"vivienda"`.
#' @param armonizar Lógico. Si `TRUE` (defecto), armoniza los nombres de
#'   variables a canónicos antes de declarar el diseño (recomendado: hace que la
#'   sintaxis del diseño sea estable entre años).
#' @param departamento,area Filtros opcionales (ver [get_eh()]).
#' @param verbose Lógico. Mostrar progreso.
#'
#' @return Un objeto `tbl_svy` de `srvyr` (envuelve `survey`). Úsalo con
#'   `srvyr::summarise()` + `survey_mean()`, `survey_total()`, `survey_prop()`.
#'
#' @details
#' Se fija temporalmente `options(survey.lonely.psu = "adjust")` durante la
#' construcción para manejar estratos con una sola UPM, y se restaura al salir.
#' Las encuestas se cargan en memoria (`as = "tibble"`) porque `survey`/`srvyr`
#' lo requieren; el tamaño de la EH (~12k viviendas) lo hace viable.
#'
#' @seealso [get_eh()], [armonizar_eh()], [diseno_ece()].
#' @export
#' @examples
#' \dontrun{
#' library(srvyr)
#' # Tasa de pobreza nacional con error estándar
#' diseno_eh(2023) |>
#'   summarise(pobreza = survey_mean(pobre, na.rm = TRUE, vartype = "ci"))
#'
#' # Ingreso medio del hogar por departamento
#' diseno_eh(2023) |>
#'   group_by(depto) |>
#'   summarise(ingreso = survey_mean(ingreso_hogar, na.rm = TRUE))
#' }
diseno_eh <- function(anio, tabla = "persona", armonizar = TRUE,
                      departamento = NULL, area = NULL, verbose = TRUE) {
  df <- get_eh(anio, tabla, departamento = departamento, area = area,
               as = "tibble", verbose = verbose)
  if (armonizar) df <- armonizar_eh(df, anio)
  .declarar_diseno(df, weights_var = "factor")
}

#' Declara el diseño muestral de la Encuesta Continua de Empleo (ECE)
#'
#' Análogo a [diseno_eh()] para la ECE trimestral. La ECE tiene factores de
#' expansión **trimestral** y **mensual** distintos; por defecto usa el
#' trimestral. No deben mezclarse en un mismo análisis.
#'
#' @param anio Entero. Año.
#' @param trimestre Entero (1-4).
#' @param tabla Caracteres. `"persona"` (defecto) o `"vivienda"`.
#' @param factor Cuál factor de expansión usar: `"trimestral"` (defecto) o
#'   `"mensual"`.
#' @param armonizar Lógico. Armonizar nombres antes de declarar el diseño.
#' @param departamento,area Filtros opcionales.
#' @param verbose Lógico. Mostrar progreso.
#'
#' @return Un objeto `tbl_svy` de `srvyr`.
#' @seealso [diseno_eh()], [get_ece()].
#' @export
#' @examples
#' \dontrun{
#' diseno_ece(2022, trimestre = 3) |>
#'   srvyr::summarise(tasa = srvyr::survey_mean(desocupado, na.rm = TRUE))
#' }
diseno_ece <- function(anio, trimestre, tabla = "persona",
                       factor = c("trimestral", "mensual"),
                       armonizar = TRUE, departamento = NULL, area = NULL,
                       verbose = TRUE) {
  factor <- match.arg(factor)
  # Nombres reales en los microdatos de la ECE: factor trimestral y mensual.
  weights_var <- if (factor == "mensual") "fact_mes_act" else "fact_trim_act"

  df <- get_ece(anio, trimestre, tabla, departamento = departamento, area = area,
                as = "tibble", verbose = verbose)
  if (armonizar) df <- armonizar_ece(df, anio, trimestre)
  .declarar_diseno(df, weights_var = weights_var)
}

#' Armoniza un data frame de la ECE a nombres canónicos
#'
#' Placeholder de armonización para la ECE (pendiente de datos; ver README).
#' Por ahora garantiza las columnas de diseño si ya existen.
#'
#' @param df Un data.frame de [get_ece()].
#' @param anio,trimestre Periodo de origen.
#' @return El data.frame (sin cambios si no hay mapa de ECE).
#' @export
armonizar_ece <- function(df, anio, trimestre) {
  # La armonización detallada de la ECE se añadirá cuando se incorporen sus
  # microdatos (alojados en el repositorio externo del INE). Por ahora se
  # devuelven los datos tal cual; las variables de diseño ya suelen ser canónicas.
  df
}
