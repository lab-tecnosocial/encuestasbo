# build_ipc.R
# -----------------------------------------------------------------------------
# Serie del Índice de Precios al Consumidor (IPC) de Bolivia, promedio anual,
# para deflactar ingresos nominales de la EH/ECE a precios de un año base.
#
# Fuente: Banco Mundial, indicador FP.CPI.TOTL (CPI, base 2010 = 100), que
# reexpone la serie oficial del INE de Bolivia. Media ANUAL (no fin de periodo),
# que es la referencia correcta para deflactar ingresos de encuestas levantadas
# a lo largo del año.
#
#   https://api.worldbank.org/v2/country/BO/indicator/FP.CPI.TOTL?format=json
#
# Uso:  Rscript data-raw/build_ipc.R   (regenera data/ipc_bolivia.rda)
# -----------------------------------------------------------------------------

# Descargado el 2026-07 (valores 2011-2024; 2024 puede revisarse al alza en
# actualizaciones posteriores del Banco Mundial/INE).
ipc_bolivia <- data.frame(
  anio = 2011:2024,
  ipc  = c(
    109.884464198239, 114.846410265601, 121.434460016488, 128.437100493447,
    133.651146397123, 138.493613869075, 142.402953510878, 145.638433874571,
    148.317518475358, 149.712803892505, 150.816761737338, 153.450518176398,
    157.40476617273,  165.432040421688
  ),
  stringsAsFactors = FALSE
)
attr(ipc_bolivia, "base") <- "2010=100 (Banco Mundial, FP.CPI.TOTL; fuente primaria INE)"

usethis::use_data(ipc_bolivia, overwrite = TRUE, compress = "xz")
message(sprintf("ipc_bolivia: %d años (%d-%d)",
                nrow(ipc_bolivia), min(ipc_bolivia$anio), max(ipc_bolivia$anio)))
