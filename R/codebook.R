#' Diccionarios de variables de la Encuesta de Hogares
#'
#' Lista nombrada por año con los metadatos de variables de la EH, extraídos de
#' las etiquetas de los archivos SPSS del INE.
#'
#' @format Una lista con un elemento por año, `"2012"` … `"2024"`, cada uno un
#'   data.frame con columnas:
#' \describe{
#'   \item{variable}{Nombre de la variable (minúsculas, igual que en los datos)}
#'   \item{etiqueta}{Descripción de la variable}
#'   \item{tabla}{Tabla de origen: `"persona"`, `"vivienda"` o una base temática
#'     del año (`"equipamiento"`, `"gastos_alimentarios"`, …)}
#'   \item{tipo}{`"categorica"`, `"numerica"` o `"texto"`}
#'   \item{valores_codigos}{Lista de data.frames `codigo`/`etiqueta` para
#'     variables categóricas; `NULL` en otras}
#' }
#' @source INE Bolivia, Encuesta de Hogares 2012-2024.
"codebook_eh_meta"

#' Diccionarios de variables de la Encuesta Continua de Empleo
#'
#' Lista nombrada por periodo (`"<año>t<trimestre>"`, e.g. `"2023t4"`) con los
#' metadatos de variables de la ECE, extraídos de las etiquetas SPSS del INE.
#'
#' @format Una lista; cada elemento es un data.frame con columnas `variable`,
#'   `etiqueta`, `tabla`, `tipo`, `valores_codigos` (igual que [codebook_eh_meta]).
#' @source INE Bolivia, Encuesta Continua de Empleo (repositorio abierto).
"codebook_ece_meta"

# Devuelve el diccionario (data.frame) para una encuesta y periodo.
.get_codebook <- function(encuesta = "eh", anio = 2024, trimestre = NULL) {
  encuesta <- match.arg(encuesta, c("eh", "ece"))
  if (encuesta == "ece") {
    if (is.null(trimestre)) {
      cli::cli_abort(c(
        "El diccionario de la ECE requiere {.arg trimestre}.",
        "i" = "Ejemplo: {.code codebook(encuesta = \"ece\", anio = 2023, trimestre = 4)}"
      ))
    }
    key <- sprintf("%dt%d", as.integer(anio), as.integer(trimestre))
    if (is.null(codebook_ece_meta[[key]])) {
      cli::cli_abort(c(
        "No hay diccionario para la ECE {anio} T{trimestre}.",
        "i" = "Periodos disponibles: {.val {names(codebook_ece_meta)}}."
      ))
    }
    return(codebook_ece_meta[[key]])
  }
  key <- as.character(as.integer(anio))
  if (is.null(codebook_eh_meta[[key]])) {
    cli::cli_abort(c(
      "No hay diccionario para la EH {anio}.",
      "i" = "Años disponibles: {.val {names(codebook_eh_meta)}}."
    ))
  }
  codebook_eh_meta[[key]]
}

#' Consulta el diccionario de variables de una encuesta del INE
#'
#' Busca variables por nombre, tabla o texto libre en las etiquetas.
#'
#' @param variable Vector de nombres de variable a consultar. Si `NULL`, todas.
#' @param tabla Filtra por tabla (`"persona"`, `"vivienda"`). Si `NULL`, todas.
#' @param buscar Texto libre para buscar en etiquetas y nombres (sin distinguir
#'   mayúsculas).
#' @param encuesta `"eh"` (defecto) o `"ece"`.
#' @param anio Año de la encuesta. Por defecto `2024`.
#' @param trimestre Trimestre (1-4); requerido si `encuesta = "ece"`.
#'
#' @return Un data.frame con las variables que coinciden.
#' @export
#' @examples
#' codebook(buscar = "ingreso", anio = 2023)
#' codebook(tabla = "vivienda", anio = 2023)
#' codebook(buscar = "desocupad", encuesta = "ece", anio = 2023, trimestre = 4)
codebook <- function(variable = NULL, tabla = NULL, buscar = NULL,
                     encuesta = "eh", anio = 2024, trimestre = NULL) {
  meta <- .get_codebook(encuesta, anio, trimestre)
  if (!is.null(tabla))    meta <- meta[tolower(meta$tabla) %in% tolower(tabla), ]
  if (!is.null(variable)) meta <- meta[tolower(meta$variable) %in% tolower(variable), ]
  if (!is.null(buscar)) {
    mask <- grepl(buscar, meta$etiqueta, ignore.case = TRUE) |
            grepl(buscar, meta$variable, ignore.case = TRUE)
    meta <- meta[mask, ]
  }
  if (nrow(meta) == 0) {
    cli::cli_inform("No se encontraron variables con esos criterios ({toupper(encuesta)}).")
  }
  # persona antes que vivienda
  rango <- match(meta$tabla, c("persona", "vivienda"))
  rango[is.na(rango)] <- 3L
  meta <- meta[order(rango), ]
  `rownames<-`(meta, NULL)
}

#' Muestra los valores codificados de una variable categórica
#'
#' @param variable Nombre de la variable.
#' @param encuesta `"eh"` (defecto) o `"ece"`.
#' @param anio Año de la encuesta. Por defecto `2024`.
#' @param trimestre Trimestre (1-4); requerido si `encuesta = "ece"`.
#' @return Un data.frame con columnas `codigo` y `etiqueta`, o `NULL` invisible
#'   si la variable no es categórica.
#' @export
#' @examples
#' \dontrun{
#' codebook_valores("s01a_02", anio = 2023)  # sexo
#' }
codebook_valores <- function(variable, encuesta = "eh", anio = 2024, trimestre = NULL) {
  meta <- codebook(variable = variable, encuesta = encuesta, anio = anio, trimestre = trimestre)
  if (nrow(meta) == 0) {
    cli::cli_abort("Variable {.var {variable}} no encontrada en {toupper(encuesta)} {anio}.")
  }
  vals <- meta$valores_codigos[[1]]
  if (is.null(vals) || nrow(vals) == 0) {
    cli::cli_inform("La variable {.var {variable}} ({meta$etiqueta[1]}) es {meta$tipo[1]}, sin categorías.")
    return(invisible(NULL))
  }
  vals
}
