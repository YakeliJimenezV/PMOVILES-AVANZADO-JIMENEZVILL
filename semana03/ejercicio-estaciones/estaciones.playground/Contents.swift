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

// MARK: - Línea 1 del Metro de Lima

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

// MARK: - Mostrar información

print("======================================")
print("       🚇 METRO DE LIMA")
print("======================================")

print("\n📍 \(linea1.nombre)")
print("Origen: \(linea1.origen)")
print("Destino: \(linea1.destino)")
print("Estado: \(linea1.estado)")

print("\n🚉 Estaciones de la Línea 1:")
print("--------------------------------------")

for (indice, estacion) in linea1.estaciones.enumerated() {
    print("\(indice + 1). \(estacion.nombre)")
}

print("\n======================================")
print("Total de estaciones: \(linea1.estaciones.count)")
print("======================================")
