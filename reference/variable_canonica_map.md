# Mapa de armonización de variables de la Encuesta de Hogares

Mapea variables de cada año de la EH a un esquema de nombres canónico
estable. Lo usa \[armonizar_eh()\] y \[get_eh_armonizada()\].

## Usage

``` r
variable_canonica_map
```

## Format

Un data.frame con columnas:

- variable:

  Nombre canónico (estable entre años)

- etiqueta:

  Descripción de la variable

- tabla:

  Tabla de origen (\`"persona"\`/\`"vivienda"\`)

- armonizada:

  \`TRUE\` si es comparable entre años; \`FALSE\` si es de paso

- v2012, ..., v2024:

  Nombre de la variable de origen en cada año (\`NA\` si no está
  disponible ese año)

## Source

INE Bolivia, Encuesta de Hogares 2012-2024.

## Details

Muchas variables derivadas del INE (ingresos \`yhog\`/\`yper\`, pobreza
\`p0\`/\`pext0\`, educación \`niv_ed_g\`, empleo \`pea\`/\`condact\`)
tienen el mismo nombre todos los años; otras del cuestionario (sexo,
edad, parentesco) cambian de nombre y se mapean por su etiqueta.

Las columnas \`vAAAA\` describen el \*\*origen\*\* en los microdatos de
ese año. Que estén \`NA\` no implica que la columna canónica falte:
\`ocupado\` y \`desocupado\` se \*\*derivan\*\* de
\`condicion_actividad\` en todos los años (ver \[armonizar_eh()\]), así
que existen también en 2022-2024, años en que el INE dejó de
publicarlas.
