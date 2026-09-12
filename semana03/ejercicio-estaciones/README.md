# Sistema de Consulta y Planificación de Rutas - Metro de Lima

Aplicación de consola desarrollada en Swift que permite consultar información de las líneas, estaciones y rutas del Metro de Lima, incluyendo transbordos, tarifas y distancias aproximadas.

## Requerimientos Funcionales

**RF01. Listar las líneas del Metro de Lima**
El sistema muestra las 6 líneas registradas del proyecto, indicando su origen, destino, estado general, cantidad de estaciones (total, operativas, en construcción y proyectadas) y la tarifa cuando está definida.

**RF02. Consultar estaciones por línea**
El sistema permite ingresar el número de una línea (del 1 al 6) y muestra el listado completo de sus estaciones junto con el estado individual de cada una.

**RF03. Buscar estación por nombre**
El sistema permite buscar una estación escribiendo su nombre, sin importar mayúsculas, minúsculas o tildes, y muestra la línea a la que pertenece, su distrito, avenida, estado, tarifa, estación anterior y estación siguiente.

**RF04. Consultar lugares cercanos y conexiones de una estación**
El sistema permite consultar los lugares cercanos registrados de una estación específica, así como las conexiones que tiene con otras líneas del metro.

**RF05. Planificar ruta entre dos estaciones**
El sistema permite ingresar una estación de origen y una de destino, y calcula el recorrido correspondiente, ya sea dentro de la misma línea o mediante un transbordo si pertenecen a líneas distintas.

**RF06. Calcular tarifa y distancia aproximada del recorrido**
El sistema calcula la distancia aproximada en kilómetros según la cantidad de tramos recorridos y muestra la tarifa o tarifas correspondientes a la línea o líneas utilizadas en la ruta.


## Autor

Yakeli Jiménez

