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
            nombre: "Puerto del Callao",
            distrito: "Callao",
            avenida: "Av. Guardia Chalaca",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Buenos Aires",
            distrito: "Callao",
            avenida: "Av. Guardia Chalaca",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Juan Pablo II",
            distrito: "Callao",
            avenida: "Av. Juan Pablo II",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Insurgentes",
            distrito: "Bellavista",
            avenida: "Av. Insurgentes",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Carmen de la Legua",
            distrito: "Carmen de la Legua-Reynoso",
            avenida: "Av. Colonial",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Óscar Benavides",
            distrito: "Cercado de Lima",
            avenida: "Av. Colonial",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Marcos",
            distrito: "Cercado de Lima",
            avenida: "Av. Colonial",
            lugaresCercanos: [
                "Universidad Nacional Mayor de San Marcos"
            ]
        ),
        Estacion(
            nombre: "Elio",
            distrito: "Cercado de Lima",
            avenida: "Av. Venezuela",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "La Alborada",
            distrito: "Cercado de Lima",
            avenida: "Av. Venezuela",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Tingo María",
            distrito: "Cercado de Lima",
            avenida: "Av. Tingo María",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Parque Murillo",
            distrito: "Cercado de Lima",
            avenida: "Av. Arica",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Plaza Bolognesi",
            distrito: "Cercado de Lima",
            avenida: "Plaza Bolognesi",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Estación Central",
            distrito: "Cercado de Lima",
            avenida: "Av. Paseo de la República",
            lugaresCercanos: [
                "Centro Cívico",
                "Metropolitano"
            ]
        ),
        Estacion(
            nombre: "Plaza Manco Cápac",
            distrito: "La Victoria",
            avenida: "Av. Manco Cápac",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Cangallo",
            distrito: "La Victoria",
            avenida: "Av. 28 de Julio",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "28 de Julio",
            distrito: "La Victoria",
            avenida: "Av. 28 de Julio",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Nicolás Ayllón",
            distrito: "La Victoria",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Circunvalación",
            distrito: "San Luis",
            avenida: "Av. Circunvalación",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "San Juan de Dios",
            distrito: "San Luis",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        ),
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
        ),
        Estacion(
            nombre: "Prolongación Javier Prado",
            distrito: "Ate",
            avenida: "Av. Prolongación Javier Prado",
            lugaresCercanos: []
        ),
        Estacion(
            nombre: "Municipalidad de Ate",
            distrito: "Ate",
            avenida: "Av. Nicolás Ayllón",
            lugaresCercanos: []
        )
    ]
)

// MARK: - Línea 3

let linea3 = Linea(
    numero: 3,
    nombre: "Línea 3",
    origen: "Comas",
    destino: "San Juan de Miraflores",
    estado: "Planificada",
    estaciones: []
)

// MARK: - Línea 4

let linea4 = Linea(
    numero: 4,
    nombre: "Línea 4",
    origen: "Callao",
    destino: "Santa Anita",
    estado: "En desarrollo",
    estaciones: []
)

// MARK: - Línea 5

let linea5 = Linea(
    numero: 5,
    nombre: "Línea 5",
    origen: "Surquillo",
    destino: "Villa El Salvador",
    estado: "Planificada",
    estaciones: []
)

// MARK: - Línea 6

let linea6 = Linea(
    numero: 6,
    nombre: "Línea 6",
    origen: "San Martín de Porres",
    destino: "La Molina",
    estado: "Planificada",
    estaciones: []
)

// MARK: - Mostrar información de las líneas

print("======================================")
print("          🚇 METRO DE LIMA")
print("======================================")

print("\n🚇 \(linea1.nombre)")
print("Origen: \(linea1.origen)")
print("Destino: \(linea1.destino)")
print("Estado: \(linea1.estado)")
print("Estaciones registradas: \(linea1.estaciones.count)")

print("\n🚇 \(linea2.nombre)")
print("Origen: \(linea2.origen)")
print("Destino: \(linea2.destino)")
print("Estado: \(linea2.estado)")
print("Estaciones registradas: \(linea2.estaciones.count)")

print("\n🚇 \(linea3.nombre)")
print("Origen: \(linea3.origen)")
print("Destino: \(linea3.destino)")
print("Estado: \(linea3.estado)")
print("Estaciones registradas: \(linea3.estaciones.count)")

print("\n🚇 \(linea4.nombre)")
print("Origen: \(linea4.origen)")
print("Destino: \(linea4.destino)")
print("Estado: \(linea4.estado)")
print("Estaciones registradas: \(linea4.estaciones.count)")

print("\n🚇 \(linea5.nombre)")
print("Origen: \(linea5.origen)")
print("Destino: \(linea5.destino)")
print("Estado: \(linea5.estado)")
print("Estaciones registradas: \(linea5.estaciones.count)")

print("\n🚇 \(linea6.nombre)")
print("Origen: \(linea6.origen)")
print("Destino: \(linea6.destino)")
print("Estado: \(linea6.estado)")
print("Estaciones registradas: \(linea6.estaciones.count)")

print("\n======================================")
print("           FIN DEL PROGRAMA")
print("======================================")
