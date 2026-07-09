test_that("deflactar() a la base devuelve el mismo valor", {
  # Un valor ya expresado en precios del año base no cambia.
  expect_equal(deflactar(100, anio = 2024, base = 2024), 100)
})

test_that("deflactar() aplica el cociente de IPC correcto", {
  ipc <- stats::setNames(ipc_bolivia$ipc, ipc_bolivia$anio)
  esperado <- 100 * ipc[["2024"]] / ipc[["2012"]]
  expect_equal(deflactar(100, anio = 2012, base = 2024), unname(esperado))
  # deflactar sube el valor (2012 < 2024, hubo inflación)
  expect_gt(deflactar(100, anio = 2012, base = 2024), 100)
})

test_that("deflactar() es vectorizado sobre valor y anio", {
  out <- deflactar(c(1000, 1000), anio = c(2015, 2023), base = 2023)
  expect_length(out, 2)
  expect_equal(out[2], 1000)                 # 2023 a base 2023
  expect_gt(out[1], 1000)                    # 2015 inflado a 2023
})

test_that("deflactar() avisa y devuelve NA para años sin IPC", {
  expect_warning(out <- deflactar(100, anio = 2025, base = 2024), "Sin IPC")
  expect_true(is.na(out))
})

test_that("deflactar() aborta si el año base no está en el índice", {
  expect_error(deflactar(100, anio = 2020, base = 1990), "año base")
})

test_that("deflactar() acepta un índice propio (vector con nombres)", {
  idx <- c("2020" = 100, "2021" = 110)
  expect_equal(deflactar(100, anio = 2020, base = 2021, indice = idx), 110)
})

test_that("deflactar() acepta un índice propio (data.frame)", {
  idx <- data.frame(anio = c(2020, 2021), ipc = c(100, 110))
  expect_equal(deflactar(220, anio = 2021, base = 2020, indice = idx), 200)
})

test_that("ipc_bolivia cubre los años de la EH y es creciente", {
  expect_true(all(2012:2024 %in% ipc_bolivia$anio))
  expect_true(all(diff(ipc_bolivia$ipc) > 0))   # inflación positiva en toda la serie
})
