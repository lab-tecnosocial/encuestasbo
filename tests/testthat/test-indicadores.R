test_that("grupo_edad() clasifica en cohortes por defecto", {
  g <- grupo_edad(c(0, 17, 18, 24, 25, 64, 65, 90))
  expect_equal(as.character(g),
               c("NNA (0-17)", "NNA (0-17)",
                 "Jóvenes (18-24)", "Jóvenes (18-24)",
                 "Adultos (25-64)", "Adultos (25-64)",
                 "Adultos mayores (65+)", "Adultos mayores (65+)"))
})

test_that("grupo_edad() admite cortes y etiquetas propias", {
  g <- grupo_edad(c(10, 30, 70), cortes = c(0, 18, 60),
                  etiquetas = c("menor", "adulto", "mayor"))
  expect_equal(as.character(g), c("menor", "adulto", "mayor"))
})

test_that(".aplicar_por() agrupa un diseño por la(s) variable(s) dada(s)", {
  skip_if_not_installed("srvyr")
  df <- data.frame(upm = 1:20, estrato = rep(1:4, 5), factor = 1,
                   sexo = rep(1:2, 10), pobre = rbinom(20, 1, .4))
  dsn <- .declarar_diseno(df)
  g <- .aplicar_por(dsn, "sexo")
  expect_s3_class(g, "tbl_svy")
  res <- srvyr::summarise(g, t = srvyr::survey_mean(pobre))
  expect_equal(nrow(res), 2)
  expect_identical(.aplicar_por(dsn, NULL), dsn)  # NULL no agrupa
})
