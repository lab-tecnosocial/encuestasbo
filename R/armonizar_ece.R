# Armonización de la Encuesta Continua de Empleo (ECE) entre versiones.
#
# El cuestionario de la ECE cambió en 2019: variables de empleo derivadas
# (`pea`, `peao`, `pead`, `pet`, `condact`) y el sexo (`s1_02`) son estables en
# toda la serie, pero la **categoría ocupacional** ("situación en el empleo")
# cambió de variable Y de codificación:
#   - Hasta 2018 (incl. el bundle 2015-2019): variable `s2_20`.
#   - Desde 2019: variable `s2_18`.
# Sus códigos NO coinciden (p. ej. "cuenta propia" es 3 en `s2_20` y 2 en
# `s2_18`), por lo que se mapean a un esquema canónico estable.

# Esquema canónico de categoría ocupacional (situación en el empleo).
.ECE_CATEGORIA_LABELS <- c(
  "1" = "Obrero/Empleado",
  "2" = "Cuenta propia",
  "3" = "Empleador o socio",
  "4" = "Cooperativista de producción",
  "5" = "Familiar/aprendiz no remunerado",
  "6" = "Empleada/o del hogar"
)

# Recodificación a canónico desde cada versión del cuestionario.
# s2_18 (>= 2019): 1 Obrero/Empleado, 2 Cuenta propia, 3 Empleador,
#   4 Cooperativista, 5 Familiar sin remun., 6 Aprendiz sin remun., 7 Empleada hogar.
.ECE_MAP_S2_18 <- c("1" = 1, "2" = 2, "3" = 3, "4" = 4, "5" = 5, "6" = 5, "7" = 6)
# s2_20 (<= 2018): 1 Obrero, 2 Empleado, 3 Cuenta propia, 4 Patrón c/salario,
#   5 Patrón s/salario, 6 Cooperativista, 7 Familiar/aprendiz sin remun., 8 Empleada hogar.
.ECE_MAP_S2_20 <- c("1" = 1, "2" = 1, "3" = 2, "4" = 3, "5" = 3, "6" = 4, "7" = 5, "8" = 6)

.recodificar <- function(x, mapa) {
  out <- unname(mapa[as.character(x)])
  out[is.na(match(as.character(x), names(mapa)))] <- NA_real_
  out
}

#' Armoniza un data frame de la ECE a nombres/códigos canónicos
#'
#' Añade columnas canónicas estables entre versiones de la ECE (el cuestionario
#' cambió en 2019), **sin** eliminar las columnas originales. Es la base para
#' [diseno_ece()] y los indicadores laborales ([tasa_desempleo()],
#' [tasa_subocupacion()], [empleo_vulnerable()]).
#'
#' Columnas canónicas añadidas (si las de origen están presentes):
#' \describe{
#'   \item{`sexo`}{1 = Hombre, 2 = Mujer (de `s1_02`).}
#'   \item{`categoria_ocupacional`}{Situación en el empleo, 1-6 (ver Detalles),
#'     mapeada desde `s2_20` (hasta 2018) o `s2_18` (desde 2019).}
#'   \item{`ocupado`, `desocupado`, `subocupado`}{Indicadores 0/1 (de `peao`,
#'     `pead`, `psubocup`). `subocupado` es `NA` antes de 2019 (no se midió).}
#' }
#'
#' @param df Un data.frame de [get_ece()].
#' @param anio,trimestre Periodo de origen (no se usan directamente: la versión
#'   del cuestionario se detecta por las variables presentes).
#' @return El `df` con las columnas canónicas añadidas.
#'
#' @details
#' Codificación canónica de `categoria_ocupacional`: 1 Obrero/Empleado,
#' 2 Cuenta propia, 3 Empleador o socio, 4 Cooperativista de producción,
#' 5 Familiar/aprendiz no remunerado, 6 Empleada/o del hogar. El "empleo
#' vulnerable" (OIT) son las categorías 2 y 5.
#'
#' @seealso [diseno_ece()], [empleo_vulnerable()].
#' @export
#' @examples
#' \dontrun{
#' get_ece(2023, trimestre = 4, as = "tibble") |>
#'   armonizar_ece(2023, 4) |>
#'   dplyr::count(categoria_ocupacional)
#' }
armonizar_ece <- function(df, anio, trimestre) {
  nm <- names(df)

  if ("s1_02" %in% nm && !"sexo" %in% nm) {
    df[["sexo"]] <- as.integer(df[["s1_02"]])
  }

  # Categoría ocupacional: detecta la versión por la variable presente.
  if ("s2_18" %in% nm) {
    df[["categoria_ocupacional"]] <- .recodificar(df[["s2_18"]], .ECE_MAP_S2_18)
  } else if ("s2_20" %in% nm) {
    df[["categoria_ocupacional"]] <- .recodificar(df[["s2_20"]], .ECE_MAP_S2_20)
  }

  if ("peao" %in% nm && !"ocupado" %in% nm)    df[["ocupado"]]    <- as.integer(df[["peao"]])
  if ("pead" %in% nm && !"desocupado" %in% nm) df[["desocupado"]] <- as.integer(df[["pead"]])
  # Subocupación solo se mide desde 2019; antes queda NA.
  if (!"subocupado" %in% nm) {
    df[["subocupado"]] <- if ("psubocup" %in% nm) as.integer(df[["psubocup"]]) else NA_integer_
  }

  df
}

