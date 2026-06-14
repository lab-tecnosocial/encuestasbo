#' Mapa de armonización de variables de la Encuesta de Hogares
#'
#' Mapea variables de cada año de la EH a un esquema de nombres canónico estable.
#' Lo usa [armonizar_eh()] y [get_eh_armonizada()].
#'
#' @format Un data.frame con columnas:
#' \describe{
#'   \item{variable}{Nombre canónico (estable entre años)}
#'   \item{etiqueta}{Descripción de la variable}
#'   \item{tabla}{Tabla de origen (`"persona"`/`"vivienda"`)}
#'   \item{armonizada}{`TRUE` si es comparable entre años; `FALSE` si es de paso}
#'   \item{v2012, ..., v2024}{Nombre de la variable de origen en cada año
#'     (`NA` si no está disponible ese año)}
#' }
#' @details
#' Muchas variables derivadas del INE (ingresos `yhog`/`yper`, pobreza `p0`/`pext0`,
#' educación `niv_ed_g`, empleo `pea`/`condact`) tienen el mismo nombre todos los
#' años; otras del cuestionario (sexo, edad, parentesco) cambian de nombre y se
#' mapean por su etiqueta.
#' @source INE Bolivia, Encuesta de Hogares 2012-2024.
"variable_canonica_map"

#' Grupos temáticos de variables armonizadas
#'
#' @return Una lista nombrada de grupos con los nombres canónicos de variables.
#' @export
#' @examples
#' grupos_variables()
#' grupos_variables()$pobreza
grupos_variables <- function() {
  list(
    demografico = c("sexo", "edad", "parentesco"),
    educacion   = c("nivel_edu", "anios_estudio"),
    empleo      = c("condicion_actividad", "pea", "pet", "ocupado", "grupo_ocupacion"),
    ingresos    = c("ingreso_laboral", "ingreso_personal", "ingreso_hogar", "ingreso_no_laboral"),
    pobreza     = c("pobre", "pobre_extremo", "linea_pobreza", "linea_pobreza_extrema")
  )
}

#' Lista las variables armonizadas disponibles
#'
#' @param solo_armonizadas Lógico. Si `TRUE` (defecto), solo las marcadas como
#'   comparables entre años.
#' @return Un data.frame con las columnas del [variable_canonica_map].
#' @export
#' @examples
#' variables_armonizadas()
variables_armonizadas <- function(solo_armonizadas = TRUE) {
  m <- variable_canonica_map
  if (solo_armonizadas) m <- m[m$armonizada, ]
  `rownames<-`(m, NULL)
}

# Columnas siempre presentes tras armonizar (identificación + diseño + geo)
.CANON_SIEMPRE <- c("folio", "nro_persona", "depto", "area", "upm", "estrato", "factor")

# Columnas numéricas (continuas o indicadores 0/1, usadas en medias/proporciones).
# El resto de columnas canónicas son códigos/identificadores -> texto.
.CANON_NUMERICAS <- c(
  "factor", "edad", "anios_estudio", "ingreso_laboral", "ingreso_no_laboral",
  "ingreso_personal", "ingreso_hogar", "linea_pobreza", "linea_pobreza_extrema",
  "pobre", "pobre_extremo", "pea", "pet", "ocupado", "desocupado"
)

# Homogeneiza tipos de las columnas canónicas para apilar años con bind_rows.
.coerce_canonicas <- function(df) {
  for (nm in names(df)) {
    x <- df[[nm]]
    if (nm %in% .CANON_NUMERICAS) {
      df[[nm]] <- if (is.numeric(x)) x else suppressWarnings(as.numeric(as.character(x)))
    } else {
      df[[nm]] <- as.character(x)   # folio, upm, estrato, depto, area, sexo, ...
    }
  }
  df
}

#' Armoniza un data frame de la Encuesta de Hogares a nombres canónicos
#'
#' Renombra las variables del año indicado a su nombre canónico estable según
#' [variable_canonica_map]. Garantiza que existan las columnas de diseño muestral
#' (`folio`, `upm`, `estrato`, `factor`) necesarias para [diseno_eh()].
#'
#' @param df Un data.frame de [get_eh()] (con `as = "tibble"`).
#' @param anio Entero. Año de la encuesta de origen (necesario para resolver los
#'   nombres de variables, que cambian entre años).
#' @param solo_canonicas Lógico. Si `TRUE`, devuelve únicamente las columnas
#'   canónicas presentes; si `FALSE` (defecto), conserva todas y solo renombra
#'   las mapeadas.
#'
#' @return El data.frame con las columnas renombradas a nombres canónicos.
#' @seealso [get_eh_armonizada()] para apilar varios años; [diseno_eh()].
#' @export
#' @examples
#' \dontrun{
#' get_eh(2023, "persona", as = "tibble") |>
#'   armonizar_eh(2023) |>
#'   dplyr::count(sexo)
#' }
armonizar_eh <- function(df, anio, solo_canonicas = FALSE) {
  col <- paste0("v", as.integer(anio))
  m <- variable_canonica_map
  if (!col %in% names(m)) {
    cli::cli_abort(c(
      "No hay armonización para el año {.val {anio}}.",
      "i" = "Años disponibles: {.val {sub('^v','', grep('^v[0-9]+$', names(m), value=TRUE))}}."
    ))
  }
  origen <- m[[col]]
  canon  <- m$variable
  ok <- !is.na(origen) & origen %in% names(df)
  # renombrar origen -> canónico (evitando colisiones: si el canónico ya existe
  # con otro origen, se prioriza el mapeo)
  ren <- stats::setNames(origen[ok], canon[ok])
  df <- dplyr::rename(df, !!!ren)

  if (solo_canonicas) {
    presentes <- intersect(canon, names(df))
    df <- dplyr::select(df, dplyr::all_of(unique(c(intersect(.CANON_SIEMPRE, names(df)), presentes))))
  }
  df
}

