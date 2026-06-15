# Descarga un Parquet de una encuesta desde su GitHub Release

Descarga un Parquet de una encuesta desde su GitHub Release

## Usage

``` r
.download_encuesta(fila, overwrite = FALSE, verbose = TRUE)
```

## Arguments

- fila:

  Una fila del \[catalogo_encuestas\] (data.frame de 1 fila) con
  \`release_tag\` y \`archivo_parquet\`.

- overwrite:

  Lógico. Si \`TRUE\`, re-descarga aunque exista en caché.

- verbose:

  Lógico. Mostrar progreso.

## Value

Ruta local al archivo (invisible).
