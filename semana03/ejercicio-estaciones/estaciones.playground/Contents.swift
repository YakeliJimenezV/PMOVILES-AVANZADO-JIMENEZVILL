import Foundation

// MARK: - ESTRUCTURAS

struct Estacion {
    let nombre: String
    let distrito: String
    let avenida: String
    let lugaresCercanos: [String]
}

struct Linea {
    let numero: Int
    let nombre: String
    let origen: String
    let destino: String
    let estado: String
    let estaciones: [Estacion]
}

struct Conexion {
    let linea1: Int
    let estacionLinea1: String
    let linea2: Int
    let estacionLinea2: String
    let estado: String
}

// MARK: - NORMALIZAR TEXTO

func normalizarTexto(_ texto: String) -> String {
    return texto
        .folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_ES")
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

// MARK: - LÍNEA 1

let linea1 = Linea(
    numero: 1,
    nombre: "Línea 1",
    origen: "Villa El Salvador",
    destino: "Bayóvar",
    estado: "Operativa",
    estaciones: [

        Estacion(
            nombre: "Villa El Salvador",
            distrito: "Villa El Salvador",
            avenida: "Av. Separadora Industrial",
            lugaresCercanos: ["Parque Industrial"]
        ),

        Estacion(
            nombre: "Parque Industrial",
            distrito: "Villa El Salvador",
            avenida: "Av. Separadora Industrial",
            lugaresCercanos: ["Parque Industrial de Villa El Salvador"]
        ),

        Estacion(
            nombre: "Pumacahua",
            distrito: "Villa El Salvador",
            avenida: "Av. Mateo Pumacahua",
            lugaresCercanos: ["Mercado Pumacahua"]
        ),

        Estacion(
            nombre: "Villa María",
            distrito: "Villa María del Triunfo",
            avenida: "Av. Pachacútec",
            lugaresCercanos: ["Municipalidad de Villa María del Triunfo"]
        ),

        Estacion(
            nombre: "María Auxiliadora",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Miguel Iglesias",
            lugaresCercanos: ["Hospital María Auxiliadora"]
        ),

        Estacion(
            nombre: "San Juan",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Los Héroes",
            lugaresCercanos: ["Municipalidad de San Juan de Miraflores"]
        ),

        Estacion(
            nombre: "Atocongo",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Los Héroes",
            lugaresCercanos: ["Mall del Sur"]
        ),

        Estacion(
            nombre: "Jorge Chávez",
            distrito: "Santiago de Surco",
            avenida: "Av. Tomás Marsano",
            lugaresCercanos: ["Parque de la Amistad"]
        ),

        Estacion(
            nombre: "Ayacucho",
            distrito: "Santiago de Surco",
            avenida: "Av. Tomás Marsano",
            lugaresCercanos: ["Mercado Jorge Chávez"]
        ),

        Estacion(
            nombre: "Los Cabitos",
            distrito: "Santiago de Surco",
            avenida: "Av. Tomás Marsano",
            lugaresCercanos: ["Centro Comercial Caminos del Inca"]
        ),

        Estacion(
            nombre: "Angamos",
            distrito: "Surquillo",
            avenida: "Av. Angamos",
            lugaresCercanos: ["Open Plaza Angamos"]
        ),

        Estacion(
            nombre: "San Borja Sur",
            distrito: "San Borja",
            avenida: "Av. Aviación",
            lugaresCercanos: ["Pentagonito"]
        ),

        Estacion(
            nombre: "La Cultura",
            distrito: "San Borja",
            avenida: "Av. Aviación",
            lugaresCercanos: [
                "Museo de la Nación",
                "Biblioteca Nacional del Perú"
            ]
        ),

        Estacion(
            nombre: "Nicolás Arriola",
            distrito: "La Victoria",
            avenida: "Av. Aviación",
            lugaresCercanos: ["Mercado de Frutas"]
        ),

        Estacion(
            nombre: "Gamarra",
            distrito: "La Victoria",
            avenida: "Av. Aviación",
            lugaresCercanos: [
                "Gamarra",
                "Emporio Comercial de Gamarra"
            ]
        ),

        Estacion(
            nombre: "Miguel Grau",
            distrito: "La Victoria",
            avenida: "Av. Aviación",
            lugaresCercanos: ["Hospital Nacional Dos de Mayo"]
        ),

        Estacion(
            nombre: "El Ángel",
            distrito: "El Agustino",
            avenida: "Av. Locumba",
            lugaresCercanos: ["Cementerio El Ángel"]
        ),

        Estacion(
            nombre: "Presbítero Maestro",
            distrito: "El Agustino",
            avenida: "Av. Locumba",
            lugaresCercanos: ["Cementerio Presbítero Maestro"]
        ),

        Estacion(
            nombre: "Caja de Agua",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Caja de Agua"]
        ),

        Estacion(
            nombre: "Pirámide del Sol",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Parque Zonal Wiracocha"]
        ),

        Estacion(
            nombre: "Los Jardines",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Mercado Los Jardines"]
        ),

        Estacion(
            nombre: "Los Postes",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Mercado Los Postes"]
        ),

        Estacion(
            nombre: "San Carlos",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Zona comercial de San Carlos"]
        ),

        Estacion(
            nombre: "San Martín",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Mercado San Martín"]
        ),

        Estacion(
            nombre: "Santa Rosa",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Mercado Santa Rosa"]
        ),

        Estacion(
            nombre: "Bayóvar",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: ["Parque Zonal Huiracocha"]
        )
    ]
)

// MARK: - LÍNEA 2

let linea2 = Linea(
    numero: 2,
    nombre: "Línea 2",
    origen: "Evitamiento",
    destino: "Mercado Santa Anita",
    estado: "Operativa parcialmente - Etapa 1A",
    estaciones: [

        Estacion(
            nombre: "Evitamiento",
            distrito: "Ate",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: ["Mall Aventura Santa Anita"]
        ),

        Estacion(
            nombre: "Óvalo Santa Anita",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: [
                "Plaza Vea Santa Anita",
                "Mall Aventura Santa Anita"
            ]
        ),

        Estacion(
            nombre: "Colectora Industrial",
            distrito: "Santa Anita",
            avenida: "Av. Colectora Industrial",
            lugaresCercanos: ["Mercado Productores"]
        ),

        Estacion(
            nombre: "Hermilio Valdizán",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: ["Hospital Hermilio Valdizán"]
        ),

        Estacion(
            nombre: "Mercado Santa Anita",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: ["Mercado Mayorista de Santa Anita"]
        )
    ]
)

// MARK: - LÍNEAS 3, 4, 5 Y 6

let linea3 = Linea(
    numero: 3,
    nombre: "Línea 3",
    origen: "Comas",
    destino: "San Juan de Miraflores",
    estado: "En proyecto",
    estaciones: []
)

let linea4 = Linea(
    numero: 4,
    nombre: "Línea 4",
    origen: "Callao",
    destino: "Santa Anita",
    estado: "En proyecto",
    estaciones: []
)

let linea5 = Linea(
    numero: 5,
    nombre: "Línea 5",
    origen: "Chorrillos",
    destino: "Villa El Salvador",
    estado: "En proyecto",
    estaciones: []
)

let linea6 = Linea(
    numero: 6,
    nombre: "Línea 6",
    origen: "San Martín de Porres",
    destino: "El Agustino",
    estado: "En proyecto",
    estaciones: []
)

// MARK: - COLECCIÓN DE LÍNEAS

let lineas = [
    linea1,
    linea2,
    linea3,
    linea4,
    linea5,
    linea6
]

// MARK: - CONEXIONES

let conexiones = [
    Conexion(
        linea1: 1,
        estacionLinea1: "Gamarra",
        linea2: 2,
        estacionLinea2: "28 de Julio",
        estado: "No operativa"
    )
]

// MARK: - OPCIÓN 1

func listarLineas() {

    print("\n===== LÍNEAS DEL METRO DE LIMA =====")

    for linea in lineas {

        print("\n\(linea.nombre)")
        print("Origen: \(linea.origen)")
        print("Destino: \(linea.destino)")
        print("Estado: \(linea.estado)")

        if linea.estaciones.isEmpty {
            print("Estaciones operativas registradas: 0")
        } else {
            print("Estaciones operativas registradas: \(linea.estaciones.count)")
        }
    }
}

// MARK: - OPCIÓN 2

func consultarEstacionesPorLinea() {

    print("\n===== CONSULTAR ESTACIONES =====")
    print("Ingrese el número de línea:")

    guard let entrada = readLine(),
          let numero = Int(entrada) else {

        print("Número de línea inválido.")
        return
    }

    guard let linea = lineas.first(where: { $0.numero == numero }) else {

        print("La línea \(numero) no existe.")
        return
    }

    print("\n===== \(linea.nombre.uppercased()) =====")
    print("Origen: \(linea.origen)")
    print("Destino: \(linea.destino)")
    print("Estado: \(linea.estado)")

    if linea.estaciones.isEmpty {

        print("\nNo hay estaciones operativas registradas para esta línea.")
        return
    }

    print("\nEstaciones:")

    for (indice, estacion) in linea.estaciones.enumerated() {
        print("\(indice + 1). \(estacion.nombre)")
    }
}

// MARK: - BÚSQUEDA DE ESTACIÓN

func buscarEstacion() -> (
    linea: Linea,
    indice: Int,
    estacion: Estacion
)? {

    print("\nIngrese el nombre de la estación:")

    guard let entrada = readLine() else {
        return nil
    }

    let textoBuscado = normalizarTexto(entrada)

    let alias: [String: String] = [
        "herminio baldizan": "Hermilio Valdizán"
    ]

    let nombreBuscado = alias[textoBuscado] ?? entrada

    let textoFinal = normalizarTexto(nombreBuscado)

    for linea in lineas {

        for (indice, estacion) in linea.estaciones.enumerated() {

            if normalizarTexto(estacion.nombre) == textoFinal {

                return (
                    linea: linea,
                    indice: indice,
                    estacion: estacion
                )
            }
        }
    }

    return nil
}

// MARK: - OPCIÓN 3

func buscarYMostrarEstacion() {

    print("\n===== BUSCAR ESTACIÓN =====")

    guard let resultado = buscarEstacion() else {

        print("\nNo se encontró la estación.")
        return
    }

    let linea = resultado.linea
    let indice = resultado.indice
    let estacion = resultado.estacion

    print("\n===== INFORMACIÓN DE LA ESTACIÓN =====")

    print("Estación: \(estacion.nombre)")
    print("Línea: \(linea.nombre)")
    print("Distrito: \(estacion.distrito)")
    print("Avenida: \(estacion.avenida)")

    if indice > 0 {
        print("Estación anterior: \(linea.estaciones[indice - 1].nombre)")
    } else {
        print("Estación anterior: No tiene")
    }

    if indice < linea.estaciones.count - 1 {
        print("Estación siguiente: \(linea.estaciones[indice + 1].nombre)")
    } else {
        print("Estación siguiente: No tiene")
    }

    print("\nLugares cercanos:")

    if estacion.lugaresCercanos.isEmpty {

        print("- No registrados")

    } else {

        for lugar in estacion.lugaresCercanos {
            print("- \(lugar)")
        }
    }
}

// MARK: - OPCIÓN 4

func informacionLineas() {

    print("\n===== INFORMACIÓN DE LAS LÍNEAS =====")

    for linea in lineas {

        print("\n--------------------------------")
        print("\(linea.nombre)")
        print("--------------------------------")

        print("Origen: \(linea.origen)")
        print("Destino: \(linea.destino)")
        print("Estado: \(linea.estado)")

        if linea.estaciones.isEmpty {
            print("Estaciones registradas: No disponibles")
        } else {
            print("Estaciones operativas: \(linea.estaciones.count)")
        }
    }
}

// MARK: - OPCIÓN 5

func consultarLugaresCercanos() {

    print("\n===== LUGARES CERCANOS =====")

    guard let resultado = buscarEstacion() else {

        print("\nNo se encontró la estación.")
        return
    }

    let estacion = resultado.estacion
    let linea = resultado.linea

    print("\nEstación: \(estacion.nombre)")
    print("Línea: \(linea.nombre)")
    print("Distrito: \(estacion.distrito)")

    print("\nLugares cercanos:")

    if estacion.lugaresCercanos.isEmpty {

        print("- No hay lugares registrados.")

    } else {

        for lugar in estacion.lugaresCercanos {
            print("- \(lugar)")
        }
    }
}

// MARK: - BUSCAR CONEXIÓN

func buscarConexion(
    lineaOrigen: Int,
    lineaDestino: Int
) -> Conexion? {

    for conexion in conexiones {

        if conexion.linea1 == lineaOrigen &&
            conexion.linea2 == lineaDestino {

            return conexion
        }

        if conexion.linea1 == lineaDestino &&
            conexion.linea2 == lineaOrigen {

            return conexion
        }
    }

    return nil
}

// MARK: - MOSTRAR TRAMO

func mostrarTramo(
    linea: Linea,
    indiceInicio: Int,
    indiceFin: Int
) {

    if indiceInicio <= indiceFin {

        for indice in indiceInicio...indiceFin {
            print("\(indice - indiceInicio + 1). \(linea.estaciones[indice].nombre)")
        }

    } else {

        var numero = 1

        for indice in stride(
            from: indiceInicio,
            through: indiceFin,
            by: -1
        ) {

            print("\(numero). \(linea.estaciones[indice].nombre)")
            numero += 1
        }
    }
}

// MARK: - OPCIÓN 6

func planificarRuta() {

    print("\n===== PLANIFICAR RUTA =====")

    print("\nIngrese la estación de origen:")

    guard let entradaOrigen = readLine() else {
        print("Origen inválido.")
        return
    }

    print("Ingrese la estación de destino:")

    guard let entradaDestino = readLine() else {
        print("Destino inválido.")
        return
    }

    let textoOrigen = normalizarTexto(entradaOrigen)
    let textoDestino = normalizarTexto(entradaDestino)

    var origenEncontrado: (
        linea: Linea,
        indice: Int,
        estacion: Estacion
    )?

    var destinoEncontrado: (
        linea: Linea,
        indice: Int,
        estacion: Estacion
    )?

    for linea in lineas {

        for (indice, estacion) in linea.estaciones.enumerated() {

            if normalizarTexto(estacion.nombre) == textoOrigen {

                origenEncontrado = (
                    linea,
                    indice,
                    estacion
                )
            }

            if normalizarTexto(estacion.nombre) == textoDestino {

                destinoEncontrado = (
                    linea,
                    indice,
                    estacion
                )
            }
        }
    }

    guard let origen = origenEncontrado else {

        print("\nNo se encontró la estación de origen.")
        return
    }

    guard let destino = destinoEncontrado else {

        print("\nNo se encontró la estación de destino.")
        return
    }

    print("\n===== INFORMACIÓN DE LA RUTA =====")

    print("Origen: \(origen.estacion.nombre)")
    print("Línea de origen: \(origen.linea.numero)")

    print("Destino: \(destino.estacion.nombre)")
    print("Línea de destino: \(destino.linea.numero)")

    // MISMA LÍNEA

    if origen.linea.numero == destino.linea.numero {

        print("\n===== RUTA =====")

        mostrarTramo(
            linea: origen.linea,
            indiceInicio: origen.indice,
            indiceFin: destino.indice
        )

        let cantidadEstaciones =
            abs(origen.indice - destino.indice) + 1

        print("\nLínea utilizada: \(origen.linea.nombre)")
        print("Número de estaciones: \(cantidadEstaciones)")
        print("Transbordos: 0")
        print("No necesitas realizar ningún transbordo.")

        return
    }

    // LÍNEAS DIFERENTES SIN CONEXIÓN

    guard let conexion = buscarConexion(
        lineaOrigen: origen.linea.numero,
        lineaDestino: destino.linea.numero
    ) else {

        print("\n===== RUTA NO DISPONIBLE =====")

        print("\nNo existe una conexión registrada entre:")
        print("Línea \(origen.linea.numero) y Línea \(destino.linea.numero)")

        print("\nTransbordos realizados: 0")

        return
    }

    // CONEXIÓN NO OPERATIVA

    if conexion.estado != "Operativa" {

        print("\n===== RUTA NO DISPONIBLE ACTUALMENTE =====")

        print("\nOrigen: \(origen.estacion.nombre)")
        print("Línea: \(origen.linea.numero)")

        print("\nDestino: \(destino.estacion.nombre)")
        print("Línea: \(destino.linea.numero)")

        print("\nConexión prevista:")

        if conexion.linea1 == origen.linea.numero {

            print("Línea \(conexion.linea1): \(conexion.estacionLinea1)")
            print("↕")
            print("Línea \(conexion.linea2): \(conexion.estacionLinea2)")

        } else {

            print("Línea \(conexion.linea2): \(conexion.estacionLinea2)")
            print("↕")
            print("Línea \(conexion.linea1): \(conexion.estacionLinea1)")
        }

        print("\nEstado: \(conexion.estado)")
        print("Transbordo requerido: 1")
        print("Transbordo realizado: 0")

        print("\nNo es posible completar esta ruta actualmente.")

        return
    }

    // CONEXIÓN OPERATIVA

    print("\n===== RUTA CON TRANSBORDO =====")

    print("\nConexión:")
    print("Línea \(conexion.linea1): \(conexion.estacionLinea1)")
    print("↕")
    print("Línea \(conexion.linea2): \(conexion.estacionLinea2)")

    print("\nPrimer tramo:")

    if origen.linea.numero == conexion.linea1 {

        if let indiceConexion = origen.linea.estaciones.firstIndex(
            where: {
                normalizarTexto($0.nombre) ==
                normalizarTexto(conexion.estacionLinea1)
            }
        ) {

            mostrarTramo(
                linea: origen.linea,
                indiceInicio: origen.indice,
                indiceFin: indiceConexion
            )
        }

    } else {

        if let indiceConexion = origen.linea.estaciones.firstIndex(
            where: {
                normalizarTexto($0.nombre) ==
                normalizarTexto(conexion.estacionLinea2)
            }
        ) {

            mostrarTramo(
                linea: origen.linea,
                indiceInicio: origen.indice,
                indiceFin: indiceConexion
            )
        }
    }

    print("\nTransbordo en la conexión.")

    print("\nSegundo tramo:")

    if destino.linea.numero == conexion.linea1 {

        if let indiceConexion = destino.linea.estaciones.firstIndex(
            where: {
                normalizarTexto($0.nombre) ==
                normalizarTexto(conexion.estacionLinea1)
            }
        ) {

            mostrarTramo(
                linea: destino.linea,
                indiceInicio: indiceConexion,
                indiceFin: destino.indice
            )
        }

    } else {

        if let indiceConexion = destino.linea.estaciones.firstIndex(
            where: {
                normalizarTexto($0.nombre) ==
                normalizarTexto(conexion.estacionLinea2)
            }
        ) {

            mostrarTramo(
                linea: destino.linea,
                indiceInicio: indiceConexion,
                indiceFin: destino.indice
            )
        }
    }

    print("\nTransbordos: 1")
}

// MARK: - MENÚ PRINCIPAL

func mostrarMenu() {

    print("""
    
    ==========================================
            METRO DE LIMA - CONSULTA
    ==========================================
    
    1. Listar líneas
    2. Consultar estaciones de una línea
    3. Buscar una estación
    4. Consultar información de las líneas
    5. Consultar lugares cercanos
    6. Planificar una ruta
    7. Salir
    
    Seleccione una opción:
    """)
}

// MARK: - PROGRAMA PRINCIPAL

var continuar = true

while continuar {

    mostrarMenu()

    guard let entrada = readLine(),
          let opcion = Int(entrada) else {

        print("\nIngrese una opción válida.")
        continue
    }

    switch opcion {

    case 1:
        listarLineas()

    case 2:
        consultarEstacionesPorLinea()

    case 3:
        buscarYMostrarEstacion()

    case 4:
        informacionLineas()

    case 5:
        consultarLugaresCercanos()

    case 6:
        planificarRuta()

    case 7:
        print("\nPrograma finalizado.")
        continuar = false

    default:
        print("\nOpción inválida. Seleccione del 1 al 7.")
    }
}
