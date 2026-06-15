# Consulta el diccionario de variables de una encuesta del INE

Busca variables por nombre, tabla o texto libre en las etiquetas.

## Usage

``` r
codebook(
  variable = NULL,
  tabla = NULL,
  buscar = NULL,
  encuesta = "eh",
  anio = 2024,
  trimestre = NULL
)
```

## Arguments

- variable:

  Vector de nombres de variable a consultar. Si \`NULL\`, todas.

- tabla:

  Filtra por tabla (\`"persona"\`, \`"vivienda"\`). Si \`NULL\`, todas.

- buscar:

  Texto libre para buscar en etiquetas y nombres (sin distinguir
  mayúsculas).

- encuesta:

  \`"eh"\` (defecto) o \`"ece"\`.

- anio:

  Año de la encuesta. Por defecto \`2024\`.

- trimestre:

  Trimestre (1-4); requerido si \`encuesta = "ece"\`.

## Value

Un data.frame con las variables que coinciden.

## Examples

``` r
codebook(buscar = "ingreso", anio = 2023)
#>     variable
#> 1   s04c_21a
#> 2  s04c_21a1
#> 3  s04c_21a2
#> 4   s04c_21b
#> 5  s04c_21b1
#> 6  s04c_21b2
#> 7   s04c_21c
#> 8  s04c_21c1
#> 9  s04c_21c2
#> 10  s04c_21d
#> 11 s04c_21d1
#> 12 s04c_21d2
#> 13  s04c_21e
#> 14 s04c_21e1
#> 15 s04c_21e2
#> 16  s04d_22a
#> 17  s04d_22b
#> 18 s04d_23aa
#> 19 s04d_23ab
#> 20 s04d_23ba
#> 21 s04d_23bb
#> 22 s04d_23ca
#> 23 s04d_23cb
#> 24 s04d_23da
#> 25 s04d_23db
#> 26 s04d_23ea
#> 27 s04d_23eb
#> 28 s04d_23fa
#> 29 s04d_23fb
#> 30 s04d_23ga
#> 31 s04d_23gb
#> 32 s04d_23ha
#> 33 s04d_23hb
#> 34  s04d_24b
#> 35  s04f_31b
#> 36  s04f_33a
#> 37  s04f_33b
#> 38  s04f_34b
#> 39  s05a_01a
#> 40  s05a_01b
#> 41  s05a_01c
#> 42  s05a_01d
#> 43  s05a_01e
#> 44 s05a_01e0
#> 45  s05a_01f
#> 46  s05a_02a
#> 47  s05a_02b
#> 48  s05a_02c
#> 49 s05a_02ce
#> 50  s05a_04a
#> 51  s05a_04b
#> 52  s05a_04c
#> 53  s05a_04d
#> 54   yprilab
#> 55   yseclab
#> 56      ylab
#> 57    ynolab
#> 58      yper
#> 59      yhog
#> 60    yhogpc
#> 61        p0
#> 62        p1
#> 63        p2
#> 64     pext0
#> 65     pext1
#> 66     pext2
#>                                                                                                                                                                                                                       etiqueta
#> 1                                        Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… A. Alimentos y bebidas para ser consumidos dentro o fuera del lugar de trabajo?
#> 2                   Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… A. Alimentos y bebidas para ser consumidos dentro o fuera del lugar de trabajo? ¿Con qué frecuencia?
#> 3                        Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… A. Alimentos y bebidas para ser consumidos dentro o fuera del lugar de trabajo? (Valorar en Bs)
#> 4                                                                    Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… B. Transporte hacia y desde el lugar de su trabajo?
#> 5                                               Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… B. Transporte hacia y desde el lugar de su trabajo? ¿Con qué frecuencia?
#> 6                                                    Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… B. Transporte hacia y desde el lugar de su trabajo? (Valorar en Bs)
#> 7                       Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… C. Vestidos y calzados utilizados frecuentemente tanto dentro como fuera de su lugar de trabajo?
#> 8  Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… C. Vestidos y calzados utilizados frecuentemente tanto dentro como fuera de su lugar de trabajo? ¿Con qué frecuencia?
#> 9       Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… C. Vestidos y calzados utilizados frecuentemente tanto dentro como fuera de su lugar de trabajo? (Valorar en Bs)
#> 10                                       Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… D. Vivienda o alojamiento que pueden ser utilizados por los miembros del hogar?
#> 11                 Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted...D. Vivienda o alojamiento que pueden ser utilizados por los miembros del hogar? ¿Con qué frecuencia?
#> 12                      Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted...D. Vivienda o alojamiento que pueden ser utilizados por los miembros del hogar? (Valorar en Bs)
#> 13                                       Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted… E. Otros, como servicio de guardería, instalaciones deportivas y/o recreativas?
#> 14                 Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted...E. Otros, como servicio de guardería, instalaciones deportivas y/o recreativas? ¿Con qué frecuencia?
#> 15                      Además de los ingresos recibidos en dinero por su trabajo, en los últimos doce meses ¿recibió, usted...E. Otros, como servicio de guardería, instalaciones deportivas y/o recreativas? (Valorar en Bs)
#> 16                                                                                                                                                           ¿Cuánto es su ingreso total en su ocupación principal? Monto (Bs)
#> 17                                                                                                                                               ¿Cuánto es su ingreso total en su ocupación principal? Frecuencia de ingreso:
#> 18                                               Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… A. Comprar materia prima, materiales o mercadería para su actividad o negocio? Monto (Bs)
#> 19                                     Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… A. Comprar materia prima, materiales o mercadería para su actividad o negocio? Frecuencia de gasto:
#> 20                                                 Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… B. Pagar por prestación de servicios a terceros para su actividad o negocio? Monto (Bs)
#> 21                                       Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… B. Pagar por prestación de servicios a terceros para su actividad o negocio? Frecuencia de gasto:
#> 22                                   Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… C. Pagar sueldos, salarios, bonos, gratificaciones, horas extras, Gestora a sus empleados? Monto (Bs)
#> 23                         Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… C. Pagar sueldos, salarios, bonos, gratificaciones, horas extras, Gestora a sus empleados? Frecuencia de gasto:
#> 24                                                Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… D. Pagar alquiler del local/vehiculo que dispone para su actividad o negocio? Monto (Bs)
#> 25                                      Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… D. Pagar alquiler del local/vehiculo que dispone para su actividad o negocio? Frecuencia de gasto:
#> 26                               Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… E. Pagar servicios de agua, luz, gas, teléfono o internet que usa para la actividad o negocio? Monto (Bs)
#> 27                     Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… E. Pagar servicios de agua, luz, gas, teléfono o internet que usa para la actividad o negocio? Frecuencia de gasto:
#> 28                                  Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… F. Pagar cuotas regulares por concepto de microcrédito/crédito para su actividad o negocio? Monto (Bs)
#> 29                        Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… F. Pagar cuotas regulares por concepto de microcrédito/crédito para su actividad o negocio? Frecuencia de gasto:
#> 30                                                                                                Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… G. Pagar impuestos, sentajes? Monto (Bs)
#> 31                                                                                      Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… G. Pagar impuestos, sentajes? Frecuencia de gasto:
#> 32                                                                         Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… H. Pagar cuotas a sindicatos, gremios, asociaciones? Monto (Bs)
#> 33                                                               Del ingreso total declarado en la pregunta anterior, ¿cuánto utiliza o guarda para… H. Pagar cuotas a sindicatos, gremios, asociaciones? Frecuencia de gasto:
#> 34                                                           Una vez descontadas todas sus obligaciones (sueldos, salarios, compra de material, mercadería, etc.), ¿cuánto le queda para uso del hogar? Frecuencia de ingreso:
#> 35                                                                                        ¿Cuánto es su salario líquido en ésta otra ocupación,  excluyendo los descuentos de ley (AFP o Gestora, IVA)? Frecuencia de ingreso:
#> 36                                                                                                                                                              ¿Cuánto es su ingreso total en ésta otra ocupación? Monto (Bs)
#> 37                                                                                                                                                  ¿Cuánto es su ingreso total en ésta otra ocupación? Frecuencia de ingreso:
#> 38                                                                         Una vez pagadas todas sus obligaciones (sueldos, salarios, compra de materiales, etc.), ¿cuánto le queda para uso del hogar? Frecuencia de ingreso:
#> 39                                                                                                                 Recibe usted ingresos (rentas) mensuales por: A. ¿Jubilación (vejez)? Excluya el monto de la Renta Dignidad
#> 40                                                                                                                         Recibe usted ingresos (rentas) mensuales por: B. ¿Benemérito? Excluya el monto de la Renta Dignidad
#> 41                                                                                                                                                                Recibe usted ingresos (rentas) mensuales por: C. ¿Invalidez?
#> 42                                                                                                                                                         Recibe usted ingresos (rentas) mensuales por: D. ¿Viudez, orfandad?
#> 43                                                                                                                                                           Recibe usted ingresos (rentas) mensuales por: E. ¿Renta Dignidad?
#> 44                                                                                                                                                Recibe usted ingresos (rentas) mensuales por: E. ¿Renta Dignidad? Monto (Bs)
#> 45                                                                                                                                           Recibe usted ingresos (rentas) mensuales por: F. ¿Aguinaldo de la Renta Dignidad?
#> 46                                                                                 Además de los ingresos mencionados, recibe usted ingresos (rentas) mensuales por: A. ¿Intereses? (por depósitos bancarios, préstamos, etc.)
#> 47                                                                                        Además de los ingresos mencionados, recibe usted ingresos (rentas) mensuales por: B. ¿Alquiler de propiedades inmuebles casas, etc.?
#> 48                                                                                                                         Además de los ingresos mencionados, recibe usted ingresos (rentas) mensuales por: C. ¿Otras rentas?
#> 49                                                                                                           Además de los ingresos mencionados, recibe usted ingresos (rentas) mensuales por: C. ¿Otras rentas? (Especifique)
#> 50                                                                                Además de los ingresos mencionados anteriormente, durante los últimos doce meses, ¿recibió, usted… A. Indemnización por dejar algún trabajo?
#> 51                                                                                             Además de los ingresos mencionados anteriormente, durante los últimos doce meses, ¿recibió, usted… B. Indemnización de Seguros?
#> 52                                                       Además de los ingresos mencionados anteriormente, durante los últimos doce meses, ¿recibió, usted… C. Ingresos por anticrético de propiedades inmuebles, casas, etc.?
#> 53                          Además de los ingresos mencionados anteriormente, durante los últimos doce meses, ¿recibió, usted… D. Otros ingresos extraordinarios (ej. Becas de estudio, derechos de autor, marcas y patentes)?
#> 54                                                                                                                                                                                Ingreso laboral Ocupación Principal (Bs/Mes)
#> 55                                                                                                                                                                               Ingreso laboral Ocupación Secundaria (Bs/Mes)
#> 56                                                                                                                                                                                                    Ingreso laboral (Bs/Mes)
#> 57                                                                                                                                                                                                 Ingreso no laboral (Bs/Mes)
#> 58                                                                                                                                                                                                   Ingreso personal (Bs/Mes)
#> 59                                                                                                                                                                                                  Ingreso del hogar (Bs/Mes)
#> 60                                                                                                                                                                                        Ingreso percápita del hogar (Bs/Mes)
#> 61                                                                                                                                                                                                         Pobreza por ingreso
#> 62                                                                                                                                                                                               Brecha de pobreza por ingreso
#> 63                                                                                                                                                                                             Magnitud de pobreza por ingreso
#> 64                                                                                                                                                                                    Pobreza extrema o indigencia por ingreso
#> 65                                                                                                                                                                                       Brecha de pobreza extrema por ingreso
#> 66                                                                                                                                                                                     Magnitud de pobreza extrema por ingreso
#>      tabla       tipo
#> 1  persona categorica
#> 2  persona categorica
#> 3  persona   numerica
#> 4  persona categorica
#> 5  persona categorica
#> 6  persona   numerica
#> 7  persona categorica
#> 8  persona categorica
#> 9  persona   numerica
#> 10 persona categorica
#> 11 persona categorica
#> 12 persona   numerica
#> 13 persona categorica
#> 14 persona categorica
#> 15 persona   numerica
#> 16 persona   numerica
#> 17 persona categorica
#> 18 persona   numerica
#> 19 persona categorica
#> 20 persona   numerica
#> 21 persona categorica
#> 22 persona   numerica
#> 23 persona categorica
#> 24 persona   numerica
#> 25 persona categorica
#> 26 persona   numerica
#> 27 persona categorica
#> 28 persona   numerica
#> 29 persona categorica
#> 30 persona   numerica
#> 31 persona categorica
#> 32 persona   numerica
#> 33 persona categorica
#> 34 persona categorica
#> 35 persona categorica
#> 36 persona   numerica
#> 37 persona categorica
#> 38 persona categorica
#> 39 persona   numerica
#> 40 persona   numerica
#> 41 persona   numerica
#> 42 persona   numerica
#> 43 persona categorica
#> 44 persona   numerica
#> 45 persona categorica
#> 46 persona   numerica
#> 47 persona   numerica
#> 48 persona   numerica
#> 49 persona      texto
#> 50 persona   numerica
#> 51 persona   numerica
#> 52 persona   numerica
#> 53 persona   numerica
#> 54 persona   numerica
#> 55 persona   numerica
#> 56 persona   numerica
#> 57 persona   numerica
#> 58 persona   numerica
#> 59 persona   numerica
#> 60 persona   numerica
#> 61 persona categorica
#> 62 persona   numerica
#> 63 persona   numerica
#> 64 persona categorica
#> 65 persona   numerica
#> 66 persona   numerica
#>                                                                                                                 valores_codigos
#> 1                                                                                                            1, 2, 1. Si, 2. No
#> 2  1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 3                                                                                                                          NULL
#> 4                                                                                                            1, 2, 1. Si, 2. No
#> 5  1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 6                                                                                                                          NULL
#> 7                                                                                                            1, 2, 1. Si, 2. No
#> 8  1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 9                                                                                                                          NULL
#> 10                                                                                                           1, 2, 1. Si, 2. No
#> 11 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 12                                                                                                                         NULL
#> 13                                                                                                           1, 2, 1. Si, 2. No
#> 14 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 15                                                                                                                         NULL
#> 16                                                                                                                         NULL
#> 17 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 18                                                                                                                         NULL
#> 19 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 20                                                                                                                         NULL
#> 21 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 22                                                                                                                         NULL
#> 23 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 24                                                                                                                         NULL
#> 25 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 26                                                                                                                         NULL
#> 27 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 28                                                                                                                         NULL
#> 29 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 30                                                                                                                         NULL
#> 31 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 32                                                                                                                         NULL
#> 33 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 34 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 35 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 36                                                                                                                         NULL
#> 37 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 38 1, 2, 3, 4, 5, 6, 7, 8, 1. Diario, 2. Semanal, 3. Quincenal, 4. Mensual, 5. Bimestral, 6. Trimestral, 7. Semestral, 8. Anual
#> 39                                                                                                                         NULL
#> 40                                                                                                                         NULL
#> 41                                                                                                                         NULL
#> 42                                                                                                                         NULL
#> 43                                                                                                           1, 2, 1. Si, 2. No
#> 44                                                                                                                         NULL
#> 45                                                                                                           1, 2, 1. Si, 2. No
#> 46                                                                                                                         NULL
#> 47                                                                                                                         NULL
#> 48                                                                                                                         NULL
#> 49                                                                                                                         NULL
#> 50                                                                                                                         NULL
#> 51                                                                                                                         NULL
#> 52                                                                                                                         NULL
#> 53                                                                                                                         NULL
#> 54                                                                                                                         NULL
#> 55                                                                                                                         NULL
#> 56                                                                                                                         NULL
#> 57                                                                                                                         NULL
#> 58                                                                                                                         NULL
#> 59                                                                                                                         NULL
#> 60                                                                                                                         NULL
#> 61                                                                                                        0, 1, No Pobre, Pobre
#> 62                                                                                                                         NULL
#> 63                                                                                                                         NULL
#> 64                                                                                        0, 1, No pobre extremo, Pobre extremo
#> 65                                                                                                                         NULL
#> 66                                                                                                                         NULL
codebook(tabla = "vivienda", anio = 2023)
#>    variable
#> 1     folio
#> 2     depto
#> 3      area
#> 4    totper
#> 5   s06a_01
#> 6   s06a_02
#> 7  s06a_02e
#> 8   s06a_03
#> 9  s06a_03e
#> 10  s06a_04
#> 11  s06a_05
#> 12 s06a_05e
#> 13  s06a_06
#> 14 s06a_06e
#> 15  s06a_07
#> 16 s06a_07e
#> 17 s06a_08a
#> 18 s06a_08b
#> 19  s06a_09
#> 20  s06a_10
#> 21  s06a_11
#> 22  s06a_12
#> 23  s06a_13
#> 24 s06a_13e
#> 25  s06a_14
#> 26  s06a_15
#> 27 s06a_15e
#> 28  s06a_16
#> 29  s06a_17
#> 30  s06a_18
#> 31  s06a_19
#> 32  s06a_20
#> 33  s06a_21
#> 34      upm
#> 35  estrato
#> 36   factor
#>                                                                                                                             etiqueta
#> 1                                                                                                               Id hogar anonimizado
#> 2                                                                                                                       Departamento
#> 3                                                                                                                       Urbana Rural
#> 4                                                                                                                  Total de personas
#> 5                                                                                                                    La vivienda es:
#> 6                                                                                               La vivienda que ocupa este hogar es:
#> 7                                                                           La vivienda que ocupa el hogar es... Otra? (Especifique)
#> 8                                                ¿Cuál es el material de construcción más utilizado en las paredes de esta vivienda?
#> 9                             ¿Cuál es el material de construcción más utilizado en las paredes de esta vivienda? OTRO (Especifique)
#> 10                                                                          ¿Las paredes interiores de esta vivienda tienen revoque?
#> 11                                                                ¿Cuál es el material más utilizado en los techos de esta vivienda?
#> 12                                         ¿Cuál es el material más utilizado en los techos de esta vivienda? ...OTRO. (Especifique)
#> 13                                                                 ¿Cuál es el material más utilizado en los pisos de esta vivienda?
#> 14                                          ¿Cuál es el material más utilizado en los pisos de esta vivienda? ...OTRO. (Especifique)
#> 15                                                                  ¿Principalmente ¿el agua que usan en la vivienda, proviene de...
#> 16                                               ¿Principalmente ¿el agua que usan en la vivienda, proviene de...Otro? (Especifique)
#> 17                                                                               Generalmente, ¿cuántos dias a la semana tiene agua?
#> 18                                                                                              Generalmente, ¿cuántas horas al día?
#> 19                                     ¿Qué tipo de baño, servicio sanitario o letrina utilizan normalmente los miembros de su hogar
#> 20                                                                             ¿El baño, servicio sanitario o letrina tiene desagüe…
#> 21                                                                                        ¿El baño, servicio sanitario o letrina es…
#> 22                                                                               ¿Usa energía eléctrica para alumbrar esta vivienda?
#> 23                                                                        ¿Habitualmente que hace con la basura que genera el hogar?
#> 24                                                    ¿Habitualmente que hace con la basura que genera el hogar? OTRO. (Especifique)
#> 25                                                                                               ¿Tiene un cuarto sólo para cocinar?
#> 26                                    Principalmente ¿qué tipo de combustible o energía utiliza para cocinar preparar sus alimentos?
#> 27               Principalmente ¿qué tipo de combustible o energía utiliza para cocinar preparar sus alimentos? 5.OTRO (Especifique)
#> 28 ¿Cuántos cuartos o habitaciones de esta vivienda ocupa su hogar, sin contar baño, cocina, lavandería, garage, depósito o negocio?
#> 29                                                        De estos cuartos o habitaciones, ¿cuántos usan exclusivamente para dormir?
#> 30                                                                                       ¿El hogar dispone de línea telefónica fija?
#> 31                                                                    ¿Tiene el hogar acceso al servicio de internet en su vivienda?
#> 32                                                                                ¿La conexión a internet es fija, móvil o de ambas?
#> 33                                                                                                 El medio de conexión fija es por:
#> 34                                                                                                                   upm anonimizada
#> 35                                                                                                                           Estrato
#> 36                                                                                                               Factor de expansión
#>       tabla       tipo
#> 1  vivienda      texto
#> 2  vivienda categorica
#> 3  vivienda categorica
#> 4  vivienda   numerica
#> 5  vivienda categorica
#> 6  vivienda categorica
#> 7  vivienda      texto
#> 8  vivienda categorica
#> 9  vivienda      texto
#> 10 vivienda categorica
#> 11 vivienda categorica
#> 12 vivienda      texto
#> 13 vivienda categorica
#> 14 vivienda      texto
#> 15 vivienda categorica
#> 16 vivienda      texto
#> 17 vivienda   numerica
#> 18 vivienda   numerica
#> 19 vivienda categorica
#> 20 vivienda categorica
#> 21 vivienda categorica
#> 22 vivienda categorica
#> 23 vivienda categorica
#> 24 vivienda      texto
#> 25 vivienda categorica
#> 26 vivienda categorica
#> 27 vivienda      texto
#> 28 vivienda   numerica
#> 29 vivienda   numerica
#> 30 vivienda categorica
#> 31 vivienda categorica
#> 32 vivienda categorica
#> 33 vivienda categorica
#> 34 vivienda      texto
#> 35 vivienda      texto
#> 36 vivienda   numerica
#>                                                                                                                                                                                                                                                                                                                                                                                                                                               valores_codigos
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                        NULL
#> 2                                                                                                                                                                                                                                                                                                                                                   1, 2, 3, 4, 5, 6, 7, 8, 9, Chuquisaca, La Paz, Cochabamba, Oruro, Potosí, Tarija, Santa Cruz, Beni, Pando
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, Urbano, Rural
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                        NULL
#> 5                                                                                                                                                                                                                                                                    1, 2, 3, 4, 5, 6, 1. Casa, 2. Choza/ Pahuichi, 3. Departamento, 4. Cuarto(s) o habitacion(es) suelta(s), 5. Vivienda improvisada o vivienda móvil, 6. Local no destinado para habitación
#> 6                                                                                                                                                                             1, 2, 3, 4, 5, 6, 7, 8, 1. ¿Propia y totalmente pagada?, 2. ¿Propia y la están pagando?, 3. ¿Alquilada?, 4. ¿En contrato Mixto (alquiler y anticretico)?, 5. ¿En contrato anticretico?, 6. ¿Cedida por servicios?, 7. ¿Prestada por parientes o amigos?, 8. ¿Otra?(Especifique)
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                        NULL
#> 8                                                                                                                                                                                                                                                                                 1, 2, 3, 4, 5, 6, 7, 1. LADRILLO/ BLOQUES DE CEMENTO/ HORMIGÓN, 2. ADOBE / TAPIAL, 3. TABIQUE/ QUINCHE, 4. PIEDRA, 5. MADERA, 6. CAÑA/ PALMA/ TRONCO, 7. OTRO (Especifique)
#> 9                                                                                                                                                                                                                                                                                                                                                                                                                                                        NULL
#> 10                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, 1. Si, 2. No
#> 11                                                                                                                                                                                                                                                                                              1, 2, 3, 4, 5, 1. CALAMINA O PLANCHA, 2. TEJA (CEMENTO/ ARCILLA/ FIBROCEMENTO, 3. LOSA DE HORMIGÓN ARMADO, 4. PAJA/ CAÑA/ PALMA/ BARRO, 5. OTRO (Especifique)
#> 12                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 13                                                                                                                                                                                                                                                                             1, 2, 3, 4, 5, 6, 7, 8, 1. TIERRA, 2. TABLÓN DE MADERA, 3. MACHIHEMBRE/PARQUET, 4. PISO FLOTANTE, 5. CEMENTO, 6. MOSAICO/BALDOSAS/CERÁMICA, 7. LADRILLO, 8. OTRO (Especifique)
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 15 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1. Cañería de red dentro de la vivienda?, 2. Cañería de red fuera de la vivienda, pero dentro del lote o terreno?, 3. Pileta pública?, 4. Cosecha de agua de lluvia?, 5. Pozo perforado o entubado, con bomba?, 6. Pozo protegido, con bomba?, 7. Pozo no protegido o sin bomba?, 8. Manantial o Vertiente protegida?, 9. Río/Acequia/Vertiente no protegida?, 10. Carro repartidor (Aguatero)?, 11. Otro (Especifique)
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 17                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 19                                                                                                                                                                                                                                                      1, 2, 3, 4, 5, 1. Baño o letrina con descarga de agua, 2. Letrina de pozo ciego con piso, 3. Pozo abierto (pozo ciego sin piso), 4. Baño ecológico (seco o de compostaje), 5. Ninguno (Arbusto/Campo)
#> 20                                                                                                                                                                                                                                                                                                 1, 2, 3, 4, 5, 1. A la red de alcantarillado?, 2. A una cámara séptica?, 3. A un pozo de absorción?, 4. A la superficie (calle/quebrada/río)?, 5. No sabe?
#> 21                                                                                                                                                                                                                                                                                                                                                                                        1, 2, 1. Usado sólo por su hogar?, 2. Compartido con otros hogares?
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, 1. Si, 2. No
#> 23                                                                                                                                                                                               1, 2, 3, 4, 5, 6, 7, 1. LA TIRA AL RIO, 2. LA QUEMA, 3. LA TIRA EN UN TERRENO BALDÍO O A LA CALLE, 4. LA ENTIERRA, 5. LA DEPOSITA EN EL BASURERO PÚBLICO O CONTENEDOR, 6. UTILIZA EL SERVICIO PÚBLICO DE RECOLECCIÓN (Carro Basurero), 7. OTRO (Especifique)
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, 1. Si, 2. No
#> 26                                                                                                                                                                                                                                                                                    1, 2, 3, 4, 5, 6, 7, 1. LEÑA, 2. GUANO/BOSTA O TAQUIA, 3. GAS LICUADO (garrafa), 4. GAS NATURAL POR RED (cañería), 5. OTRO (Especifique), 6. ELECTRICIDAD, 7. NO COCINA
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 30                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, 1. Si, 2. No
#> 31                                                                                                                                                                                                                                                                                                                                                                                                                                         1, 2, 1. Si, 2. No
#> 32                                                                                                                                                                                                                        1, 2, 3, 4, 1. Solo fija(la conexión solo puede realizarse en la vivienda), 2. Solo móvil (la conexión es mediante red móvil como celular o modem USB, por cualquiera de los miembros del hogar, 3. Ambas(fija y móvil), 4. NO SABE
#> 33                           1, 2, 3, 4, 5, 1. Cable de red (fibra óptica como ENTEL, TIGO; o línea telefónica como COTEL, COMTECO, COTAS)?, 2. Satelital( por una antena parabólica se accede a Internet del satélite "Tupak Katari", de la empresa pública SUBE), 3. Conexión inalámbrica (por una antena o dispositivo inalámbrico se recibe señal de Internet, como Internet LTE Fijo in, 4. Fija compartida (entre vecinos u otros hogares)?, 5. NO SABE
#> 34                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 35                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
#> 36                                                                                                                                                                                                                                                                                                                                                                                                                                                       NULL
codebook(buscar = "desocupad", encuesta = "ece", anio = 2023, trimestre = 4)
#>   variable                       etiqueta   tabla       tipo valores_codigos
#> 1     pead           Población Desocupada persona categorica    0, 1, No, Sí
#> 2  peadces   Población Desocupada Cesante persona categorica    0, 1, No, Sí
#> 3  peadasp Población Desocupada Aspirante persona categorica    0, 1, No, Sí
```
