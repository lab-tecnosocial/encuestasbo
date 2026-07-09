test_that("get_eh_armonizada() lee el Parquet materializado (tibble)", {
  local_fixture_armonizada()
  t <- get_eh_armonizada(verbose = FALSE)
  expect_s3_class(t, "data.frame")
  expect_true(all(c("anio", "folio", "upm", "estrato", "factor", "pobre") %in% names(t)))
  expect_setequal(unique(t$anio), c(2022L, 2023L))
})

test_that("get_eh_armonizada() filtra por año, grupo y departamento", {
  local_fixture_armonizada()
  t <- get_eh_armonizada(anios = 2023, grupo = "pobreza", verbose = FALSE)
  expect_equal(unique(t$anio), 2023L)
  expect_true("pobre" %in% names(t))

  sc <- get_eh_armonizada(departamento = "Santa Cruz", as = "tibble", verbose = FALSE)
  expect_true(all(sc$depto == "7"))
})

test_that("get_eh_armonizada(as = 'arrow') es perezoso", {
  local_fixture_armonizada()
  a <- get_eh_armonizada(as = "arrow", verbose = FALSE)
  expect_s3_class(a, "Dataset")
})

test_that("get_eh_armonizada(as = 'duckdb') registra la tabla eh_armonizada", {
  local_fixture_armonizada()
  con <- get_eh_armonizada(as = "duckdb", verbose = FALSE)
  on.exit(DBI::dbDisconnect(con, shutdown = TRUE), add = TRUE)
  r <- DBI::dbGetQuery(con, "SELECT anio, COUNT(*) n FROM eh_armonizada GROUP BY anio ORDER BY anio")
  expect_equal(nrow(r), 2)
})

test_that("get_eh_armonizada() aborta con grupo desconocido", {
  expect_error(get_eh_armonizada(grupo = "inexistente", verbose = FALSE), "desconocido")
})

test_that("get_eh_armonizada() avisa de variables= inexistentes pero no de grupo=", {
  local_fixture_armonizada()
  # variables explícitas ausentes -> aviso
  expect_warning(
    get_eh_armonizada(variables = c("pobre", "no_existe"), verbose = FALSE),
    "no encontradas"
  )
  # grupo con miembros ausentes en el Parquet -> SIN aviso (ausencia parcial normal)
  expect_no_warning(get_eh_armonizada(grupo = "pobreza", verbose = FALSE))
})
