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
    pobreza     = c("pobre", "pobre_extremo", "linea_pobreza", "linea_pobreza_extrema"),
    vivienda    = c("tipo_vivienda", "tenencia_vivienda"),
    salud       = c("tiene_seguro_salud")
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

# Etiquetas de valor del esquema armonizado (códigos -> texto), consistentes
# entre años. Las usa etiquetar_valores() sobre datos armonizados.
.HARMONIZED_VALUE_LABELS <- list(
  sexo                = c("1" = "Hombre", "2" = "Mujer"),
  area                = c("1" = "Urbana", "2" = "Rural"),
  nivel_edu           = c("0" = "Ninguno", "1" = "Primaria", "2" = "Secundaria",
                          "3" = "Superior", "4" = "Otros"),
  condicion_actividad = c("0" = "Menor de 10 años", "1" = "Ocupado", "2" = "Cesante",
                          "3" = "Aspirante", "4" = "Inactivo temporal",
                          "5" = "Inactivo permanente"),
  pobre               = c("0" = "No pobre", "1" = "Pobre"),
  pobre_extremo       = c("0" = "No", "1" = "Sí"),
  pea                 = c("0" = "No", "1" = "Sí"),
  pet                 = c("0" = "No", "1" = "Sí"),
  ocupado             = c("0" = "No", "1" = "Sí"),
  desocupado          = c("0" = "No", "1" = "Sí"),
  tipo_vivienda       = c("1" = "Casa", "2" = "Choza/Pahuichi", "3" = "Departamento",
                          "4" = "Cuarto(s) suelto(s)", "5" = "Vivienda improvisada",
                          "6" = "Local no destinado a habitación"),
  tenencia_vivienda   = c("1" = "Propia y pagada", "2" = "Propia y pagándose",
                          "3" = "Alquilada", "4" = "Anticrético/contrato mixto",
                          "5" = "Cedida por servicios", "6" = "Prestada por parientes/amigos",
                          "7" = "Otra"),
  tiene_seguro_salud  = c("0" = "Sin seguro", "1" = "Con seguro")
)

# Recodificación de la tenencia de la vivienda a un esquema canónico estable.
# El INE usó dos órdenes de códigos: 2012-2015 (régimen A) y 2016-2024 (régimen B).
# Canónico: 1 Propia pagada, 2 Propia pagándose, 3 Alquilada, 4 Anticrético/Mixto,
# 5 Cedida por servicios, 6 Prestada por parientes/amigos, 7 Otra.
.TENENCIA_RECODE_A <- c("1" = 3, "2" = 1, "3" = 2, "4" = 5, "5" = 6, "6" = 4, "7" = 7)
.TENENCIA_RECODE_B <- c("1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 4, "6" = 5, "7" = 6, "8" = 7)

# Código de "Ninguno" (sin seguro) de la variable de seguro de salud, por año
# (cambia: 7 en 2012-2013, 6 en 2015-2023, 5 en 2024). Se obtiene del codebook.
.ninguno_seguro_code <- function(anio) {
  cb <- codebook_eh_meta[[as.character(anio)]]
  if (is.null(cb)) return(NA_integer_)
  i <- which(grepl("afiliad.* a alguno de los siguientes seguros de salud",
                   cb$etiqueta, ignore.case = TRUE, perl = TRUE) & cb$tabla == "persona")
  if (length(i) == 0) return(NA_integer_)
  vc <- cb$valores_codigos[[i[1]]]
  if (!is.data.frame(vc)) return(NA_integer_)
  code <- vc$codigo[grepl("ninguno", vc$etiqueta, ignore.case = TRUE)]
  if (length(code) == 0) NA_integer_ else as.integer(code[1])
}

# Marcadores: nombres canónicos que NO existen como variable cruda del INE; su
# presencia indica que el data frame ya está armonizado.
.HARMONIZED_MARKERS <- c("sexo", "edad", "nivel_edu", "condicion_actividad",
                         "ingreso_hogar", "pobre",
                         "tipo_vivienda", "tenencia_vivienda", "tiene_seguro_salud")

# Armoniza VALORES que cambian de código entre años a un esquema canónico.
#  - nivel_edu: "Otros" es 4/5/9 según el año -> se colapsa a 4. Códigos 0-3 estables.
#  - tenencia_vivienda: dos regímenes de códigos (2012-2015 vs 2016+) -> canónico.
#  - tiene_seguro_salud: código de seguro -> binario (0 = ninguno, 1 = afiliado).
.armonizar_valores <- function(df, anio = NULL) {
  if ("nivel_edu" %in% names(df)) {
    v <- suppressWarnings(as.integer(as.character(df[["nivel_edu"]])))
    v[v %in% c(5L, 9L)] <- 4L
    df[["nivel_edu"]] <- v
  }
  if ("tenencia_vivienda" %in% names(df) && !is.null(anio)) {
    mapa <- if (as.integer(anio) <= 2015) .TENENCIA_RECODE_A else .TENENCIA_RECODE_B
    v <- as.character(df[["tenencia_vivienda"]])
    out <- unname(mapa[v]); out[is.na(match(v, names(mapa)))] <- NA_real_
    df[["tenencia_vivienda"]] <- out
  }
  if ("tiene_seguro_salud" %in% names(df) && !is.null(anio)) {
    ning <- .ninguno_seguro_code(anio)
    v <- suppressWarnings(as.integer(as.character(df[["tiene_seguro_salud"]])))
    df[["tiene_seguro_salud"]] <- if (is.na(ning)) NA_integer_ else as.integer(v != ning)
  }
  df
}

# Columnas numéricas (continuas o indicadores 0/1, usadas en medias/proporciones).
# El resto de columnas canónicas son códigos/identificadores -> texto.
.CANON_NUMERICAS <- c(
  "factor", "edad", "anios_estudio", "ingreso_laboral", "ingreso_no_laboral",
  "ingreso_personal", "ingreso_hogar", "linea_pobreza", "linea_pobreza_extrema",
  "pobre", "pobre_extremo", "pea", "pet", "ocupado", "desocupado",
  "tiene_seguro_salud"
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
  df <- .armonizar_valores(df, anio)

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
