# Índice de Precios al Consumidor (IPC) de Bolivia, promedio anual

Serie del IPC de Bolivia (media anual) para deflactar ingresos nominales
de la EH/ECE a precios constantes de un año base. Usa la media anual (no
fin de periodo), que es la referencia correcta para deflactar ingresos
de encuestas levantadas a lo largo del año.

## Usage

``` r
ipc_bolivia
```

## Format

Un data.frame con columnas:

- anio:

  Año (2011-2024)

- ipc:

  Índice de precios al consumidor, base 2010 = 100 (media anual)

El valor base del índice es irrelevante para deflactar (se usa como
cociente entre años); se conserva la base original de la fuente.

## Source

Banco Mundial, indicador \`FP.CPI.TOTL\` (CPI, 2010 = 100), que reexpone
la serie oficial del INE de Bolivia:
<https://datos.bancomundial.org/indicador/FP.CPI.TOTL?locations=BO>

## See also

\[deflactar()\]