# Resuelve el conjunto de variables canónicas pedido (variables o grupo).
.resolve_armon_vars <- function(variables, grupo) {
  if (!is.null(variables)) return(variables)
  if (!is.null(grupo)) {
    g <- grupos_variables()
    if (!grupo %in% names(g)) {
      cli::cli_abort("Grupo {.val {grupo}} desconocido. Usa: {.val {names(g)}}.")
    }
    return(g[[grupo]])
  }
  NULL  # todas
}

#' Serie armonizada de la Encuesta de Hogares entre años
#'
#' Devuelve la EH armonizada (nombres canónicos estables) de varios años apilada
#' en formato largo con una columna `anio`. Se respalda en un único Parquet
#' precalculado (~5 MB con los 13 años), consultable de forma perezosa con Arrow
#' y DuckDB. Equivalente para encuestas de la función de análisis temporal de censos.
#'
#' @param anios Vector de años a incluir (por defecto todos los disponibles).
#' @param variables Vector de nombres canónicos a incluir. Si `NULL`, usa `grupo`
#'   o, si tampoco, todas las variables armonizadas.
#' @param grupo Nombre de un grupo temático de [grupos_variables()]
#'   (e.g., `"pobreza"`, `"empleo"`). Ignorado si se pasa `variables`.
#' @param departamento Filtro opcional por departamento.
#' @param area Filtro opcional por área.
#' @param as Formato de retorno: `"tibble"` (defecto), `"arrow"` (Dataset lazy) o
#'   `"duckdb"` (conexión DBI con la tabla `"eh_armonizada"`).
#' @param overwrite Lógico. Si `TRUE`, re-descarga el Parquet armonizado.
#' @param verbose Lógico. Mostrar progreso.
#'
#' @return Según `as`: un `data.frame` (tibble), un `arrow::Dataset` o una
#'   conexión `DBI`. Siempre incluye la columna `anio` y las de diseño
#'   (`folio`, `upm`, `estrato`, `factor`, `depto`, `area`).
#'
#' @details
#' Las columnas de identificación/agrupación/diseño (`folio`, `upm`, `estrato`,
#' `depto`, `area`, `sexo`, …) se almacenan como texto (códigos, consistentes
#' entre años y válidos como `ids`/`strata` en survey); las analíticas continuas
#' e indicadores 0/1 (`factor`, `ingreso_*`, `pobre`, …) como numéricas.
#'
#' @seealso [grupos_variables()], [variables_armonizadas()], [diseno_eh()].
#' @export
#' @examples
#' \dontrun{
#' # Evolución de la pobreza ponderada por año
#' library(srvyr); library(dplyr)
#' get_eh_armonizada(grupo = "pobreza") |>
#'   group_by(anio) |>
#'   summarise(mean(pobre, na.rm = TRUE))
#'
#' # Consulta perezosa con DuckDB
#' con <- get_eh_armonizada(as = "duckdb")
#' DBI::dbGetQuery(con, "SELECT anio, AVG(pobre) FROM eh_armonizada GROUP BY anio")
#' DBI::dbDisconnect(con, shutdown = TRUE)
#' }
get_eh_armonizada <- function(anios = NULL, variables = NULL, grupo = NULL,
                              departamento = NULL, area = NULL,
                              as = c("tibble", "arrow", "duckdb"),
                              overwrite = FALSE, verbose = TRUE) {
  as <- match.arg(as)
  variables <- .resolve_armon_vars(variables, grupo)

  path <- .download_armonizada_eh(overwrite = overwrite, verbose = verbose)
  ds <- arrow::open_dataset(path, format = "parquet")

  if (!is.null(anios)) {
    anios <- as.integer(anios)
    ds <- dplyr::filter(ds, .data$anio %in% !!anios)
  }
  dep <- .resolve_dep_codes(departamento)
  if (!is.null(dep)) {
    dep <- as.character(dep)
    ds <- dplyr::filter(ds, .data$depto %in% !!dep)
  }
  ar <- .resolve_area_codes(area)
  if (!is.null(ar)) {
    ar <- as.character(ar)
    ds <- dplyr::filter(ds, .data$area %in% !!ar)
  }

  if (!is.null(variables)) {
    cols <- intersect(unique(c(.CANON_SIEMPRE, "anio", variables)), names(ds))
    ds <- dplyr::select(ds, dplyr::all_of(cols))
  }
  .return_as(ds, as, table_name = "eh_armonizada", verbose = verbose)
}
