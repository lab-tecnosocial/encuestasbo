# Tasa de subocupación (ECE)

Población subocupada (por insuficiencia de horas) sobre la PEA. Solo se
mide \*\*desde 2019\*\*; para periodos anteriores devuelve \`NaN\` con
una advertencia (la ECE no trae \`psubocup\`, así que no hay nada que
estimar).

## Usage

``` r
tasa_subocupacion(
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

Un tibble con \`tasa\` y su varianza.

## See also

\[tasa_desempleo()\], \[empleo_vulnerable()\].

## Examples

``` r
if (FALSE) { # \dontrun{
tasa_subocupacion(2023, trimestre = 4, por = "sexo")
} # }
```
