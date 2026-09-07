import Foundation

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
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Parque Industrial",
            distrito: "Villa El Salvador",
            avenida: "Av. Separadora Industrial",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Pumacahua",
            distrito: "Villa María del Triunfo",
            avenida: "Av. Salvador Allende",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Villa María",
            distrito: "Villa María del Triunfo",
            avenida: "Av. Pachacútec",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Juan",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Los Héroes",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "María Auxiliadora",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Pachacútec",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Atocongo",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Los Héroes",
            lugaresCercanos: [
                "Mall del Sur",
                "TECSUP"
            ]
        ),
        Estacion(
            nombre: "Jorge Chávez",
            distrito: "Santiago de Surco",
            avenida: "Av. Tomás Marsano",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Los Cabitos",
            distrito: "Santiago de Surco",
            avenida: "Av. Aviación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Ayacucho",
            distrito: "Santiago de Surco",
            avenida: "Av. Tomás Marsano",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Angamos",
            distrito: "Surquillo",
            avenida: "Av. Aviación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Borja Sur",
            distrito: "San Borja",
            avenida: "Av. Aviación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "La Cultura",
            distrito: "San Borja",
            avenida: "Av. Aviación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Nicolás Arriola",
            distrito: "La Victoria",
            avenida: "Av. Aviación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Gamarra",
            distrito: "La Victoria",
            avenida: "Av. Aviación",
            lugaresCercanos: [
                "Emporio Comercial de Gamarra"
            ]
        ),
        Estacion(
            nombre: "Miguel Grau",
            distrito: "Lima",
            avenida: "Av. Grau",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "El Ángel",
            distrito: "Lima",
            avenida: "Av. Grau",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Presbítero Maestro",
            distrito: "Lima",
            avenida: "Av. Locumba",
            lugaresCercanos: [
                "Cementerio Presbítero Maestro"
            ]
        ),
        Estacion(
            nombre: "Caja de Agua",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Pirámide del Sol",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Los Jardines",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Los Postes",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Carlos",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Martín",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Santa Rosa",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Bayóvar",
            distrito: "San Juan de Lurigancho",
            avenida: "Av. Próceres de la Independencia",
            lugaresCercanos: []
        )
    ]
)

// MARK: - LÍNEA 2

let linea2 = Linea(
    numero: 2,
    nombre: "Línea 2",
    origen: "Ate",
    destino: "Callao",
    estado: "En operación por etapas",
    estaciones: [
        Estacion(
            nombre: "Evitamiento",
            distrito: "Ate",
            avenida: "Vía de Evitamiento",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Óvalo Santa Anita",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Colectora Industrial",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Hermilio Valdizán",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Mercado Santa Anita",
            distrito: "Santa Anita",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: [
                "Mercado Mayorista de Santa Anita"
            ]
        )
    ]
)

// MARK: - LÍNEA 3

let linea3 = Linea(
    numero: 3,
    nombre: "Línea 3",
    origen: "Comas",
    destino: "San Juan de Miraflores",
    estado: "Proyecto en planificación",
    estaciones: []
)

// MARK: - LÍNEA 4

let linea4 = Linea(
    numero: 4,
    nombre: "Línea 4",
    origen: "Lima Este",
    destino: "Callao",
    estado: "Proyecto en planificación",
    estaciones: []
)

// MARK: - LÍNEA 5

let linea5 = Linea(
    numero: 5,
    nombre: "Línea 5",
    origen: "Surquillo",
    destino: "Villa El Salvador",
    estado: "Proyecto en planificación",
    estaciones: []
)

// MARK: - LÍNEA 6

let linea6 = Linea(
    numero: 6,
    nombre: "Línea 6",
    origen: "Lima Norte",
    destino: "La Molina",
    estado: "Proyecto en planificación",
    estaciones: []
)

// MARK: - COLECCIÓN

let lineas = [
    linea1,
    linea2,
    linea3,
    linea4,
    linea5,
    linea6
]

// MARK: - LISTAR LÍNEAS

func mostrarLineas() {

    print("\n===================================")
    print("          METRO DE LIMA")
    print("===================================")

    for linea in lineas {

        print("\nLínea \(linea.numero): \(linea.nombre)")
        print("Origen: \(linea.origen)")
        print("Destino: \(linea.destino)")
        print("Estado: \(linea.estado)")
    }
}

// MARK: - CONSULTAR LÍNEA

func consultarLinea() {

    print("\n===== CONSULTAR LÍNEA =====")
    print("Ingrese el número de línea (1-6): ", terminator: "")

    guard let entrada = readLine(),
          let numero = Int(entrada) else {

        print("Debe ingresar un número válido.")
        return
    }

    guard let linea = lineas.first(where: { $0.numero == numero }) else {

        print("La línea \(numero) no existe.")
        return
    }

    print("\n===== \(linea.nombre) =====")
    print("Origen: \(linea.origen)")
    print("Destino: \(linea.destino)")
    print("Estado: \(linea.estado)")

    if linea.estaciones.isEmpty {

        print("\nEsta línea todavía no tiene estaciones operativas registradas en el sistema.")

    } else {

        print("\nEstaciones:")

        for (indice, estacion) in linea.estaciones.enumerated() {

            print("\(indice + 1). \(estacion.nombre)")
        }
    }
}

