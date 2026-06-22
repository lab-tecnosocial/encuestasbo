test_that("armonizar_ece() añade sexo y categoría desde s2_18 (>= 2019)", {
  df <- data.frame(s1_02 = c(1, 2, 1), s2_18 = c(1, 2, 5),
                   peao = c(1, 1, 0), pead = c(0, 0, 1), psubocup = c(0, 1, 0))
  out <- armonizar_ece(df, 2023, 4)
  expect_equal(out$sexo, c(1L, 2L, 1L))
  # s2_18: 1->Obrero/Empleado(1), 2->Cuenta propia(2), 5->Familiar(5)
  expect_equal(out$categoria_ocupacional, c(1, 2, 5))
  expect_equal(out$ocupado, c(1L, 1L, 0L))
  expect_equal(out$desocupado, c(0L, 0L, 1L))
  expect_equal(out$subocupado, c(0L, 1L, 0L))
})

test_that("armonizar_ece() mapea s2_20 (<= 2018) a la MISMA escala canónica", {
  # s2_20: 3 = cuenta propia, 7 = familiar/aprendiz; deben caer en 2 y 5.
  df <- data.frame(s1_02 = c(1, 2, 1, 2),
                   s2_20 = c(1, 3, 7, 8),
                   peao  = c(1, 1, 1, 1))
  out <- armonizar_ece(df, 2018, 2)
  # 1->Obrero(1), 3->Cuenta propia(2), 7->Familiar(5), 8->Empleada hogar(6)
  expect_equal(out$categoria_ocupacional, c(1, 2, 5, 6))
})

test_that("empleo vulnerable (cat 2 y 5) es comparable entre s2_18 y s2_20", {
  # cuenta propia + familiar no remunerado en cada versión
  d18 <- armonizar_ece(data.frame(s2_18 = c(2, 5, 1, 7)), 2023, 4)
  d20 <- armonizar_ece(data.frame(s2_20 = c(3, 7, 1, 8)), 2017, 2)
  vuln18 <- d18$categoria_ocupacional %in% c(2, 5)
  vuln20 <- d20$categoria_ocupacional %in% c(2, 5)
  expect_equal(vuln18, c(TRUE, TRUE, FALSE, FALSE))
  expect_equal(vuln20, c(TRUE, TRUE, FALSE, FALSE))
})

test_that("armonizar_ece() deja subocupado = NA cuando no hay psubocup (bundle)", {
  df <- data.frame(s1_02 = 1, s2_20 = 3, peao = 1)
  out <- armonizar_ece(df, 2017, 2)
  expect_true(is.na(out$subocupado))
})

test_that("armonizar_ece() no elimina columnas originales", {
  df <- data.frame(s1_02 = 1, s2_18 = 2, peao = 1, pead = 0, otra = 99)
  out <- armonizar_ece(df, 2023, 4)
  expect_true(all(c("s1_02", "s2_18", "peao", "pead", "otra") %in% names(out)))
})
