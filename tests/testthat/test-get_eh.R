test_that("get_eh() devuelve un Arrow Dataset por defecto", {
  local_fixture_eh(2023, "persona")
  ds <- get_eh(2023, "persona", verbose = FALSE)
  expect_s3_class(ds, "Dataset")
  expect_true(all(c("folio", "depto", "area", "factor") %in% names(ds)))
})

test_that("get_eh(as = 'tibble') trae los datos a RAM", {
  df_src <- local_fixture_eh(2023, "persona")
  res <- get_eh(2023, "persona", as = "tibble", verbose = FALSE)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), nrow(df_src))
})

test_that("get_eh() filtra por departamento", {
  local_fixture_eh(2023, "persona")
  res <- get_eh(2023, "persona", departamento = "Santa Cruz",
                as = "tibble", verbose = FALSE)
  expect_true(all(res$depto == 7))
})

test_that("get_eh() filtra por área", {
  local_fixture_eh(2023, "persona")
  res <- get_eh(2023, "persona", area = "Rural", as = "tibble", verbose = FALSE)
  expect_true(all(res$area == 2))
})

test_that("get_eh() selecciona variables conservando diseño y geografía", {
  local_fixture_eh(2023, "persona")
  res <- get_eh(2023, "persona", variables = "edad", as = "tibble", verbose = FALSE)
  expect_true(all(c("edad", "folio", "depto", "area", "factor", "upm", "estrato")
                  %in% names(res)))
})

test_that("get_eh(as = 'duckdb') registra una conexión consultable", {
  local_fixture_eh(2023, "persona")
  con <- get_eh(2023, "persona", as = "duckdb", verbose = FALSE)
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  n <- DBI::dbGetQuery(con, "SELECT COUNT(*) AS n FROM persona")$n
  expect_equal(n, 200)
})
