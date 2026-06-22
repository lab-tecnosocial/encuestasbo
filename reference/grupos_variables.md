# Grupos temáticos de variables armonizadas

Grupos temáticos de variables armonizadas

## Usage

``` r
grupos_variables()
```

## Value

Una lista nombrada de grupos con los nombres canónicos de variables.

## Examples

``` r
grupos_variables()
#> $demografico
#> [1] "sexo"       "edad"       "parentesco"
#> 
#> $educacion
#> [1] "nivel_edu"     "anios_estudio"
#> 
#> $empleo
#> [1] "condicion_actividad" "pea"                 "pet"                
#> [4] "ocupado"             "grupo_ocupacion"    
#> 
#> $ingresos
#> [1] "ingreso_laboral"    "ingreso_personal"   "ingreso_hogar"     
#> [4] "ingreso_no_laboral"
#> 
#> $pobreza
#> [1] "pobre"                 "pobre_extremo"         "linea_pobreza"        
#> [4] "linea_pobreza_extrema"
#> 
#> $vivienda
#> [1] "tipo_vivienda"     "tenencia_vivienda"
#> 
#> $salud
#> [1] "tiene_seguro_salud"
#> 
grupos_variables()$pobreza
#> [1] "pobre"                 "pobre_extremo"         "linea_pobreza"        
#> [4] "linea_pobreza_extrema"
```
