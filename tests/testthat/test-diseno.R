make_df <- function(n = 400) {
  set.seed(1)
  data.frame(
    upm     = rep(1:50, length.out = n),
    estrato = rep(1:10, length.out = n),
    factor  = runif(n, 50, 300),
    pobre   = rbinom(n, 1, 0.35),
    ingreso_hogar = rlnorm(n, log(4000), 0.5),
    depto   = rep(1:9, length.out = n)
  )
}

test_that(".declarar_diseno() devuelve un tbl_svy de srvyr", {
  skip_if_not_installed("srvyr")
  des <- .declarar_diseno(make_df())
  expect_s3_class(des, "tbl_svy")
})

test_that("survey_mean() produce una estimación con error estándar", {
  skip_if_not_installed("srvyr")
  des <- .declarar_diseno(make_df())
  res <- srvyr::summarise(des, p = srvyr::survey_mean(pobre, vartype = "se"))
  expect_true(is.finite(res$p))
  expect_true(is.finite(res$p_se))
  expect_gt(res$p_se, 0)
})

test_that(".declarar_diseno() fuerza 'adjust' si la opción causaría error", {
  skip_if_not_installed("srvyr")
  withr::local_options(list(survey.lonely.psu = "fail"))
  invisible(.declarar_diseno(make_df()))
  expect_equal(getOption("survey.lonely.psu"), "adjust")
})

test_that(".declarar_diseno() respeta una opción válida del usuario", {
  skip_if_not_installed("srvyr")
  withr::local_options(list(survey.lonely.psu = "remove"))
  invisible(.declarar_diseno(make_df()))
  expect_equal(getOption("survey.lonely.psu"), "remove")
})

test_that(".declarar_diseno() aborta si faltan variables de diseño", {
  skip_if_not_installed("srvyr")
  df <- data.frame(x = 1:10, factor = 1)  # sin upm/estrato
  expect_error(.declarar_diseno(df), "diseño muestral")
})
