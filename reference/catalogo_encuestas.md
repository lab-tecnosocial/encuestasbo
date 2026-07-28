# Catálogo de encuestas del INE disponibles

Tabla maestra que enumera cada base de microdatos disponible en el
paquete y mapea cada \`(encuesta, anio, trimestre, tabla)\` a su Release
de GitHub y a los nombres canónicos de sus variables de diseño muestral.

## Usage

``` r
catalogo_encuestas
```

## Format

Un data.frame con una fila por base, con columnas:

- encuesta:

  \`"eh"\` (Encuesta de Hogares) o \`"ece"\` (Encuesta Continua de
  Empleo)

- anio:

  Año de referencia

- trimestre:

  Trimestre (1-4) para la ECE; \`NA\` para la EH

- tabla:

  Nivel de análisis: \`"vivienda"\`, \`"persona"\`, etc.

- release_tag:

  Etiqueta del GitHub Release que contiene el Parquet

- archivo_parquet:

  Nombre del archivo Parquet dentro del Release

- factor_var:

  Nombre canónico del factor de expansión principal

- factor_var_alt:

  Factor alternativo (ECE: factor mensual); \`NA\` para EH

- upm_var:

  Nombre canónico de la unidad primaria de muestreo

- estrato_var:

  Nombre canónico del estrato

- cobertura:

  \`"nacional"\` o \`"urbana"\` (ECE 2020 T2-T4, por la pandemia).
  \[get_ece()\] avisa al usar los periodos de cobertura urbana

- catalog_id:

  Identificador del estudio en el portal ANDA (procedencia). Los
  trimestres 4T2015-2T2019 de la ECE comparten el id del estudio
  consolidado. Es \`NA\` en 3T2019-1T2021, que no tienen estudio en
  ANDA: provienen del repositorio abierto del INE (\`nube.ine.gob.bo\`)

## Source

INE Bolivia, portal ANDA:
<https://anda.ine.gob.bo/index.php/catalog/ENCUESTAS>
