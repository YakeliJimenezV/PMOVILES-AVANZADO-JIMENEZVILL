import Foundation

// - Definición de Usuarios

enum TipoUsuario: String {
    case alumno = "Alumno"
    case docente = "Docente"
    case administrador = "Administrador"
    case coordinador = "Coordinador"
    
    var diasPermitidos: Int {
        switch self {
        case .alumno:
            return 7
        case .docente:
            return 15
        case .administrador:
            return 10
        case .coordinador:
            return 15
        }
    }
    
    var multaBase: Double {
        switch self {
        case .alumno:
            return 1.50
        case .docente:
            return 2.00
        case .administrador:
            return 3.00
        case .coordinador:
            return 4.00
        }
    }
}

// - Ingreso de Datos

print("==========================================")
print("     SISTEMA DE PRÉSTAMO DE BIBLIOTECA")
print("==========================================")

print("")
print("Ingrese el título del libro:")
let tituloLibro = readLine() ?? "Sin título"

// - Selección del tipo de usuario

print("")
print("Seleccione el tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrador")
print("4. Coordinador")

var usuario: TipoUsuario

while true {
    
    print("Ingrese una opción:")
    
    if let entrada = readLine(), let opcionUsuario = Int(entrada) {
        
        switch opcionUsuario {
            
        case 1:
            usuario = .alumno
            break
            
        case 2:
            usuario = .docente
            break
            
        case 3:
            usuario = .administrador
            break
            
        case 4:
            usuario = .coordinador
            break
            
        default:
            print("")
            print("Opción incorrecta. Vuelva a elegir una opción.")
            print("")
            continue
        }
        
        break
        
    } else {
        print("")
        print("Opción incorrecta. Vuelva a elegir una opción.")
        print("")
    }
}

// - Días reales del préstamo

print("")
print("Ingrese los días reales del préstamo:")

let diasPrestadosReales = Int(readLine() ?? "0") ?? 0

// - Manejo de Fechas

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

// - Formateador de Fechas

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"

// - Cálculo de Días de Atraso

let diasAtraso = max(
    0,
    diasPrestadosReales - usuario.diasPermitidos
)

// - Cálculo de Multas

var multaTotal = 0.0

guard let fechaInicioAtraso = calendar.date(
    byAdding: .day,
    value: usuario.diasPermitidos,
    to: fechaPrestamo
) else {
    fatalError("Error calculando fecha de inicio del atraso")
}

print("")
print("==========================================")
print("           CÁLCULO DE MULTAS")
print("==========================================")

if diasAtraso > 0 {
    
    print("")
    print("Día | Fecha       | Multa    | Acumulado")
    print("------------------------------------------")
    
    for dia in 1...diasAtraso {
        
        guard let fechaAtraso = calendar.date(
            byAdding: .day,
            value: dia,
            to: fechaInicioAtraso
        ) else {
            continue
        }
        
        var multaDia = 0.0
        
        // - Reglas especiales para Coordinador
        
        if usuario == .coordinador {
            
            if dia <= 3 {
                // Días 1 al 3: multa normal
                multaDia = usuario.multaBase
                
            } else if dia <= 6 {
                // Días 4 al 6: 20% adicional
                multaDia = usuario.multaBase * 1.20
                
            } else if dia <= 10 {
                // Días 7 al 10: 50% adicional
                multaDia = usuario.multaBase * 1.50
                
            } else {
                // Días 11 al 20: 100% adicional
                multaDia = usuario.multaBase * 2.00
            }
            
        } else {
            
            // - Reglas para Alumno, Docente y Administrador
            
            if dia <= 3 {
                // Días 1 al 3: multa normal
                multaDia = usuario.multaBase
                
            } else if dia <= 6 {
                // Días 4 al 6: 50% adicional
                multaDia = usuario.multaBase * 1.50
                
            } else {
                // Desde el día 7: 100% adicional
                multaDia = usuario.multaBase * 2.00
            }
        }
        
        multaTotal += multaDia
        
        print(
            "\(dia)   | \(formatter.string(from: fechaAtraso)) | " +
            "S/ \(String(format: "%.2f", multaDia)) | " +
            "S/ \(String(format: "%.2f", multaTotal))"
        )
    }
    
} else {
    
    print("")
    print("No hay días de atraso.")
}

// - Situación del Usuario

let situacion: String

if usuario == .coordinador {
    
    // Coordinador: máximo 20 días de atraso
    if diasAtraso > 20 {
        situacion = "SUSPENDIDO"
    } else {
        situacion = "HABILITADO"
    }
    
} else {
    
    // Alumno, Docente y Administrador:
    // suspensión desde 10 días de atraso
    if diasAtraso >= 10 {
        situacion = "SUSPENDIDO"
    } else {
        situacion = "HABILITADO"
    }
}

// - Resultado Final

print("")
print("==========================================")
print("          RESULTADO DEL PRÉSTAMO")
print("==========================================")

print("Libro              : \(tituloLibro)")
print("Usuario            : \(usuario.rawValue)")
print("Días permitidos    : \(usuario.diasPermitidos)")
print("Tarifa base        : S/ \(String(format: "%.2f", usuario.multaBase))")
print("Fecha de préstamo  : \(formatter.string(from: fechaPrestamo))")
print("Fecha límite       : \(formatter.string(from: fechaLimite))")
print("Fecha de devolución: \(formatter.string(from: fechaDevolucion))")
print("Días de atraso     : \(diasAtraso)")
print("Multa total        : S/ \(String(format: "%.2f", multaTotal))")
print("Situación          : \(situacion)")

print("==========================================")
