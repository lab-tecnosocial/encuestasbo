# Aplica filtros de departamento y área a un Arrow Dataset usando dplyr.
# Las columnas canónicas `depto` (entero 1-9) y `area` (1=Urbana, 2=Rural)
# están garantizadas en los Parquet del paquete.
.apply_filtros <- function(ds, departamento, area) {
  dep_codes <- .resolve_dep_codes(departamento)
  if (!is.null(dep_codes)) {
    ds <- dplyr::filter(ds, .data$depto %in% dep_codes)
  }
  area_codes <- .resolve_area_codes(area)
  if (!is.null(area_codes)) {
    ds <- dplyr::filter(ds, .data$area %in% area_codes)
  }
  ds
}

# Selecciona variables preservando siempre las columnas de identificación,
# geografía y diseño muestral cuando existen.
.apply_variable_selection <- function(ds, variables) {
  if (is.null(variables)) return(ds)
  siempre <- c("folio", "nro_hogar", "nro_persona", "depto", "area",
               "factor", "factor_trimestral", "factor_mensual", "upm", "estrato")
  cols <- unique(c(siempre, variables))
  available <- names(ds)
  missing_user <- setdiff(variables, available)
  if (length(missing_user) > 0) {
    cli::cli_warn(c(
      "Columnas no encontradas: {.val {missing_user}}",
      "i" = "Usa {.code codebook()} para ver las variables disponibles."
    ))
  }
  dplyr::select(ds, dplyr::all_of(intersect(cols, available)))
}

# Retorna el dataset en el formato solicitado.
.return_as <- function(ds, as, table_name = "datos", verbose = TRUE) {
  switch(as,
    "arrow" = ds,
    "tibble" = {
      if (verbose) cli::cli_inform("Cargando datos a memoria RAM...")
      dplyr::collect(ds)
    },
    "duckdb" = {
      con <- DBI::dbConnect(duckdb::duckdb(), dbdir = ":memory:")
      duckdb::duckdb_register_arrow(con, table_name, ds)
      con
    }
  )
}
