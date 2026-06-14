test_that("etiquetar_valores() convierte categóricas a factor con etiquetas", {
  df <- data.frame(s01a_02 = c(1L, 2L, 1L))   # sexo: 1=Hombre, 2=Mujer
  res <- etiquetar_valores(df, anio = 2023)
  expect_s3_class(res$s01a_02, "factor")
  expect_true(all(grepl("Hombre|Mujer", as.character(res$s01a_02))))
})

test_that("etiquetar_valores() deja sin cambios las columnas no categóricas", {
  df <- data.frame(ylab = c(1000, 2000))  # numérica
  res <- etiquetar_valores(df, anio = 2023)
  expect_equal(res$ylab, df$ylab)
})

test_that("etiquetar_variables() reemplaza nombres por etiquetas", {
  df <- data.frame(yhog = 1, ylab = 2)
  res <- etiquetar_variables(df, anio = 2023)
  expect_false("yhog" %in% names(res))
  expect_true(any(grepl("Ingreso del hogar", names(res), ignore.case = TRUE)))
})
