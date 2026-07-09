# Lista las columnas canónicas de la serie ECE armonizada

Lista las columnas canónicas de la serie ECE armonizada

## Usage

``` r
variables_armonizadas_ece()
```

## Value

Un data.frame con el nombre canónico y una breve descripción de cada
columna que devuelve \[get_ece_armonizada()\].

## See also

\[get_ece_armonizada()\], \[variables_armonizadas()\].

## Examples

``` r
variables_armonizadas_ece()
#>                 variable
#> 1                   anio
#> 2              trimestre
#> 3                  depto
#> 4                   area
#> 5                    upm
#> 6                estrato
#> 7          fact_trim_act
#> 8           fact_mes_act
#> 9                   sexo
#> 10 categoria_ocupacional
#> 11               ocupado
#> 12            desocupado
#> 13            subocupado
#> 14                   pea
#> 15                   pet
#> 16                  ylab
#>                                                        etiqueta
#> 1                                             Año de referencia
#> 2                                               Trimestre (1-4)
#> 3                                     Departamento (código 1-9)
#> 4                                  Área (1 = Urbana, 2 = Rural)
#> 5                                   Unidad primaria de muestreo
#> 6                                                       Estrato
#> 7                                Factor de expansión trimestral
#> 8                                   Factor de expansión mensual
#> 9                                  Sexo (1 = Hombre, 2 = Mujer)
#> 10 Categoría ocupacional canónica (1-6; situación en el empleo)
#> 11                                                Ocupado (0/1)
#> 12                                             Desocupado (0/1)
#> 13                           Subocupado (0/1; NA antes de 2019)
#> 14                        Población económicamente activa (0/1)
#> 15                          Población en edad de trabajar (0/1)
#> 16                                              Ingreso laboral
```
