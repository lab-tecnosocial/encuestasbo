#' Accede a los microdatos de la Encuesta Continua de Empleo (ECE) del INE
#'
#' Descarga y/o carga desde caché los microdatos trimestrales de la Encuesta
#' Continua de Empleo de Bolivia (4T-2015 en adelante, con huecos en 2020-2021
#' por la pandemia), con filtros opcionales por departamento y área. Cada
#' trimestre es un archivo único a nivel persona.
#'
#' @param anio Entero. Año de la encuesta.
#' @param trimestre Entero (1-4). Trimestre de referencia.
#' @param tabla Caracteres. Nivel de análisis: `"persona"` (defecto) o
#'   `"vivienda"`. Usa [catalogo_ece()] para ver lo disponible.
#' @param departamento Vector. Código(s) `1`-`9` o nombre(s). Si `NULL`, todos.
#' @param area Vector. `1`/`"Urbana"` o `2`/`"Rural"`. Si `NULL`, ambas.
#' @param variables Vector de caracteres. Columnas a seleccionar. Si `NULL`,
#'   todas. Las columnas de diseño muestral siempre se incluyen.
#' @param as Formato de retorno: `"arrow"` (defecto), `"tibble"` o `"duckdb"`.
#' @param overwrite Lógico. Si `TRUE`, re-descarga aunque exista en caché.
#' @param verbose Lógico. Mostrar progreso. Por defecto `TRUE`.
#'
#' @return Según `as`: un `arrow::Dataset`, un `data.frame` o una conexión `DBI`.
#'
#' @details
#' La ECE tiene factores de expansión **mensual y trimestral** distintos; no
#' deben mezclarse. Para análisis trimestrales usa [diseno_ece()] con el factor
#' trimestral (por defecto). El periodo IV-2015 a II-2019 se distribuyó como un
#' único estudio en ANDA; en el paquete se accede por trimestre individual.
#'
#' @seealso [diseno_ece()] para análisis con diseño muestral; [catalogo_ece()].
#' @export
#' @examples
#' \dontrun{
#' get_ece(2022, trimestre = 3, tabla = "persona")
#' }
get_ece <- function(
    anio,
    trimestre,
    tabla        = "persona",
    departamento = NULL,
    area         = NULL,
    variables    = NULL,
    as           = c("arrow", "tibble", "duckdb"),
    overwrite    = FALSE,
    verbose      = TRUE
) {
  as <- match.arg(as)
  fila <- .resolve_catalogo("ece", anio = anio, tabla = tabla, trimestre = trimestre)

  local_path <- .download_encuesta(fila, overwrite = overwrite, verbose = verbose)
  ds <- arrow::open_dataset(local_path, format = "parquet")
  ds <- .apply_filtros(ds, departamento, area)
  ds <- .apply_variable_selection(ds, variables)
  .return_as(ds, as, table_name = tabla, verbose = verbose)
}
