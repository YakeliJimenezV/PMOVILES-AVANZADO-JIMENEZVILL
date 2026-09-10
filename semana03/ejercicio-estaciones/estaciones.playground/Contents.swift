
import Foundation

enum Estado {
    case operativa, construccion, proyectada
    
    var descripcion: String {
        switch self {
        case .operativa: return "Operativa"
        case .construccion: return "En construcción"
        case .proyectada: return "Proyectada"
        }
    }
}

struct Estacion {
    let nombre: String
    let distrito: String
    let avenida: String
    let estado: Estado
    let lugaresCercanos: [String]
    let estacionesCercanas: [String]
}

struct Linea {
    let numero: Int
    let nombre: String
    let origen: String
    let destino: String
    let estado: Estado
    let tarifa: Double?
    let estaciones: [Estacion]
}

struct Conexion {
    let linea1: Int
    let estacion1: String
    let linea2: Int
    let estacion2: String
    let estado: Estado
}

// MARK: - FUNCIONES GENERALES

func normalizar(_ texto: String) -> String {
    texto.folding(options: [.diacriticInsensitive, .caseInsensitive],
                  locale: Locale(identifier: "es_PE"))
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func leerOpcion() -> String {
    readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func tarifaTexto(_ tarifa: Double?) -> String {
    tarifa.map { String(format: "S/ %.2f", $0) } ?? "No definida"
}

// MARK: - CREAR ESTACIONES

func crearEstaciones(
    nombres: [String],
    estados: [Estado],
    lugares: [String: [String]] = [:],
    avenidas: [String: String] = [:],
    distritos: [String: String] = [:]
) -> [Estacion] {
    
    nombres.enumerated().map { i, nombre in
        let cercanas = [
            i > 0 ? nombres[i - 1] : nil,
            i < nombres.count - 1 ? nombres[i + 1] : nil
        ].compactMap { $0 }
        
        return Estacion(
            nombre: nombre,
            distrito: distritos[nombre] ?? "Lima Metropolitana",
            avenida: avenidas[nombre] ?? "Ubicación no registrada",
            estado: estados[i],
            lugaresCercanos: lugares[nombre] ?? [],
            estacionesCercanas: cercanas
        )
    }
}

// MARK: - CREAR LÍNEAS

func crearLineas() -> [Linea] {
    
    // LÍNEA 1
    let nombresL1 = [
        "Bayóvar","Santa Rosa","San Martín","San Carlos","Los Postes",
        "Los Jardines","Pirámide del Sol","Caja de Agua","Presbítero Maestro",
        "El Ángel","Miguel Grau","Gamarra","Nicolás Arriola","La Cultura",
        "San Borja Sur","Angamos","Los Cabitos","Ayacucho","Jorge Chávez",
        "Atocongo","San Juan","María Auxiliadora","Villa María","Pumacahua",
        "Parque Industrial","Villa El Salvador"
    ]
    
    let lugaresL1: [String: [String]] = [
        "Gamarra":["Emporio Comercial de Gamarra"],
        "La Cultura":["Biblioteca Nacional del Perú","Gran Teatro Nacional"],
        "Miguel Grau":["Hospital Nacional Dos de Mayo","Cementerio El Ángel"],
        "Angamos":["Real Plaza Angamos"],
        "Los Cabitos":["Centro Comercial Caminos del Inca"],
        "Atocongo":["Mall del Sur"],
        "Villa El Salvador":["Parque Industrial de Villa El Salvador"]
    ]
    
    let avenidasL1: [String: String] = [
        "Bayóvar":"Av. Fernando Wiesse",
        "Santa Rosa":"Av. Fernando Wiesse",
        "San Martín":"Av. Fernando Wiesse",
        "San Carlos":"Av. Fernando Wiesse",
        "Los Postes":"Av. Próceres de la Independencia",
        "Los Jardines":"Av. Próceres de la Independencia",
        "Pirámide del Sol":"Av. Próceres de la Independencia",
        "Caja de Agua":"Av. Próceres de la Independencia",
        "Presbítero Maestro":"Av. Locumba",
        "El Ángel":"Av. Ancash",
        "Miguel Grau":"Av. Miguel Grau",
        "Gamarra":"Av. Aviación",
        "Nicolás Arriola":"Av. Aviación",
        "La Cultura":"Av. Aviación",
        "San Borja Sur":"Av. Aviación",
        "Angamos":"Av. Aviación",
        "Los Cabitos":"Av. Aviación",
        "Ayacucho":"Av. Ayacucho",
        "Jorge Chávez":"Av. Jorge Chávez",
        "Atocongo":"Av. Tomás Marsano",
        "San Juan":"Av. Los Héroes",
        "María Auxiliadora":"Av. Los Héroes",
        "Villa María":"Av. Pachacútec",
        "Pumacahua":"Av. Pachacútec",
        "Parque Industrial":"Av. El Sol",
        "Villa El Salvador":"Av. Separadora Industrial"
    ]
    
    let distritosL1: [String: String] = [
        "Gamarra":"La Victoria","La Cultura":"San Borja",
        "San Borja Sur":"San Borja","Angamos":"San Borja",
        "Los Cabitos":"Santiago de Surco","Ayacucho":"Santiago de Surco",
        "Atocongo":"San Juan de Miraflores","San Juan":"San Juan de Miraflores",
        "María Auxiliadora":"San Juan de Miraflores",
        "Villa María":"Villa María del Triunfo",
        "Pumacahua":"Villa María del Triunfo",
        "Parque Industrial":"Villa El Salvador",
        "Villa El Salvador":"Villa El Salvador"
    ]
    
    let l1 = Linea(
        numero: 1,
        nombre: "Línea 1",
        origen: "Villa El Salvador",
        destino: "Bayóvar",
        estado: .operativa,
        tarifa: 1.50,
        estaciones: crearEstaciones(
            nombres: nombresL1,
            estados: Array(repeating: .operativa, count: nombresL1.count),
            lugares: lugaresL1,
            avenidas: avenidasL1,
            distritos: distritosL1
        )
    )
    
    // LÍNEA 2
    let nombresL2 = [
        "Puerto Callao","Buenos Aires","Juan Pablo II","Óscar Benavides",
        "San Marcos","Elio","La Alborada","Tingo María","Parque Murillo",
        "Plaza Bolognesi","Estación Central","Plaza Manco Cápac","Cangallo",
        "28 de Julio","Nicolás Ayllón","Circunvalación","San Juan de Dios",
        "Evitamiento","Óvalo Santa Anita","Colectora Industrial",
        "Hermilio Valdizán","Mercado Santa Anita","Vista Alegre",
        "Prolongación Javier Prado","Municipalidad de Ate"
    ]
    
    var estadosL2 = Array(repeating: Estado.proyectada, count: nombresL2.count)
    for i in 17...21 { estadosL2[i] = .operativa }
    
    let lugaresL2: [String: [String]] = [
        "Evitamiento":["Mall Aventura Santa Anita","Cinepolis Santa Anita","Puente Santa Anita"],
        "Óvalo Santa Anita":["Mall Aventura Santa Anita","Av. La Molina","Carretera Central","Zona comercial de Santa Anita"],
        "Colectora Industrial":["Zona Industrial de Ate","Av. Colectora Industrial","Colegio Saco Oliveros"],
        "Hermilio Valdizán":["Hospital Hermilio Valdizán","Hospital Jorge Voto Bernales","Hospital Geriátrico San Isidro Labrador","Mercado de Productores","Gran Mercado Mayorista de Lima"],
        "Mercado Santa Anita":["Gran Mercado Mayorista de Lima","Mercado Mayorista de Santa Anita","Av. Separadora Industrial","Av. Nicolás Ayllón"]
    ]
    
    let avenidasL2: [String: String] = [
        "Puerto Callao":"Av. Néstor Gambetta","Buenos Aires":"Av. Buenos Aires",
        "Juan Pablo II":"Av. Juan Pablo II","Óscar Benavides":"Av. Óscar R. Benavides",
        "San Marcos":"Av. Universitaria","Elio":"Av. Elmer Faucett",
        "La Alborada":"Av. Elmer Faucett","Tingo María":"Av. Tingo María",
        "Parque Murillo":"Av. Tingo María","Plaza Bolognesi":"Av. Alfonso Ugarte",
        "Estación Central":"Av. Paseo de la República","Plaza Manco Cápac":"Av. Abancay",
        "Cangallo":"Av. Grau","28 de Julio":"Av. 28 de Julio",
        "Nicolás Ayllón":"Av. Nicolás Ayllón","Circunvalación":"Av. Circunvalación",
        "San Juan de Dios":"Av. Nicolás Ayllón",
        "Evitamiento":"Av. Nicolás Ayllón / Vía de Evitamiento",
        "Óvalo Santa Anita":"Carretera Central / Av. La Molina",
        "Colectora Industrial":"Av. Nicolás Ayllón / Av. Colectora Industrial",
        "Hermilio Valdizán":"Carretera Central",
        "Mercado Santa Anita":"Av. Nicolás Ayllón / Av. Separadora Industrial",
        "Vista Alegre":"Av. Metropolitana",
        "Prolongación Javier Prado":"Prolongación Av. Javier Prado",
        "Municipalidad de Ate":"Carretera Central"
    ]
    
    let distritosL2: [String: String] = [
        "Evitamiento":"Santa Anita",
        "Óvalo Santa Anita":"Santa Anita / Ate",
        "Colectora Industrial":"Santa Anita / Ate",
        "Hermilio Valdizán":"Ate",
        "Mercado Santa Anita":"Santa Anita"
    ]
    
    let l2 = Linea(
        numero: 2,
        nombre: "Línea 2",
        origen: "Puerto Callao",
        destino: "Municipalidad de Ate",
        estado: .construccion,
        tarifa: 1.40,
        estaciones: crearEstaciones(
            nombres: nombresL2,
            estados: estadosL2,
            lugares: lugaresL2,
            avenidas: avenidasL2,
            distritos: distritosL2
        )
    )
    
    // LÍNEA 3
    let nombresL3 = [
        "El Álamo","Huandoy","2 de Octubre","Villa Sol","Naranjal",
        "Carlos Izaguirre","Tomás Valle","Bartolomé de las Casas","José Granda",
        "Caquetá","Tacna","Garcilaso de la Vega","Estación Central",
        "Parque de la Reserva","Museo de Historia Natural","César Canevaro",
        "Conde de San Isidro","Andrés Aramburú","Huaca Pucllana",
        "Parque Central Miraflores","Parque Reducto","Panamá","Juana Alarco",
        "Alejandro Velasco","Las Gardenias","Los Héroes","Pedro Miotta"
    ]
    
    let l3 = Linea(
        numero: 3,
        nombre: "Línea 3",
        origen: "El Álamo",
        destino: "Pedro Miotta",
        estado: .proyectada,
        tarifa: nil,
        estaciones: crearEstaciones(
            nombres: nombresL3,
            estados: Array(repeating: .proyectada, count: nombresL3.count)
        )
    )
    
    // LÍNEA 4
    let nombresL4 = [
        "Gambeta","Canta Callao","Bocanegra","Aeropuerto","El Olivar",
        "Quilca","Morales Duárez","Carmen de la Legua","Venezuela",
        "Rafael Escardó","Pando","José de Sucre","Brasil","Felipe Salaverry",
        "Guillermo Prescott","Las Palmeras","Rivera Navarrete",
        "Pablo Carriquiry","San Luis","Monterrico","Manuel Olguín",
        "Los Frutales","La Molina","Santa Patricia","Mayorazgo",
        "Mercado Santa Anita"
    ]
    
    var estadosL4 = Array(repeating: Estado.proyectada, count: nombresL4.count)
    for i in 0...7 { estadosL4[i] = .construccion }
    
    let l4 = Linea(
        numero: 4,
        nombre: "Línea 4",
        origen: "Gambeta",
        destino: "Mercado Santa Anita",
        estado: .construccion,
        tarifa: nil,
        estaciones: crearEstaciones(
            nombres: nombresL4,
            estados: estadosL4
        )
    )
    
    // LÍNEA 5 Y 6
    let l5 = Linea(
        numero: 5, nombre: "Línea 5",
        origen: "Chorrillos", destino: "Centro de Lima",
        estado: .proyectada, tarifa: nil, estaciones: []
    )
    
    let l6 = Linea(
        numero: 6, nombre: "Línea 6",
        origen: "Independencia", destino: "Santiago de Surco",
        estado: .proyectada, tarifa: nil, estaciones: []
    )
    
    return [l1,l2,l3,l4,l5,l6]
}

// MARK: - DATOS PRINCIPALES

let lineas = crearLineas()

let conexiones: [Conexion] = [
    Conexion(linea1: 1, estacion1: "La Cultura", linea2: 2, estacion2: "28 de Julio", estado: .proyectada),
    Conexion(linea1: 1, estacion1: "Los Cabitos", linea2: 3, estacion2: "Juana Alarco", estado: .proyectada),
    Conexion(linea1: 1, estacion1: "Atocongo", linea2: 3, estacion2: "Los Héroes", estado: .proyectada),
    Conexion(linea1: 1, estacion1: "La Cultura", linea2: 4, estacion2: "San Luis", estado: .proyectada),
    Conexion(linea1: 2, estacion1: "Estación Central", linea2: 3, estacion2: "Estación Central", estado: .proyectada),
    Conexion(linea1: 2, estacion1: "Óscar Benavides", linea2: 4, estacion2: "Carmen de la Legua", estado: .proyectada)
]

// MARK: - INFORMACIÓN DE LÍNEAS

func resumenLinea(_ linea: Linea) {
    let operativas = linea.estaciones.filter { $0.estado == .operativa }.count
    let construccion = linea.estaciones.filter { $0.estado == .construccion }.count
    let proyectadas = linea.estaciones.filter { $0.estado == .proyectada }.count
    
    print("""
    
    \(linea.nombre)
    Origen: \(linea.origen)
    Destino: \(linea.destino)
    Estado: \(linea.estado.descripcion.uppercased())
    """)
    
    if linea.numero == 2 {
        print("Servicio actual: \(operativas) estaciones operativas")
    }
    
    print("""
    Estaciones registradas: \(linea.estaciones.count)
    Operativas: \(operativas)
    En construcción: \(construccion)
    Proyectadas: \(proyectadas)
    Tarifa: \(tarifaTexto(linea.tarifa))
    """)
}

func listarLineas() {
    print("\n--- LÍNEAS DEL METRO DE LIMA ---")
    lineas.forEach { resumenLinea($0) }
}

// MARK: - CONSULTAR ESTACIONES

func seleccionarLinea() -> Linea? {
    print("\nIngrese el número de línea (1-6): ", terminator: "")
    
    guard let numero = Int(leerOpcion()),
          let linea = lineas.first(where: { $0.numero == numero }) else {
        print("Número de línea no válido.")
        return nil
    }
    
    return linea
}

func consultarEstacionesPorLinea() {
    guard let linea = seleccionarLinea() else { return }
    
    print("\n--- \(linea.nombre.uppercased()) ---")
    print("Estado de la línea: \(linea.estado.descripcion)")
    
    if linea.estaciones.isEmpty {
        print("No hay estaciones registradas para esta línea.")
        return
    }
    
    for (i, estacion) in linea.estaciones.enumerated() {
        print("\(i + 1). \(estacion.nombre) - \(estacion.estado.descripcion)")
    }
}

// MARK: - BUSCAR ESTACIÓN

func encontrarEstacion(_ consulta: String) -> (linea: Linea, estacion: Estacion)? {
    let buscada = normalizar(consulta)
    
    for linea in lineas {
        if let estacion = linea.estaciones.first(where: {
            normalizar($0.nombre) == buscada
        }) {
            return (linea, estacion)
        }
    }
    
    for linea in lineas {
        if let estacion = linea.estaciones.first(where: {
            normalizar($0.nombre).contains(buscada) ||
            buscada.contains(normalizar($0.nombre))
        }) {
            return (linea, estacion)
        }
    }
    
    return nil
}

// MARK: - CONEXIONES

func conexionesDe(estacion: String, linea: Int) -> [Conexion] {
    conexiones.filter {
        ($0.linea1 == linea && normalizar($0.estacion1) == normalizar(estacion)) ||
        ($0.linea2 == linea && normalizar($0.estacion2) == normalizar(estacion))
    }
}

func mostrarConexion(_ conexion: Conexion) {
    print("- Línea \(conexion.linea1): \(conexion.estacion1) ↔ Línea \(conexion.linea2): \(conexion.estacion2) - \(conexion.estado.descripcion)")
}

// MARK: - INFORMACIÓN DE ESTACIÓN

func buscarEstacion() {
    print("\nIngrese el nombre de la estación: ", terminator: "")
    let consulta = leerOpcion()
    
    guard !consulta.isEmpty else {
        print("Debe ingresar una estación.")
        return
    }
    
    guard let resultado = encontrarEstacion(consulta) else {
        print("No se encontró la estación \"\(consulta)\".")
        return
    }
    
    let linea = resultado.linea
    let estacion = resultado.estacion
    
    guard let indice = linea.estaciones.firstIndex(where: {
        normalizar($0.nombre) == normalizar(estacion.nombre)
    }) else { return }
    
    print("""
    
    --- INFORMACIÓN DE ESTACIÓN ---
    Estación: \(estacion.nombre)
    Línea: \(linea.nombre)
    Distrito: \(estacion.distrito)
    Avenida: \(estacion.avenida)
    Estado: \(estacion.estado.descripcion)
    Tarifa de la línea: \(tarifaTexto(linea.tarifa))
    """)
    
    print(indice > 0
          ? "Estación anterior: \(linea.estaciones[indice - 1].nombre)"
          : "Estación anterior: Ninguna")
    
    print(indice < linea.estaciones.count - 1
          ? "Estación siguiente: \(linea.estaciones[indice + 1].nombre)"
          : "Estación siguiente: Ninguna")
    
    print("Lugares cercanos:")
    
    if estacion.lugaresCercanos.isEmpty {
        print("- No hay lugares registrados.")
    } else {
        estacion.lugaresCercanos.forEach { print("- \($0)") }
    }
    
    let conexionesEstacion = conexionesDe(
        estacion: estacion.nombre,
        linea: linea.numero
    )
    
    print("Conexiones relacionadas:")
    
    if conexionesEstacion.isEmpty {
        print("- No hay conexiones registradas.")
    } else {
        conexionesEstacion.forEach { mostrarConexion($0) }
    }
}

// MARK: - LUGARES CERCANOS

func consultarLugaresCercanos() {
    print("\nIngrese la estación: ", terminator: "")
    let consulta = leerOpcion()
    
    guard let resultado = encontrarEstacion(consulta) else {
        print("No se encontró la estación \"\(consulta)\".")
        return
    }
    
    let estacion = resultado.estacion
    let linea = resultado.linea
    
    print("""
    
    --- LUGARES CERCANOS ---
    Estación: \(estacion.nombre)
    Línea: \(linea.nombre)
    """)
    
    if estacion.lugaresCercanos.isEmpty {
        print("No hay lugares cercanos registrados para esta estación.")
    } else {
        estacion.lugaresCercanos.forEach { print("- \($0)") }
    }
    
    let conexionesEstacion = conexionesDe(
        estacion: estacion.nombre,
        linea: linea.numero
    )
    
    print("\nConexiones o estaciones relacionadas:")
    
    if conexionesEstacion.isEmpty {
        print("- No hay conexiones registradas.")
    } else {
        conexionesEstacion.forEach { mostrarConexion($0) }
    }
}

// MARK: - FUNCIONES PARA RUTAS

func estacionEnLinea(_ nombre: String, linea: Linea) -> Estacion? {
    let buscada = normalizar(nombre)
    
    return linea.estaciones.first {
        let nombreNormalizado = normalizar($0.nombre)
        return nombreNormalizado == buscada ||
               nombreNormalizado.contains(buscada) ||
               buscada.contains(nombreNormalizado)
    }
}

func indiceEstacion(_ estacion: Estacion, en linea: Linea) -> Int? {
    linea.estaciones.firstIndex {
        normalizar($0.nombre) == normalizar(estacion.nombre)
    }
}

func imprimirRuta(_ estaciones: ArraySlice<Estacion>) {
    for (i, estacion) in estaciones.enumerated() {
        let marca = estacion.estado == .operativa
            ? "OPERATIVA"
            : estacion.estado.descripcion.uppercased()
        
        print("\(i + 1). \(estacion.nombre) [\(marca)]")
    }
}

func distanciaAproximada(numeroDeTramos: Int) -> Double {
    Double(numeroDeTramos) * 1.2
}

// MARK: - PLANIFICAR RUTA

func planificarRuta() {
    print("\n--- PLANIFICAR RUTA ---")
    
    print("Estación de origen: ", terminator: "")
    let origenTexto = leerOpcion()
    
    print("Estación de destino: ", terminator: "")
    let destinoTexto = leerOpcion()
    
    guard let origenResultado = encontrarEstacion(origenTexto) else {
        print("No se encontró la estación de origen.")
        return
    }
    
    guard let destinoResultado = encontrarEstacion(destinoTexto) else {
        print("No se encontró la estación de destino.")
        return
    }
    
    let lineaOrigen = origenResultado.linea
    let lineaDestino = destinoResultado.linea
    let origen = origenResultado.estacion
    let destino = destinoResultado.estacion
    
    print("\nOrigen: \(origen.nombre) - \(lineaOrigen.nombre)")
    print("Destino: \(destino.nombre) - \(lineaDestino.nombre)")
    
    if lineaOrigen.numero == lineaDestino.numero {
        print("Tarifa: \(tarifaTexto(lineaOrigen.tarifa))")
    } else {
        print("Tarifa \(lineaOrigen.nombre): \(tarifaTexto(lineaOrigen.tarifa))")
        print("Tarifa \(lineaDestino.nombre): \(tarifaTexto(lineaDestino.tarifa))")
    }
    
    // MISMA LÍNEA
    if lineaOrigen.numero == lineaDestino.numero {
        guard let iOrigen = indiceEstacion(origen, en: lineaOrigen),
              let iDestino = indiceEstacion(destino, en: lineaOrigen) else {
            print("No se pudo calcular la ruta.")
            return
        }
        
        let inicio = min(iOrigen, iDestino)
        let fin = max(iOrigen, iDestino)
        let tramo = lineaOrigen.estaciones[inicio...fin]
        let tramos = abs(iDestino - iOrigen)
        let distancia = distanciaAproximada(numeroDeTramos: tramos)
        let noOperativas = tramo.filter { $0.estado != .operativa }.count
        
        print(noOperativas == 0
              ? "Estado de ruta: DISPONIBLE EN EL TRAMO OPERATIVO"
              : "Estado de ruta: PLANIFICADA / NO DISPONIBLE COMPLETAMENTE")
        
        if noOperativas > 0 {
            print("Motivo: la ruta incluye estaciones en construcción o proyectadas.")
        }
        
        print("Número de estaciones recorridas: \(tramos)")
        print(String(format: "Distancia aproximada: %.1f km", distancia))
        print("Transbordos: 0")
        print("Ruta:")
        imprimirRuta(tramo)
        return
    }
    
    // DIFERENTES LÍNEAS
    guard let conexion = conexiones.first(where: {
        ($0.linea1 == lineaOrigen.numero && $0.linea2 == lineaDestino.numero) ||
        ($0.linea1 == lineaDestino.numero && $0.linea2 == lineaOrigen.numero)
    }) else {
        print("No hay una conexión registrada entre \(lineaOrigen.nombre) y \(lineaDestino.nombre).")
        print("No es posible planificar el transbordo con las conexiones registradas.")
        return
    }
    
    let estacionTransbordoOrigen: String
    let estacionTransbordoDestino: String
    
    if conexion.linea1 == lineaOrigen.numero {
        estacionTransbordoOrigen = conexion.estacion1
        estacionTransbordoDestino = conexion.estacion2
    } else {
        estacionTransbordoOrigen = conexion.estacion2
        estacionTransbordoDestino = conexion.estacion1
    }
    
    guard let transOrigen = estacionEnLinea(estacionTransbordoOrigen, linea: lineaOrigen),
          let transDestino = estacionEnLinea(estacionTransbordoDestino, linea: lineaDestino),
          let iOrigen = indiceEstacion(origen, en: lineaOrigen),
          let iTransOrigen = indiceEstacion(transOrigen, en: lineaOrigen),
          let iTransDestino = indiceEstacion(transDestino, en: lineaDestino),
          let iDestino = indiceEstacion(destino, en: lineaDestino) else {
        print("No se pudo construir la ruta con la conexión registrada.")
        return
    }
    
    let tramo1 = lineaOrigen.estaciones[
        min(iOrigen, iTransOrigen)...max(iOrigen, iTransOrigen)
    ]
    
    let tramo2 = lineaDestino.estaciones[
        min(iTransDestino, iDestino)...max(iTransDestino, iDestino)
    ]
    
    let tramosTotales = abs(iTransOrigen - iOrigen) + abs(iDestino - iTransDestino)
    let distancia = distanciaAproximada(numeroDeTramos: tramosTotales)
    
    let noOperativas = tramo1.filter { $0.estado != .operativa }.count +
                       tramo2.filter { $0.estado != .operativa }.count
    
    print("\nEstado de ruta: PLANIFICADA")
    
    if noOperativas > 0 || conexion.estado != .operativa {
        print("Disponibilidad: NO DISPONIBLE COMPLETAMENTE EN LA ACTUALIDAD")
    }
    
    print("Transbordos: 1")
    print("Punto de transbordo: \(transOrigen.nombre) (\(lineaOrigen.nombre)) ↔ \(transDestino.nombre) (\(lineaDestino.nombre))")
    print("Estado de conexión: \(conexion.estado.descripcion)")
    print("Número de estaciones recorridas: \(tramosTotales)")
    print(String(format: "Distancia aproximada: %.1f km", distancia))
    
    print("\nTramo 1 - \(lineaOrigen.nombre):")
    imprimirRuta(tramo1)
    
    print("\nTransbordo:")
    print("\(transOrigen.nombre) → \(transDestino.nombre)")
    
    print("\nTramo 2 - \(lineaDestino.nombre):")
    imprimirRuta(tramo2)
}

// MARK: - MENÚ

func mostrarMenu() {
    print("""
    
    ====================================
               METRO DE LIMA
    ====================================
    1. Listar líneas
    2. Consultar estaciones por línea
    3. Buscar estación
    4. Información de líneas
    5. Consultar lugares cercanos
    6. Planificar ruta
    7. Salir
    ====================================
    """)
    
    print("Seleccione una opción: ", terminator: "")
}

// MARK: - PROGRAMA PRINCIPAL

var ejecutando = true

while ejecutando {
    mostrarMenu()
    
    switch leerOpcion() {
    case "1":
        listarLineas()
        
    case "2":
        consultarEstacionesPorLinea()
        
    case "3":
        buscarEstacion()
        
    case "4":
        print("\n--- INFORMACIÓN DE LÍNEAS ---")
        lineas.forEach { resumenLinea($0) }
        
    case "5":
        consultarLugaresCercanos()
        
    case "6":
        planificarRuta()
        
    case "7":
        ejecutando = false
        print("\nGracias por usar el Metro de Lima.")
        
    default:
        print("Opción no válida. Seleccione un número del 1 al 7.")
    }
}


