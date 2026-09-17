import Foundation

// MARK: - ESTADOS

enum Estado {
    case operativa
    case construccion
    case proyectada

    var descripcion: String {
        switch self {
        case .operativa:
            return "Operativa"
        case .construccion:
            return "En construcción"
        case .proyectada:
            return "Proyectada"
        }
    }
}

// MARK: - USUARIO

struct Usuario {
    let nombre: String
    var saldo: Double
}

// MARK: - ESTACIÓN

struct Estacion {
    let nombre: String
    let distrito: String
    let avenida: String
    let estado: Estado
    let lugaresCercanos: [String]
    let estacionesCercanas: [String]
}

// MARK: - LÍNEA

struct Linea {
    var numero: Int
    var nombre: String
    var origen: String
    var destino: String
    var estado: Estado
    var tarifa: Double?
    var estaciones: [Estacion]
}

// MARK: - CONEXIÓN

struct Conexion {
    let linea1: Int
    let estacion1: String
    let linea2: Int
    let estacion2: String
    let estado: Estado
}

// MARK: - DATOS

func normalizar(_ texto: String) -> String {
    return texto
        .folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_PE")
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func leerOpcion() -> String {
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func tarifaTexto(_ tarifa: Double) -> String {
    return String(format: "S/ %.2f", tarifa)
}

func leerEstado() -> Estado {
    print("""
    
    Seleccione el estado:
    1. Operativa
    2. En construcción
    3. Proyectada
    """)
    
    print("Opción: ", terminator: "")
    
    switch leerOpcion() {
    case "1":
        return .operativa
    case "2":
        return .construccion
    default:
        return .proyectada
    }
}

// MARK: - CREAR ESTACIONES

func crearEstaciones(
    nombres: [String],
    distritos: [String] = [],
    avenidas: [String] = [],
    estados: [Estado] = [],
    lugares: [String: [String]] = [:]
) -> [Estacion] {
    
    var resultado: [Estacion] = []
    
    for i in 0..<nombres.count {
        
        let anterior = i > 0
            ? nombres[i - 1]
            : "Inicio de línea"
        
        let siguiente = i < nombres.count - 1
            ? nombres[i + 1]
            : "Fin de línea"
        
        let distrito = i < distritos.count
            ? distritos[i]
            : "Por definir"
        
        let avenida = i < avenidas.count
            ? avenidas[i]
            : "Por definir"
        
        let estado = i < estados.count
            ? estados[i]
            : .proyectada
        
        resultado.append(
            Estacion(
                nombre: nombres[i],
                distrito: distrito,
                avenida: avenida,
                estado: estado,
                lugaresCercanos: lugares[nombres[i]] ?? [],
                estacionesCercanas: [anterior, siguiente]
            )
        )
    }
    
    return resultado
}

func actualizarEstacionesCercanas(
    estaciones: inout [Estacion]
) {
    
    if estaciones.isEmpty {
        return
    }
    
    for i in 0..<estaciones.count {
        
        let anterior = i > 0
            ? estaciones[i - 1].nombre
            : "Inicio de línea"
        
        let siguiente = i < estaciones.count - 1
            ? estaciones[i + 1].nombre
            : "Fin de línea"
        
        let estacion = estaciones[i]
        
        estaciones[i] = Estacion(
            nombre: estacion.nombre,
            distrito: estacion.distrito,
            avenida: estacion.avenida,
            estado: estacion.estado,
            lugaresCercanos: estacion.lugaresCercanos,
            estacionesCercanas: [anterior, siguiente]
        )
    }
}

// MARK: - CREAR LÍNEAS

func crearLineas() -> [Linea] {
    
    // MARK: Línea 1
    
    let nombresL1 = [
        "Bayóvar",
        "Santa Rosa",
        "San Martín",
        "San Carlos",
        "Los Postes",
        "Los Jardines",
        "Pirámide del Sol",
        "Caja de Agua",
        "Presbítero Maestro",
        "El Ángel",
        "Miguel Grau",
        "Gamarra",
        "Arriola",
        "La Cultura",
        "San Borja Sur",
        "Angamos",
        "Cabitos",
        "Ayacucho",
        "Jorge Chávez",
        "Atocongo",
        "San Juan",
        "San Martín de Porres",
        "Villa María",
        "Pumacurco",
        "Parque Industrial",
        "Villa El Salvador"
    ]
    
    let distritosL1 = [
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "San Juan de Lurigancho",
        "El Agustino",
        "Cercado de Lima",
        "La Victoria",
        "La Victoria",
        "La Victoria",
        "La Victoria",
        "San Borja",
        "Surquillo",
        "Santiago de Surco",
        "Santiago de Surco",
        "Santiago de Surco",
        "San Juan de Miraflores",
        "San Juan de Miraflores",
        "San Juan de Miraflores",
        "Villa María del Triunfo",
        "Villa María del Triunfo",
        "Villa El Salvador",
        "Villa El Salvador"
    ]
    
    let avenidasL1 = [
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Próceres de la Independencia",
        "Av. Ancash",
        "Av. Ancash",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Aviación",
        "Av. Tomás Marsano",
        "Av. Tomás Marsano",
        "Av. Los Héroes",
        "Av. Los Héroes",
        "Av. Los Héroes",
        "Av. Pachacútec",
        "Av. Pachacútec",
        "Av. Separadora Industrial",
        "Av. Separadora Industrial"
    ]
    
    let lugaresL1: [String: [String]] = [
        "Gamarra": [
            "Emporio Comercial de Gamarra"
        ],
        "La Cultura": [
            "Biblioteca Nacional del Perú",
            "Gran Teatro Nacional"
        ],
        "Atocongo": [
            "Mall del Sur"
        ],
        "Miguel Grau": [
            "Hospital Nacional Dos de Mayo"
        ],
        "Villa El Salvador": [
            "Parque Industrial de Villa El Salvador"
        ]
    ]
    
    let estacionesL1 = crearEstaciones(
        nombres: nombresL1,
        distritos: distritosL1,
        avenidas: avenidasL1,
        estados: Array(
            repeating: .operativa,
            count: nombresL1.count
        ),
        lugares: lugaresL1
    )
    
    // MARK: Línea 2
    
    let nombresL2 = [
        "Puerto del Callao",
        "Buenos Aires",
        "Juan Pablo II",
        "Insurgentes",
        "Carmen de la Legua",
        "Óscar Benavides",
        "San Marcos",
        "Elio",
        "La Alborada",
        "Tingo María",
        "Parque Murillo",
        "Plaza Bolognesi",
        "Central",
        "28 de Julio",
        "Nicolás Ayllón",
        "Circunvalación",
        "San Juan de Lurigancho",
        "Evitamiento",
        "Óvalo Santa Anita",
        "Colectora Industrial",
        "Hermilio Valdizán",
        "Mercado Santa Anita",
        "Vista Alegre",
        "Prolongación Javier Prado",
        "Municipalidad de Ate"
    ]
    
    var estadosL2 = Array(
        repeating: Estado.proyectada,
        count: nombresL2.count
    )
    
    for i in 17...21 {
        estadosL2[i] = .operativa
    }
    
    let lugaresL2: [String: [String]] = [
        "Evitamiento": [
            "Panamericana Sur"
        ],
        "Óvalo Santa Anita": [
            "Mall Aventura Santa Anita"
        ],
        "Colectora Industrial": [
            "Zona industrial de Santa Anita"
        ],
        "Hermilio Valdizán": [
            "Hospital Hermilio Valdizán"
        ],
        "Mercado Santa Anita": [
            "Gran Mercado Mayorista de Lima"
        ]
    ]
    
    let estacionesL2 = crearEstaciones(
        nombres: nombresL2,
        estados: estadosL2,
        lugares: lugaresL2
    )
    
    // MARK: Línea 3
    
    let nombresL3 = [
        "El Álamo",
        "Naranjal",
        "Túpac Amaru",
        "Universitaria",
        "José Granda",
        "César Vallejo",
        "Independencia",
        "Cayetano Heredia",
        "Tomás Valle",
        "Habich",
        "Caquetá",
        "Tacna",
        "Jirón de la Unión",
        "Abancay",
        "Parque de la Reserva",
        "Estación Central",
        "San Luis",
        "San Borja",
        "Alejandro Velasco",
        "Juana Alarco",
        "Surco",
        "Benavides",
        "Tomás Marsano",
        "Los Héroes",
        "Atocongo",
        "San Juan",
        "Pedro Miotta"
    ]
    
    let estacionesL3 = crearEstaciones(
        nombres: nombresL3,
        estados: Array(
            repeating: .proyectada,
            count: nombresL3.count
        )
    )
    
    // MARK: Línea 4
    
    let nombresL4 = [
        "Gambeta",
        "Canta Callao",
        "Bocanegra",
        "Morales Duárez",
        "Carmen de la Legua",
        "Óscar Benavides",
        "San Martín",
        "San Marcos",
        "Elio",
        "La Alborada",
        "Tingo María",
        "Plaza Bolognesi",
        "Javier Prado",
        "San Luis",
        "La Cultura",
        "San Borja",
        "Angamos",
        "Cabitos",
        "Benavides",
        "Surco",
        "Tomás Marsano",
        "Ate",
        "Puruchuco",
        "Vista Alegre",
        "Prolongación Javier Prado",
        "Mercado Santa Anita"
    ]
    
    var estadosL4 = Array(
        repeating: Estado.proyectada,
        count: nombresL4.count
    )
    
    for i in 0..<8 {
        estadosL4[i] = .construccion
    }
    
    let estacionesL4 = crearEstaciones(
        nombres: nombresL4,
        estados: estadosL4
    )
    
    // MARK: Líneas 5 y 6
    
    let estacionesL5: [Estacion] = []
    let estacionesL6: [Estacion] = []
    
    return [
        
        Linea(
            numero: 1,
            nombre: "Línea 1",
            origen: "Bayóvar",
            destino: "Villa El Salvador",
            estado: .operativa,
            tarifa: 1.50,
            estaciones: estacionesL1
        ),
        
        Linea(
            numero: 2,
            nombre: "Línea 2",
            origen: "Puerto del Callao",
            destino: "Municipalidad de Ate",
            estado: .construccion,
            tarifa: 1.40,
            estaciones: estacionesL2
        ),
        
        Linea(
            numero: 3,
            nombre: "Línea 3",
            origen: "El Álamo",
            destino: "Pedro Miotta",
            estado: .proyectada,
            tarifa: nil,
            estaciones: estacionesL3
        ),
        
        Linea(
            numero: 4,
            nombre: "Línea 4",
            origen: "Gambeta",
            destino: "Mercado Santa Anita",
            estado: .construccion,
            tarifa: nil,
            estaciones: estacionesL4
        ),
        
        Linea(
            numero: 5,
            nombre: "Línea 5",
            origen: "Chorrillos",
            destino: "Centro de Lima",
            estado: .proyectada,
            tarifa: nil,
            estaciones: estacionesL5
        ),
        
        Linea(
            numero: 6,
            nombre: "Línea 6",
            origen: "Independencia",
            destino: "Santiago de Surco",
            estado: .proyectada,
            tarifa: nil,
            estaciones: estacionesL6
        )
    ]
}

// MARK: - CONEXIONES

let conexiones: [Conexion] = [
    
    Conexion(
        linea1: 1,
        estacion1: "La Cultura",
        linea2: 2,
        estacion2: "28 de Julio",
        estado: .proyectada
    ),
    
    Conexion(
        linea1: 1,
        estacion1: "Cabitos",
        linea2: 3,
        estacion2: "Juana Alarco",
        estado: .proyectada
    ),
    
    Conexion(
        linea1: 1,
        estacion1: "Atocongo",
        linea2: 3,
        estacion2: "Los Héroes",
        estado: .proyectada
    ),
    
    Conexion(
        linea1: 1,
        estacion1: "La Cultura",
        linea2: 4,
        estacion2: "San Luis",
        estado: .proyectada
    ),
    
    Conexion(
        linea1: 2,
        estacion1: "Central",
        linea2: 3,
        estacion2: "Estación Central",
        estado: .proyectada
    ),
    
    Conexion(
        linea1: 2,
        estacion1: "Óscar Benavides",
        linea2: 4,
        estacion2: "Carmen de la Legua",
        estado: .proyectada
    )
]

// MARK: - SISTEMA METRO

final class MetroSistema {
    
    var lineas: [Linea] = crearLineas()
    
    // MARK: LISTAR LÍNEAS
    
    func listarLineas() {
        
        print("\n--- LÍNEAS DEL METRO DE LIMA ---")
        
        for linea in lineas.sorted(by: {
            $0.numero < $1.numero
        }) {
            
            print("""
            
            Línea \(linea.numero): \(linea.nombre)
            Origen: \(linea.origen)
            Destino: \(linea.destino)
            Estado: \(linea.estado.descripcion)
            Estaciones registradas: \(linea.estaciones.count)
            Tarifa: \(linea.tarifa != nil
                     ? tarifaTexto(linea.tarifa!)
                     : "No definida")
            """)
        }
    }
    
    // MARK: SELECCIONAR LÍNEA
    
    func seleccionarLinea() -> Int? {
        
        print("\nSeleccione la línea:")
        
        for linea in lineas.sorted(by: {
            $0.numero < $1.numero
        }) {
            print("\(linea.numero). \(linea.nombre)")
        }
        
        print("Ingrese una opción: ", terminator: "")
        
        guard let numero = Int(leerOpcion()) else {
            print("Opción no válida.")
            return nil
        }
        
        guard lineas.contains(where: {
            $0.numero == numero
        }) else {
            print("La línea no existe.")
            return nil
        }
        
        return numero
    }
    
    // MARK: INFORMACIÓN DE LÍNEA
    
    func mostrarInformacionLinea() {
        
        print("\n--- INFORMACIÓN DE LÍNEA ---")
        
        guard let numero = seleccionarLinea() else {
            return
        }
        
        guard let linea = lineas.first(where: {
            $0.numero == numero
        }) else {
            return
        }
        
        let operativas = linea.estaciones.filter {
            $0.estado == .operativa
        }.count
        
        let construccion = linea.estaciones.filter {
            $0.estado == .construccion
        }.count
        
        let proyectadas = linea.estaciones.filter {
            $0.estado == .proyectada
        }.count
        
        print("""
        
        Línea: \(linea.nombre)
        Origen: \(linea.origen)
        Destino: \(linea.destino)
        Estado: \(linea.estado.descripcion)
        Estaciones registradas: \(linea.estaciones.count)
        Operativas: \(operativas)
        En construcción: \(construccion)
        Proyectadas: \(proyectadas)
        Tarifa: \(linea.tarifa != nil
                 ? tarifaTexto(linea.tarifa!)
                 : "No definida")
        """)
    }
    
    // MARK: ESTACIONES POR LÍNEA
    
    func consultarEstacionesPorLinea() {
        
        print("\n--- ESTACIONES POR LÍNEA ---")
        
        guard let numero = seleccionarLinea() else {
            return
        }
        
        guard let linea = lineas.first(where: {
            $0.numero == numero
        }) else {
            return
        }
        
        if linea.estaciones.isEmpty {
            print("\nEsta línea todavía no tiene estaciones registradas.")
            return
        }
        
        print("\n--- \(linea.nombre) ---")
        
        for (indice, estacion) in linea.estaciones.enumerated() {
            
            print(
                "\(indice + 1). \(estacion.nombre) - \(estacion.estado.descripcion)"
            )
        }
    }
    
    // MARK: BUSCAR ESTACIÓN
    
    func encontrarEstacion(
        nombre: String
    ) -> [(Linea, Estacion)] {
        
        let buscada = normalizar(nombre)
        
        var resultados: [(Linea, Estacion)] = []
        
        for linea in lineas {
            
            for estacion in linea.estaciones {
                
                if normalizar(estacion.nombre) == buscada {
                    resultados.append((linea, estacion))
                }
            }
        }
        
        return resultados
    }
    
    func buscarEstacion() {
        
        print("\n--- BUSCAR ESTACIÓN ---")
        print("Ingrese el nombre de la estación: ", terminator: "")
        
        let nombre = leerOpcion()
        
        let resultados = encontrarEstacion(
            nombre: nombre
        )
        
        if resultados.isEmpty {
            print("No se encontró la estación.")
            return
        }
        
        for (linea, estacion) in resultados {
            
            print("""
            
            Estación: \(estacion.nombre)
            Línea: \(linea.nombre)
            Estado: \(estacion.estado.descripcion)
            Distrito: \(estacion.distrito)
            Avenida: \(estacion.avenida)
            """)
            
            print("Estaciones cercanas:")
            
            for cercana in estacion.estacionesCercanas {
                print("- \(cercana)")
            }
            
            if estacion.lugaresCercanos.isEmpty == false {
                
                print("Lugares cercanos:")
                
                for lugar in estacion.lugaresCercanos {
                    print("- \(lugar)")
                }
            }
            
            let conexionesEncontradas = conexionesDe(
                linea: linea.numero,
                estacion: estacion.nombre
            )
            
            if conexionesEncontradas.isEmpty == false {
                
                print("Conexiones:")
                
                for conexion in conexionesEncontradas {
                    mostrarConexion(conexion)
                }
            }
        }
    }
    
    // MARK: LUGARES CERCANOS
    
    func consultarLugaresCercanos() {
        
        print("\n--- LUGARES CERCANOS ---")
        print("Ingrese el nombre de la estación: ", terminator: "")
        
        let nombre = leerOpcion()
        
        let resultados = encontrarEstacion(
            nombre: nombre
        )
        
        if resultados.isEmpty {
            print("No se encontró la estación.")
            return
        }
        
        for (linea, estacion) in resultados {
            
            print("\nEstación: \(estacion.nombre)")
            print("Línea: \(linea.nombre)")
            
            if estacion.lugaresCercanos.isEmpty {
                print("No hay lugares cercanos registrados.")
            } else {
                
                for lugar in estacion.lugaresCercanos {
                    print("- \(lugar)")
                }
            }
        }
    }
    
    // MARK: CONEXIONES
    
    func conexionesDe(
        linea: Int,
        estacion: String
    ) -> [Conexion] {
        
        let buscada = normalizar(estacion)
        
        return conexiones.filter { conexion in
            
            (
                conexion.linea1 == linea &&
                normalizar(conexion.estacion1) == buscada
            )
            ||
            (
                conexion.linea2 == linea &&
                normalizar(conexion.estacion2) == buscada
            )
        }
    }
    
    func mostrarConexion(_ conexion: Conexion) {
        
        print(
            "Línea \(conexion.linea1) \(conexion.estacion1) ↔ Línea \(conexion.linea2) \(conexion.estacion2) - \(conexion.estado.descripcion)"
        )
    }
    
    // MARK: RUTA
    
    func indiceEstacion(
        nombre: String,
        linea: Linea
    ) -> Int? {
        
        let buscada = normalizar(nombre)
        
        return linea.estaciones.firstIndex {
            normalizar($0.nombre) == buscada
        }
    }
    
    func imprimirRuta(
        linea: Linea,
        origen: Int,
        destino: Int
    ) {
        
        let paso = origen <= destino ? 1 : -1
        var posicion = origen
        
        while true {
            
            print("- \(linea.estaciones[posicion].nombre)")
            
            if posicion == destino {
                break
            }
            
            posicion += paso
        }
    }
    
    func distanciaAproximada(
        estaciones: Int
    ) -> Double {
        
        return Double(estaciones) * 1.2
    }
    
    // MARK: COBRAR VIAJE
    
    func cobrarViaje(
        usuario: inout Usuario,
        tarifa: Double
    ) {
        
        if usuario.saldo < tarifa {
            
            print("""
            
            Saldo insuficiente.
            Saldo actual: \(tarifaTexto(usuario.saldo))
            Tarifa: \(tarifaTexto(tarifa))
            """)
            
            return
        }
        
        usuario.saldo -= tarifa
        
        print("""
        
        Viaje realizado correctamente.
        Tarifa cobrada: \(tarifaTexto(tarifa))
        Saldo restante: \(tarifaTexto(usuario.saldo))
        """)
    }
    
    // MARK: PLANIFICAR RUTA
    
    func planificarRuta(
        usuario: inout Usuario
    ) {
        
        print("\n--- PLANIFICAR RUTA ---")
        
        print("Estación de origen: ", terminator: "")
        let origenTexto = leerOpcion()
        
        print("Estación de destino: ", terminator: "")
        let destinoTexto = leerOpcion()
        
        let origenResultados = encontrarEstacion(
            nombre: origenTexto
        )
        
        let destinoResultados = encontrarEstacion(
            nombre: destinoTexto
        )
        
        if origenResultados.isEmpty {
            print("No se encontró la estación de origen.")
            return
        }
        
        if destinoResultados.isEmpty {
            print("No se encontró la estación de destino.")
            return
        }
        
        let origen = origenResultados[0]
        let destino = destinoResultados[0]
        
        // MISMA LÍNEA
        
        if origen.0.numero == destino.0.numero {
            
            guard let indiceOrigen = indiceEstacion(
                nombre: origen.1.nombre,
                linea: origen.0
            ),
            let indiceDestino = indiceEstacion(
                nombre: destino.1.nombre,
                linea: destino.0
            ) else {
                
                print("No se pudo calcular la ruta.")
                return
            }
            
            let cantidad = abs(
                indiceDestino - indiceOrigen
            )
            
            let distancia = distanciaAproximada(
                estaciones: cantidad
            )
            
            print("""
            
            --- RUTA ENCONTRADA ---
            
            Línea: \(origen.0.nombre)
            Origen: \(origen.1.nombre)
            Destino: \(destino.1.nombre)
            Estaciones a recorrer: \(cantidad)
            Distancia aproximada: \(String(format: "%.1f", distancia)) km
            """)
            
            print("\nRecorrido:")
            
            imprimirRuta(
                linea: origen.0,
                origen: indiceOrigen,
                destino: indiceDestino
            )
            
            guard let tarifa = origen.0.tarifa else {
                
                print("\nEsta línea no tiene tarifa definida.")
                return
            }
            
            print("\nTarifa: \(tarifaTexto(tarifa))")
            
            print(
                "¿Desea realizar el viaje? (s/n): ",
                terminator: ""
            )
            
            let respuesta = normalizar(
                leerOpcion()
            )
            
            if respuesta == "s" || respuesta == "si" {
                
                cobrarViaje(
                    usuario: &usuario,
                    tarifa: tarifa
                )
                
            } else {
                
                print("Viaje cancelado.")
            }
            
            return
        }
        
        // DIFERENTES LÍNEAS
        
        let posiblesConexiones = conexiones.filter {
            conexion in
            
            (
                conexion.linea1 == origen.0.numero &&
                conexion.linea2 == destino.0.numero
            )
            ||
            (
                conexion.linea2 == origen.0.numero &&
                conexion.linea1 == destino.0.numero
            )
        }
        
        if posiblesConexiones.isEmpty {
            
            print("""
            
            No existe una conexión registrada entre
            \(origen.0.nombre) y \(destino.0.nombre).
            """)
            
            return
        }
        
        let conexion = posiblesConexiones[0]
        
        print("\n--- CONEXIÓN ENCONTRADA ---")
        mostrarConexion(conexion)
        
        if conexion.estado != .operativa {
            
            print("""
            
            Esta conexión todavía no está operativa.
            No se puede realizar el viaje por transbordo.
            """)
            
            return
        }
        
        guard let tarifa1 = origen.0.tarifa,
              let tarifa2 = destino.0.tarifa else {
            
            print("No se puede calcular la tarifa.")
            return
        }
        
        let tarifaTotal = tarifa1 + tarifa2
        
        print("""
        
        Ruta con transbordo:
        1. \(origen.0.nombre)
        2. Transbordo
        3. \(destino.0.nombre)
        
        Tarifa total: \(tarifaTexto(tarifaTotal))
        """)
        
        print(
            "¿Desea realizar el viaje? (s/n): ",
            terminator: ""
        )
        
        let respuesta = normalizar(
            leerOpcion()
        )
        
        if respuesta == "s" || respuesta == "si" {
            
            cobrarViaje(
                usuario: &usuario,
                tarifa: tarifaTotal
            )
            
        } else {
            
            print("Viaje cancelado.")
        }
    }
    
    // MARK: SALDO
    
    func consultarSaldo(
        usuario: Usuario
    ) {
        
        print("""
        
        --- SALDO ---
        Usuario: \(usuario.nombre)
        Saldo disponible: \(tarifaTexto(usuario.saldo))
        """)
    }
    
    func recargarSaldo(
        usuario: inout Usuario
    ) {
        
        print("\n--- RECARGAR TARJETA ---")
        print("Ingrese el monto: ", terminator: "")
        
        guard let monto = Double(leerOpcion()),
              monto > 0 else {
            
            print("Monto no válido.")
            return
        }
        
        usuario.saldo += monto
        
        print("""
        
        Recarga realizada correctamente.
        Monto recargado: \(tarifaTexto(monto))
        Nuevo saldo: \(tarifaTexto(usuario.saldo))
        """)
    }
    
    // MARK: MENÚ USUARIO
    
    func menuUsuario(
        usuario: inout Usuario
    ) {
        
        var ejecutando = true
        
        while ejecutando {
            
            print("""
            
            
            ========================================
                     MENÚ DE USUARIO
            ========================================
            
            Usuario: \(usuario.nombre)
            
            1. Listar líneas
            2. Consultar estaciones por línea
            3. Buscar estación
            4. Información de líneas
            5. Consultar lugares cercanos
            6. Planificar ruta
            7. Consultar saldo
            8. Recargar tarjeta
            9. Cerrar sesión
            
            Seleccione una opción:
            """)
            
            switch leerOpcion() {
                
            case "1":
                listarLineas()
                
            case "2":
                consultarEstacionesPorLinea()
                
            case "3":
                buscarEstacion()
                
            case "4":
                mostrarInformacionLinea()
                
            case "5":
                consultarLugaresCercanos()
                
            case "6":
                planificarRuta(
                    usuario: &usuario
                )
                
            case "7":
                consultarSaldo(
                    usuario: usuario
                )
                
            case "8":
                recargarSaldo(
                    usuario: &usuario
                )
                
            case "9":
                ejecutando = false
                print("\nSesión cerrada.")
                
            default:
                print("Opción no válida.")
            }
        }
    }
    
    // MARK: ADMINISTRADOR
    
    func menuAdministrador() {
        
        var ejecutando = true
        
        while ejecutando {
            
            print("""
            
            
            ========================================
                  MENÚ DE ADMINISTRADOR
            ========================================
            
            1. Ver todas las líneas
            2. Ver estaciones de una línea
            3. Buscar estación
            4. Agregar estación al final
            5. Insertar estación intermedia
            6. Crear nueva línea
            7. Cerrar sesión
            
            Seleccione una opción:
            """)
            
            switch leerOpcion() {
                
            case "1":
                listarLineas()
                
            case "2":
                consultarEstacionesPorLinea()
                
            case "3":
                buscarEstacion()
                
            case "4":
                agregarEstacionAlFinal()
                
            case "5":
                insertarEstacionIntermedia()
                
            case "6":
                crearNuevaLinea()
                
            case "7":
                ejecutando = false
                print("\nSesión de administrador cerrada.")
                
            default:
                print("Opción no válida.")
            }
        }
    }
    
    // MARK: AGREGAR ESTACIÓN
    
    func agregarEstacionAlFinal() {
        
        print("\n--- AGREGAR ESTACIÓN AL FINAL ---")
        
        guard let numero = seleccionarLinea() else {
            return
        }
        
        guard let indiceLinea = lineas.firstIndex(
            where: {
                $0.numero == numero
            }
        ) else {
            return
        }
        
        print("Nombre de la estación: ", terminator: "")
        let nombre = leerOpcion()
        
        if nombre.isEmpty {
            print("El nombre no puede estar vacío.")
            return
        }
        
        print("Distrito: ", terminator: "")
        let distrito = leerOpcion()
        
        print("Avenida: ", terminator: "")
        let avenida = leerOpcion()
        
        let estado = leerEstado()
        
        let nuevaEstacion = Estacion(
            nombre: nombre,
            distrito: distrito.isEmpty
                ? "Por definir"
                : distrito,
            avenida: avenida.isEmpty
                ? "Por definir"
                : avenida,
            estado: estado,
            lugaresCercanos: [],
            estacionesCercanas: []
        )
        
        lineas[indiceLinea].estaciones.append(
            nuevaEstacion
        )
        
        actualizarEstacionesCercanas(
            estaciones: &lineas[indiceLinea].estaciones
        )
        
        print("\nEstación agregada correctamente.")
    }
    
    // MARK: INSERTAR ESTACIÓN
    
    func insertarEstacionIntermedia() {
        
        print("\n--- INSERTAR ESTACIÓN INTERMEDIA ---")
        
        guard let numero = seleccionarLinea() else {
            return
        }
        
        guard let indiceLinea = lineas.firstIndex(
            where: {
                $0.numero == numero
            }
        ) else {
            return
        }
        
        if lineas[indiceLinea].estaciones.isEmpty {
            
            print("La línea no tiene estaciones.")
            return
        }
        
        print("\nEstaciones actuales:")
        
        for (indice, estacion) in lineas[indiceLinea].estaciones.enumerated() {
            
            print(
                "\(indice + 1). \(estacion.nombre)"
            )
        }
        
        print("\nIngrese la estación después de la cual desea insertar:")
        print("Nombre: ", terminator: "")
        
        let referencia = leerOpcion()
        
        guard let posicion = lineas[indiceLinea].estaciones.firstIndex(
            where: {
                normalizar($0.nombre) == normalizar(referencia)
            }
        ) else {
            
            print("No se encontró la estación indicada.")
            return
        }
        
        print("Nombre de la nueva estación: ", terminator: "")
        let nombre = leerOpcion()
        
        if nombre.isEmpty {
            print("El nombre no puede estar vacío.")
            return
        }
        
        print("Distrito: ", terminator: "")
        let distrito = leerOpcion()
        
        print("Avenida: ", terminator: "")
        let avenida = leerOpcion()
        
        let estado = leerEstado()
        
        let nuevaEstacion = Estacion(
            nombre: nombre,
            distrito: distrito.isEmpty
                ? "Por definir"
                : distrito,
            avenida: avenida.isEmpty
                ? "Por definir"
                : avenida,
            estado: estado,
            lugaresCercanos: [],
            estacionesCercanas: []
        )
        
        lineas[indiceLinea].estaciones.insert(
            nuevaEstacion,
            at: posicion + 1
        )
        
        actualizarEstacionesCercanas(
            estaciones: &lineas[indiceLinea].estaciones
        )
        
        print("\nEstación insertada correctamente.")
    }
    
    // MARK: CREAR NUEVA LÍNEA
    
    func crearNuevaLinea() {
        
        print("\n--- CREAR NUEVA LÍNEA ---")
        
        let nuevoNumero = (
            lineas.map {
                $0.numero
            }.max() ?? 0
        ) + 1
        
        print("Número asignado: \(nuevoNumero)")
        
        print("Nombre de la línea: ", terminator: "")
        let nombre = leerOpcion()
        
        if nombre.isEmpty {
            print("El nombre no puede estar vacío.")
            return
        }
        
        print("Origen: ", terminator: "")
        let origen = leerOpcion()
        
        print("Destino: ", terminator: "")
        let destino = leerOpcion()
        
        let estado = leerEstado()
        
        print("¿Desea agregar una tarifa? (s/n): ", terminator: "")
        let respuesta = normalizar(leerOpcion())
        
        var tarifa: Double? = nil
        
        if respuesta == "s" || respuesta == "si" {
            
            print("Ingrese la tarifa: ", terminator: "")
            
            if let valor = Double(leerOpcion()),
               valor >= 0 {
                
                tarifa = valor
            }
        }
        
        let nuevaLinea = Linea(
            numero: nuevoNumero,
            nombre: nombre,
            origen: origen,
            destino: destino,
            estado: estado,
            tarifa: tarifa,
            estaciones: []
        )
        
        lineas.append(nuevaLinea)
        
        print("""
        
        Línea creada correctamente.
        Número: \(nuevoNumero)
        """)
    }
    
    // MARK: INICIAR SISTEMA
    
    func iniciar() {
        
        print("""
        
        
        ========================================
              SISTEMA METRO DE LIMA
        ========================================
        """)
        
        print("Ingrese su nombre: ", terminator: "")
        
        let nombre = leerOpcion()
        
        if nombre.isEmpty {
            
            print("Debe ingresar un nombre para continuar.")
            return
        }
        
        var usuario = Usuario(
            nombre: nombre,
            saldo: 0.0
        )
        
        var ejecutando = true
        
        while ejecutando {
            
            print("""
            
            
            ========================================
                    INICIO DE SESIÓN
            ========================================
            
            1. Ingresar como usuario
            2. Ingresar como administrador
            3. Salir
            
            Seleccione una opción:
            """)
            
            switch leerOpcion() {
                
            case "1":
                
                menuUsuario(
                    usuario: &usuario
                )
                
            case "2":
                
                print("\n--- ACCESO ADMINISTRADOR ---")
                print("Contraseña: ", terminator: "")
                
                let password = leerOpcion()
                
                if password == "admin123" {
                    
                    print("\nAcceso correcto.")
                    
                    menuAdministrador()
                    
                } else {
                    
                    print("\nContraseña incorrecta.")
                }
                
            case "3":
                
                ejecutando = false
                
                print("""
                
                
                ========================================
                Gracias por usar el Metro de Lima.
                ========================================
                """)
                
            default:
                
                print("Opción no válida.")
            }
        }
    }
}

// MARK: - EJECUTAR

let sistemaMetro = MetroSistema()
sistemaMetro.iniciar()
