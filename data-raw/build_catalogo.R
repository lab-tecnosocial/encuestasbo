# build_catalogo.R
# -----------------------------------------------------------------------------
# Construye `catalogo_encuestas`: la tabla maestra que mapea cada
# (encuesta, anio, trimestre, tabla) a su origen en ANDA y a su Release en GitHub.
#
# Es una tabla CURADA A MANO. Los `catalog_id` y el conjunto exacto de tablas se
# verifican navegando el catálogo ANDA (https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS)
# durante la adquisición (data-raw/acquire_anda.R) y se rellenan aquí.
#
# Inventario confirmado en el catálogo ANDA (jun-2026):
#   EH:  una entrada por año 2012..2024 (13 datasets).
#   ECE: bundle "IV 2015 - II 2019" (un solo estudio, 15 trimestres) +
#        trimestres sueltos 2021 (T2-T4), 2022-2024 (T1-T4), 2025 (T1-T3).
#        2020 ausente (pandemia) y falta T1-2021.
#
# Para regenerar:  Rscript data-raw/build_catalogo.R
# -----------------------------------------------------------------------------

# --- Encuesta de Hogares (EH) -------------------------------------------------
# Niveles analíticos principales. El conjunto completo de bases por año
# (equipamiento, gastos_alimentarios, seguridad_alimentaria, discriminacion)
# se añade durante la adquisición. EH 2012-2024 (13 años). Niveles centrales
# persona/vivienda + bases temáticas (equipamiento, gastos, seguridad alimentaria,
# discriminación, turismo, cultura, defunciones) según disponibilidad por año.
eh_anios   <- 2012:2024
eh_tablas  <- c("vivienda", "persona")

eh <- expand.grid(
  encuesta  = "eh",
  anio      = eh_anios,
  trimestre = NA_integer_,
  tabla     = eh_tablas,
  stringsAsFactors = FALSE
)
# Bases temáticas adicionales (inventario real generado por add_eh_bases.R).
if (file.exists("data-raw/eh_bases_extra.rds")) {
  extra <- readRDS("data-raw/eh_bases_extra.rds")
  extra$encuesta  <- "eh"
  extra$trimestre <- NA_integer_
  eh <- rbind(eh, extra[, c("encuesta", "anio", "trimestre", "tabla")])
}
eh$release_tag     <- "data-eh-v1"   # un Release con todos los Parquet de la EH
eh$archivo_parquet <- sprintf("eh_%d_%s.parquet", eh$anio, eh$tabla)
eh$factor_var      <- "factor"
eh$factor_var_alt  <- NA_character_
eh$upm_var         <- "upm"
eh$estrato_var     <- "estrato"

# --- Encuesta Continua de Empleo (ECE) ---------------------------------------
# Periodos REALES disponibles (descargados del repositorio abierto del INE,
# nube.ine.gob.bo). Un único archivo a nivel persona por trimestre. Hay huecos:
# faltan 2T/3T/4T-2020 y 1T/2T-2021 (pandemia), entre otros.
# El periodo lo determina build_ece.R (data-raw/ece_periodos.rds).
ece_periodos <- if (file.exists("data-raw/ece_periodos.rds")) {
  readRDS("data-raw/ece_periodos.rds")[, c("anio", "trimestre")]
} else {
  # Fallback si aún no se procesó la ECE: deja el catálogo solo con EH.
  data.frame(anio = integer(0), trimestre = integer(0))
}

ece <- ece_periodos
if (nrow(ece) > 0) {
  ece$encuesta        <- "ece"
  ece$tabla           <- "persona"
  ece$release_tag     <- "data-ece-v1"   # un Release con todos los Parquet de la ECE
  ece$archivo_parquet <- sprintf("ece_%dt%d_persona.parquet", ece$anio, ece$trimestre)
  ece$factor_var      <- "fact_trim_act"   # factor trimestral (real en los .sav)
  ece$factor_var_alt  <- "fact_mes_act"    # factor mensual
  ece$upm_var         <- "upm"
  ece$estrato_var     <- "estrato"
  # Cobertura: la ECE de 2020 T2-T4 fue SOLO URBANA (la pandemia impidió el
  # levantamiento rural). El resto de trimestres son de cobertura nacional.
  ece$cobertura       <- ifelse(ece$anio == 2020 & ece$trimestre %in% 2:4,
                                "urbana", "nacional")
  ece <- ece[, c("encuesta", "anio", "trimestre", "tabla", "release_tag",
                 "archivo_parquet", "factor_var", "factor_var_alt",
                 "upm_var", "estrato_var", "cobertura")]
} else {
  ece <- eh[0, ]
}

# La EH es siempre de cobertura nacional.
eh$cobertura <- "nacional"

# --- Combinar -----------------------------------------------------------------
catalogo_encuestas <- rbind(
  eh[, names(ece)],
  ece
)

# --- Procedencia: id del estudio en ANDA --------------------------------------
# Se toma de `metadata_encuestas` (extraída del DDI de ANDA), única fuente real
# del dato. Para la ECE:
#   - trimestres con estudio propio -> su id;
#   - trimestres del periodo 4T2015-2T2019 -> el id del estudio consolidado
#     (ANDA los publica como un solo estudio);
#   - 3T2019-1T2021 -> NA: se obtuvieron del repositorio abierto del INE
#     (nube.ine.gob.bo), no de ANDA, y no tienen estudio en el catálogo.
load("data/metadata_encuestas.rda")
md <- metadata_encuestas
bundle_id <- md$catalog_id[md$encuesta == "ece" & is.na(md$anio)][1]

catalogo_encuestas$catalog_id <- vapply(seq_len(nrow(catalogo_encuestas)), function(i) {
  r <- catalogo_encuestas[i, ]
  if (r$encuesta == "eh") {
    id <- md$catalog_id[md$encuesta == "eh" & !is.na(md$anio) & md$anio == r$anio]
  } else {
    id <- md$catalog_id[md$encuesta == "ece" & !is.na(md$anio) & md$anio == r$anio &
                          !is.na(md$trimestre) & md$trimestre == r$trimestre]
    # Periodo cubierto por el estudio consolidado 4T2015-2T2019.
    en_bundle <- (r$anio == 2015 & r$trimestre == 4) ||
      (r$anio %in% 2016:2018) || (r$anio == 2019 & r$trimestre %in% 1:2)
    if (length(id) == 0 && en_bundle) id <- bundle_id
  }
  if (length(id) == 0) NA_character_ else as.character(id[1])
}, character(1))

# Orden estable
ord <- with(catalogo_encuestas, order(encuesta, anio, trimestre, tabla))
catalogo_encuestas <- catalogo_encuestas[ord, ]
rownames(catalogo_encuestas) <- NULL

usethis::use_data(catalogo_encuestas, overwrite = TRUE, compress = "xz")

message(sprintf("catalogo_encuestas: %d filas (EH: %d, ECE: %d)",
                nrow(catalogo_encuestas),
                sum(catalogo_encuestas$encuesta == "eh"),
                sum(catalogo_encuestas$encuesta == "ece")))
