# Diccionarios de variables de la Encuesta de Hogares

Lista nombrada por año con los metadatos de variables de la EH,
extraídos de las etiquetas de los archivos SPSS del INE.

## Usage

``` r
codebook_eh_meta
```

## Format

Una lista con un elemento por año, \`"2012"\` … \`"2024"\`, cada uno un
data.frame con columnas:

- variable:

  Nombre de la variable (minúsculas, igual que en los datos)

- etiqueta:

  Descripción de la variable

- tabla:

  Tabla de origen: \`"persona"\`, \`"vivienda"\` o una base temática del
  año (\`"equipamiento"\`, \`"gastos_alimentarios"\`, …)

- tipo:

  \`"categorica"\`, \`"numerica"\` o \`"texto"\`

- valores_codigos:

  Lista de data.frames \`codigo\`/\`etiqueta\` para variables
  categóricas; \`NULL\` en otras

## Source

INE Bolivia, Encuesta de Hogares 2012-2024.
