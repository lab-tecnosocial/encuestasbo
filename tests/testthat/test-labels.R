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

test_that("etiquetar_valores() etiqueta datos armonizados (esquema canónico)", {
  df <- data.frame(
    sexo = c("1", "2"), nivel_edu = c("0", "4"),
    condicion_actividad = c("1", "0"), pobre = c("1", "0"),
    ingreso_hogar = c(4000, 5000)        # marcador de datos armonizados
  )
  res <- etiquetar_valores(df)            # sin anio: usa etiquetas armonizadas
  expect_equal(as.character(res$sexo), c("Hombre", "Mujer"))
  expect_equal(as.character(res$nivel_edu), c("Ninguno", "Otros"))
  expect_equal(as.character(res$pobre), c("Pobre", "No pobre"))
  expect_true(is.numeric(res$ingreso_hogar))   # no se toca
})

test_that("etiquetar_valores() usa el codebook (no armonizado) con datos crudos", {
  df <- data.frame(s01a_02 = c(1L, 2L))   # sin marcadores canónicos -> codebook
  res <- etiquetar_valores(df, anio = 2023)
  expect_true(all(grepl("Hombre|Mujer", as.character(res$s01a_02))))
})

test_that("etiquetar_variables() reemplaza nombres por etiquetas", {
  df <- data.frame(yhog = 1, ylab = 2)
  res <- etiquetar_variables(df, anio = 2023)
  expect_false("yhog" %in% names(res))
  expect_true(any(grepl("Ingreso del hogar", names(res), ignore.case = TRUE)))
})
