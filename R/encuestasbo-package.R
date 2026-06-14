#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom rlang .data
#' @importFrom dplyr filter select collect all_of
## usethis namespace: end
NULL

# Silenciar notas de R CMD check sobre datos del paquete accedidos por nombre
utils::globalVariables(c(
  "catalogo_encuestas", "codebook_eh_meta", "codebook_ece_meta",
  "variable_canonica_map", "metadata_encuestas"
))

`%||%` <- function(x, y) if (is.null(x)) y else x