# Columnas de identificación/diseño siempre presentes en la serie ECE armonizada.
.CANON_ECE_SIEMPRE <- c("depto", "area", "upm", "estrato",
                        "fact_trim_act", "fact_mes_act")
# Columnas analíticas canónicas (nombres estables entre versiones del cuestionario):
# las que añade armonizar_ece() más los indicadores de empleo e ingreso laboral
# derivados por el INE (estables en toda la serie).
.CANON_ECE_ANALITICAS <- c("sexo", "categoria_ocupacional", "ocupado", "desocupado",
                           "subocupado", "pea", "pet", "ylab")
# Numéricas (continuas o indicadores 0/1) para homogeneizar tipos al apilar
# trimestres con bind_rows; el resto de columnas canónicas son códigos -> texto.
.CANON_ECE_NUMERICAS <- c("fact_trim_act", "fact_mes_act", "ocupado", "desocupado",
                          "subocupado", "pea", "pet", "ylab")

# Homogeneiza tipos de las columnas canónicas de la ECE para apilar trimestres.
.coerce_canonicas_ece <- function(df) {
  for (nm in names(df)) {
    x <- df[[nm]]
    if (nm %in% .CANON_ECE_NUMERICAS) {
      df[[nm]] <- if (is.numeric(x)) x else suppressWarnings(as.numeric(as.character(x)))
    } else {
      df[[nm]] <- as.character(x)
    }
  }
  df
}

