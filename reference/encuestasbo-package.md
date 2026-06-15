# encuestasbo: Acceso, armonización y análisis con diseño muestral de las encuestas de hogares y empleo del INE de Bolivia (2012-2024)

Proporciona acceso programático a los microdatos de las encuestas del
Instituto Nacional de Estadística (INE) de Bolivia: la Encuesta de
Hogares (EH, 2012-2024) y la Encuesta Continua de Empleo (ECE, 2015+).
Descarga archivos Parquet desde GitHub Releases, los almacena en caché
local y permite filtrar por departamento y área. Soporta flujos de
trabajo estilo dplyr vía Apache Arrow y consultas SQL vía DuckDB.
Incluye diccionarios de variables por encuesta y año, una capa de
armonización canónica entre años, indicadores derivados (empleo,
educación, pobreza, ingresos) y helpers de diseño muestral con
'srvyr'/'survey' para producir estimaciones e intervalos de confianza
estadísticamente correctos.

## See also

Useful links:

- <https://lab-tecnosocial.github.io/encuestasbo/>

- <https://github.com/lab-tecnosocial/encuestasbo>

- Report bugs at <https://github.com/lab-tecnosocial/encuestasbo/issues>

## Author

**Maintainer**: Alex Ojeda Copa <alex@labtecnosocial.org> (organization:
Lab TecnoSocial)

Authors:

- Alex Ojeda Copa <alex@labtecnosocial.org> (organization: Lab
  TecnoSocial)
