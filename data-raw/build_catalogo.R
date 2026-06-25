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
# se añade durante la adquisición; aquí se siembran los dos niveles centrales.
# EH 2012-2024 (13 años). El catálogo 88 (EH 2020) distribuye 4 bases SPSS
# (Persona, Vivienda, Defunciones, GastosAlimentarios); se usan Persona+Vivienda.
eh_anios   <- 2012:2024
eh_tablas  <- c("vivienda", "persona")

eh <- expand.grid(
  encuesta  = "eh",
  anio      = eh_anios,
  trimestre = NA_integer_,
  tabla     = eh_tablas,
  stringsAsFactors = FALSE
)
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

# Columnas de procedencia y armonización (se rellenan en la adquisición).
catalogo_encuestas$catalog_id   <- NA_character_   # id del estudio en ANDA
catalogo_encuestas$archivo_sav  <- NA_character_   # nombre original del .sav
catalogo_encuestas$version_caeb <- NA_character_   # versión del clasificador de actividad
catalogo_encuestas$version_cob  <- NA_character_   # versión del clasificador de ocupación

# Orden estable
ord <- with(catalogo_encuestas, order(encuesta, anio, trimestre, tabla))
catalogo_encuestas <- catalogo_encuestas[ord, ]
rownames(catalogo_encuestas) <- NULL

usethis::use_data(catalogo_encuestas, overwrite = TRUE, compress = "xz")

message(sprintf("catalogo_encuestas: %d filas (EH: %d, ECE: %d)",
                nrow(catalogo_encuestas),
                sum(catalogo_encuestas$encuesta == "eh"),
                sum(catalogo_encuestas$encuesta == "ece")))
