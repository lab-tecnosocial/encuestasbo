# Lista las variables armonizadas disponibles

Lista las variables armonizadas disponibles

## Usage

``` r
variables_armonizadas(solo_armonizadas = TRUE)
```

## Arguments

- solo_armonizadas:

  Lógico. Si \`TRUE\` (defecto), solo las marcadas como comparables
  entre años.

## Value

Un data.frame con las columnas del \[variable_canonica_map\].

## Examples

``` r
variables_armonizadas()
#>                 variable                                  etiqueta    tabla
#> 1                  depto                        Departamento (1-9)  persona
#> 2                   area                  Área (1=Urbana, 2=Rural)  persona
#> 3                 factor                       Factor de expansión  persona
#> 4                   sexo                  Sexo (1=Hombre, 2=Mujer)  persona
#> 5                   edad                    Edad en años cumplidos  persona
#> 6              nivel_edu                 Nivel educativo (general)  persona
#> 7          anios_estudio                           Años de estudio  persona
#> 8                    pea           Población económicamente activa  persona
#> 9                    pet             Población en edad de trabajar  persona
#> 10               ocupado                         Población ocupada  persona
#> 11            desocupado                      Población desocupada  persona
#> 12   condicion_actividad                    Condición de actividad  persona
#> 13       ingreso_laboral                  Ingreso laboral (Bs/Mes)  persona
#> 14    ingreso_no_laboral               Ingreso no laboral (Bs/Mes)  persona
#> 15      ingreso_personal                 Ingreso personal (Bs/Mes)  persona
#> 16         ingreso_hogar                Ingreso del hogar (Bs/Mes)  persona
#> 17         linea_pobreza         Línea de pobreza (Bs/persona/mes)  persona
#> 18 linea_pobreza_extrema Línea de pobreza extrema (Bs/persona/mes)  persona
#> 19                 pobre                   Pobre por ingreso (0/1)  persona
#> 20         pobre_extremo           Pobre extremo por ingreso (0/1)  persona
#> 21         tipo_vivienda        Tipo de vivienda (1=Casa..6=Local) vivienda
#> 22     tenencia_vivienda    Tenencia de la vivienda (recodificada) vivienda
#> 23    tiene_seguro_salud    Afiliado a algún seguro de salud (0/1)  persona
#>    armonizada       v2012       v2013       v2014      v2015      v2016
#> 1        TRUE       depto       depto       depto      depto      depto
#> 2        TRUE        area        area        area       area       area
#> 3        TRUE factor_2014 factor_2014 factor_2014     factor     factor
#> 4        TRUE       s1_03      s2a_02      s2a_02     s2a_02    s02a_02
#> 5        TRUE       s1_04      s2a_03      s2a_03     s2a_03    s02a_03
#> 6        TRUE    niv_ed_g    niv_ed_g    niv_ed_g   niv_ed_g   niv_ed_g
#> 7        TRUE    aestudio    aestudio    aestudio   aestudio   aestudio
#> 8        TRUE         pea         pea         pea        pea        pea
#> 9        TRUE         pet         pet         pet        pet        pet
#> 10       TRUE     ocupado     ocupado     ocupado    ocupado    ocupado
#> 11       TRUE  desocupado  desocupado  desocupado desocupado desocupado
#> 12       TRUE     condact     condact     condact    condact    condact
#> 13       TRUE        ylab        ylab        ylab       ylab       ylab
#> 14       TRUE      ynolab      ynolab      ynolab     ynolab     ynolab
#> 15       TRUE        yper        yper        yper       yper       yper
#> 16       TRUE        yhog        yhog        yhog       yhog       yhog
#> 17       TRUE           z           z           z          z          z
#> 18       TRUE        zext        zext        zext       zext       zext
#> 19       TRUE          p0          p0          p0         p0         p0
#> 20       TRUE       pext0       pext0       pext0      pext0      pext0
#> 21       TRUE      s8a_01      s1a_01      s1a_01     s1a_01    s01a_01
#> 22       TRUE      s8a_02      s1a_02      s1a_02     s1a_02    s01a_02
#> 23       TRUE      s3_24a     s4d_21a        <NA>     s4a_4a   s04a_04a
#>         v2017      v2018      v2019      v2020      v2021    v2022    v2023
#> 1       depto      depto      depto      depto      depto    depto    depto
#> 2        area       area       area       area       area     area     area
#> 3      factor     factor     factor     factor     factor   factor   factor
#> 4     s02a_02    s02a_02    s02a_02    s01a_02    s01a_02  s01a_02  s01a_02
#> 5     s02a_03    s02a_03    s02a_03    s01a_03    s01a_03  s01a_03  s01a_03
#> 6    niv_ed_g   niv_ed_g   niv_ed_g   niv_ed_g   niv_ed_g niv_ed_g niv_ed_g
#> 7    aestudio   aestudio   aestudio   aestudio   aestudio aestudio aestudio
#> 8         pea        pea        pea        pea        pea      pea      pea
#> 9         pet        pet        pet        pet        pet      pet      pet
#> 10    ocupado    ocupado    ocupado    ocupado    ocupado     <NA>     <NA>
#> 11 desocupado desocupado desocupado desocupado desocupado     <NA>     <NA>
#> 12    condact    condact    condact    condact    condact  condact  condact
#> 13       ylab       ylab       ylab       ylab       ylab     ylab     ylab
#> 14     ynolab     ynolab     ynolab     ynolab     ynolab   ynolab   ynolab
#> 15       yper       yper       yper       yper       yper     yper     yper
#> 16       yhog       yhog       yhog       yhog       yhog     yhog     yhog
#> 17          z          z          z          z          z        z        z
#> 18       zext       zext       zext       zext       zext     zext     zext
#> 19         p0         p0         p0         p0         p0       p0       p0
#> 20      pext0      pext0      pext0      pext0      pext0    pext0    pext0
#> 21    s01a_01    s01a_01    s01a_01       <NA>    s07a_01  s06a_01  s06a_01
#> 22    s01a_02    s01a_02    s01a_02       <NA>    s07a_02  s06a_02  s06a_02
#> 23   s04a_04a   s04a_04a   s04a_04a   s02a_01a   s02a_01a s02a_01a s02a_01a
#>       v2024
#> 1     depto
#> 2      area
#> 3    factor
#> 4   s01a_02
#> 5   s01a_03
#> 6  niv_ed_g
#> 7  aestudio
#> 8       pea
#> 9       pet
#> 10     <NA>
#> 11     <NA>
#> 12  condact
#> 13     ylab
#> 14   ynolab
#> 15     yper
#> 16     yhog
#> 17        z
#> 18     zext
#> 19       p0
#> 20    pext0
#> 21  s06a_01
#> 22  s06a_02
#> 23 s02a_01a
```
