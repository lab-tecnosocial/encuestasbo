# Ficha técnica y metadata oficial de las encuestas del INE

Metadata estructurada (DDI) de cada estudio publicada por el INE en
ANDA: universo, cobertura, marco y diseño muestral, factor de expansión,
modo de recolección, tasa de respuesta y periodo de referencia.

## Usage

``` r
metadata_encuestas
```

## Format

Un data.frame con una fila por estudio y columnas:

- encuesta:

  \`"eh"\` / \`"ece"\`

- anio, trimestre:

  Periodo (\`NA\`/\`NA\` en la fila del consolidado ECE 4T2015–2T2019)

- catalog_id, idno:

  Identificadores del estudio en ANDA

- titulo:

  Título del estudio

- universo:

  Población objetivo

- unidad_analisis:

  Unidad de análisis

- cobertura_geografica:

  Cobertura/desagregación geográfica

- periodo_referencia:

  Periodo de referencia

- marco_diseno_muestral:

  Marco muestral, estratificación y etapas de selección

- factor_expansion:

  Descripción del factor de expansión

- modo_recoleccion:

  Modo de recolección (e.g., cara a cara)

- muestra_respuesta:

  Muestra lograda / tasa de respuesta

- fechas_recoleccion:

  Fechas (ciclos) de recolección

## Source

INE Bolivia, ANDA — exportación DDI/JSON de cada estudio.
