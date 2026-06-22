# Tasa de pobreza (EH)

Incidencia de pobreza monetaria ponderada con el diseño muestral de la
EH.

## Usage

``` r
tasa_pobreza(
  anio,
  extrema = FALSE,
  por = NULL,
  vartype = "ci",
  verbose = FALSE
)
```

## Arguments

- anio:

  Entero. Año de la EH.

- extrema:

  Lógico. Si \`TRUE\`, pobreza extrema (\`pobre_extremo\`); si \`FALSE\`
  (defecto), pobreza moderada (\`pobre\`).

- por:

  Caracteres. Variable(s) de desagregación (p. ej. \`"depto"\`,
  \`"area"\`, \`c("depto","area")\`). \`NULL\` (defecto) = total
  nacional.

- vartype:

  Tipo de varianza para \`srvyr\` (\`"ci"\` por defecto).

- verbose:

  Lógico. Mostrar progreso de descarga.

## Value

Un tibble con la(s) variable(s) de \`por\`, \`tasa\` y su varianza.

## See also

\[diseno_eh()\], \[tasa_desempleo()\].

## Examples

``` r
if (FALSE) { # \dontrun{
tasa_pobreza(2023)                       # nacional
tasa_pobreza(2023, por = "area")         # por área
tasa_pobreza(2023, extrema = TRUE, por = "depto")
} # }
```
