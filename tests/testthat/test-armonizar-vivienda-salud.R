# Recodificación de valores de las variables EH de vivienda y salud.

test_that("tenencia_vivienda recodifica el régimen 2012-2015 (A) al canónico", {
  # Régimen A: 1=Alquilada, 2=Propia pagada, 3=Propia pagando, 6=Anticrético
  df <- data.frame(tenencia_vivienda = c(1, 2, 3, 6))
  out <- encuestasbo:::.armonizar_valores(df, 2012)
  # Canónico: 1=Propia pagada, 2=Propia pagando, 3=Alquilada, 4=Anticrético
  expect_equal(out$tenencia_vivienda, c(3, 1, 2, 4))
})

test_that("tenencia_vivienda recodifica el régimen 2016+ (B) al canónico", {
  # Régimen B: 1=Propia pagada, 3=Alquilada, 4=Mixto, 5=Anticrético, 8=Otra
  df <- data.frame(tenencia_vivienda = c(1, 3, 4, 5, 8))
  out <- encuestasbo:::.armonizar_valores(df, 2023)
  expect_equal(out$tenencia_vivienda, c(1, 3, 4, 4, 7))  # mixto y anticrético -> 4
})

test_that("tiene_seguro_salud se binariza usando el código 'Ninguno' del año", {
  # 2023: ninguno = 6  ->  1..5 = con seguro (1), 6 = sin seguro (0)
  df <- data.frame(tiene_seguro_salud = c(1, 2, 5, 6))
  out <- encuestasbo:::.armonizar_valores(df, 2023)
  expect_equal(out$tiene_seguro_salud, c(1L, 1L, 1L, 0L))
})

test_that("tiene_seguro_salud usa el código correcto en años con otra escala", {
  # 2024: ninguno = 5 ; 2012: ninguno = 7
  expect_equal(encuestasbo:::.armonizar_valores(data.frame(tiene_seguro_salud = c(4, 5)), 2024)$tiene_seguro_salud,
               c(1L, 0L))
  expect_equal(encuestasbo:::.armonizar_valores(data.frame(tiene_seguro_salud = c(6, 7)), 2012)$tiene_seguro_salud,
               c(1L, 0L))
})

test_that("el seguro de 2014 se detecta pese al errata de etiqueta del INE", {
  # La etiqueta de 2014 dice "los siguiente seguros" (sic). El patrón debe
  # tolerarlo: si no, ese año queda 100% NA. Ninguno = 6 en 2014.
  expect_equal(encuestasbo:::.ninguno_seguro_code(2014), 6L)
  out <- encuestasbo:::.armonizar_valores(data.frame(tiene_seguro_salud = c(1, 5, 6)), 2014)
  expect_equal(out$tiene_seguro_salud, c(1L, 1L, 0L))
})

test_that("el patrón del seguro cubre los 13 años de la EH", {
  anios <- as.integer(names(codebook_eh_meta))
  codigos <- vapply(anios, encuestasbo:::.ninguno_seguro_code, integer(1))
  expect_false(any(is.na(codigos)))
  # El código de "Ninguno" cambió a lo largo de la serie
  expect_equal(codigos[anios == 2012], 7L)
  expect_equal(codigos[anios == 2024], 5L)
  # El mapa canónico también debe cubrir los 13 años
  fila <- variable_canonica_map[variable_canonica_map$variable == "tiene_seguro_salud", ]
  expect_false(any(is.na(fila[paste0("v", anios)])))
})

test_that("tipo_vivienda NO se recodifica (códigos estables 1-6)", {
  df <- data.frame(tipo_vivienda = c(1, 2, 6))
  out <- encuestasbo:::.armonizar_valores(df, 2023)
  expect_equal(out$tipo_vivienda, c(1, 2, 6))
})

test_that("las nuevas variables tienen etiquetas de valor armonizadas", {
  labs <- encuestasbo:::.HARMONIZED_VALUE_LABELS
  expect_equal(unname(labs$tipo_vivienda["1"]), "Casa")
  expect_equal(unname(labs$tenencia_vivienda["3"]), "Alquilada")
  expect_equal(unname(labs$tiene_seguro_salud["0"]), "Sin seguro")
})

test_that("el mapa canónico incluye las nuevas variables con su tabla de origen", {
  m <- variable_canonica_map
  expect_true(all(c("tipo_vivienda", "tenencia_vivienda", "tiene_seguro_salud") %in% m$variable))
  expect_equal(m$tabla[m$variable == "tipo_vivienda"], "vivienda")
  expect_equal(m$tabla[m$variable == "tiene_seguro_salud"], "persona")
})
