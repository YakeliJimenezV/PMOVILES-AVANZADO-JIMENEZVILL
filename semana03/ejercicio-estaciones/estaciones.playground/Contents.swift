import Foundation

// MARK: - Modelo de Estación

struct Estacion {
    let nombre: String
    let distrito: String
    let avenida: String
    let lugaresCercanos: [String]
}

// MARK: - Modelo de Línea

struct Linea {
    let numero: Int
    let nombre: String
    let origen: String
    let destino: String
    let estado: String
    let estaciones: [Estacion]
}

// MARK: - Línea 1

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
            avenida: "Av. Unión",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Villa María",
            distrito: "Villa María del Triunfo",
            avenida: "Av. Pachacútec",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "María Auxiliadora",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Miguel Iglesias",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Juan",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Los Héroes",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Atocongo",
            distrito: "San Juan de Miraflores",
            avenida: "Av. Pedro Miotta",
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
            avenida: "Av. Ayacucho",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Angamos",
            distrito: "San Borja",
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
            distrito: "Cercado de Lima",
            avenida: "Av. Miguel Grau",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "El Ángel",
            distrito: "Cercado de Lima",
            avenida: "Av. Locumba",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Presbítero Maestro",
            distrito: "Cercado de Lima",
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

// MARK: - Línea 2

let linea2 = Linea(
    numero: 2,
    nombre: "Línea 2",
    origen: "Puerto del Callao",
    destino: "Municipalidad de Ate",
    estado: "Operativa parcialmente",
    estaciones: [
        Estacion(
            nombre: "Evitamiento",
            distrito: "Ate",
            avenida: "Av. Nicolás Ayllón",
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
        ),
        Estacion(
            nombre: "Vista Alegre",
            distrito: "Ate",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        )
    ]
)

// MARK: - Líneas 3, 4, 5 y 6

let linea3 = Linea(
    numero: 3,
    nombre: "Línea 3",
    origen: "Comas",
    destino: "San Juan de Miraflores",
    estado: "Proyectada",
    estaciones: []
)

let linea4 = Linea(
    numero: 4,
    nombre: "Línea 4",
    origen: "Callao",
    destino: "La Molina",
    estado: "Proyectada",
    estaciones: []
)

let linea5 = Linea(
    numero: 5,
    nombre: "Línea 5",
    origen: "Chorrillos",
    destino: "Villa El Salvador",
    estado: "Proyectada",
    estaciones: []
)

let linea6 = Linea(
    numero: 6,
    nombre: "Línea 6",
    origen: "Independencia",
    destino: "Santiago de Surco",
    estado: "Proyectada",
    estaciones: []
)

// MARK: - Colección general

let lineas = [
    linea1,
    linea2,
    linea3,
    linea4,
    linea5,
    linea6
]

// MARK: - Mostrar líneas

func mostrarLineas() {

    print("\n========================================")
    print("       🚇 LÍNEAS DEL METRO DE LIMA")
    print("========================================")

    for linea in lineas {

        print("\n🚇 \(linea.nombre)")
        print("   Origen: \(linea.origen)")
        print("   Destino: \(linea.destino)")
        print("   Estado: \(linea.estado)")
        print("   Estaciones registradas: \(linea.estaciones.count)")
    }

    print("\n========================================")
}

// MARK: - Consultar información de una línea

func consultarLinea() {

    print("\n========================================")
    print("       🔎 CONSULTAR LÍNEA")
    print("========================================")

    print("Ingrese el número de línea (1-6): ", terminator: "")

    guard let entrada = readLine(),
          let numero = Int(entrada) else {

        print("\n❌ Debe ingresar un número válido.")
        return
    }

    guard let linea = lineas.first(where: { $0.numero == numero }) else {

        print("\n❌ No existe una línea con ese número.")
        return
    }

    print("\n🚇 \(linea.nombre)")
    print("Origen: \(linea.origen)")
    print("Destino: \(linea.destino)")
    print("Estado: \(linea.estado)")

    if linea.estaciones.isEmpty {

        print("\nℹ️ Esta línea todavía no tiene estaciones registradas en la aplicación.")

    } else {

        print("\n📍 ESTACIONES:")

        for (indice, estacion) in linea.estaciones.enumerated() {

            print("\(indice + 1). \(estacion.nombre)")
        }
    }

    print("\n========================================")
}

// MARK: - Menú principal

var continuar = true

while continuar {

    print("""
    
    ========================================
              🚇 METRO DE LIMA
    ========================================
    
    1. Listar líneas
    2. Consultar estaciones de una línea
    3. Salir
    
    Seleccione una opción:
    """, terminator: "")

    let opcion = readLine()

    switch opcion {

    case "1":

        mostrarLineas()

    case "2":

        consultarLinea()

    case "3":

        continuar = false

        print("""
        
        ========================================
        🚇 Gracias por usar Metro de Lima
        ========================================
        """)

    default:

        print("\n Opción no válida. Seleccione 1, 2 o 3.")
    }
}
