# Tasa de desempleo (ECE)

Desocupados sobre la población económicamente activa (PEA), ponderada
con el diseño de la ECE.

## Usage

``` r
tasa_desempleo(
  anio,
  trimestre,
  por = NULL,
  factor = c("trimestral", "mensual"),
  vartype = "ci",
  verbose = FALSE
)
```

## Arguments

- anio, trimestre:

  Periodo de la ECE.

- por:

  Caracteres. Variable(s) de desagregación (p. ej. \`"sexo"\`,
  \`"depto"\`). \`NULL\` = total.

- factor:

  \`"trimestral"\` (defecto) o \`"mensual"\`.

- vartype:

  Tipo de varianza (\`"ci"\` por defecto).

- verbose:

  Lógico.

## Value

Un tibble con \`tasa\` (proporción) y su varianza.

## See also

\[diseno_ece()\], \[tasa_subocupacion()\], \[empleo_vulnerable()\].

## Examples

``` r
if (FALSE) { # \dontrun{
tasa_desempleo(2023, trimestre = 4)
tasa_desempleo(2023, trimestre = 4, por = "sexo")
} # }
```
