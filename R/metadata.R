#' Ficha técnica y metadata oficial de las encuestas del INE
#'
#' Metadata estructurada (DDI) de cada estudio publicada por el INE en ANDA:
#' universo, cobertura, marco y diseño muestral, factor de expansión, modo de
#' recolección, tasa de respuesta y periodo de referencia.
#'
#' @format Un data.frame con una fila por estudio y columnas:
#' \describe{
#'   \item{encuesta}{`"eh"` / `"ece"`}
#'   \item{anio, trimestre}{Periodo (`NA`/`NA` en la fila del consolidado ECE 4T2015–2T2019)}
#'   \item{catalog_id, idno}{Identificadores del estudio en ANDA}
#'   \item{titulo}{Título del estudio}
#'   \item{universo}{Población objetivo}
#'   \item{unidad_analisis}{Unidad de análisis}
#'   \item{cobertura_geografica}{Cobertura/desagregación geográfica}
#'   \item{periodo_referencia}{Periodo de referencia}
#'   \item{marco_diseno_muestral}{Marco muestral, estratificación y etapas de selección}
#'   \item{factor_expansion}{Descripción del factor de expansión}
#'   \item{modo_recoleccion}{Modo de recolección (e.g., cara a cara)}
#'   \item{muestra_respuesta}{Muestra lograda / tasa de respuesta}
#'   \item{fechas_recoleccion}{Fechas (ciclos) de recolección}
#' }
#' @source INE Bolivia, ANDA — exportación DDI/JSON de cada estudio.
"metadata_encuestas"

#' Muestra la ficha técnica (diseño muestral) de una encuesta
#'
#' Imprime y devuelve la metadata oficial del INE para la encuesta y periodo
#' indicados: universo, cobertura, marco y diseño muestral, factor de expansión,
#' modo de recolección y tasa de respuesta.
#'
#' @param encuesta `"eh"` (defecto) o `"ece"`.
#' @param anio Año del estudio.
#' @param trimestre Trimestre (1-4); requerido para la ECE.
#'
#' @return Invisible: un data.frame de una fila con la ficha. Imprime un
#'   resumen legible.
#'
#' @details
#' Para trimestres de la ECE sin estudio propio en ANDA (p. ej. 3T/4T-2019,
#' 1T-2020, o los del periodo 4T2015–2T2019), se devuelve la ficha del estudio
#' consolidado ECE 4T2015–2T2019 como descripción general del diseño (que es
#' estable entre trimestres), con un aviso.
#'
#' @seealso [catalogo_eh()], [catalogo_ece()], [diseno_eh()].
#' @export
#' @examples
#' ficha_tecnica("eh", 2023)
#' ficha_tecnica("ece", 2023, trimestre = 4)
ficha_tecnica <- function(encuesta = "eh", anio, trimestre = NULL) {
  encuesta <- match.arg(encuesta, c("eh", "ece"))
  m <- metadata_encuestas[metadata_encuestas$encuesta == encuesta, ]

  if (encuesta == "eh") {
    fila <- m[!is.na(m$anio) & m$anio == as.integer(anio), ]
  } else {
    if (is.null(trimestre)) {
      cli::cli_abort(c("La ECE requiere {.arg trimestre} (1-4).",
                       "i" = "Ejemplo: {.code ficha_tecnica(\"ece\", 2023, trimestre = 4)}"))
    }
    fila <- m[!is.na(m$anio) & m$anio == as.integer(anio) &
              !is.na(m$trimestre) & m$trimestre == as.integer(trimestre), ]
    if (nrow(fila) == 0) {
      bundle <- m[is.na(m$anio), ]
      if (nrow(bundle) == 1) {
        cli::cli_warn(c(
          "No hay ficha propia para la ECE {anio} T{trimestre} en ANDA.",
          "i" = "Se muestra el diseño general del consolidado ECE 4T2015-2T2019 (estable entre trimestres)."
        ))
        fila <- bundle
      }
    }
  }

  if (nrow(fila) == 0) {
    cli::cli_abort("No hay ficha técnica para {toupper(encuesta)} {anio}{if (!is.null(trimestre)) paste0(' T', trimestre) else ''}.")
  }
  fila <- fila[1, ]

  campos <- c(
    "Título"               = "titulo",
    "Universo"             = "universo",
    "Unidad de análisis"   = "unidad_analisis",
    "Cobertura geográfica" = "cobertura_geografica",
    "Periodo de referencia"= "periodo_referencia",
    "Diseño y marco muestral" = "marco_diseno_muestral",
    "Factor de expansión"  = "factor_expansion",
    "Modo de recolección"  = "modo_recoleccion",
    "Muestra / respuesta"  = "muestra_respuesta"
  )
  cli::cli_h1("Ficha técnica: {fila$titulo}")
  for (k in names(campos)) {
    val <- fila[[campos[[k]]]]
    if (is.na(val) || !nzchar(val)) next
    if (nchar(val) > 400) val <- paste0(substr(val, 1, 400), " […]")
    cli::cli_text("{.strong {k}}: {val}")
    cli::cli_text("")
  }
  cli::cli_alert_info("Fuente: INE Bolivia, ANDA (id {fila$catalog_id}). Metadata completa en {.field metadata_encuestas}.")
  invisible(fila)
}
