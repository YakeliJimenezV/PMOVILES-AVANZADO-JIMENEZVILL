import Foundation

// Definición de Usuarios
enum TipoUsuario: String {
    case alumno = "Alumno"
    case docente = "Docente"
    case administrador = "Administrador"
    
    var diasPermitidos: Int {
        switch self {
        case .alumno: return 7
        case .docente: return 15
        case .administrador: return 10
        }
    }
}

// Datos de Entrada
let tituloLibro = "Estructuras de Datos en Swift"
let usuario = TipoUsuario.alumno

// Manejo de fechas usando el calendario actual
let calendar = Calendar.current
let fechaPrestamo = Date()

// Fecha límite = Fecha préstamo + Días permitidos según el usuario
guard let fechaLimite = calendar.date(byAdding: .day, value: usuario.diasPermitidos, to: fechaPrestamo) else {
    fatalError("Error calculando fecha límite")
}

// Simulación de devolución ejem 11 días transcurridos para generar atraso
let diasPrestadosReales = 11
guard let fechaDevolucion = calendar.date(byAdding: .day, value: diasPrestadosReales, to: fechaPrestamo) else {
    fatalError("Error calculando fecha de devolución")
}

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

print("=== REGISTRO DE PRÉSTAMO DE BIBLIOTECA ===")
print("Título del Libro  : \(tituloLibro)")
print("Tipo de Usuario   : \(usuario.rawValue) (\(usuario.diasPermitidos) días permitidos)")
print("Fecha de Préstamo : \(formatter.string(from: fechaPrestamo))")
print("Fecha Límite      : \(formatter.string(from: fechaLimite))")
print("Fecha Devolución  : \(formatter.string(from: fechaDevolucion))")
 
