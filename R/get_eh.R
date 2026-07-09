#' Accede a los microdatos de la Encuesta de Hogares (EH) del INE
#'
#' Descarga y/o carga desde caché los microdatos de la Encuesta de Hogares de
#' Bolivia (2012-2024), con filtros opcionales por departamento y área.
#'
#' @param anio Entero. Año de la encuesta (`2012`-`2024`).
#' @param tabla Caracteres. Nivel de análisis: `"persona"` (defecto) o
#'   `"vivienda"` (y otras bases temáticas según el año). Usa [catalogo_eh()]
#'   para ver las tablas disponibles.
#' @param departamento Vector. Código(s) `1`-`9` o nombre(s) del departamento
#'   (e.g., `"Santa Cruz"`). Si `NULL`, incluye todos.
#' @param area Vector. `1`/`"Urbana"` o `2`/`"Rural"`. Si `NULL`, incluye ambas.
#' @param variables Vector de caracteres. Nombres de columnas a seleccionar.
#'   Si `NULL`, devuelve todas. Las columnas de identificación, geografía y
#'   diseño muestral (`folio`, `depto`, `area`, `factor`, `upm`, `estrato`)
#'   siempre se incluyen.
#' @param as Formato de retorno: `"arrow"` (lazy, por defecto), `"tibble"`
#'   (RAM) o `"duckdb"` (conexión DBI con la tabla registrada).
#' @param overwrite Lógico. Si `TRUE`, re-descarga aunque exista en caché.
#' @param verbose Lógico. Mostrar mensajes de progreso. Por defecto `TRUE`.
#'
#' @return Según `as`:
#'   - `"arrow"`: un `arrow::Dataset` (lazy, soporta dplyr)
#'   - `"tibble"`: un `data.frame` con los datos en RAM
#'   - `"duckdb"`: una conexión `DBI`; cierra con `DBI::dbDisconnect(con)`.
#'
#' @details
#' Los microdatos provienen del portal ANDA del INE y se distribuyen como
#' Parquet en GitHub Releases. Para un análisis estadísticamente correcto (con
#' factores de expansión y errores estándar válidos) usa [diseno_eh()] en lugar
#' de operar sobre los datos crudos.
#'
#' @seealso [diseno_eh()] para análisis con diseño muestral; [get_eh_armonizada()]
#'   para series comparables entre años; [catalogo_eh()] para el inventario.
#' @export
#' @examples
#' \dontrun{
#' # Personas de la EH 2023 (Arrow lazy)
#' get_eh(2023, "persona")
#'
#' # Filtrar y contar sin traer todo a RAM
#' library(dplyr)
#' get_eh(2023, "persona", departamento = "Santa Cruz") |>
#'   count(area) |>
#'   collect()
#'
#' # Atajo equivalente
#' get_personas_eh(2023)
#' }
get_eh <- function(
    anio,
    tabla        = "persona",
    departamento = NULL,
    area         = NULL,
    variables    = NULL,
    as           = c("arrow", "tibble", "duckdb"),
    overwrite    = FALSE,
    verbose      = TRUE
) {
  as <- match.arg(as)
  fila <- .resolve_catalogo("eh", anio = anio, tabla = tabla)

  local_path <- .download_encuesta(fila, overwrite = overwrite, verbose = verbose)
  ds <- arrow::open_dataset(local_path, format = "parquet")
  ds <- .apply_filtros(ds, departamento, area)
  ds <- .apply_variable_selection(ds, variables, fila = fila)
  .return_as(ds, as, table_name = tabla, verbose = verbose)
}