// MARK: - BUSCAR ESTACIÓN

func buscarEstacion() {

    print("\n===== BUSCAR ESTACIÓN =====")
    print("Ingrese el nombre de la estación: ", terminator: "")

    guard let entrada = readLine(),
          !entrada.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {

        print("Debe ingresar el nombre de una estación.")
        return
    }

    let busqueda = entrada.trimmingCharacters(
        in: .whitespacesAndNewlines
    )

    for linea in lineas {

        for (indice, estacion) in linea.estaciones.enumerated() {

            if estacion.nombre.lowercased() == busqueda.lowercased() {

                print("\n===== ESTACIÓN ENCONTRADA =====")
                print("Estación: \(estacion.nombre)")
                print("Línea: \(linea.nombre)")
                print("Distrito: \(estacion.distrito)")
                print("Avenida: \(estacion.avenida)")

                if indice > 0 {

                    print(
                        "Estación anterior: \(linea.estaciones[indice - 1].nombre)"
                    )

                } else {

                    print(
                        "Estación anterior: No tiene, es la estación inicial."
                    )
                }

                if indice < linea.estaciones.count - 1 {

                    print(
                        "Estación siguiente: \(linea.estaciones[indice + 1].nombre)"
                    )

                } else {

                    print(
                        "Estación siguiente: No tiene, es la estación final."
                    )
                }

                if estacion.lugaresCercanos.isEmpty {

                    print("Lugares cercanos: No registrados")

                } else {

                    print("Lugares cercanos:")

                    for lugar in estacion.lugaresCercanos {

                        print("- \(lugar)")
                    }
                }

                return
            }
        }
    }

    print("\nNo se encontró la estación \"\(busqueda)\".")
}

// MARK: - LUGARES CERCANOS

func consultarLugaresCercanos() {

    print("\n===== LUGARES CERCANOS =====")
    print("Ingrese el nombre de la estación: ", terminator: "")

    guard let entrada = readLine(),
          !entrada.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {

        print("Debe ingresar una estación.")
        return
    }

    let busqueda = entrada
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()

    for linea in lineas {

        for estacion in linea.estaciones {

            if estacion.nombre.lowercased() == busqueda {

                print("\n===== \(estacion.nombre) =====")
                print("Línea: \(linea.nombre)")
                print("Distrito: \(estacion.distrito)")

                if estacion.lugaresCercanos.isEmpty {

                    print("\nNo hay lugares cercanos registrados.")

                } else {

                    print("\nLugares cercanos:")

                    for lugar in estacion.lugaresCercanos {

                        print("- \(lugar)")
                    }
                }

                return
            }
        }
    }

    print("\nNo se encontró la estación.")
}

// MARK: - CONEXIONES

func consultarConexiones() {

    print("\n===== CONEXIONES ENTRE LÍNEAS =====")

    print("\nLínea 1")
    print("Estado: Operativa")
    print("Conexiones: Línea actualmente operativa.")

    print("\nLínea 2")
    print("Estado: En operación por etapas")
    print("Conexiones: Su proyecto contempla integración con otras líneas del sistema.")

    print("\nLínea 3")
    print("Estado: Proyecto en planificación")
    print("Recorrido proyectado: Comas - San Juan de Miraflores")

    print("\nLínea 4")
    print("Estado: Proyecto en planificación")
    print("Recorrido proyectado: Lima Este - Callao")
    print("Integración proyectada con Línea 1 y Línea 2.")

    print("\nLínea 5")
    print("Estado: Proyecto en planificación")
    print("Recorrido proyectado: Surquillo - Miraflores - Chorrillos - Villa El Salvador")

    print("\nLínea 6")
    print("Estado: Proyecto en planificación")
    print("Recorrido transversal por Lima Norte, Surco y La Molina, entre otros sectores.")
}

// MARK: - MENÚ PRINCIPAL

var continuar = true

while continuar {

    print("\n")
    print("===================================")
    print("          METRO DE LIMA")
    print("===================================")
    print("1. Listar líneas")
    print("2. Consultar estaciones de una línea")
    print("3. Buscar una estación")
    print("4. Consultar conexiones entre líneas")
    print("5. Consultar lugares cercanos")
    print("6. Salir")
    print("===================================")
    print("Seleccione una opción: ", terminator: "")

    guard let opcion = readLine() else {

        print("No se pudo leer la opción.")
        continue
    }

    switch opcion {

    case "1":
        mostrarLineas()

    case "2":
        consultarLinea()

    case "3":
        buscarEstacion()

    case "4":
        consultarConexiones()

    case "5":
        consultarLugaresCercanos()

    case "6":
        print("\nGracias por usar el Metro de Lima.")
        continuar = false

    default:
        print("\nOpción inválida. Ingrese un número del 1 al 6.")
    }
}