#' Serie armonizada de la Encuesta Continua de Empleo entre trimestres
#'
#' Devuelve la ECE armonizada (columnas canónicas estables entre versiones del
#' cuestionario, que cambió en 2019) de varios trimestres apilada en formato
#' largo, con columnas `anio` y `trimestre`. Es el equivalente para la ECE de
#' [get_eh_armonizada()]: aplica [armonizar_ece()] a cada trimestre y los apila
#' con tipos homogéneos. Los trimestres se descargan (y cachean) por separado
#' desde GitHub Releases; no requiere un Parquet consolidado.
#'
#' @param anios Vector de años a incluir (por defecto todos los disponibles).
#' @param trimestres Vector de trimestres (1-4) a incluir (por defecto todos).
#' @param variables Vector de nombres canónicos a incluir. Si `NULL`, todas las
#'   analíticas armonizadas (ver [variables_armonizadas_ece()]).
#' @param departamento Filtro opcional por departamento.
#' @param area Filtro opcional por área.
#' @param as Formato de retorno: `"tibble"` (defecto), `"arrow"` (Arrow Table) o
#'   `"duckdb"` (conexión DBI con la tabla `"ece_armonizada"`).
#' @param overwrite Lógico. Si `TRUE`, re-descarga los Parquet por trimestre.
#' @param verbose Lógico. Mostrar progreso.
#'
#' @return Según `as`: un `data.frame` (tibble), una `arrow::Table` o una
#'   conexión `DBI`. Siempre incluye `anio`, `trimestre` y las columnas de diseño
#'   (`upm`, `estrato`, `fact_trim_act`, `fact_mes_act`, `depto`, `area`).
#'
#' @details
#' Las columnas de identificación/diseño/geografía (`depto`, `area`, `upm`,
#' `estrato`, `sexo`, `categoria_ocupacional`) se almacenan como texto (códigos
#' estables y válidos como `ids`/`strata` en survey); los factores de expansión,
#' los indicadores de empleo (`ocupado`, `desocupado`, `subocupado`, `pea`,
#' `pet`) y el ingreso laboral (`ylab`) como numéricas. `subocupado` es `NA`
#' antes de 2019 (no se medía). Como se apilan trimestres con factores de
#' expansión distintos, para estimaciones ponderadas de un periodo concreto usa
#' [diseno_ece()]; esta serie es para comparaciones descriptivas entre periodos.
#'
#' @seealso [armonizar_ece()], [get_ece()], [diseno_ece()], [get_eh_armonizada()].
#' @export
#' @examples
#' \dontrun{
#' # Evolución del empleo vulnerable (cuenta propia + familiar no remunerado)
#' library(dplyr)
#' get_ece_armonizada(anios = 2022:2023) |>
#'   filter(ocupado == 1) |>
#'   group_by(anio, trimestre) |>
#'   summarise(vulnerable = mean(categoria_ocupacional %in% c(2, 5), na.rm = TRUE))
#' }
get_ece_armonizada <- function(anios = NULL, trimestres = NULL, variables = NULL,
                               departamento = NULL, area = NULL,
                               as = c("tibble", "arrow", "duckdb"),
                               overwrite = FALSE, verbose = TRUE) {
  as <- match.arg(as)
  cat_ece <- catalogo_encuestas[catalogo_encuestas$encuesta == "ece" &
                                  catalogo_encuestas$tabla == "persona", ]
  if (!is.null(anios))      cat_ece <- cat_ece[cat_ece$anio %in% as.integer(anios), ]
  if (!is.null(trimestres)) cat_ece <- cat_ece[cat_ece$trimestre %in% as.integer(trimestres), ]
  if (nrow(cat_ece) == 0) {
    cli::cli_abort(c(
      "No hay trimestres de la ECE para esa combinación de {.arg anios}/{.arg trimestres}.",
      "i" = "Usa {.code catalogo_ece()} para ver los periodos disponibles."
    ))
  }
  cat_ece <- cat_ece[order(cat_ece$anio, cat_ece$trimestre), ]

  if (verbose) {
    cli::cli_inform("Armonizando {nrow(cat_ece)} trimestre{?s} de la ECE...")
  }
  partes <- lapply(seq_len(nrow(cat_ece)), function(i) {
    y <- cat_ece$anio[i]; t <- cat_ece$trimestre[i]
    df <- get_ece(y, t, "persona", departamento = departamento, area = area,
                  as = "tibble", overwrite = overwrite, verbose = FALSE)
    df <- armonizar_ece(df, y, t)
    cols <- intersect(c(.CANON_ECE_SIEMPRE, .CANON_ECE_ANALITICAS), names(df))
    df <- .coerce_canonicas_ece(df[, cols, drop = FALSE])
    df$anio <- as.integer(y); df$trimestre <- as.integer(t)
    df
  })
  arm <- dplyr::bind_rows(partes)
  front <- intersect(c("anio", "trimestre"), names(arm))
  arm <- arm[, c(front, setdiff(names(arm), front)), drop = FALSE]

  if (!is.null(variables)) {
    faltan <- setdiff(variables, names(arm))
    if (length(faltan) > 0) {
      cli::cli_warn(c(
        "Variables armonizadas de la ECE no encontradas: {.val {faltan}}",
        "i" = "Usa {.code variables_armonizadas_ece()} para ver las disponibles."
      ))
    }
    keep <- intersect(unique(c(.CANON_ECE_SIEMPRE, "anio", "trimestre", variables)),
                      names(arm))
    arm <- arm[, keep, drop = FALSE]
  }

  switch(as,
    "tibble" = dplyr::as_tibble(arm),
    "arrow"  = arrow::arrow_table(arm),
    "duckdb" = {
      con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
      DBI::dbWriteTable(con, "ece_armonizada", arm)
      con
    }
  )
}

#' Lista las columnas canónicas de la serie ECE armonizada
#'
#' @return Un data.frame con el nombre canónico y una breve descripción de cada
#'   columna que devuelve [get_ece_armonizada()].
#' @seealso [get_ece_armonizada()], [variables_armonizadas()].
#' @export
#' @examples
#' variables_armonizadas_ece()
variables_armonizadas_ece <- function() {
  data.frame(
    variable = c("anio", "trimestre", .CANON_ECE_SIEMPRE, .CANON_ECE_ANALITICAS),
    etiqueta = c(
      "Año de referencia", "Trimestre (1-4)",
      "Departamento (código 1-9)", "Área (1 = Urbana, 2 = Rural)",
      "Unidad primaria de muestreo", "Estrato",
      "Factor de expansión trimestral", "Factor de expansión mensual",
      "Sexo (1 = Hombre, 2 = Mujer)",
      "Categoría ocupacional canónica (1-6; situación en el empleo)",
      "Ocupado (0/1)", "Desocupado (0/1)",
      "Subocupado (0/1; NA antes de 2019)",
      "Población económicamente activa (0/1)",
      "Población en edad de trabajar (0/1)",
      "Ingreso laboral"
    ),
    stringsAsFactors = FALSE
  )
}
