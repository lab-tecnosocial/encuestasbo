# Inspecciona los .sav de Persona de cada año EH: localiza el archivo y reporta
# las variables de diseño/geografía/clave para construir el mapa canónico.
suppressMessages(library(haven))
base <- "original-data/eh"
years <- 2012:2024

find_file <- function(y, kind = "persona") {
  if (y == 2020) return(file.path(base, "2020", "BOL_EH2020.sav"))
  dir <- if (y == 2023) file.path(base, "2023") else file.path(base, y, "raw")
  f <- list.files(dir, pattern = "[.]sav$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  f <- f[grepl(kind, f, ignore.case = TRUE)]
  f <- f[!grepl("nesstar", f, ignore.case = TRUE)]
  if (length(f) == 0) return(NA_character_)
  f[which.min(nchar(f))]
}

pat <- "^(folio|depto|dep|area|factor|fact|upm|estrato|nro|id|s01a_02|s01a_03)"
for (y in years) {
  f <- find_file(y, "persona")
  if (is.na(f) || !file.exists(f)) { cat(y, ": NO PERSONA FILE\n"); next }
  d <- tryCatch(read_sav(f, n_max = 0), error = function(e) NULL)
  if (is.null(d)) { cat(y, ": ERROR read\n"); next }
  nm <- names(d)
  dis <- nm[grepl(pat, nm, ignore.case = TRUE)]
  cat(sprintf("\n=== %d (%s) | %d vars ===\n", y, basename(f), length(nm)))
  cat("  diseno/geo/clave:", paste(dis, collapse = ", "), "\n")
}
