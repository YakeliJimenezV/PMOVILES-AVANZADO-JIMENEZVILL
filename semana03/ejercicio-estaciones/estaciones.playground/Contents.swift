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

let atocongo = Estacion(
    nombre: "Atocongo",
    distrito: "San Juan de Miraflores",
    avenida: "Av. Pedro Miotta",
    lugaresCercanos: [
        "Mall del Sur",
        "TECSUP"
    ]
)

print(atocongo.nombre)


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
        )
    ]
)

print("🚇 \(linea1.nombre)")
print("Origen: \(linea1.origen)")
print("Destino: \(linea1.destino)")
print("Estado: \(linea1.estado)")

print("\nEstaciones:")

for estacion in linea1.estaciones {
    print("- \(estacion.nombre)")
}
