# Inspecciona por ETIQUETA (no por nombre) para mapear variables comparables
# entre años: sexo, edad, ingreso, pobreza, condición de actividad, educación.
suppressMessages(library(haven))
base <- "original-data/eh"
years <- 2012:2024

find_file <- function(y, kind = "persona") {
  if (y == 2020) return(file.path(base, "2020", "BOL_EH2020.sav"))
  dir <- if (y == 2023) file.path(base, "2023") else file.path(base, y, "raw")
  f <- list.files(dir, pattern = "[.]sav$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  f <- f[grepl(kind, f, ignore.case = TRUE) & !grepl("nesstar", f, ignore.case = TRUE)]
  if (length(f) == 0) return(NA_character_)
  f[which.min(nchar(f))]
}

# patrones por concepto, buscados en la etiqueta de cada variable
conceptos <- list(
  sexo      = "hombre o mujer|sexo",
  edad      = "cuantos a.os|a.os cumplidos|edad",
  ingreso   = "^ingreso|ingreso del hogar|ingreso per|ictpc|yhog|ylab",
  pobreza   = "pobre|l.nea de pobreza|pobreza",
  actividad = "condici.n de actividad|ocupad|desocupad|pea|cob_op",
  educacion = "a.os de estudio|nivel.*instrucci|nivel educativo|niv_ed"
)

for (y in years) {
  f <- find_file(y, "persona")
  if (is.na(f)) { cat(y, ": NO FILE\n"); next }
  d <- tryCatch(read_sav(f, n_max = 0), error = function(e) NULL)
  if (is.null(d)) next
  labs <- vapply(d, function(x) { l <- attr(x, "label"); if (is.null(l)) "" else l }, character(1))
  nm <- names(d)
  cat(sprintf("\n=== %d ===\n", y))
  for (cc in names(conceptos)) {
    hit <- which(grepl(conceptos[[cc]], labs, ignore.case = TRUE) | grepl(conceptos[[cc]], nm, ignore.case = TRUE))
    hit <- head(hit, 6)
    if (length(hit)) {
      pares <- paste0(nm[hit], " [", substr(labs[hit], 1, 28), "]")
      cat(sprintf("  %-10s: %s\n", cc, paste(pares, collapse = " | ")))
    }
  }
}
