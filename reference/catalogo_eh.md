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
#>    encuesta anio trimestre                  tabla release_tag
#> 1        eh 2012        NA           equipamiento  data-eh-v1
#> 2        eh 2012        NA    gastos_alimentarios  data-eh-v1
#> 3        eh 2012        NA gastos_no_alimentarios  data-eh-v1
#> 4        eh 2012        NA                persona  data-eh-v1
#> 5        eh 2012        NA               vivienda  data-eh-v1
#> 6        eh 2013        NA           equipamiento  data-eh-v1
#> 7        eh 2013        NA    gastos_alimentarios  data-eh-v1
#> 8        eh 2013        NA gastos_no_alimentarios  data-eh-v1
#> 9        eh 2013        NA                persona  data-eh-v1
#> 10       eh 2013        NA               vivienda  data-eh-v1
#> 11       eh 2014        NA           equipamiento  data-eh-v1
#> 12       eh 2014        NA    gastos_alimentarios  data-eh-v1
#> 13       eh 2014        NA gastos_no_alimentarios  data-eh-v1
#> 14       eh 2014        NA                persona  data-eh-v1
#> 15       eh 2014        NA               vivienda  data-eh-v1
#> 16       eh 2015        NA           equipamiento  data-eh-v1
#> 17       eh 2015        NA    gastos_alimentarios  data-eh-v1
#> 18       eh 2015        NA gastos_no_alimentarios  data-eh-v1
#> 19       eh 2015        NA                persona  data-eh-v1
#> 20       eh 2015        NA               vivienda  data-eh-v1
#> 21       eh 2016        NA           equipamiento  data-eh-v1
#> 22       eh 2016        NA                persona  data-eh-v1
#> 23       eh 2016        NA  seguridad_alimentaria  data-eh-v1
#> 24       eh 2016        NA                turismo  data-eh-v1
#> 25       eh 2016        NA               vivienda  data-eh-v1
#> 26       eh 2017        NA                cultura  data-eh-v1
#> 27       eh 2017        NA           equipamiento  data-eh-v1
#> 28       eh 2017        NA    gastos_alimentarios  data-eh-v1
#> 29       eh 2017        NA gastos_no_alimentarios  data-eh-v1
#> 30       eh 2017        NA                persona  data-eh-v1
#> 31       eh 2017        NA  seguridad_alimentaria  data-eh-v1
#> 32       eh 2017        NA               vivienda  data-eh-v1
#> 33       eh 2018        NA         discriminacion  data-eh-v1
#> 34       eh 2018        NA           equipamiento  data-eh-v1
#> 35       eh 2018        NA    gastos_alimentarios  data-eh-v1
#> 36       eh 2018        NA gastos_no_alimentarios  data-eh-v1
#> 37       eh 2018        NA                persona  data-eh-v1
#> 38       eh 2018        NA  seguridad_alimentaria  data-eh-v1
#> 39       eh 2018        NA               vivienda  data-eh-v1
#> 40       eh 2019        NA         discriminacion  data-eh-v1
#> 41       eh 2019        NA           equipamiento  data-eh-v1
#> 42       eh 2019        NA    gastos_alimentarios  data-eh-v1
#> 43       eh 2019        NA gastos_no_alimentarios  data-eh-v1
#> 44       eh 2019        NA                persona  data-eh-v1
#> 45       eh 2019        NA  seguridad_alimentaria  data-eh-v1
#> 46       eh 2019        NA                turismo  data-eh-v1
#> 47       eh 2019        NA               vivienda  data-eh-v1
#> 48       eh 2020        NA                persona  data-eh-v1
#> 49       eh 2020        NA               vivienda  data-eh-v1
#> 50       eh 2021        NA            defunciones  data-eh-v1
#> 51       eh 2021        NA         discriminacion  data-eh-v1
#> 52       eh 2021        NA           equipamiento  data-eh-v1
#> 53       eh 2021        NA    gastos_alimentarios  data-eh-v1
#> 54       eh 2021        NA gastos_no_alimentarios  data-eh-v1
#> 55       eh 2021        NA                persona  data-eh-v1
#> 56       eh 2021        NA  seguridad_alimentaria  data-eh-v1
#> 57       eh 2021        NA               vivienda  data-eh-v1
#> 58       eh 2022        NA         discriminacion  data-eh-v1
#> 59       eh 2022        NA           equipamiento  data-eh-v1
#> 60       eh 2022        NA    gastos_alimentarios  data-eh-v1
#> 61       eh 2022        NA                persona  data-eh-v1
#> 62       eh 2022        NA  seguridad_alimentaria  data-eh-v1
#> 63       eh 2022        NA               vivienda  data-eh-v1
#> 64       eh 2023        NA         discriminacion  data-eh-v1
#> 65       eh 2023        NA           equipamiento  data-eh-v1
#> 66       eh 2023        NA    gastos_alimentarios  data-eh-v1
#> 67       eh 2023        NA                persona  data-eh-v1
#> 68       eh 2023        NA  seguridad_alimentaria  data-eh-v1
#> 69       eh 2023        NA               vivienda  data-eh-v1
#> 70       eh 2024        NA         discriminacion  data-eh-v1
#> 71       eh 2024        NA           equipamiento  data-eh-v1
#> 72       eh 2024        NA    gastos_alimentarios  data-eh-v1
#> 73       eh 2024        NA                persona  data-eh-v1
#> 74       eh 2024        NA  seguridad_alimentaria  data-eh-v1
#> 75       eh 2024        NA               vivienda  data-eh-v1
#>                           archivo_parquet factor_var factor_var_alt upm_var
#> 1            eh_2012_equipamiento.parquet     factor           <NA>     upm
#> 2     eh_2012_gastos_alimentarios.parquet     factor           <NA>     upm
#> 3  eh_2012_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 4                 eh_2012_persona.parquet     factor           <NA>     upm
#> 5                eh_2012_vivienda.parquet     factor           <NA>     upm
#> 6            eh_2013_equipamiento.parquet     factor           <NA>     upm
#> 7     eh_2013_gastos_alimentarios.parquet     factor           <NA>     upm
#> 8  eh_2013_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 9                 eh_2013_persona.parquet     factor           <NA>     upm
#> 10               eh_2013_vivienda.parquet     factor           <NA>     upm
#> 11           eh_2014_equipamiento.parquet     factor           <NA>     upm
#> 12    eh_2014_gastos_alimentarios.parquet     factor           <NA>     upm
#> 13 eh_2014_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 14                eh_2014_persona.parquet     factor           <NA>     upm
#> 15               eh_2014_vivienda.parquet     factor           <NA>     upm
#> 16           eh_2015_equipamiento.parquet     factor           <NA>     upm
#> 17    eh_2015_gastos_alimentarios.parquet     factor           <NA>     upm
#> 18 eh_2015_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 19                eh_2015_persona.parquet     factor           <NA>     upm
#> 20               eh_2015_vivienda.parquet     factor           <NA>     upm
#> 21           eh_2016_equipamiento.parquet     factor           <NA>     upm
#> 22                eh_2016_persona.parquet     factor           <NA>     upm
#> 23  eh_2016_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 24                eh_2016_turismo.parquet     factor           <NA>     upm
#> 25               eh_2016_vivienda.parquet     factor           <NA>     upm
#> 26                eh_2017_cultura.parquet     factor           <NA>     upm
#> 27           eh_2017_equipamiento.parquet     factor           <NA>     upm
#> 28    eh_2017_gastos_alimentarios.parquet     factor           <NA>     upm
#> 29 eh_2017_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 30                eh_2017_persona.parquet     factor           <NA>     upm
#> 31  eh_2017_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 32               eh_2017_vivienda.parquet     factor           <NA>     upm
#> 33         eh_2018_discriminacion.parquet     factor           <NA>     upm
#> 34           eh_2018_equipamiento.parquet     factor           <NA>     upm
#> 35    eh_2018_gastos_alimentarios.parquet     factor           <NA>     upm
#> 36 eh_2018_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 37                eh_2018_persona.parquet     factor           <NA>     upm
#> 38  eh_2018_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 39               eh_2018_vivienda.parquet     factor           <NA>     upm
#> 40         eh_2019_discriminacion.parquet     factor           <NA>     upm
#> 41           eh_2019_equipamiento.parquet     factor           <NA>     upm
#> 42    eh_2019_gastos_alimentarios.parquet     factor           <NA>     upm
#> 43 eh_2019_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 44                eh_2019_persona.parquet     factor           <NA>     upm
#> 45  eh_2019_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 46                eh_2019_turismo.parquet     factor           <NA>     upm
#> 47               eh_2019_vivienda.parquet     factor           <NA>     upm
#> 48                eh_2020_persona.parquet     factor           <NA>     upm
#> 49               eh_2020_vivienda.parquet     factor           <NA>     upm
#> 50            eh_2021_defunciones.parquet     factor           <NA>     upm
#> 51         eh_2021_discriminacion.parquet     factor           <NA>     upm
#> 52           eh_2021_equipamiento.parquet     factor           <NA>     upm
#> 53    eh_2021_gastos_alimentarios.parquet     factor           <NA>     upm
#> 54 eh_2021_gastos_no_alimentarios.parquet     factor           <NA>     upm
#> 55                eh_2021_persona.parquet     factor           <NA>     upm
#> 56  eh_2021_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 57               eh_2021_vivienda.parquet     factor           <NA>     upm
#> 58         eh_2022_discriminacion.parquet     factor           <NA>     upm
#> 59           eh_2022_equipamiento.parquet     factor           <NA>     upm
#> 60    eh_2022_gastos_alimentarios.parquet     factor           <NA>     upm
#> 61                eh_2022_persona.parquet     factor           <NA>     upm
#> 62  eh_2022_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 63               eh_2022_vivienda.parquet     factor           <NA>     upm
#> 64         eh_2023_discriminacion.parquet     factor           <NA>     upm
#> 65           eh_2023_equipamiento.parquet     factor           <NA>     upm
#> 66    eh_2023_gastos_alimentarios.parquet     factor           <NA>     upm
#> 67                eh_2023_persona.parquet     factor           <NA>     upm
#> 68  eh_2023_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 69               eh_2023_vivienda.parquet     factor           <NA>     upm
#> 70         eh_2024_discriminacion.parquet     factor           <NA>     upm
#> 71           eh_2024_equipamiento.parquet     factor           <NA>     upm
#> 72    eh_2024_gastos_alimentarios.parquet     factor           <NA>     upm
#> 73                eh_2024_persona.parquet     factor           <NA>     upm
#> 74  eh_2024_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 75               eh_2024_vivienda.parquet     factor           <NA>     upm
#>    estrato_var cobertura catalog_id archivo_sav version_caeb version_cob
#> 1      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 2      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 3      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 4      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 5      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 6      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 7      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 8      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 9      estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 10     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 11     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 12     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 13     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 14     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 15     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 16     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 17     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 18     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 19     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 20     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 21     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 22     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 23     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 24     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 25     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 26     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 27     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 28     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 29     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 30     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 31     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 32     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 33     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 34     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 35     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 36     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 37     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 38     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 39     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 40     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 41     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 42     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 43     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 44     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 45     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 46     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 47     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 48     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 49     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 50     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 51     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 52     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 53     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 54     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 55     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 56     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 57     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 58     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 59     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 60     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 61     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 62     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 63     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 64     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 65     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 66     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 67     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 68     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 69     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 70     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 71     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 72     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 73     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 74     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 75     estrato  nacional       <NA>        <NA>         <NA>        <NA>
catalogo_eh(anio = 2023)
#>   encuesta anio trimestre                 tabla release_tag
#> 1       eh 2023        NA        discriminacion  data-eh-v1
#> 2       eh 2023        NA          equipamiento  data-eh-v1
#> 3       eh 2023        NA   gastos_alimentarios  data-eh-v1
#> 4       eh 2023        NA               persona  data-eh-v1
#> 5       eh 2023        NA seguridad_alimentaria  data-eh-v1
#> 6       eh 2023        NA              vivienda  data-eh-v1
#>                         archivo_parquet factor_var factor_var_alt upm_var
#> 1        eh_2023_discriminacion.parquet     factor           <NA>     upm
#> 2          eh_2023_equipamiento.parquet     factor           <NA>     upm
#> 3   eh_2023_gastos_alimentarios.parquet     factor           <NA>     upm
#> 4               eh_2023_persona.parquet     factor           <NA>     upm
#> 5 eh_2023_seguridad_alimentaria.parquet     factor           <NA>     upm
#> 6              eh_2023_vivienda.parquet     factor           <NA>     upm
#>   estrato_var cobertura catalog_id archivo_sav version_caeb version_cob
#> 1     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 2     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 3     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 4     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 5     estrato  nacional       <NA>        <NA>         <NA>        <NA>
#> 6     estrato  nacional       <NA>        <NA>         <NA>        <NA>
```
