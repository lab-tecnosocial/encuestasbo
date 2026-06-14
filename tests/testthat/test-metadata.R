test_that("metadata_encuestas cubre EH y ECE con campos de diseño", {
  expect_true(all(c("eh", "ece") %in% metadata_encuestas$encuesta))
  expect_equal(sum(metadata_encuestas$encuesta == "eh"), 13)
  # campos de ficha técnica presentes
  expect_true(all(c("universo", "marco_diseno_muestral", "factor_expansion",
                    "modo_recoleccion") %in% names(metadata_encuestas)))
  # contenido no vacío para EH 2023
  f <- metadata_encuestas[metadata_encuestas$encuesta == "eh" &
                          metadata_encuestas$anio == 2023, ]
  expect_match(f$marco_diseno_muestral, "MM-2012|marco", ignore.case = TRUE)
})

test_that("ficha_tecnica() devuelve la fila de la EH", {
  f <- ficha_tecnica("eh", 2023)
  expect_s3_class(f, "data.frame")
  expect_equal(nrow(f), 1)
  expect_match(f$titulo, "HOGARES")
})

test_that("ficha_tecnica() exige trimestre para la ECE", {
  expect_error(ficha_tecnica("ece", 2023), "trimestre")
})

test_that("ficha_tecnica() de ECE sin estudio propio usa el consolidado con aviso", {
  expect_warning(f <- ficha_tecnica("ece", 2019, trimestre = 3), "consolidado|general")
  expect_equal(nrow(f), 1)
})
