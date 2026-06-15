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
#> 17      ece 2020         1 persona data-ece-v1 ece_2020t1_persona.parquet
#> 18      ece 2021         3 persona data-ece-v1 ece_2021t3_persona.parquet
#> 19      ece 2021         4 persona data-ece-v1 ece_2021t4_persona.parquet
#> 20      ece 2022         1 persona data-ece-v1 ece_2022t1_persona.parquet
#> 21      ece 2022         2 persona data-ece-v1 ece_2022t2_persona.parquet
#> 22      ece 2022         3 persona data-ece-v1 ece_2022t3_persona.parquet
#> 23      ece 2022         4 persona data-ece-v1 ece_2022t4_persona.parquet
#> 24      ece 2023         1 persona data-ece-v1 ece_2023t1_persona.parquet
#> 25      ece 2023         2 persona data-ece-v1 ece_2023t2_persona.parquet
#> 26      ece 2023         3 persona data-ece-v1 ece_2023t3_persona.parquet
#> 27      ece 2023         4 persona data-ece-v1 ece_2023t4_persona.parquet
#> 28      ece 2024         2 persona data-ece-v1 ece_2024t2_persona.parquet
#> 29      ece 2024         3 persona data-ece-v1 ece_2024t3_persona.parquet
#> 30      ece 2024         4 persona data-ece-v1 ece_2024t4_persona.parquet
#> 31      ece 2025         1 persona data-ece-v1 ece_2025t1_persona.parquet
#> 32      ece 2025         2 persona data-ece-v1 ece_2025t2_persona.parquet
#> 33      ece 2025         3 persona data-ece-v1 ece_2025t3_persona.parquet
#>       factor_var factor_var_alt upm_var estrato_var catalog_id archivo_sav
#> 1  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 2  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 3  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 4  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 5  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 6  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 7  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 8  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 9  fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 10 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 11 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 12 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 13 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 14 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 15 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 16 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 17 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 18 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 19 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 20 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 21 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 22 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 23 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 24 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 25 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 26 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 27 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 28 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 29 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 30 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 31 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 32 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#> 33 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#>    version_caeb version_cob
#> 1          <NA>        <NA>
#> 2          <NA>        <NA>
#> 3          <NA>        <NA>
#> 4          <NA>        <NA>
#> 5          <NA>        <NA>
#> 6          <NA>        <NA>
#> 7          <NA>        <NA>
#> 8          <NA>        <NA>
#> 9          <NA>        <NA>
#> 10         <NA>        <NA>
#> 11         <NA>        <NA>
#> 12         <NA>        <NA>
#> 13         <NA>        <NA>
#> 14         <NA>        <NA>
#> 15         <NA>        <NA>
#> 16         <NA>        <NA>
#> 17         <NA>        <NA>
#> 18         <NA>        <NA>
#> 19         <NA>        <NA>
#> 20         <NA>        <NA>
#> 21         <NA>        <NA>
#> 22         <NA>        <NA>
#> 23         <NA>        <NA>
#> 24         <NA>        <NA>
#> 25         <NA>        <NA>
#> 26         <NA>        <NA>
#> 27         <NA>        <NA>
#> 28         <NA>        <NA>
#> 29         <NA>        <NA>
#> 30         <NA>        <NA>
#> 31         <NA>        <NA>
#> 32         <NA>        <NA>
#> 33         <NA>        <NA>
catalogo_ece(anio = 2022, trimestre = 3)
#>   encuesta anio trimestre   tabla release_tag            archivo_parquet
#> 1      ece 2022         3 persona data-ece-v1 ece_2022t3_persona.parquet
#>      factor_var factor_var_alt upm_var estrato_var catalog_id archivo_sav
#> 1 fact_trim_act   fact_mes_act     upm     estrato       <NA>        <NA>
#>   version_caeb version_cob
#> 1         <NA>        <NA>
```
