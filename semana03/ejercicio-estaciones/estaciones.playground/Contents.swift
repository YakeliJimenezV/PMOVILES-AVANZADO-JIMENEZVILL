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
        Estacion(nombre: "Villa El Salvador", distrito: "Villa El Salvador", avenida: "Av. Separadora Industrial", lugaresCercanos: []),
        Estacion(nombre: "Parque Industrial", distrito: "Villa El Salvador", avenida: "Av. Separadora Industrial", lugaresCercanos: []),
        Estacion(nombre: "Pumacahua", distrito: "Villa María del Triunfo", avenida: "Av. Salvador Allende", lugaresCercanos: []),
        Estacion(nombre: "Villa María", distrito: "Villa María del Triunfo", avenida: "Av. Pachacútec", lugaresCercanos: []),
        Estacion(nombre: "María Auxiliadora", distrito: "San Juan de Miraflores", avenida: "Av. Pachacútec", lugaresCercanos: []),
        Estacion(nombre: "San Juan", distrito: "San Juan de Miraflores", avenida: "Av. Los Héroes", lugaresCercanos: []),
        Estacion(nombre: "Atocongo", distrito: "San Juan de Miraflores", avenida: "Av. Los Héroes", lugaresCercanos: ["Mall del Sur", "TECSUP"]),
        Estacion(nombre: "Jorge Chávez", distrito: "Surco", avenida: "Av. Tomás Marsano", lugaresCercanos: []),
        Estacion(nombre: "Los Cabitos", distrito: "Santiago de Surco", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "Ayacucho", distrito: "Santiago de Surco", avenida: "Av. Tomás Marsano", lugaresCercanos: []),
        Estacion(nombre: "Angamos", distrito: "Surquillo", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "San Borja Sur", distrito: "San Borja", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "La Cultura", distrito: "San Borja", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "Nicolás Arriola", distrito: "La Victoria", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "Gamarra", distrito: "La Victoria", avenida: "Av. Aviación", lugaresCercanos: ["Emporio Comercial de Gamarra"]),
        Estacion(nombre: "Miguel Grau", distrito: "Lima", avenida: "Av. Aviación", lugaresCercanos: []),
        Estacion(nombre: "El Ángel", distrito: "Lima", avenida: "Av. Grau", lugaresCercanos: []),
        Estacion(nombre: "Presbítero Maestro", distrito: "Lima", avenida: "Av. Locumba", lugaresCercanos: ["Cementerio Presbítero Maestro"]),
        Estacion(nombre: "Caja de Agua", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "Pirámide del Sol", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "Los Jardines", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "Los Postes", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "San Carlos", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "San Martín", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "Santa Rosa", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: []),
        Estacion(nombre: "Bayóvar", distrito: "San Juan de Lurigancho", avenida: "Av. Próceres de la Independencia", lugaresCercanos: [])
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
        Estacion(nombre: "Evitamiento", distrito: "Ate", avenida: "Vía de Evitamiento", lugaresCercanos: []),
        Estacion(nombre: "Óvalo Santa Anita", distrito: "Santa Anita", avenida: "Av. Nicolás Ayllón", lugaresCercanos: []),
        Estacion(nombre: "Colectora Industrial", distrito: "Santa Anita", avenida: "Av. Nicolás Ayllón", lugaresCercanos: []),
        Estacion(nombre: "Hermilio Valdizán", distrito: "Santa Anita", avenida: "Av. Nicolás Ayllón", lugaresCercanos: []),
        Estacion(nombre: "Mercado Santa Anita", distrito: "Santa Anita", avenida: "Av. Nicolás Ayllón", lugaresCercanos: ["Mercado Mayorista de Santa Anita"])
    ]
)

// MARK: - LÍNEAS 3 A 6

let linea3 = Linea(
    numero: 3,
    nombre: "Línea 3",
    origen: "Lima Norte",
    destino: "Lima Sur",
    estado: "En planificación",
    estaciones: []
)

let linea4 = Linea(
    numero: 4,
    nombre: "Línea 4",
    origen: "Callao",
    destino: "La Molina",
    estado: "En planificación",
    estaciones: []
)

let linea5 = Linea(
    numero: 5,
    nombre: "Línea 5",
    origen: "Surquillo",
    destino: "Villa El Salvador",
    estado: "En planificación",
    estaciones: []
)

let linea6 = Linea(
    numero: 6,
    nombre: "Línea 6",
    origen: "San Martín de Porres",
    destino: "La Molina",
    estado: "En planificación",
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

// MARK: - FUNCIONES

func mostrarLineas() {
    print("\n===== LÍNEAS DEL METRO DE LIMA =====")

    for linea in lineas {
        print("\nLínea \(linea.numero): \(linea.nombre)")
        print("Origen: \(linea.origen)")
        print("Destino: \(linea.destino)")
        print("Estado: \(linea.estado)")
    }
}

func consultarLinea() {
    print("\nIngrese el número de línea (1-6): ", terminator: "")

    guard let entrada = readLine(),
          let numero = Int(entrada) else {
        print(" Debe ingresar un número válido.")
        return
    }

    guard let linea = lineas.first(where: { $0.numero == numero }) else {
        print(" La línea \(numero) no existe.")
        return
    }

    print("\n===== \(linea.nombre) =====")
    print("Origen: \(linea.origen)")
    print("Destino: \(linea.destino)")
    print("Estado: \(linea.estado)")

    if linea.estaciones.isEmpty {
        print("\n Esta línea todavía no tiene estaciones registradas.")
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
        print(" Debe ingresar el nombre de una estación.")
        return
    }

    let busqueda = entrada.trimmingCharacters(in: .whitespacesAndNewlines)

    for linea in lineas {

        for (indice, estacion) in linea.estaciones.enumerated() {

            if estacion.nombre.lowercased() == busqueda.lowercased() {

                print("\n===== ESTACIÓN ENCONTRADA =====")
                print("Estación: \(estacion.nombre)")
                print("Línea: \(linea.nombre)")
                print("Distrito: \(estacion.distrito)")
                print("Avenida: \(estacion.avenida)")

                // Estación anterior
                if indice > 0 {
                    let anterior = linea.estaciones[indice - 1]
                    print("Estación anterior: \(anterior.nombre)")
                } else {
                    print("Estación anterior: No tiene, es la estación inicial.")
                }

                // Estación siguiente
                if indice < linea.estaciones.count - 1 {
                    let siguiente = linea.estaciones[indice + 1]
                    print("Estación siguiente: \(siguiente.nombre)")
                } else {
                    print("Estación siguiente: No tiene, es la estación final.")
                }

                // Lugares cercanos
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

    print("\n No se encontró la estación \"\(busqueda)\".")
}

// MARK: - MENÚ PRINCIPAL

var continuar = true

while continuar {

    print("\n")
    print("===================================")
    print("       METRO DE LIMA")
    print("===================================")
    print("1. Listar líneas")
    print("2. Consultar estaciones de una línea")
    print("3. Buscar una estación")
    print("4. Salir")
    print("===================================")
    print("Seleccione una opción: ", terminator: "")

    guard let opcion = readLine() else {
        print(" No se pudo leer la opción.")
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
        print("\n👋 Gracias por usar el Metro de Lima.")
        continuar = false

    default:
        print("\n Opción inválida. Ingrese un número del 1 al 4.")
    }
}
