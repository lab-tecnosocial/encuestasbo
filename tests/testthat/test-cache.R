test_that("encuestasbo_cache_dir() respeta la opción encuestasbo.cache_dir", {
  withr::with_options(list(encuestasbo.cache_dir = "/tmp/mi_cache"), {
    expect_equal(encuestasbo_cache_dir(), "/tmp/mi_cache")
  })
})

test_that("encuestasbo_cache_dir() usa R_user_dir por defecto", {
  withr::with_options(list(encuestasbo.cache_dir = NULL), {
    expect_match(encuestasbo_cache_dir(), "encuestasbo")
  })
})

test_that(".cache_path() respeta subdirectorios", {
  withr::with_options(list(encuestasbo.cache_dir = "/tmp/c"), {
    expect_equal(as.character(.cache_path("x.parquet", subdir = "eh")),
                 "/tmp/c/eh/x.parquet")
  })
})

test_that("un fallo de descarga da un mensaje accionable (no un error de cli)", {
  withr::local_options(list(encuestasbo.cache_dir = withr::local_tempdir()))
  fila <- data.frame(archivo_parquet = "no_existe.parquet", encuesta = "eh",
                     release_tag = "data-eh-vNOPE", stringsAsFactors = FALSE)
  err <- tryCatch(.download_encuesta(fila, verbose = FALSE),
                  error = function(e) conditionMessage(e))
  expect_match(err, "Error al descargar")
  expect_match(err, "data-eh-vNOPE")
  expect_match(err, "github.com/lab-tecnosocial/encuestasbo/releases", fixed = TRUE)
  expect_false(grepl("Invalid cli literal", err))
})
