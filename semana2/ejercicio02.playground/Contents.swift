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
    
    var multaBase: Double {
        switch self {
        case .alumno: return 1.50
        case .docente: return 2.00
        case .administrador: return 3.00
        }
    }
}

// Ingreso de Datos

print("=== SISTEMA DE PRÉSTAMO DE BIBLIOTECA ===")

print("Ingrese el título del libro:")
let tituloLibro = readLine() ?? "Sin título"

print("")
print("Seleccione el tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrador")
print("Ingrese una opción:")

let opcionUsuario = Int(readLine() ?? "1") ?? 1

let usuario: TipoUsuario

switch opcionUsuario {
case 1:
    usuario = .alumno
case 2:
    usuario = .docente
case 3:
    usuario = .administrador
default:
    usuario = .alumno
    print("Opción no válida. Se asignará Alumno.")
}

print("")
print("Ingrese los días reales del préstamo:")
let diasPrestadosReales = Int(readLine() ?? "0") ?? 0

// Manejo de Fechas

let calendar = Calendar.current
let fechaPrestamo = Date()

guard let fechaLimite = calendar.date(
    byAdding: .day,
    value: usuario.diasPermitidos,
    to: fechaPrestamo
) else {
    fatalError("Error calculando fecha límite")
}

guard let fechaDevolucion = calendar.date(
    byAdding: .day,
    value: diasPrestadosReales,
    to: fechaPrestamo
) else {
    fatalError("Error calculando fecha de devolución")
}

// Formateador de Fechas

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

// Cálculo de Días de Atraso

let diasAtraso = max(
    0,
    diasPrestadosReales - usuario.diasPermitidos
)

//  Cálculo de Multas

var multaTotal = 0.0

guard let fechaInicioAtraso = calendar.date(
    byAdding: .day,
    value: usuario.diasPermitidos,
    to: fechaPrestamo
) else {
    fatalError("Error calculando inicio del atraso")
}

print("")
print("=== CÁLCULO DE MULTAS ===")

if diasAtraso > 0 {
    
    for dia in 1...diasAtraso {
        
        guard let fechaAtraso = calendar.date(
            byAdding: .day,
            value: dia,
            to: fechaInicioAtraso
        ) else {
            continue
        }
        
        var multaDia = 0.0
        
        if dia <= 3 {
            // Del día 1 al 3: multa normal
            multaDia = usuario.multaBase
            
        } else if dia <= 6 {
            // Del día 4 al 6: 50% adicional
            multaDia = usuario.multaBase * 1.50
            
        } else {
            // Desde el día 7: 100% adicional
            multaDia = usuario.multaBase * 2.00
        }
        
        multaTotal += multaDia
        
        print(
            "Día \(dia) | Fecha: \(formatter.string(from: fechaAtraso)) | " +
            "Multa: S/ \(String(format: "%.2f", multaDia)) | " +
            "Acumulado: S/ \(String(format: "%.2f", multaTotal))"
        )
    }
    
} else {
    print("No hay días de atraso.")
}

//  Resultado

print("")
print("=== RESULTADO DEL PRÉSTAMO ===")
print("Título del Libro  : \(tituloLibro)")
print("Tipo de Usuario   : \(usuario.rawValue)")
print("Días Permitidos   : \(usuario.diasPermitidos)")
print("Fecha de Préstamo : \(formatter.string(from: fechaPrestamo))")
print("Fecha Límite      : \(formatter.string(from: fechaLimite))")
print("Fecha Devolución  : \(formatter.string(from: fechaDevolucion))")
print("Días de Atraso    : \(diasAtraso)")
print("Multa Total       : S/ \(String(format: "%.2f", multaTotal))")


