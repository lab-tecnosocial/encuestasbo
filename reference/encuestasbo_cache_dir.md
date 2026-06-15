# Directorio de caché local del paquete

Devuelve la ruta donde se guardan los archivos Parquet descargados. Por
defecto usa el directorio estándar del sistema operativo, pero puede
redirigirse a cualquier ruta local (por ejemplo, dentro del proyecto
actual) estableciendo la opción \`encuestasbo.cache_dir\` antes de
llamar a \`get\_\*()\`.

## Usage

``` r
encuestasbo_cache_dir()
```

## Value

Ruta al directorio de caché (cadena de caracteres).

## Details

Para guardar el caché dentro de tu proyecto en lugar del directorio del
sistema, añade esto al inicio de tu script o en tu \`.Rprofile\`:

“\`r options(encuestasbo.cache_dir = "data/encuestasbo") “\`

El directorio se crea automáticamente si no existe.

## Examples

``` r
encuestasbo_cache_dir()
#> [1] "/home/runner/.cache/R/encuestasbo"

# Cambiar a un directorio local (solo para la sesión actual)
if (FALSE) { # \dontrun{
options(encuestasbo.cache_dir = "data/encuestasbo")
encuestasbo_cache_dir()
} # }
```
