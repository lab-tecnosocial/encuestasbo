# add_ece_pandemia.R
# -----------------------------------------------------------------------------
# Procesa los trimestres ECE que faltaban en el paquete, a partir del archivo
# CONSOLIDADO del INE (ECE_4T2015_3T2025.sav, ~2.3 GB, esquema único de 327 vars),
# descargado desde nube.ine.gob.bo. Filtra por (gestion, trimestre) y escribe un
# Parquet por trimestre, igual que build_ece.R; añade su codebook y el periodo.
#
# Faltantes: 2019-T4, 2020-T2/T3/T4 (urbano), 2021-T1/T2, 2024-T1.
# -----------------------------------------------------------------------------
suppressMessages({ library(haven); library(arrow) })

sav <- "/tmp/ece_bundle/ECE_4T2015_3T2025.sav"
targets <- list(c(2019,4), c(2020,2), c(2020,3), c(2020,4),
                c(2021,1), c(2021,2), c(2024,1))

clasificar_tipo <- function(x, nombre) {
  labs <- attr(x, "labels")
  if (!is.null(labs) && length(labs) > 0) return("categorica")
  if (grepl("(_cod$|cod$)", nombre)) return("categorica")
  if (is.character(x)) return("texto")
  "numerica"
}
extraer_codebook <- function(d, tabla = "persona") {
  nm <- names(d)
  etq <- vapply(d, function(x) { l <- attr(x, "label"); if (is.null(l)) NA_character_ else as.character(l) }, character(1))
  tipo <- mapply(clasificar_tipo, d, nm)
  vc <- lapply(d, function(x) {
    labs <- attr(x, "labels"); if (is.null(labs) || length(labs) == 0) return(NULL)
    data.frame(codigo = unname(labs), etiqueta = names(labs), stringsAsFactors = FALSE)
  })
  df <- data.frame(variable = nm, etiqueta = etq, tabla = tabla, tipo = tipo, stringsAsFactors = FALSE)
  df$valores_codigos <- vc
  df
}

message("Leyendo el consolidado (2.3 GB)...")
d <- read_sav(sav)
names(d) <- tolower(names(d))
message(sprintf("  %d filas x %d cols", nrow(d), ncol(d)))

load("data/codebook_ece_meta.rda")
per <- readRDS("data-raw/ece_periodos.rds")[, c("anio", "trimestre", "filas", "cols")]
out_dir <- "data-raw/parquet/ece"

for (t in targets) {
  y <- t[1]; q <- t[2]
  sub <- d[!is.na(d$gestion) & !is.na(d$trimestre) & d$gestion == y & d$trimestre == q, ]
  key <- sprintf("%dt%d", y, q)
  codebook_ece_meta[[key]] <- extraer_codebook(sub)
  sub2 <- zap_formats(zap_labels(sub))
  out <- file.path(out_dir, sprintf("ece_%dt%d_persona.parquet", y, q))
  write_parquet(sub2, out, compression = "zstd", compression_level = 6)
  per <- rbind(per, data.frame(anio = y, trimestre = q, filas = nrow(sub2), cols = ncol(sub2)))
  message(sprintf("  %s: %d x %d -> %s", key, nrow(sub2), ncol(sub2), basename(out)))
}

per <- per[!duplicated(paste(per$anio, per$trimestre)), ]
per <- per[order(per$anio, per$trimestre), ]
saveRDS(per, "data-raw/ece_periodos.rds")
usethis::use_data(codebook_ece_meta, overwrite = TRUE, compress = "xz")
message(sprintf("Listo. codebook_ece_meta: %d periodos; ece_periodos: %d", length(codebook_ece_meta), nrow(per)))
