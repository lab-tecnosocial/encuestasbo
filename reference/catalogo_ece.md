# Consulta el catálogo de la Encuesta Continua de Empleo (ECE)

Consulta el catálogo de la Encuesta Continua de Empleo (ECE)

## Usage

``` r
catalogo_ece(anio = NULL, trimestre = NULL, tabla = NULL)
```

## Arguments

- anio:

  Entero opcional. Filtra por año.

- trimestre:

  Entero opcional (1-4). Filtra por trimestre.

- tabla:

  Caracteres opcional. Filtra por nivel.

## Value

Un data.frame con las filas del catálogo correspondientes a la ECE.

## Examples

``` r
catalogo_ece()
#>    encuesta anio trimestre   tabla release_tag            archivo_parquet
#> 1       ece 2015         4 persona data-ece-v1 ece_2015t4_persona.parquet
#> 2       ece 2016         1 persona data-ece-v1 ece_2016t1_persona.parquet
#> 3       ece 2016         2 persona data-ece-v1 ece_2016t2_persona.parquet
#> 4       ece 2016         3 persona data-ece-v1 ece_2016t3_persona.parquet
#> 5       ece 2016         4 persona data-ece-v1 ece_2016t4_persona.parquet
#> 6       ece 2017         1 persona data-ece-v1 ece_2017t1_persona.parquet
#> 7       ece 2017         2 persona data-ece-v1 ece_2017t2_persona.parquet
#> 8       ece 2017         3 persona data-ece-v1 ece_2017t3_persona.parquet
#> 9       ece 2017         4 persona data-ece-v1 ece_2017t4_persona.parquet
#> 10      ece 2018         1 persona data-ece-v1 ece_2018t1_persona.parquet
#> 11      ece 2018         2 persona data-ece-v1 ece_2018t2_persona.parquet
#> 12      ece 2018         3 persona data-ece-v1 ece_2018t3_persona.parquet
#> 13      ece 2018         4 persona data-ece-v1 ece_2018t4_persona.parquet
#> 14      ece 2019         1 persona data-ece-v1 ece_2019t1_persona.parquet
#> 15      ece 2019         2 persona data-ece-v1 ece_2019t2_persona.parquet
#> 16      ece 2019         3 persona data-ece-v1 ece_2019t3_persona.parquet
#> 17      ece 2019         4 persona data-ece-v1 ece_2019t4_persona.parquet
#> 18      ece 2020         1 persona data-ece-v1 ece_2020t1_persona.parquet
#> 19      ece 2020         2 persona data-ece-v1 ece_2020t2_persona.parquet
#> 20      ece 2020         3 persona data-ece-v1 ece_2020t3_persona.parquet
#> 21      ece 2020         4 persona data-ece-v1 ece_2020t4_persona.parquet
#> 22      ece 2021         1 persona data-ece-v1 ece_2021t1_persona.parquet
#> 23      ece 2021         2 persona data-ece-v1 ece_2021t2_persona.parquet
#> 24      ece 2021         3 persona data-ece-v1 ece_2021t3_persona.parquet
#> 25      ece 2021         4 persona data-ece-v1 ece_2021t4_persona.parquet
#> 26      ece 2022         1 persona data-ece-v1 ece_2022t1_persona.parquet
#> 27      ece 2022         2 persona data-ece-v1 ece_2022t2_persona.parquet
#> 28      ece 2022         3 persona data-ece-v1 ece_2022t3_persona.parquet
#> 29      ece 2022         4 persona data-ece-v1 ece_2022t4_persona.parquet
#> 30      ece 2023         1 persona data-ece-v1 ece_2023t1_persona.parquet
#> 31      ece 2023         2 persona data-ece-v1 ece_2023t2_persona.parquet
#> 32      ece 2023         3 persona data-ece-v1 ece_2023t3_persona.parquet
#> 33      ece 2023         4 persona data-ece-v1 ece_2023t4_persona.parquet
#> 34      ece 2024         1 persona data-ece-v1 ece_2024t1_persona.parquet
#> 35      ece 2024         2 persona data-ece-v1 ece_2024t2_persona.parquet
#> 36      ece 2024         3 persona data-ece-v1 ece_2024t3_persona.parquet
#> 37      ece 2024         4 persona data-ece-v1 ece_2024t4_persona.parquet
#> 38      ece 2025         1 persona data-ece-v1 ece_2025t1_persona.parquet
#> 39      ece 2025         2 persona data-ece-v1 ece_2025t2_persona.parquet
#> 40      ece 2025         3 persona data-ece-v1 ece_2025t3_persona.parquet
#>       factor_var factor_var_alt upm_var estrato_var cobertura catalog_id
#> 1  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 2  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 3  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 4  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 5  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 6  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 7  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 8  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 9  fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 10 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 11 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 12 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 13 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 14 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 15 fact_trim_act   fact_mes_act     upm     estrato  nacional         82
#> 16 fact_trim_act   fact_mes_act     upm     estrato  nacional       <NA>
#> 17 fact_trim_act   fact_mes_act     upm     estrato  nacional       <NA>
#> 18 fact_trim_act   fact_mes_act     upm     estrato  nacional       <NA>
#> 19 fact_trim_act   fact_mes_act     upm     estrato    urbana       <NA>
#> 20 fact_trim_act   fact_mes_act     upm     estrato    urbana       <NA>
#> 21 fact_trim_act   fact_mes_act     upm     estrato    urbana       <NA>
#> 22 fact_trim_act   fact_mes_act     upm     estrato  nacional       <NA>
#> 23 fact_trim_act   fact_mes_act     upm     estrato  nacional         91
#> 24 fact_trim_act   fact_mes_act     upm     estrato  nacional         94
#> 25 fact_trim_act   fact_mes_act     upm     estrato  nacional         95
#> 26 fact_trim_act   fact_mes_act     upm     estrato  nacional         96
#> 27 fact_trim_act   fact_mes_act     upm     estrato  nacional         97
#> 28 fact_trim_act   fact_mes_act     upm     estrato  nacional        100
#> 29 fact_trim_act   fact_mes_act     upm     estrato  nacional        101
#> 30 fact_trim_act   fact_mes_act     upm     estrato  nacional        103
#> 31 fact_trim_act   fact_mes_act     upm     estrato  nacional        104
#> 32 fact_trim_act   fact_mes_act     upm     estrato  nacional        105
#> 33 fact_trim_act   fact_mes_act     upm     estrato  nacional        107
#> 34 fact_trim_act   fact_mes_act     upm     estrato  nacional        109
#> 35 fact_trim_act   fact_mes_act     upm     estrato  nacional        110
#> 36 fact_trim_act   fact_mes_act     upm     estrato  nacional        231
#> 37 fact_trim_act   fact_mes_act     upm     estrato  nacional        232
#> 38 fact_trim_act   fact_mes_act     upm     estrato  nacional        131
#> 39 fact_trim_act   fact_mes_act     upm     estrato  nacional        170
#> 40 fact_trim_act   fact_mes_act     upm     estrato  nacional        254
catalogo_ece(anio = 2022, trimestre = 3)
#>   encuesta anio trimestre   tabla release_tag            archivo_parquet
#> 1      ece 2022         3 persona data-ece-v1 ece_2022t3_persona.parquet
#>      factor_var factor_var_alt upm_var estrato_var cobertura catalog_id
#> 1 fact_trim_act   fact_mes_act     upm     estrato  nacional        100
```
