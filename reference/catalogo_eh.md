# Consulta el catálogo de la Encuesta de Hogares (EH)

Consulta el catálogo de la Encuesta de Hogares (EH)

## Usage

``` r
catalogo_eh(anio = NULL, tabla = NULL)
```

## Arguments

- anio:

  Entero opcional. Filtra por año.

- tabla:

  Caracteres opcional. Filtra por nivel (e.g., \`"persona"\`).

## Value

Un data.frame con las filas del catálogo correspondientes a la EH.

## Examples

``` r
catalogo_eh()
#>    encuesta anio trimestre    tabla release_tag          archivo_parquet
#> 1        eh 2012        NA  persona  data-eh-v1  eh_2012_persona.parquet
#> 2        eh 2012        NA vivienda  data-eh-v1 eh_2012_vivienda.parquet
#> 3        eh 2013        NA  persona  data-eh-v1  eh_2013_persona.parquet
#> 4        eh 2013        NA vivienda  data-eh-v1 eh_2013_vivienda.parquet
#> 5        eh 2014        NA  persona  data-eh-v1  eh_2014_persona.parquet
#> 6        eh 2014        NA vivienda  data-eh-v1 eh_2014_vivienda.parquet
#> 7        eh 2015        NA  persona  data-eh-v1  eh_2015_persona.parquet
#> 8        eh 2015        NA vivienda  data-eh-v1 eh_2015_vivienda.parquet
#> 9        eh 2016        NA  persona  data-eh-v1  eh_2016_persona.parquet
#> 10       eh 2016        NA vivienda  data-eh-v1 eh_2016_vivienda.parquet
#> 11       eh 2017        NA  persona  data-eh-v1  eh_2017_persona.parquet
#> 12       eh 2017        NA vivienda  data-eh-v1 eh_2017_vivienda.parquet
#> 13       eh 2018        NA  persona  data-eh-v1  eh_2018_persona.parquet
#> 14       eh 2018        NA vivienda  data-eh-v1 eh_2018_vivienda.parquet
#> 15       eh 2019        NA  persona  data-eh-v1  eh_2019_persona.parquet
#> 16       eh 2019        NA vivienda  data-eh-v1 eh_2019_vivienda.parquet
#> 17       eh 2020        NA  persona  data-eh-v1  eh_2020_persona.parquet
#> 18       eh 2020        NA vivienda  data-eh-v1 eh_2020_vivienda.parquet
#> 19       eh 2021        NA  persona  data-eh-v1  eh_2021_persona.parquet
#> 20       eh 2021        NA vivienda  data-eh-v1 eh_2021_vivienda.parquet
#> 21       eh 2022        NA  persona  data-eh-v1  eh_2022_persona.parquet
#> 22       eh 2022        NA vivienda  data-eh-v1 eh_2022_vivienda.parquet
#> 23       eh 2023        NA  persona  data-eh-v1  eh_2023_persona.parquet
#> 24       eh 2023        NA vivienda  data-eh-v1 eh_2023_vivienda.parquet
#> 25       eh 2024        NA  persona  data-eh-v1  eh_2024_persona.parquet
#> 26       eh 2024        NA vivienda  data-eh-v1 eh_2024_vivienda.parquet
#>    factor_var factor_var_alt upm_var estrato_var cobertura catalog_id
#> 1      factor           <NA>     upm     estrato  nacional       <NA>
#> 2      factor           <NA>     upm     estrato  nacional       <NA>
#> 3      factor           <NA>     upm     estrato  nacional       <NA>
#> 4      factor           <NA>     upm     estrato  nacional       <NA>
#> 5      factor           <NA>     upm     estrato  nacional       <NA>
#> 6      factor           <NA>     upm     estrato  nacional       <NA>
#> 7      factor           <NA>     upm     estrato  nacional       <NA>
#> 8      factor           <NA>     upm     estrato  nacional       <NA>
#> 9      factor           <NA>     upm     estrato  nacional       <NA>
#> 10     factor           <NA>     upm     estrato  nacional       <NA>
#> 11     factor           <NA>     upm     estrato  nacional       <NA>
#> 12     factor           <NA>     upm     estrato  nacional       <NA>
#> 13     factor           <NA>     upm     estrato  nacional       <NA>
#> 14     factor           <NA>     upm     estrato  nacional       <NA>
#> 15     factor           <NA>     upm     estrato  nacional       <NA>
#> 16     factor           <NA>     upm     estrato  nacional       <NA>
#> 17     factor           <NA>     upm     estrato  nacional       <NA>
#> 18     factor           <NA>     upm     estrato  nacional       <NA>
#> 19     factor           <NA>     upm     estrato  nacional       <NA>
#> 20     factor           <NA>     upm     estrato  nacional       <NA>
#> 21     factor           <NA>     upm     estrato  nacional       <NA>
#> 22     factor           <NA>     upm     estrato  nacional       <NA>
#> 23     factor           <NA>     upm     estrato  nacional       <NA>
#> 24     factor           <NA>     upm     estrato  nacional       <NA>
#> 25     factor           <NA>     upm     estrato  nacional       <NA>
#> 26     factor           <NA>     upm     estrato  nacional       <NA>
#>    archivo_sav version_caeb version_cob
#> 1         <NA>         <NA>        <NA>
#> 2         <NA>         <NA>        <NA>
#> 3         <NA>         <NA>        <NA>
#> 4         <NA>         <NA>        <NA>
#> 5         <NA>         <NA>        <NA>
#> 6         <NA>         <NA>        <NA>
#> 7         <NA>         <NA>        <NA>
#> 8         <NA>         <NA>        <NA>
#> 9         <NA>         <NA>        <NA>
#> 10        <NA>         <NA>        <NA>
#> 11        <NA>         <NA>        <NA>
#> 12        <NA>         <NA>        <NA>
#> 13        <NA>         <NA>        <NA>
#> 14        <NA>         <NA>        <NA>
#> 15        <NA>         <NA>        <NA>
#> 16        <NA>         <NA>        <NA>
#> 17        <NA>         <NA>        <NA>
#> 18        <NA>         <NA>        <NA>
#> 19        <NA>         <NA>        <NA>
#> 20        <NA>         <NA>        <NA>
#> 21        <NA>         <NA>        <NA>
#> 22        <NA>         <NA>        <NA>
#> 23        <NA>         <NA>        <NA>
#> 24        <NA>         <NA>        <NA>
#> 25        <NA>         <NA>        <NA>
#> 26        <NA>         <NA>        <NA>
catalogo_eh(anio = 2023)
#>   encuesta anio trimestre    tabla release_tag          archivo_parquet
#> 1       eh 2023        NA  persona  data-eh-v1  eh_2023_persona.parquet
#> 2       eh 2023        NA vivienda  data-eh-v1 eh_2023_vivienda.parquet
#>   factor_var factor_var_alt upm_var estrato_var cobertura catalog_id
#> 1     factor           <NA>     upm     estrato  nacional       <NA>
#> 2     factor           <NA>     upm     estrato  nacional       <NA>
#>   archivo_sav version_caeb version_cob
#> 1        <NA>         <NA>        <NA>
#> 2        <NA>         <NA>        <NA>
```
