test_that("codebook() busca por texto libre en las etiquetas", {
  res <- codebook(buscar = "ingreso del hogar", anio = 2023)
  expect_true(nrow(res) >= 1)
  expect_true("yhog" %in% res$variable)
})

test_that("codebook() filtra por tabla", {
  res <- codebook(tabla = "vivienda", anio = 2023)
  expect_true(all(res$tabla == "vivienda"))
})

test_that("codebook_valores() devuelve códigos de una categórica", {
  v <- codebook_valores("s01a_02", anio = 2023)   # sexo
  expect_s3_class(v, "data.frame")
  expect_true(all(c("codigo", "etiqueta") %in% names(v)))
})

test_that("codebook() aborta con año inexistente", {
  expect_error(codebook(anio = 1999), "diccionario")
})

test_that("el diccionario de la ECE requiere trimestre y funciona con él", {
  expect_error(.get_codebook("ece", 2023), "trimestre")
  cb <- .get_codebook("ece", 2023, 4)
  expect_s3_class(cb, "data.frame")
  expect_true("upm" %in% cb$variable)
})
