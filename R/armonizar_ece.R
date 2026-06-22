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
