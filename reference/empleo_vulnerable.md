# Tasa de empleo vulnerable (ECE)

Proporción de la población \*\*ocupada\*\* en empleo vulnerable según la
OIT: trabajadores por cuenta propia y trabajadores familiares no
remunerados (\`categoria_ocupacional\` 2 y 5). Comparable entre
versiones de la ECE gracias a la armonización de la categoría
ocupacional (\[armonizar_ece()\]).

## Usage

``` r
empleo_vulnerable(
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

Un tibble con \`tasa\` (sobre ocupados) y su varianza.

## See also

\[armonizar_ece()\], \[tasa_desempleo()\].

## Examples

``` r
if (FALSE) { # \dontrun{
empleo_vulnerable(2023, trimestre = 4)
empleo_vulnerable(2023, trimestre = 4, por = "sexo")
} # }
```
