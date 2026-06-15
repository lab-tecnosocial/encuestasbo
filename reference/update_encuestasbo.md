# Actualiza el paquete encuestasbo y limpia el caché

Reinstala la última versión de \`encuestasbo\` desde GitHub y elimina el
caché local de datos Parquet, para que los datos se vuelvan a descargar
en su versión más reciente.

## Usage

``` r
update_encuestasbo(clear_cache = TRUE)
```

## Arguments

- clear_cache:

  Lógico. Si \`TRUE\` (defecto), limpia el caché local automáticamente
  tras actualizar el paquete.

## Value

Invisible \`NULL\`.

## Examples

``` r
if (FALSE) { # \dontrun{
update_encuestasbo()
} # }
```
