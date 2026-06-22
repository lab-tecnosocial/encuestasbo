# Agrupa la edad en cohortes

Utilidad para clasificar la edad en grupos etarios, útil para desagregar
indicadores (p. ej. pobreza por cohorte). Por defecto usa los grupos NNA
(0-17), jóvenes (18-24), adultos (25-64) y adultos mayores (65+).

## Usage

``` r
grupo_edad(
  edad,
  cortes = c(0, 18, 25, 65),
  etiquetas = c("NNA (0-17)", "Jóvenes (18-24)", "Adultos (25-64)",
    "Adultos mayores (65+)")
)
```

## Arguments

- edad:

  Vector numérico de edades.

- cortes:

  Vector de cortes (límites inferiores). Por defecto \`c(0, 18, 25,
  65)\`.

- etiquetas:

  Etiquetas de cada grupo (una más que… no: una por intervalo).

## Value

Un factor con la cohorte de cada edad.

## Examples

``` r
grupo_edad(c(5, 20, 40, 70))
#> [1] NNA (0-17)            Jóvenes (18-24)       Adultos (25-64)      
#> [4] Adultos mayores (65+)
#> Levels: NNA (0-17) Jóvenes (18-24) Adultos (25-64) Adultos mayores (65+)
```
