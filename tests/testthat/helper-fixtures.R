# Crea un Parquet de fixture en un directorio de caché temporal y apunta la
# opción `encuestasbo.cache_dir` a él, de modo que get_eh()/get_ece() lo
# encuentren en caché sin descargar nada de la red.
#
# Devuelve el data.frame fuente para comparar en los asserts.
local_fixture_eh <- function(anio = 2023, tabla = "persona", env = parent.frame()) {
  cache_dir <- withr::local_tempdir(.local_envir = env)
  withr::local_options(list(encuestasbo.cache_dir = cache_dir), .local_envir = env)

  set.seed(42)
  n <- 200L
  df <- data.frame(
    folio       = sprintf("F%04d", seq_len(n)),
    nro_hogar   = 1L,
    nro_persona = rep(1:4, length.out = n),
    depto       = rep(1:9, length.out = n),
    area        = rep(1:2, length.out = n),
    factor      = runif(n, 50, 500),
    upm         = rep(1:40, length.out = n),
    estrato     = rep(1:8, length.out = n),
    sexo        = rep(1:2, length.out = n),
    edad        = sample(0:95, n, replace = TRUE),
    stringsAsFactors = FALSE
  )

  fila <- encuestasbo::catalogo_eh(anio = anio, tabla = tabla)
  stopifnot(nrow(fila) == 1)
  dest_dir <- file.path(cache_dir, "eh")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  arrow::write_parquet(df, file.path(dest_dir, fila$archivo_parquet))

  df
}

# Escribe un eh_armonizada.parquet de fixture en el caché temporal.
local_fixture_armonizada <- function(env = parent.frame()) {
  cache_dir <- withr::local_tempdir(.local_envir = env)
  withr::local_options(list(encuestasbo.cache_dir = cache_dir), .local_envir = env)
  set.seed(11)
  mk <- function(anio, n = 150L) data.frame(
    folio = sprintf("F%04d", seq_len(n)), nro_persona = "1",
    depto = as.character(rep(1:9, length.out = n)),
    area  = as.character(rep(1:2, length.out = n)),
    upm   = as.character(rep(1:30, length.out = n)),
    estrato = as.character(rep(1:6, length.out = n)),
    factor = runif(n, 50, 400),
    sexo  = as.character(rep(1:2, length.out = n)),
    pobre = rbinom(n, 1, 0.36),
    ingreso_hogar = rlnorm(n, log(4000), 0.5),
    anio = as.integer(anio), stringsAsFactors = FALSE)
  df <- rbind(mk(2022), mk(2023))
  dest_dir <- file.path(cache_dir, "eh")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  arrow::write_parquet(df, file.path(dest_dir, "eh_armonizada.parquet"))
  df
}

# Igual que local_fixture_eh() pero para un trimestre de la ECE.
local_fixture_ece <- function(anio = 2023, trimestre = 4, env = parent.frame()) {
  cache_dir <- withr::local_tempdir(.local_envir = env)
  withr::local_options(list(encuestasbo.cache_dir = cache_dir), .local_envir = env)
  set.seed(7)
  n <- 200L
  df <- data.frame(
    depto = rep(1:9, length.out = n), area = rep(1:2, length.out = n),
    upm = rep(1:40, length.out = n), estrato = rep(1:8, length.out = n),
    fact_trim_act = runif(n, 50, 500), fact_mes_act = runif(n, 50, 500),
    pea = rbinom(n, 1, 0.6), pead = rbinom(n, 1, 0.05)
  )
  fila <- encuestasbo::catalogo_ece(anio = anio, trimestre = trimestre, tabla = "persona")
  stopifnot(nrow(fila) == 1)
  dest_dir <- file.path(cache_dir, "ece")
  dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
  arrow::write_parquet(df, file.path(dest_dir, fila$archivo_parquet))
  df
}
