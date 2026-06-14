# build_canonica_map.R
# -----------------------------------------------------------------------------
# Construye `variable_canonica_map`: el mapa que renombra variables de cada año
# de la EH a un esquema canónico estable, usado por armonizar_eh().
#
# Dos clases de variables:
#  (a) DISEÑO/GEO y DERIVADAS del INE con nombre estable entre años
#      (folio, depto, area, upm, estrato, factor, yhog, p0, niv_ed_g, ...).
#  (b) Variables del cuestionario cuyo nombre CAMBIA por año (sexo, edad,
#      parentesco) — se detectan por su etiqueta en codebook_eh_meta.
#
# Salida: data/variable_canonica_map.rda
# Uso:    Rscript data-raw/build_canonica_map.R   (requiere codebook_eh_meta)
# -----------------------------------------------------------------------------
load("data/codebook_eh_meta.rda")
years <- as.integer(names(codebook_eh_meta))

# Conjunto de variables (persona) disponibles por año
vars_persona <- lapply(codebook_eh_meta, function(cb) cb$variable[cb$tabla == "persona"])
vars_vivienda <- lapply(codebook_eh_meta, function(cb) cb$variable[cb$tabla == "vivienda"])

# Detecta el nombre de una variable por patrón en su etiqueta (nivel persona)
detect_by_label <- function(y, pat) {
  cb <- codebook_eh_meta[[as.character(y)]]
  i <- which(grepl(pat, cb$etiqueta, ignore.case = TRUE) & cb$tabla == "persona")
  if (length(i) == 0) return(NA_character_)
  cb$variable[i][1]
}

# Devuelve el nombre de origen si está presente ese año (en persona o vivienda), si no NA
present <- function(y, name, tabla = "persona") {
  pool <- if (tabla == "vivienda") vars_vivienda else vars_persona
  if (name %in% pool[[as.character(y)]]) name else NA_character_
}

# Caso especial: factor de expansión (2012-2014 traen factor_2001/factor_2014)
factor_var <- function(y) {
  v <- vars_persona[[as.character(y)]]
  if ("factor" %in% v) return("factor")
  if ("factor_2014" %in% v) return("factor_2014")  # marco actualizado MM-2012
  if ("factor_2001" %in% v) return("factor_2001")
  NA_character_
}

# Definición del esquema canónico: lista de filas.
# tipo de origen: "estable" (mismo nombre), "label" (por etiqueta), o función.
add <- function(rows, variable, etiqueta, tabla, armonizada, resolver) {
  v <- vapply(years, resolver, character(1))
  names(v) <- paste0("v", years)
  rows[[length(rows) + 1]] <- c(
    list(variable = variable, etiqueta = etiqueta, tabla = tabla, armonizada = armonizada),
    as.list(v)
  )
  rows
}

R <- list()
# --- Identificación y diseño muestral ---
R <- add(R, "folio",       "Identificador del hogar (anonimizado)", "persona", FALSE, function(y) present(y,"folio"))
R <- add(R, "nro_persona", "Número de persona en el hogar",         "persona", FALSE, function(y) present(y,"nro"))
R <- add(R, "depto",       "Departamento (1-9)",                    "persona", TRUE,  function(y) present(y,"depto"))
R <- add(R, "area",        "Área (1=Urbana, 2=Rural)",              "persona", TRUE,  function(y) present(y,"area"))
R <- add(R, "upm",         "Unidad primaria de muestreo",           "persona", FALSE, function(y) present(y,"upm"))
R <- add(R, "estrato",     "Estrato muestral",                      "persona", FALSE, function(y) present(y,"estrato"))
R <- add(R, "factor",      "Factor de expansión",                   "persona", TRUE,  factor_var)
# --- Demografía (nombre cambia por año -> detección por etiqueta) ---
R <- add(R, "sexo",        "Sexo (1=Hombre, 2=Mujer)",              "persona", TRUE,  function(y) detect_by_label(y, "hombre o mujer"))
R <- add(R, "edad",        "Edad en años cumplidos",                "persona", TRUE,  function(y) detect_by_label(y, "a.os cumplidos tiene"))
R <- add(R, "parentesco",  "Relación de parentesco con el jefe/a",  "persona", FALSE, function(y) detect_by_label(y, "parentesco|relaci.n.*jefe"))
# --- Educación (derivadas INE, nombre estable) ---
R <- add(R, "nivel_edu",        "Nivel educativo (general)",        "persona", TRUE,  function(y) present(y,"niv_ed_g"))
R <- add(R, "nivel_edu_detalle","Nivel educativo (detallado)",      "persona", FALSE, function(y) present(y,"niv_ed"))
R <- add(R, "anios_estudio",    "Años de estudio",                  "persona", TRUE,  function(y) present(y,"aestudio"))
# --- Empleo (derivadas INE) ---
R <- add(R, "pea",                "Población económicamente activa","persona", TRUE,  function(y) present(y,"pea"))
R <- add(R, "pet",                "Población en edad de trabajar",  "persona", TRUE,  function(y) present(y,"pet"))
R <- add(R, "ocupado",            "Población ocupada",              "persona", TRUE,  function(y) present(y,"ocupado"))
R <- add(R, "desocupado",         "Población desocupada",           "persona", TRUE,  function(y) present(y,"desocupado"))
R <- add(R, "condicion_actividad","Condición de actividad",         "persona", TRUE,  function(y) present(y,"condact"))
R <- add(R, "grupo_ocupacion",    "Grupo ocupacional (COB)",        "persona", FALSE, function(y) present(y,"cob_op"))
# --- Ingresos (Bs/Mes, derivadas INE) ---
R <- add(R, "ingreso_laboral",    "Ingreso laboral (Bs/Mes)",       "persona", TRUE,  function(y) present(y,"ylab"))
R <- add(R, "ingreso_no_laboral", "Ingreso no laboral (Bs/Mes)",    "persona", TRUE,  function(y) present(y,"ynolab"))
R <- add(R, "ingreso_personal",   "Ingreso personal (Bs/Mes)",      "persona", TRUE,  function(y) present(y,"yper"))
R <- add(R, "ingreso_hogar",      "Ingreso del hogar (Bs/Mes)",     "persona", TRUE,  function(y) present(y,"yhog"))
# --- Pobreza (derivadas INE) ---
R <- add(R, "linea_pobreza",         "Línea de pobreza (Bs/persona/mes)",        "persona", TRUE, function(y) present(y,"z"))
R <- add(R, "linea_pobreza_extrema", "Línea de pobreza extrema (Bs/persona/mes)","persona", TRUE, function(y) present(y,"zext"))
R <- add(R, "pobre",                 "Pobre por ingreso (0/1)",                  "persona", TRUE, function(y) present(y,"p0"))
R <- add(R, "pobre_extremo",         "Pobre extremo por ingreso (0/1)",          "persona", TRUE, function(y) present(y,"pext0"))

variable_canonica_map <- do.call(rbind, lapply(R, function(r) as.data.frame(r, stringsAsFactors = FALSE)))
rownames(variable_canonica_map) <- NULL

usethis::use_data(variable_canonica_map, overwrite = TRUE, compress = "xz")

# Resumen de cobertura
cov <- vapply(seq_len(nrow(variable_canonica_map)), function(i) {
  sum(!is.na(variable_canonica_map[i, paste0("v", years)]))
}, integer(1))
print(data.frame(variable = variable_canonica_map$variable, anios_cubiertos = cov))
