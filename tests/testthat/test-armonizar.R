test_that("variable_canonica_map cubre las variables clave en todos los años", {
  m <- variable_canonica_map
  vcols <- grep("^v[0-9]+$", names(m), value = TRUE)
  fila <- m[m$variable == "pobre", ]
  expect_true(all(!is.na(fila[vcols])))  # pobre disponible todos los años
  expect_true("factor" %in% m$variable)
  expect_true(all(c("sexo", "edad", "ingreso_hogar") %in% m$variable))
})

test_that("armonizar_eh renombra a nombres canónicos (datos 2023)", {
  df <- data.frame(
    folio = "F1", nro = 1L, depto = 7L, area = 1L, upm = 3L, estrato = 2L,
    factor = 120, s01a_02 = 2L, s01a_03 = 30L, yhog = 4000, p0 = 1L,
    niv_ed_g = 3L
  )
  res <- armonizar_eh(df, 2023)
  expect_true(all(c("sexo", "edad", "ingreso_hogar", "pobre", "nivel_edu",
                    "nro_persona", "factor", "upm", "estrato") %in% names(res)))
  expect_equal(res$sexo, 2L)
})

test_that("armonizar_eh con factor_2014 para años 2012-2014", {
  m <- variable_canonica_map
  expect_equal(m$v2012[m$variable == "factor"], "factor_2014")
  df <- data.frame(folio = "F1", nro = 1L, depto = 1L, area = 1L,
                   upm = 1L, estrato = 1L, factor_2014 = 99)
  res <- armonizar_eh(df, 2012)
  expect_true("factor" %in% names(res))
  expect_equal(res$factor, 99)
})

test_that("armonizar_eh(solo_canonicas) devuelve solo columnas canónicas", {
  df <- data.frame(folio = "F1", nro = 1L, depto = 7L, area = 1L, upm = 3L,
                   estrato = 2L, factor = 120, s01a_02 = 1L, basura = "x")
  res <- armonizar_eh(df, 2023, solo_canonicas = TRUE)
  expect_false("basura" %in% names(res))
  expect_true("sexo" %in% names(res))
})

test_that(".coerce_canonicas homogeniza tipos para apilar años", {
  # estrato como texto en un año y numérico en otro (caso real entre años EH)
  a <- data.frame(folio = "F1", upm = "10", estrato = "3", factor = 100,
                  pobre = 1L, ingreso_hogar = 4000, stringsAsFactors = FALSE)
  b <- data.frame(folio = "F2", upm = 11L, estrato = 4L, factor = 120,
                  pobre = 0L, ingreso_hogar = 5000, stringsAsFactors = FALSE)
  ra <- .coerce_canonicas(a); rb <- .coerce_canonicas(b)
  expect_type(ra$estrato, "character")   # ids/estratos -> texto consistente
  expect_type(rb$estrato, "character")
  expect_true(is.numeric(ra$factor))     # analíticas -> numérico
  expect_true(is.numeric(ra$pobre))
  # se pueden apilar sin error de tipos
  expect_silent(dplyr::bind_rows(ra, rb))
})

test_that(".armonizar_valores() colapsa los códigos de 'Otros' de nivel_edu", {
  df <- data.frame(nivel_edu = c(0L, 1L, 2L, 3L, 4L, 5L, 9L, NA))
  r <- .armonizar_valores(df)
  expect_equal(r$nivel_edu, c(0L, 1L, 2L, 3L, 4L, 4L, 4L, NA))  # 5 y 9 -> 4
})

test_that("armonizar_eh recodifica nivel_edu a un esquema estable", {
  # niv_ed_g 2014 usa 5 para 'Otros'
  df <- data.frame(folio = "F1", nro = 1L, depto = 1L, area = 1L, upm = 1L,
                   estrato = 1L, factor_2014 = 1, niv_ed_g = 5L)
  res <- armonizar_eh(df, 2014)
  expect_equal(res$nivel_edu, 4L)
})

test_that("grupos_variables() devuelve grupos temáticos válidos", {
  g <- grupos_variables()
  expect_true(all(c("demografico", "empleo", "pobreza", "ingresos") %in% names(g)))
  expect_true(all(g$pobreza %in% variable_canonica_map$variable))
})
