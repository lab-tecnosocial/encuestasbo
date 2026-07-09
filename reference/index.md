# Package index

## Acceso a microdatos

Descarga y consulta de los microdatos. Todas devuelven un Arrow Dataset
(lazy), un tibble, o una conexión DuckDB.

- [`get_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh.md)
  : Accede a los microdatos de la Encuesta de Hogares (EH) del INE
- [`get_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_ece.md)
  : Accede a los microdatos de la Encuesta Continua de Empleo (ECE) del
  INE
- [`get_personas_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_eh.md)
  [`get_viviendas_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_eh.md)
  : Atajos de acceso a la Encuesta de Hogares por nivel
- [`get_personas_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/atajos_ece.md)
  : Atajos de acceso a la Encuesta Continua de Empleo por nivel

## Catálogo y ficha técnica

Inventario de encuestas disponibles y metadata oficial del INE (diseño
muestral, cobertura, factor de expansión).

- [`catalogo_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_eh.md)
  : Consulta el catálogo de la Encuesta de Hogares (EH)
- [`catalogo_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_ece.md)
  : Consulta el catálogo de la Encuesta Continua de Empleo (ECE)
- [`ficha_tecnica()`](https://lab-tecnosocial.github.io/encuestasbo/reference/ficha_tecnica.md)
  : Muestra la ficha técnica (diseño muestral) de una encuesta

## Diccionario de variables y etiquetas

Explora variables y etiquetas por encuesta y periodo, y convierte
códigos numéricos a texto legible.

- [`codebook()`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook.md)
  : Consulta el diccionario de variables de una encuesta del INE
- [`codebook_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook_valores.md)
  : Muestra los valores codificados de una variable categórica
- [`etiquetar_valores()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_valores.md)
  : Etiqueta los valores de las variables categóricas
- [`etiquetar_variables()`](https://lab-tecnosocial.github.io/encuestasbo/reference/etiquetar_variables.md)
  : Etiqueta los nombres de las variables (columnas)

## Armonización entre periodos

Renombrado a un esquema canónico estable y series largas comparables
entre años (EH) y trimestres (ECE), apoyadas en las variables derivadas
del INE.

- [`armonizar_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_eh.md)
  : Armoniza un data frame de la Encuesta de Hogares a nombres canónicos
- [`get_eh_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_eh_armonizada.md)
  : Serie armonizada de la Encuesta de Hogares entre años
- [`variables_armonizadas()`](https://lab-tecnosocial.github.io/encuestasbo/reference/variables_armonizadas.md)
  : Lista las variables armonizadas disponibles
- [`grupos_variables()`](https://lab-tecnosocial.github.io/encuestasbo/reference/grupos_variables.md)
  : Grupos temáticos de variables armonizadas
- [`armonizar_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/armonizar_ece.md)
  : Armoniza un data frame de la ECE a nombres/códigos canónicos
- [`get_ece_armonizada()`](https://lab-tecnosocial.github.io/encuestasbo/reference/get_ece_armonizada.md)
  : Serie armonizada de la Encuesta Continua de Empleo entre trimestres
- [`variables_armonizadas_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/variables_armonizadas_ece.md)
  : Lista las columnas canónicas de la serie ECE armonizada

## Diseño muestral (survey / srvyr)

Declaran el diseño estratificado bietápico con factores de expansión
para estimaciones e intervalos de confianza correctos.

- [`diseno_eh()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_eh.md)
  : Declara el diseño muestral de la Encuesta de Hogares (EH)
- [`diseno_ece()`](https://lab-tecnosocial.github.io/encuestasbo/reference/diseno_ece.md)
  : Declara el diseño muestral de la Encuesta Continua de Empleo (ECE)

## Indicadores con diseño muestral

Atajos para los indicadores más comunes (pobreza, desempleo,
subocupación, empleo vulnerable) con desagregación opcional e intervalos
de confianza.

- [`tasa_pobreza()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_pobreza.md)
  : Tasa de pobreza (EH)
- [`tasa_desempleo()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_desempleo.md)
  : Tasa de desempleo (ECE)
- [`tasa_subocupacion()`](https://lab-tecnosocial.github.io/encuestasbo/reference/tasa_subocupacion.md)
  : Tasa de subocupación (ECE)
- [`empleo_vulnerable()`](https://lab-tecnosocial.github.io/encuestasbo/reference/empleo_vulnerable.md)
  : Tasa de empleo vulnerable (ECE)
- [`grupo_edad()`](https://lab-tecnosocial.github.io/encuestasbo/reference/grupo_edad.md)
  : Agrupa la edad en cohortes

## Ingresos reales (deflactor)

Deflacta ingresos nominales a precios constantes con el IPC de Bolivia
para comparar entre años.

- [`deflactar()`](https://lab-tecnosocial.github.io/encuestasbo/reference/deflactar.md)
  : Deflacta valores monetarios a precios constantes de un año base
- [`ipc_bolivia`](https://lab-tecnosocial.github.io/encuestasbo/reference/ipc_bolivia.md)
  : Índice de Precios al Consumidor (IPC) de Bolivia, promedio anual

## Geografía

- [`departamentos()`](https://lab-tecnosocial.github.io/encuestasbo/reference/departamentos.md)
  : Lista los departamentos de Bolivia

## Gestión del caché

Ubicación, inspección y limpieza de los datos descargados.

- [`encuestasbo_cache_dir()`](https://lab-tecnosocial.github.io/encuestasbo/reference/encuestasbo_cache_dir.md)
  : Directorio de caché local del paquete
- [`encuestasbo_cache_info()`](https://lab-tecnosocial.github.io/encuestasbo/reference/encuestasbo_cache_info.md)
  : Información sobre los archivos en caché
- [`encuestasbo_cache_clear()`](https://lab-tecnosocial.github.io/encuestasbo/reference/encuestasbo_cache_clear.md)
  : Limpia el caché local de datos
- [`update_encuestasbo()`](https://lab-tecnosocial.github.io/encuestasbo/reference/update_encuestasbo.md)
  : Actualiza el paquete encuestasbo y limpia el caché

## Datos del paquete

Tablas de metadatos incluidas.

- [`catalogo_encuestas`](https://lab-tecnosocial.github.io/encuestasbo/reference/catalogo_encuestas.md)
  : Catálogo de encuestas del INE disponibles
- [`codebook_eh_meta`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook_eh_meta.md)
  : Diccionarios de variables de la Encuesta de Hogares
- [`codebook_ece_meta`](https://lab-tecnosocial.github.io/encuestasbo/reference/codebook_ece_meta.md)
  : Diccionarios de variables de la Encuesta Continua de Empleo
- [`variable_canonica_map`](https://lab-tecnosocial.github.io/encuestasbo/reference/variable_canonica_map.md)
  : Mapa de armonización de variables de la Encuesta de Hogares
- [`metadata_encuestas`](https://lab-tecnosocial.github.io/encuestasbo/reference/metadata_encuestas.md)
  : Ficha técnica y metadata oficial de las encuestas del INE
