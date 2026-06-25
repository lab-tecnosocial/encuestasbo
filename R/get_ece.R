#' Accede a los microdatos de la Encuesta Continua de Empleo (ECE) del INE
#'
#' Descarga y/o carga desde caché los microdatos trimestrales de la Encuesta
#' Continua de Empleo de Bolivia (4T-2015 a 3T-2025, serie completa). En
#' **2020-T2/T3/T4** la ECE fue de cobertura **solo urbana** (la pandemia impidió
#' el levantamiento rural); esos trimestres emiten un aviso y se marcan como
#' `cobertura = "urbana"` en [catalogo_ece()]. Con filtros opcionales por
#' departamento y área. Cada trimestre es un archivo único a nivel persona.
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

  # Aviso de cobertura: en la pandemia (2020 T2-T4) la ECE fue solo urbana.
  if (!is.null(fila$cobertura) && length(fila$cobertura) == 1 &&
      !is.na(fila$cobertura) && fila$cobertura == "urbana") {
    cli::cli_warn(c(
      "La ECE {anio}-T{trimestre} tiene cobertura {.strong urbana} (sin muestra rural, por la pandemia).",
      "i" = "No es directamente comparable con los trimestres de cobertura nacional."
    ))
  }

  local_path <- .download_encuesta(fila, overwrite = overwrite, verbose = verbose)
  ds <- arrow::open_dataset(local_path, format = "parquet")
  ds <- .apply_filtros(ds, departamento, area)
  ds <- .apply_variable_selection(ds, variables)
  .return_as(ds, as, table_name = tabla, verbose = verbose)
}
