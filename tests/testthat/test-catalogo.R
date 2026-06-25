test_that("el catálogo cubre EH 2012-2024 (13 años)", {
  eh <- catalogo_eh()
  expect_setequal(unique(eh$anio), 2012:2024)
  expect_true(all(c("persona", "vivienda") %in% eh$tabla))
})

test_that("el catálogo de ECE cubre la serie completa 4T-2015 a 3T-2025", {
  ece <- catalogo_ece()
  expect_equal(nrow(ece), 40)
  # serie completa, sin huecos: 2020-T1 y 2021-T1 existen
  expect_equal(nrow(catalogo_ece(anio = 2020, trimestre = 1, tabla = "persona")), 1)
  expect_equal(nrow(catalogo_ece(anio = 2021, trimestre = 1, tabla = "persona")), 1)
  expect_equal(nrow(catalogo_ece(anio = 2022, trimestre = 3, tabla = "persona")), 1)
})

test_that("la EH incluye las bases temáticas además de persona/vivienda", {
  eh <- catalogo_eh()
  tablas <- unique(eh$tabla)
  expect_true(all(c("persona", "vivienda", "equipamiento", "gastos_alimentarios",
                    "gastos_no_alimentarios", "seguridad_alimentaria",
                    "discriminacion") %in% tablas))
  # persona y vivienda en los 13 años
  expect_equal(nrow(catalogo_eh(tabla = "persona")), 13)
  expect_equal(nrow(catalogo_eh(tabla = "vivienda")), 13)
})

test_that("la ECE 2020 T2-T4 está marcada como cobertura urbana", {
  ece <- catalogo_ece()
  expect_true("cobertura" %in% names(ece))
  urb <- ece$cobertura[ece$anio == 2020 & ece$trimestre %in% 2:4]
  expect_true(all(urb == "urbana"))
  # el resto es nacional
  resto <- ece$cobertura[!(ece$anio == 2020 & ece$trimestre %in% 2:4)]
  expect_true(all(resto == "nacional"))
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
