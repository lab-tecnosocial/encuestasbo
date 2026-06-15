# Repositorio de GitHub que aloja los Releases con los datos Parquet.
.ENCUESTASBO_REPO <- "lab-tecnosocial/encuestasbo"

# Construye la URL de descarga de un archivo dentro de un Release dado.
.release_url <- function(release_tag, filename) {
  paste0("https://github.com/", .ENCUESTASBO_REPO,
         "/releases/download/", release_tag, "/", filename)
}

# EH armonizada (todos los años, columnas canónicas) en un único Parquet.
.ARMONIZADA_EH <- list(
  filename    = "eh_armonizada.parquet",
  subdir      = "eh",
  release_tag = "data-eh-v1"
)

# Departamentos de Bolivia. En las encuestas del INE el código de departamento
# (`depto`) es un entero 1-9, a diferencia del censo que usa "01".."09".
.DEP_CODES <- c(
  "1" = "Chuquisaca", "2" = "La Paz",    "3" = "Cochabamba",
  "4" = "Oruro",      "5" = "Potosí",    "6" = "Tarija",
  "7" = "Santa Cruz", "8" = "Beni",      "9" = "Pando"
)

# Convierte nombres o números de departamento a códigos enteros (1-9).
# Devuelve NULL si `departamento` es NULL (sin filtro).
.resolve_dep_codes <- function(departamento) {
  if (is.null(departamento)) return(NULL)
  dep <- as.character(departamento)

  numeric_mask <- grepl("^[0-9]+$", dep)
  dep[numeric_mask] <- as.character(as.integer(dep[numeric_mask]))

  name_mask <- !numeric_mask
  if (any(name_mask)) {
    matched <- match(tolower(dep[name_mask]), tolower(.DEP_CODES))
    if (any(is.na(matched))) {
      cli::cli_abort(c(
        "Departamento no reconocido: {dep[name_mask][is.na(matched)]}",
        "i" = "Usa {.code departamentos()} para ver los nombres válidos."
      ))
    }
    dep[name_mask] <- names(.DEP_CODES)[matched]
  }

  invalid <- !dep %in% names(.DEP_CODES)
  if (any(invalid)) {
    cli::cli_abort(c(
      "Código(s) de departamento inválido(s): {dep[invalid]}",
      "i" = "Los departamentos válidos son del 1 al 9."
    ))
  }
  as.integer(dep)
}

# Códigos de área (urbano/rural) usados por el INE.
.AREA_CODES <- c("1" = "Urbana", "2" = "Rural")

# Normaliza el argumento `area` a códigos enteros (1 = Urbana, 2 = Rural).
.resolve_area_codes <- function(area) {
  if (is.null(area)) return(NULL)
  a <- as.character(area)
  numeric_mask <- grepl("^[0-9]+$", a)
  a[numeric_mask] <- as.character(as.integer(a[numeric_mask]))
  name_mask <- !numeric_mask
  if (any(name_mask)) {
    matched <- match(tolower(a[name_mask]), tolower(.AREA_CODES))
    if (any(is.na(matched))) {
      cli::cli_abort(c(
        "Área no reconocida: {a[name_mask][is.na(matched)]}",
        "i" = "Valores válidos: {.val Urbana} (1) o {.val Rural} (2)."
      ))
    }
    a[name_mask] <- names(.AREA_CODES)[matched]
  }
  invalid <- !a %in% names(.AREA_CODES)
  if (any(invalid)) {
    cli::cli_abort("Código(s) de área inválido(s): {a[invalid]}. Usa 1 (Urbana) o 2 (Rural).")
  }
  as.integer(a)
}

#' Lista los departamentos de Bolivia
#'
#' @return Un data.frame con columnas `depto` (código entero 1-9) y `nombre_dep`.
#' @export
#' @examples
#' departamentos()
departamentos <- function() {
  data.frame(
    depto      = as.integer(names(.DEP_CODES)),
    nombre_dep = unname(.DEP_CODES),
    stringsAsFactors = FALSE
  )
}
