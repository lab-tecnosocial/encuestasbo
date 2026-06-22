# Armoniza un data frame de la ECE a nombres/códigos canónicos

Añade columnas canónicas estables entre versiones de la ECE (el
cuestionario cambió en 2019), \*\*sin\*\* eliminar las columnas
originales. Es la base para \[diseno_ece()\] y los indicadores laborales
(\[tasa_desempleo()\], \[tasa_subocupacion()\],
\[empleo_vulnerable()\]).

## Usage

``` r
armonizar_ece(df, anio, trimestre)
```

## Arguments

- df:

  Un data.frame de \[get_ece()\].

- anio, trimestre:

  Periodo de origen (no se usan directamente: la versión del
  cuestionario se detecta por las variables presentes).

## Value

El \`df\` con las columnas canónicas añadidas.

## Details

Columnas canónicas añadidas (si las de origen están presentes):

- \`sexo\`:

  1 = Hombre, 2 = Mujer (de \`s1_02\`).

- \`categoria_ocupacional\`:

  Situación en el empleo, 1-6 (ver Detalles), mapeada desde \`s2_20\`
  (hasta 2018) o \`s2_18\` (desde 2019).

- \`ocupado\`, \`desocupado\`, \`subocupado\`:

  Indicadores 0/1 (de \`peao\`, \`pead\`, \`psubocup\`). \`subocupado\`
  es \`NA\` antes de 2019 (no se midió).

Codificación canónica de \`categoria_ocupacional\`: 1 Obrero/Empleado, 2
Cuenta propia, 3 Empleador o socio, 4 Cooperativista de producción, 5
Familiar/aprendiz no remunerado, 6 Empleada/o del hogar. El "empleo
vulnerable" (OIT) son las categorías 2 y 5.

## See also

\[diseno_ece()\], \[empleo_vulnerable()\].

## Examples

``` r
if (FALSE) { # \dontrun{
get_ece(2023, trimestre = 4, as = "tibble") |>
  armonizar_ece(2023, 4) |>
  dplyr::count(categoria_ocupacional)
} # }
```
