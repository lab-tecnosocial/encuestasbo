.onLoad <- function(libname, pkgname) {
  # Las encuestas del INE tienen estratos con una sola UPM (lonely PSU). Para que
  # las estimaciones de varianza de survey/srvyr no fallen, se usa el ajuste
  # estándar. Solo se fija si el usuario no eligió explícitamente otra opción
  # (la estimación lee survey.lonely.psu en el momento del cálculo, no al
  # construir el diseño, por eso debe estar activo a nivel de sesión).
  if (is.null(getOption("survey.lonely.psu"))) {
    options(survey.lonely.psu = "adjust")
  }
  invisible()
}
