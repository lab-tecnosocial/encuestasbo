# Deflacta valores monetarios a precios constantes de un año base

Convierte ingresos (u otros valores nominales) de distintos años a
precios reales de un \`base\` común, usando el IPC de Bolivia
(\[ipc_bolivia\]). Permite comparar ingresos entre años de la EH/ECE sin
el sesgo de la inflación.

## Usage

``` r
deflactar(valor, anio, base = 2024, indice = NULL)
```

## Arguments

- valor:

  Vector numérico de valores nominales (p. ej. ingresos).

- anio:

  Vector de años de cada valor (mismo largo que \`valor\`, o largo 1
  reciclado). Es el año en cuyos precios está expresado cada valor.

- base:

  Año base al que se llevan los precios. Por defecto \`2024\` (el año
  más reciente de la serie).

- indice:

  Serie de IPC a usar. Por defecto \[ipc_bolivia\]. Puede ser un
  data.frame con columnas \`anio\` e \`ipc\`, o un vector numérico con
  nombres de año (p. ej. \`c("2023" = 157.4, "2024" = 165.4)\`), para
  usar otra fuente o una serie propia (p. ej. IPC por ciudad).

## Value

Un vector numérico con los valores a precios del año \`base\`. Los años
sin IPC en la serie devuelven \`NA\` (con una advertencia).

## Details

La fórmula es \`valor_real = valor \* IPC\[base\] / IPC\[anio\]\`. El
valor absoluto de la base del índice no afecta el resultado (se cancela
en el cociente).

## See also

\[ipc_bolivia\], \[get_eh_armonizada()\].

## Examples

``` r
# 100 Bs de 2012 valían, a precios de 2024:
deflactar(100, anio = 2012)
#> [1] 144.0463

# Vectorizado: ingresos de distintos años a precios de 2023
deflactar(c(1000, 1200, 1500), anio = c(2015, 2019, 2023), base = 2023)
#> [1] 1177.729 1273.523 1500.000

if (FALSE) { # \dontrun{
# Ingreso del hogar real (precios 2024) en la serie armonizada de la EH
library(dplyr)
get_eh_armonizada(grupo = "ingresos") |>
  mutate(ingreso_hogar_real = deflactar(ingreso_hogar, anio, base = 2024))
} # }
```
