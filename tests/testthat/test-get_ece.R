test_that("get_ece() lee un trimestre y exige el trimestre", {
  local_fixture_ece(2023, 4)
  res <- get_ece(2023, trimestre = 4, as = "tibble", verbose = FALSE)
  expect_s3_class(res, "data.frame")
  expect_true(all(c("upm", "estrato", "fact_trim_act") %in% names(res)))
})

test_that("get_ece() filtra por departamento", {
  local_fixture_ece(2023, 4)
  res <- get_ece(2023, trimestre = 4, departamento = "La Paz",
                 as = "tibble", verbose = FALSE)
  expect_true(all(res$depto == 2))
})

test_that("diseno_ece() usa el factor trimestral por defecto y el mensual si se pide", {
  skip_if_not_installed("srvyr")
  local_fixture_ece(2023, 4)
  des <- diseno_ece(2023, trimestre = 4, verbose = FALSE)
  expect_s3_class(des, "tbl_svy")
  r <- srvyr::summarise(des, td = srvyr::survey_ratio(pead, pea, na.rm = TRUE))
  expect_true(is.finite(r$td))
})

test_that("get_ece() con variables= conserva los factores de expansión de la ECE", {
  # Regresión: los factores de la ECE son fact_trim_act/fact_mes_act, no `factor`.
  # La selección de variables debe preservarlos (se derivan del catálogo).
  local_fixture_ece(2023, 4)
  res <- get_ece(2023, trimestre = 4, variables = "pead",
                 as = "tibble", verbose = FALSE)
  expect_true(all(c("pead", "fact_trim_act", "fact_mes_act", "upm", "estrato",
                    "depto", "area") %in% names(res)))
})

test_that("get_ece() aborta con mensaje claro para tabla no disponible (vivienda)", {
  expect_error(get_ece(2023, trimestre = 4, tabla = "vivienda", verbose = FALSE),
               "persona")
})

test_that(".resolve_catalogo() exige trimestre para la ECE", {
  expect_error(.resolve_catalogo("ece", 2023, "persona"), "trimestre")
})
