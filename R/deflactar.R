#' Índice de Precios al Consumidor (IPC) de Bolivia, promedio anual
#'
#' Serie del IPC de Bolivia (media anual) para deflactar ingresos nominales de
#' la EH/ECE a precios constantes de un año base. Usa la media anual (no fin de
#' periodo), que es la referencia correcta para deflactar ingresos de encuestas
#' levantadas a lo largo del año.
#'
#' @format Un data.frame con columnas:
#' \describe{
#'   \item{anio}{Año (2011-2024)}
#'   \item{ipc}{Índice de precios al consumidor, base 2010 = 100 (media anual)}
#' }
#' El valor base del índice es irrelevante para deflactar (se usa como cociente
#' entre años); se conserva la base original de la fuente.
#' @source Banco Mundial, indicador `FP.CPI.TOTL` (CPI, 2010 = 100), que reexpone
#'   la serie oficial del INE de Bolivia:
#'   \url{https://datos.bancomundial.org/indicador/FP.CPI.TOTL?locations=BO}
#' @seealso [deflactar()]
"ipc_bolivia"

#' Deflacta valores monetarios a precios constantes de un año base
#'
#' Convierte ingresos (u otros valores nominales) de distintos años a precios
#' reales de un `base` común, usando el IPC de Bolivia ([ipc_bolivia]). Permite
#' comparar ingresos entre años de la EH/ECE sin el sesgo de la inflación.
#'
#' @param valor Vector numérico de valores nominales (p. ej. ingresos).
#' @param anio Vector de años de cada valor (mismo largo que `valor`, o largo 1
#'   reciclado). Es el año en cuyos precios está expresado cada valor.
#' @param base Año base al que se llevan los precios. Por defecto `2024` (el año
#'   más reciente de la serie).
#' @param indice Serie de IPC a usar. Por defecto [ipc_bolivia]. Puede ser un
#'   data.frame con columnas `anio` e `ipc`, o un vector numérico con nombres de
#'   año (p. ej. `c("2023" = 157.4, "2024" = 165.4)`), para usar otra fuente o
#'   una serie propia (p. ej. IPC por ciudad).
#'
#' @return Un vector numérico con los valores a precios del año `base`. Los años
#'   sin IPC en la serie devuelven `NA` (con una advertencia).
#'
#' @details
#' La fórmula es `valor_real = valor * IPC[base] / IPC[anio]`. El valor absoluto
#' de la base del índice no afecta el resultado (se cancela en el cociente).
#'
#' @seealso [ipc_bolivia], [get_eh_armonizada()].
#' @export
#' @examples
#' # 100 Bs de 2012 valían, a precios de 2024:
#' deflactar(100, anio = 2012)
#'
#' # Vectorizado: ingresos de distintos años a precios de 2023
#' deflactar(c(1000, 1200, 1500), anio = c(2015, 2019, 2023), base = 2023)
#'
#' \dontrun{
#' # Ingreso del hogar real (precios 2024) en la serie armonizada de la EH
#' library(dplyr)
#' get_eh_armonizada(grupo = "ingresos") |>
#'   mutate(ingreso_hogar_real = deflactar(ingreso_hogar, anio, base = 2024))
#' }
deflactar <- function(valor, anio, base = 2024, indice = NULL) {
  idx <- if (is.null(indice)) ipc_bolivia else indice

  # Normaliza `indice` a un vector con nombres de año.
  if (is.data.frame(idx)) {
    if (!all(c("anio", "ipc") %in% names(idx))) {
      cli::cli_abort("El {.arg indice} (data.frame) debe tener columnas {.field anio} e {.field ipc}.")
    }
    lookup <- stats::setNames(as.numeric(idx$ipc), as.character(idx$anio))
  } else if (is.numeric(idx) && !is.null(names(idx))) {
    lookup <- idx
  } else {
    cli::cli_abort("El {.arg indice} debe ser un data.frame (anio/ipc) o un vector numérico con nombres de año.")
  }

  base_val <- unname(lookup[as.character(base)])
  if (length(base_val) == 0 || is.na(base_val)) {
    cli::cli_abort(c(
      "No hay IPC para el año base {.val {base}} en el índice.",
      "i" = "Años disponibles: {.val {names(lookup)}}."
    ))
  }

  anio_chr <- as.character(anio)
  anio_val <- unname(lookup[anio_chr])
  faltan <- unique(anio_chr[is.na(anio_val)])
  if (length(faltan) > 0) {
    cli::cli_warn(c(
      "Sin IPC para el/los año(s): {.val {faltan}}; esos valores serán {.val NA}.",
      "i" = "Años disponibles: {.val {names(lookup)}}."
    ))
  }

  valor * base_val / anio_val
}
