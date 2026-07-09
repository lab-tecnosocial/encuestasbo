#' Catálogo de encuestas del INE disponibles
#'
#' Tabla maestra que enumera cada base de microdatos disponible en el paquete
#' y mapea cada `(encuesta, anio, trimestre, tabla)` a su Release de GitHub y a
#' los nombres canónicos de sus variables de diseño muestral.
#'
#' @format Un data.frame con una fila por base, con columnas:
#' \describe{
#'   \item{encuesta}{`"eh"` (Encuesta de Hogares) o `"ece"` (Encuesta Continua de Empleo)}
#'   \item{anio}{Año de referencia}
#'   \item{trimestre}{Trimestre (1-4) para la ECE; `NA` para la EH}
#'   \item{tabla}{Nivel de análisis: `"vivienda"`, `"persona"`, etc.}
#'   \item{release_tag}{Etiqueta del GitHub Release que contiene el Parquet}
#'   \item{archivo_parquet}{Nombre del archivo Parquet dentro del Release}
#'   \item{factor_var}{Nombre canónico del factor de expansión principal}
#'   \item{factor_var_alt}{Factor alternativo (ECE: factor mensual); `NA` para EH}
#'   \item{upm_var}{Nombre canónico de la unidad primaria de muestreo}
#'   \item{estrato_var}{Nombre canónico del estrato}
#'   \item{cobertura}{`"nacional"` o `"urbana"` (ECE 2020 T2-T4, por la pandemia).
#'     [get_ece()] avisa al usar los periodos de cobertura urbana}
#'   \item{catalog_id}{Identificador del estudio en el portal ANDA (procedencia)}
#'   \item{archivo_sav}{Nombre original del archivo SPSS en ANDA (procedencia)}
#'   \item{version_caeb}{Versión del clasificador de actividad económica}
#'   \item{version_cob}{Versión del clasificador de ocupación}
#' }
#' @source INE Bolivia, portal ANDA: \url{https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS}
"catalogo_encuestas"

#' Consulta el catálogo de la Encuesta de Hogares (EH)
#'
#' @param anio Entero opcional. Filtra por año.
#' @param tabla Caracteres opcional. Filtra por nivel (e.g., `"persona"`).
#' @return Un data.frame con las filas del catálogo correspondientes a la EH.
#' @export
#' @examples
#' catalogo_eh()
#' catalogo_eh(anio = 2023)
catalogo_eh <- function(anio = NULL, tabla = NULL) {
  out <- catalogo_encuestas[catalogo_encuestas$encuesta == "eh", ]
  if (!is.null(anio))  out <- out[out$anio %in% as.integer(anio), ]
  if (!is.null(tabla)) out <- out[out$tabla %in% tabla, ]
  `rownames<-`(out, NULL)
}

#' Consulta el catálogo de la Encuesta Continua de Empleo (ECE)
#'
#' @param anio Entero opcional. Filtra por año.
#' @param trimestre Entero opcional (1-4). Filtra por trimestre.
#' @param tabla Caracteres opcional. Filtra por nivel.
#' @return Un data.frame con las filas del catálogo correspondientes a la ECE.
#' @export
#' @examples
#' catalogo_ece()
#' catalogo_ece(anio = 2022, trimestre = 3)
catalogo_ece <- function(anio = NULL, trimestre = NULL, tabla = NULL) {
  out <- catalogo_encuestas[catalogo_encuestas$encuesta == "ece", ]
  if (!is.null(anio))      out <- out[out$anio %in% as.integer(anio), ]
  if (!is.null(trimestre)) out <- out[out$trimestre %in% as.integer(trimestre), ]
  if (!is.null(tabla))     out <- out[out$tabla %in% tabla, ]
  `rownames<-`(out, NULL)
}

# Resuelve una única fila del catálogo para un (encuesta, anio, trimestre, tabla).
# Aborta con un mensaje útil si no existe o si hay ambigüedad.
.resolve_catalogo <- function(encuesta, anio, tabla, trimestre = NULL) {
  cat_e <- catalogo_encuestas[catalogo_encuestas$encuesta == encuesta, ]
  sel <- cat_e$anio == as.integer(anio) & cat_e$tabla == tabla
  if (encuesta == "ece") {
    if (is.null(trimestre)) {
      cli::cli_abort(c(
        "La ECE requiere especificar el {.arg trimestre} (1-4).",
        "i" = "Ejemplo: {.code get_ece({anio}, trimestre = 3)}"
      ))
    }
    sel <- sel & cat_e$trimestre == as.integer(trimestre)
  }
  fila <- cat_e[sel, ]

  if (nrow(fila) == 0) {
    periodo <- if (encuesta == "ece") sprintf("%s T%s", anio, trimestre) else as.character(anio)
    disp <- if (encuesta == "ece") {
      paste(unique(paste0(cat_e$anio, "T", cat_e$trimestre)), collapse = ", ")
    } else {
      paste(sort(unique(cat_e$anio)), collapse = ", ")
    }
    cli::cli_abort(c(
      "No hay datos de {.val {toupper(encuesta)}} para {periodo}, tabla {.val {tabla}}.",
      "i" = "Tablas válidas: {.val {sort(unique(cat_e$tabla))}}.",
      "i" = "Periodos disponibles: {disp}."
    ))
  }
  if (nrow(fila) > 1) {
    cli::cli_abort("Catálogo ambiguo: {nrow(fila)} filas para esa combinación (revisa build_catalogo.R).")
  }
  fila
}
