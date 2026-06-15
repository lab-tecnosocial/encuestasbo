# Limpia el caché local de datos

Elimina todos los archivos Parquet descargados localmente. Los datos se
pueden volver a descargar usando las funciones \`get\_\*()\`.

## Usage

``` r
encuestasbo_cache_clear(ask = TRUE)
```

## Arguments

- ask:

  Lógico. Si \`TRUE\` (defecto), pide confirmación antes de borrar.

## Value

Invisible \`NULL\`.

## Examples

``` r
if (FALSE) { # \dontrun{
encuestasbo_cache_clear()
} # }
```
