# Muestra la ficha técnica (diseño muestral) de una encuesta

Imprime y devuelve la metadata oficial del INE para la encuesta y
periodo indicados: universo, cobertura, marco y diseño muestral, factor
de expansión, modo de recolección y tasa de respuesta.

## Usage

``` r
ficha_tecnica(encuesta = "eh", anio, trimestre = NULL)
```

## Arguments

- encuesta:

  \`"eh"\` (defecto) o \`"ece"\`.

- anio:

  Año del estudio.

- trimestre:

  Trimestre (1-4); requerido para la ECE.

## Value

Invisible: un data.frame de una fila con la ficha. Imprime un resumen
legible.

## Details

Para trimestres de la ECE sin estudio propio en ANDA (p. ej. 3T/4T-2019,
1T-2020, o los del periodo 4T2015–2T2019), se devuelve la ficha del
estudio consolidado ECE 4T2015–2T2019 como descripción general del
diseño (que es estable entre trimestres), con un aviso.

## See also

\[catalogo_eh()\], \[catalogo_ece()\], \[diseno_eh()\].

## Examples

``` r
ficha_tecnica("eh", 2023)
#> 
#> ── Ficha técnica: ENCUESTA DE HOGARES 2023 ─────────────────────────────────────
#> Título: ENCUESTA DE HOGARES 2023
#> 
#> Universo: Hogares y personas (nacionales o extranjeros) que residen en
#> viviendas particulares ocupadas en el territorio nacional.
#> 
#> Unidad de análisis: El hogar y sus miembros del hogar
#> 
#> Cobertura geográfica: La cobertura geográfica de la Encuesta de Hogares 2023 es
#> nacional. La información es recolectada en los nueve departamentos del país,
#> tanto en área urbana como rural.
#> 
#> Periodo de referencia: 2023 2023 Anual
#> 
#> Diseño y marco muestral: MARCO MUESTRAL El marco muestral (MM-2012) está basada
#> con los datos del Censo de Población y Vivienda de 2012 (CNPV-2012), la
#> Actualización Cartográfica Multipropósito (ACM-2010-2012) y el Censo Nacional
#> Agropecuario de 2013 (CNA-2013). Por tanto, el MM-2012 se describe como un
#> marco de áreas y listas. El Marco Muestral 2012 (MM-2012), contiene la
#> estratificación de áreas geográficas y la estrati […]
#> 
#> Factor de expansión: El factor de expansión es el inverso de la probabilidad de
#> selección de la vivienda. Para su construcción se considera: el ajuste de la
#> no-respuesta, los resultados de incidencias de campo y el total poblacional
#> proyectado para ese año; los factores de expansión son calculados una vez
#> realizada la encuesta. Para más detalle de la construcción del factor de
#> expansión consultar el Diseño Muestral qu […]
#> 
#> Modo de recolección: Face-to-face [f2f]
#> 
#> Muestra / respuesta: La incidencia de campo de la encuesta fue de 98.8 % a
#> nivel nacional. Donde se llegó a ejecutar una muestra de 12815 viviendas de un
#> total de muestra de 12948 viviendas.
#> 
#> ℹ Fuente: INE Bolivia, ANDA (id 108). Metadata completa en metadata_encuestas.
ficha_tecnica("ece", 2023, trimestre = 4)
#> 
#> ── Ficha técnica: ENCUESTA CONTINUA DE EMPLEO ──────────────────────────────────
#> Título: ENCUESTA CONTINUA DE EMPLEO
#> 
#> Universo: La investigación está dirigida al conjunto de hogares constituidos en
#> viviendas ocupadas particulares de los nueve departamentos del país del área
#> urbana y rural; excluyendo así a las personas que habitan en viviendas
#> colectivas, como hospitales, cárceles, conventos, cuarteles y otros; pero
#> incluye a las personas que residen en viviendas particulares dentro de dichos
#> centros, como porteros, conser […]
#> 
#> Unidad de análisis: La unidad de análisis de la Encuesta Continua de Empleo son
#> los miembros del hogar que residen en viviendas particulares.
#> 
#> Cobertura geográfica: La ECE recopila información acerca de la situación del
#> empleo de las personas del área urbana (ciudades capitales y El Alto, ciudades
#> intermedias y conurbaciones) y se incluye al área rural para contar con una
#> cobertura a nivel nacional. El menor nivel de desagregación de información es
#> departamental, exceptuando a Pando y Beni, donde se realizan estimaciones de
#> forma conjunta.
#> 
#> Periodo de referencia: 2023-10-01 2023-12-30 Cuarto Trimestre del 2023
#> 
#> Diseño y marco muestral: MARCO MUESTRAL Está basada en el Censo de Población y
#> Vivienda de 2012 (CNPV-2012), la Actualización Cartográfica Multipropósito
#> (ACM-2010-2012) y el Censo Nacional Agropecuario de 2013 (CNA-2013). TIPO DE
#> MUESTREO El tipo de muestreo es probabilístico, estratificado, por conglomerado
#> y bietápico. Probabilístico, La unidad de selección, es decir las viviendas,
#> tienen una probabilidad conocida y di […]
#> 
#> Factor de expansión: Existen dos factores de expansión, mensual y trimestral.
#> De acuerdo al diseño de la muestra, ambos factores se calculan con el mismo
#> procedimiento, considerando los resultados de las incidencias de campo en la
#> actualización cartográfica y tomando el número de viviendas encuestadas por
#> UPM. Para mayor detalle, la información se encuentra disponible en el documento
#> del Diseño Muestral de la Encuesta […]
#> 
#> Modo de recolección: Face-to-face [f2f]
#> 
#> Muestra / respuesta: Ya que el diseño es complejo, se requiere utilizar
#> fórmulas especiales que consideran los efectos de la estratificación y la
#> conglomeración al momento de obtener los resultados de la encuesta. Para
#> calcular los estimadores, es prioritario que la base de datos de la encuesta
#> esté expandida, vale decir, que se empleen los factores de expansión. Para el
#> cálculo de los intervalos de confianza, coefici […]
#> 
#> ℹ Fuente: INE Bolivia, ANDA (id 107). Metadata completa en metadata_encuestas.
```
