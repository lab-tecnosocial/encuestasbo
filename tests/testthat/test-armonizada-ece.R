# Nota: el fixture solo escribe 2018-T4 y 2023-T4 en el caché temporal, así que
# TODAS las llamadas acotan anios + trimestres = 4 para no tocar la red.

test_that("get_ece_armonizada() apila trimestres con columnas canónicas y periodo", {
  local_fixture_ece_serie()
  df <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4, verbose = FALSE)
  expect_s3_class(df, "data.frame")
  expect_equal(sort(unique(df$anio)), c(2018L, 2023L))
  expect_true(all(c("anio", "trimestre", "depto", "area", "upm", "estrato",
                    "fact_trim_act", "fact_mes_act", "sexo",
                    "categoria_ocupacional", "ocupado", "desocupado",
                    "subocupado", "pea", "pet") %in% names(df)))
  expect_equal(names(df)[1:2], c("anio", "trimestre"))
})

test_that("get_ece_armonizada() homogeneiza tipos entre versiones del cuestionario", {
  local_fixture_ece_serie()
  df <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4, verbose = FALSE)
  expect_type(df$depto, "character")
  expect_type(df$categoria_ocupacional, "character")
  expect_true(is.numeric(df$fact_trim_act))
  expect_true(is.numeric(df$ocupado))
})

test_that("get_ece_armonizada() deja subocupado = NA en trimestres <= 2018", {
  local_fixture_ece_serie()
  df <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4, verbose = FALSE)
  expect_true(all(is.na(df$subocupado[df$anio == 2018])))     # s2_20, sin psubocup
  expect_false(all(is.na(df$subocupado[df$anio == 2023])))    # s2_18, con psubocup
})

test_that("get_ece_armonizada() respeta el filtro de variables y avisa de faltantes", {
  local_fixture_ece_serie()
  expect_warning(
    df <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4,
                             variables = c("ocupado", "no_existe"), verbose = FALSE),
    "no encontradas"
  )
  expect_true(all(c("anio", "trimestre", "fact_trim_act", "upm", "estrato",
                    "ocupado") %in% names(df)))
  expect_false("pea" %in% names(df))   # no pedida
})

test_that("get_ece_armonizada() admite modos arrow y duckdb", {
  local_fixture_ece_serie()
  tbl <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4,
                            as = "arrow", verbose = FALSE)
  expect_s3_class(tbl, "Table")

  con <- get_ece_armonizada(anios = c(2018, 2023), trimestres = 4,
                            as = "duckdb", verbose = FALSE)
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  n <- DBI::dbGetQuery(con, "SELECT COUNT(*) AS n FROM ece_armonizada")$n
  expect_equal(n, 300)   # 150 + 150
})

test_that("get_ece_armonizada() aborta si no hay periodos", {
  local_fixture_ece_serie()
  expect_error(get_ece_armonizada(anios = 1990, verbose = FALSE), "No hay trimestres")
})

test_that("etiquetar_valores() reconoce la serie ECE armonizada", {
  local_fixture_ece_serie()
  df <- get_ece_armonizada(anios = 2023, trimestres = 4, verbose = FALSE)
  lab <- etiquetar_valores(df, columnas = c("sexo", "categoria_ocupacional"))
  expect_s3_class(lab$sexo, "factor")
  expect_s3_class(lab$categoria_ocupacional, "factor")
  expect_true(all(levels(lab$sexo) %in% c("Hombre", "Mujer")))
})
