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

test_that(".resolve_catalogo() exige trimestre para la ECE", {
  expect_error(.resolve_catalogo("ece", 2023, "persona"), "trimestre")
})
