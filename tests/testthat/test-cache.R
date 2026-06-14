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
