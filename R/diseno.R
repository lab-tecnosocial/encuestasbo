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
  # Manejo de "lonely PSU" (estratos con una sola UPM). La estimación de varianza
  # lee survey.lonely.psu al CALCULAR (no al construir), así que se fija a nivel de
  # sesión, de forma persistente. Solo se fuerza "adjust" cuando la opción actual
  # provocaría un error (NULL o "fail"); se respeta cualquier otra elección válida
  # del usuario ("remove", "average", "certainty").
  cur <- getOption("survey.lonely.psu")
  if (is.null(cur) || identical(cur, "fail")) options(survey.lonely.psu = "adjust")
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
#' @param anio Entero. Año de la EH (`2012`-`2024`).
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
#' El paquete fija `options(survey.lonely.psu = "adjust")` al cargarse (si no lo
#' fijaste tú), para manejar estratos con una sola UPM en la estimación de
#' varianza. Las encuestas se cargan en memoria (`as = "tibble"`) porque
#' `survey`/`srvyr` lo requieren; el tamaño de la EH (~12k viviendas) lo hace viable.
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
#' @param tabla Caracteres. La ECE se distribuye solo a nivel `"persona"`
#'   (defecto); se expone el argumento por simetría con [diseno_eh()].
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

# armonizar_ece() vive en R/armonizar_ece.R
