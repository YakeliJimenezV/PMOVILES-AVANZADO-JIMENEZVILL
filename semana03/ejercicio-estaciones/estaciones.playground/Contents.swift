
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
    let numero: Int
    let nombre: String
    let origen: String
    let destino: String
    let estado: Estado
    let tarifa: Double?
    let estaciones: [Estacion]
}

// MARK: - CONEXIÓN

struct Conexion {
    let linea1: Int
    let estacion1: String
    let linea2: Int
    let estacion2: String
    let estado: Estado
}

// MARK: - FUNCIONES GENERALES

func normalizar(_ texto: String) -> String {
    texto
        .folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_PE")
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func leerOpcion() -> String {
    readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func tarifaTexto(_ tarifa: Double) -> String {
    String(format: "S/ %.2f", tarifa)
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
        let anterior = i > 0 ? nombres[i - 1] : "Inicio de línea"
        let siguiente = i < nombres.count - 1 ? nombres[i + 1] : "Fin de línea"
        
        let distrito = i < distritos.count ? distritos[i] : "Por definir"
        let avenida = i < avenidas.count ? avenidas[i] : "Por definir"
        let estado = i < estados.count ? estados[i] : .proyectada
        
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

// MARK: - CREAR LÍNEAS

func crearLineas() -> [Linea] {
    
    let estacionesL1 = [
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
        "San Juan de Lurigancho",
        "El Agustino",
        "Cercado de Lima",
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
        "Gamarra": ["Emporio Comercial de Gamarra"],
        "La Cultura": ["Biblioteca Nacional del Perú", "Gran Teatro Nacional"],
        "Atocongo": ["Mall del Sur"],
        "Miguel Grau": ["Hospital Nacional Dos de Mayo"],
        "Villa El Salvador": ["Parque Industrial de Villa El Salvador"]
    ]
    
    let l1 = crearEstaciones(
        nombres: estacionesL1,
        distritos: distritosL1,
        avenidas: avenidasL1,
        estados: Array(repeating: .operativa, count: estacionesL1.count),
        lugares: lugaresL1
    )
    
    let estacionesL2 = [
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
    
    var estadosL2 = Array(repeating: Estado.proyectada, count: estacionesL2.count)
    
    estadosL2[17] = .operativa
    estadosL2[18] = .operativa
    estadosL2[19] = .operativa
    estadosL2[20] = .operativa
    estadosL2[21] = .operativa
    
    let lugaresL2: [String: [String]] = [
        "Evitamiento": ["Panamericana Sur"],
        "Óvalo Santa Anita": ["Mall Aventura Santa Anita"],
        "Colectora Industrial": ["Zona industrial de Santa Anita"],
        "Hermilio Valdizán": ["Hospital Hermilio Valdizán"],
        "Mercado Santa Anita": ["Gran Mercado Mayorista de Lima"]
    ]
    
    let l2 = crearEstaciones(
        nombres: estacionesL2,
        estados: estadosL2,
        lugares: lugaresL2
    )
    
    let estacionesL3 = [
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
    
    let l3 = crearEstaciones(
        nombres: estacionesL3,
        estados: Array(repeating: .proyectada, count: estacionesL3.count)
    )
    
    let estacionesL4 = [
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
    
    var estadosL4 = Array(repeating: Estado.proyectada, count: estacionesL4.count)
    
    for i in 0..<8 {
        estadosL4[i] = .construccion
    }
    
    let l4 = crearEstaciones(
        nombres: estacionesL4,
        estados: estadosL4
    )
    
    let l5 = [Estacion]()
    let l6 = [Estacion]()
    
    return [
        Linea(
            numero: 1,
            nombre: "Línea 1",
            origen: "Bayóvar",
            destino: "Villa El Salvador",
            estado: .operativa,
            tarifa: 1.50,
            estaciones: l1
        ),
        Linea(
            numero: 2,
            nombre: "Línea 2",
            origen: "Puerto del Callao",
            destino: "Municipalidad de Ate",
            estado: .construccion,
            tarifa: 1.40,
            estaciones: l2
        ),
        Linea(
            numero: 3,
            nombre: "Línea 3",
            origen: "El Álamo",
            destino: "Pedro Miotta",
            estado: .proyectada,
            tarifa: nil,
            estaciones: l3
        ),
        Linea(
            numero: 4,
            nombre: "Línea 4",
            origen: "Gambeta",
            destino: "Mercado Santa Anita",
            estado: .construccion,
            tarifa: nil,
            estaciones: l4
        ),
        Linea(
            numero: 5,
            nombre: "Línea 5",
            origen: "Chorrillos",
            destino: "Centro de Lima",
            estado: .proyectada,
            tarifa: nil,
            estaciones: l5
        ),
        Linea(
            numero: 6,
            nombre: "Línea 6",
            origen: "Independencia",
            destino: "Santiago de Surco",
            estado: .proyectada,
            tarifa: nil,
            estaciones: l6
        )
    ]
}

let lineas = crearLineas()

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
        estacion1: "Los Cabitos",
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
        estacion1: "Estación Central",
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

// MARK: - MOSTRAR INFORMACIÓN DE LÍNEA

func resumenLinea(_ linea: Linea) {
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
    
    \(linea.nombre)
    Origen: \(linea.origen)
    Destino: \(linea.destino)
    Estado: \(linea.estado.descripcion)
    Estaciones: \(linea.estaciones.count)
    Operativas: \(operativas)
    En construcción: \(construccion)
    Proyectadas: \(proyectadas)
    Tarifa: \(linea.tarifa != nil ? tarifaTexto(linea.tarifa!) : "No definida")
    """)
}

// MARK: - LISTAR LÍNEAS

func listarLineas() {
    print("\n--- LÍNEAS DEL METRO DE LIMA ---")
    
    for linea in lineas {
        resumenLinea(linea)
    }
}

// MARK: - SELECCIONAR LÍNEA

func seleccionarLinea() -> Linea? {
    print("\nIngrese el número de línea: ", terminator: "")
    
    guard let numero = Int(leerOpcion()) else {
        print("Número de línea no válido.")
        return nil
    }
    
    guard let linea = lineas.first(where: {
        $0.numero == numero
    }) else {
        print("La línea no existe.")
        return nil
    }
    
    return linea
}

// MARK: - CONSULTAR ESTACIONES

func consultarEstacionesPorLinea() {
    print("\n--- ESTACIONES POR LÍNEA ---")
    
    guard let linea = seleccionarLinea() else {
        return
    }
    
    print("\n\(linea.nombre) - \(linea.origen) → \(linea.destino)")
    
    if linea.estaciones.isEmpty {
        print("Esta línea todavía no tiene estaciones registradas.")
        return
    }
    
    for (indice, estacion) in linea.estaciones.enumerated() {
        print("\(indice + 1). \(estacion.nombre) - \(estacion.estado.descripcion)")
    }
}

// MARK: - BUSCAR ESTACIÓN

func encontrarEstacion(nombre: String) -> (Linea, Estacion)? {
    let buscada = normalizar(nombre)
    
    for linea in lineas {
        if let estacion = linea.estaciones.first(where: {
            normalizar($0.nombre) == buscada
        }) {
            return (linea, estacion)
        }
    }
    
    return nil
}

func conexionesDe(
    estacion: String,
    linea: Int
) -> [Conexion] {
    
    conexiones.filter {
        ($0.linea1 == linea &&
         normalizar($0.estacion1) == normalizar(estacion)) ||
        ($0.linea2 == linea &&
         normalizar($0.estacion2) == normalizar(estacion))
    }
}

func mostrarConexion(_ conexion: Conexion) {
    print("""
    
    Conexión:
    Línea \(conexion.linea1): \(conexion.estacion1)
    Línea \(conexion.linea2): \(conexion.estacion2)
    Estado: \(conexion.estado.descripcion)
    """)
}

func buscarEstacion() {
    print("\n--- BUSCAR ESTACIÓN ---")
    print("Ingrese el nombre de la estación: ", terminator: "")
    
    let nombre = leerOpcion()
    
    guard let resultado = encontrarEstacion(nombre: nombre) else {
        print("No se encontró la estación.")
        return
    }
    
    let linea = resultado.0
    let estacion = resultado.1
    
    print("""
    
    Estación encontrada
    
    Nombre: \(estacion.nombre)
    Línea: \(linea.nombre)
    Distrito: \(estacion.distrito)
    Avenida: \(estacion.avenida)
    Estado: \(estacion.estado.descripcion)
    Tarifa: \(linea.tarifa != nil ? tarifaTexto(linea.tarifa!) : "No definida")
    """)
    
    if let indice = linea.estaciones.firstIndex(where: {
        normalizar($0.nombre) == normalizar(estacion.nombre)
    }) {
        
        if indice > 0 {
            print("Estación anterior: \(linea.estaciones[indice - 1].nombre)")
        } else {
            print("Estación anterior: No existe")
        }
        
        if indice < linea.estaciones.count - 1 {
            print("Estación siguiente: \(linea.estaciones[indice + 1].nombre)")
        } else {
            print("Estación siguiente: No existe")
        }
    }
    
    if !estacion.lugaresCercanos.isEmpty {
        print("Lugares cercanos:")
        
        for lugar in estacion.lugaresCercanos {
            print("- \(lugar)")
        }
    } else {
        print("Lugares cercanos: No registrados")
    }
    
    let conexionesEncontradas = conexionesDe(
        estacion: estacion.nombre,
        linea: linea.numero
    )
    
    if !conexionesEncontradas.isEmpty {
        for conexion in conexionesEncontradas {
            mostrarConexion(conexion)
        }
    } else {
        print("Conexiones: No registradas")
    }
}

// MARK: - LUGARES CERCANOS

func consultarLugaresCercanos() {
    print("\n--- LUGARES CERCANOS ---")
    print("Ingrese el nombre de la estación: ", terminator: "")
    
    let nombre = leerOpcion()
    
    guard let resultado = encontrarEstacion(nombre: nombre) else {
        print("No se encontró la estación.")
        return
    }
    
    let estacion = resultado.1
    
    if estacion.lugaresCercanos.isEmpty {
        print("No hay lugares cercanos registrados para esta estación.")
        return
    }
    
    print("\nLugares cercanos a \(estacion.nombre):")
    
    for lugar in estacion.lugaresCercanos {
        print("- \(lugar)")
    }
}

// MARK: - PLANIFICAR RUTA

func indiceEstacion(
    nombre: String,
    linea: Linea
) -> Int? {
    
    linea.estaciones.firstIndex {
        normalizar($0.nombre) == normalizar(nombre)
    }
}

func imprimirRuta(
    linea: Linea,
    origen: String,
    destino: String
) {
    
    guard let indiceOrigen = indiceEstacion(
        nombre: origen,
        linea: linea
    ),
    let indiceDestino = indiceEstacion(
        nombre: destino,
        linea: linea
    ) else {
        return
    }
    
    let inicio = min(indiceOrigen, indiceDestino)
    let fin = max(indiceOrigen, indiceDestino)
    
    let ruta = linea.estaciones[inicio...fin]
    
    print("\nRecorrido:")
    
    for estacion in ruta {
        print("- \(estacion.nombre)")
    }
    
    print("\nCantidad de estaciones: \(ruta.count - 1)")
}

func distanciaAproximada(
    cantidadEstaciones: Int
) -> Double {
    
    Double(cantidadEstaciones) * 1.2
}

// MARK: - COBRAR VIAJE

func cobrarViaje(
    usuario: inout Usuario,
    tarifa: Double
) {
    
    print("\n¿Desea realizar este viaje?")
    print("1. Sí")
    print("2. No")
    print("Seleccione una opción: ", terminator: "")
    
    let opcion = leerOpcion()
    
    switch opcion {
        
    case "1":
        
        if usuario.saldo >= tarifa {
            
            usuario.saldo -= tarifa
            
            print("""
            
            Viaje realizado correctamente.
            Tarifa cobrada: \(tarifaTexto(tarifa))
            Saldo restante: \(tarifaTexto(usuario.saldo))
            """)
            
        } else {
            
            print("""
            
            Saldo insuficiente.
            Tarifa del viaje: \(tarifaTexto(tarifa))
            Saldo disponible: \(tarifaTexto(usuario.saldo))
            
            Recargue su tarjeta para realizar el viaje.
            """)
        }
        
    case "2":
        print("\nViaje cancelado. No se realizó ningún cobro.")
        
    default:
        print("\nOpción no válida. No se realizó ningún cobro.")
    }
}

// MARK: - PLANIFICAR RUTA

func planificarRuta(usuario: inout Usuario) {
    
    print("\n--- PLANIFICAR RUTA ---")
    
    print("Estación de origen: ", terminator: "")
    let origenTexto = leerOpcion()
    
    print("Estación de destino: ", terminator: "")
    let destinoTexto = leerOpcion()
    
    guard let origen = encontrarEstacion(
        nombre: origenTexto
    ) else {
        print("No se encontró la estación de origen.")
        return
    }
    
    guard let destino = encontrarEstacion(
        nombre: destinoTexto
    ) else {
        print("No se encontró la estación de destino.")
        return
    }
    
    let lineaOrigen = origen.0
    let lineaDestino = destino.0
    
    // MISMA LÍNEA
    
    if lineaOrigen.numero == lineaDestino.numero {
        
        guard let indiceOrigen = indiceEstacion(
            nombre: origen.1.nombre,
            linea: lineaOrigen
        ),
        let indiceDestino = indiceEstacion(
            nombre: destino.1.nombre,
            linea: lineaOrigen
        ) else {
            print("No se pudo calcular la ruta.")
            return
        }
        
        let cantidadEstaciones = abs(
            indiceDestino - indiceOrigen
        )
        
        print("""
        
        Ruta encontrada
        
        Línea: \(lineaOrigen.nombre)
        Origen: \(origen.1.nombre)
        Destino: \(destino.1.nombre)
        Estaciones por recorrer: \(cantidadEstaciones)
        Distancia aproximada: \(String(format: "%.1f km", distanciaAproximada(cantidadEstaciones: cantidadEstaciones)))
        """)
        
        imprimirRuta(
            linea: lineaOrigen,
            origen: origen.1.nombre,
            destino: destino.1.nombre
        )
        
        guard let tarifa = lineaOrigen.tarifa else {
            print("\nEsta línea no tiene una tarifa definida.")
            return
        }
        
        print("\nTarifa del viaje: \(tarifaTexto(tarifa))")
        print("Saldo actual: \(tarifaTexto(usuario.saldo))")
        
        cobrarViaje(
            usuario: &usuario,
            tarifa: tarifa
        )
        
    } else {
        
        // DIFERENTES LÍNEAS
        
        let conexionesEncontradas = conexiones.filter {
            ($0.linea1 == lineaOrigen.numero &&
             $0.linea2 == lineaDestino.numero) ||
            ($0.linea1 == lineaDestino.numero &&
             $0.linea2 == lineaOrigen.numero)
        }
        
        guard let conexion = conexionesEncontradas.first else {
            print("No existe una conexión registrada entre estas líneas.")
            return
        }
        
        print("""
        
        Ruta con transbordo
        
        Línea de origen: \(lineaOrigen.nombre)
        Línea de destino: \(lineaDestino.nombre)
        
        Punto de conexión:
        \(conexion.estacion1) ↔ \(conexion.estacion2)
        
        Estado de la conexión: \(conexion.estado.descripcion)
        """)
        
        if conexion.estado != .operativa {
            print("\nLa conexión todavía no está operativa.")
            print("La ruta no puede realizarse actualmente.")
            return
        }
        
        guard let tarifaOrigen = lineaOrigen.tarifa,
              let tarifaDestino = lineaDestino.tarifa else {
            print("\nNo se puede calcular la tarifa de esta ruta.")
            return
        }
        
        let tarifaTotal = tarifaOrigen + tarifaDestino
        
        print("\nTarifa total: \(tarifaTexto(tarifaTotal))")
        print("Saldo actual: \(tarifaTexto(usuario.saldo))")
        
        cobrarViaje(
            usuario: &usuario,
            tarifa: tarifaTotal
        )
    }
}

// MARK: - CONSULTAR SALDO

func consultarSaldo(usuario: Usuario) {
    
    print("""
    
    --- SALDO DE TARJETA ---
    
    Usuario: \(usuario.nombre)
    Saldo actual: \(tarifaTexto(usuario.saldo))
    """)
}

// MARK: - RECARGAR TARJETA

func recargarSaldo(usuario: inout Usuario) {
    
    print("\n--- RECARGAR TARJETA ---")
    print("Saldo actual: \(tarifaTexto(usuario.saldo))")
    print("Ingrese el monto a recargar: S/ ", terminator: "")
    
    let textoMonto = leerOpcion()
    
    guard let monto = Double(textoMonto) else {
        print("Monto no válido.")
        return
    }
    
    guard monto > 0 else {
        print("El monto debe ser mayor a S/ 0.00.")
        return
    }
    
    usuario.saldo += monto
    
    print("""
    
    Recarga realizada correctamente.
    Monto recargado: \(tarifaTexto(monto))
    Nuevo saldo: \(tarifaTexto(usuario.saldo))
    """)
}

// MARK: - MENÚ DE USUARIO

func mostrarMenuUsuario(usuario: Usuario) {
    
    print("""
    
    ====================================
               METRO DE LIMA
    ====================================
    
    Hola, \(usuario.nombre)
    Saldo actual: \(tarifaTexto(usuario.saldo))
    
    ------------- USUARIO --------------
    
    1. Listar líneas
    2. Consultar estaciones por línea
    3. Buscar estación
    4. Información de líneas
    5. Consultar lugares cercanos
    6. Planificar ruta
    7. Consultar saldo
    8. Recargar tarjeta
    9. Salir
    
    ====================================
    """)
    
    print("Seleccione una opción: ", terminator: "")
}

// MARK: - PROGRAMA PRINCIPAL

print("""
====================================
           METRO DE LIMA
====================================
""")

print("Ingrese su nombre: ", terminator: "")
let nombreUsuario = leerOpcion()

if nombreUsuario.isEmpty {
    
    print("Debe ingresar un nombre para continuar.")
    
} else {
    
    var usuarioActual = Usuario(
        nombre: nombreUsuario,
        saldo: 0.0
    )
    
    var ejecutando = true
    
    while ejecutando {
        
        mostrarMenuUsuario(
            usuario: usuarioActual
        )
        
        switch leerOpcion() {
            
        case "1":
            listarLineas()
            
        case "2":
            consultarEstacionesPorLinea()
            
        case "3":
            buscarEstacion()
            
        case "4":
            print("\n--- INFORMACIÓN DE LÍNEAS ---")
            
            lineas.forEach {
                resumenLinea($0)
            }
            
        case "5":
            consultarLugaresCercanos()
            
        case "6":
            planificarRuta(
                usuario: &usuarioActual
            )
            
        case "7":
            consultarSaldo(
                usuario: usuarioActual
            )
            
        case "8":
            recargarSaldo(
                usuario: &usuarioActual
            )
            
        case "9":
            ejecutando = false
            print("\nGracias por usar el Metro de Lima.")
            
        default:
            print("Opción no válida. Seleccione un número del 1 al 9.")
        }
    }
}


