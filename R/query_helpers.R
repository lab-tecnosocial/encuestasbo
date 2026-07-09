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
# geografía y diseño muestral cuando existen. Los nombres de las columnas de
# diseño (factor de expansión, UPM, estrato) difieren entre encuestas (p. ej.
# la EH usa `factor` y la ECE `fact_trim_act`/`fact_mes_act`), así que se
# derivan del catálogo (`fila`) en lugar de codificarlos aquí.
.apply_variable_selection <- function(ds, variables, fila = NULL) {
  if (is.null(variables)) return(ds)
  id_geo <- c("folio", "nro_hogar", "nro_persona", "depto", "area")
  if (is.null(fila)) {
    diseno <- c("factor", "upm", "estrato")
  } else {
    diseno <- c(fila$factor_var, fila$factor_var_alt, fila$upm_var, fila$estrato_var)
    diseno <- diseno[!is.na(diseno)]
  }
  cols <- unique(c(id_geo, diseno, variables))
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
      # Materializamos a una tabla DuckDB nativa (las encuestas son pequeñas).
      # Registrar el Dataset Arrow como view lazy provoca errores de
      # "dynamic filter pushdown not supported" con ORDER BY/LIMIT.
      DBI::dbWriteTable(con, table_name, dplyr::collect(ds))
      con
    }
  )
}
