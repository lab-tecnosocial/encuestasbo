test_that("el catálogo cubre EH 2012-2024 (13 años)", {
  eh <- catalogo_eh()
  expect_setequal(unique(eh$anio), 2012:2024)
  expect_true(all(c("persona", "vivienda") %in% eh$tabla))
})

test_that("el catálogo de ECE refleja los periodos reales (con huecos)", {
  ece <- catalogo_ece()
  expect_gt(nrow(ece), 25)
  # 1T-2020 existe; 1T/2T-2021 no (pandemia)
  expect_equal(nrow(catalogo_ece(anio = 2020, trimestre = 1, tabla = "persona")), 1)
  expect_equal(nrow(catalogo_ece(anio = 2021, trimestre = 1, tabla = "persona")), 0)
  expect_equal(nrow(catalogo_ece(anio = 2022, trimestre = 3, tabla = "persona")), 1)
})

test_that("toda fila tiene release_tag y variables de diseño no nulas", {
  expect_false(any(is.na(catalogo_encuestas$release_tag)))
  expect_false(any(is.na(catalogo_encuestas$archivo_parquet)))
  expect_false(any(is.na(catalogo_encuestas$factor_var)))
  expect_false(any(is.na(catalogo_encuestas$upm_var)))
  expect_false(any(is.na(catalogo_encuestas$estrato_var)))
})

test_that("no hay periodos-tabla duplicados", {
  key <- with(catalogo_encuestas, paste(encuesta, anio, trimestre, tabla))
  expect_equal(anyDuplicated(key), 0L)
})

test_that(".resolve_catalogo() exige trimestre para la ECE", {
  expect_error(.resolve_catalogo("ece", 2022, "persona"), "trimestre")
})

test_that(".resolve_catalogo() aborta con periodo inexistente", {
  expect_error(.resolve_catalogo("eh", 1999, "persona"), "No hay datos")
})
