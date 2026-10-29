import Foundation

// Las enumeraciones limitan la selección a opciones válidas y agrupan los cargos por área.
enum AreaTrabajo: String, CaseIterable, Identifiable {
    case tecnologia = "Tecnología", administracion = "Administración", contabilidad = "Contabilidad"
    case recursos = "Recursos Humanos", marketing = "Marketing", ventas = "Ventas"
    case logistica = "Logística", produccion = "Producción", atencion = "Atención al cliente", otro = "Otro"
    var id: String { rawValue }
    var cargos: [String] {
        switch self {
        case .tecnologia: return ["Desarrollador de Software", "Programador", "Analista de Sistemas", "Diseñador UX/UI", "Soporte Técnico"]
        case .administracion: return ["Administrador", "Asistente Administrativo", "Gerente"]
        case .contabilidad: return ["Contador", "Auxiliar Contable", "Analista Financiero"]
        case .recursos: return ["Analista de RR. HH.", "Reclutador", "Asistente de RR. HH."]
        case .marketing: return ["Diseñador Gráfico", "Analista de Marketing", "Community Manager"]
        case .ventas: return ["Vendedor", "Ejecutivo de Ventas", "Supervisor de Ventas"]
        case .logistica: return ["Auxiliar de Almacén", "Coordinador Logístico"]
        case .produccion: return ["Operario", "Supervisor de Producción"]
        case .atencion: return ["Asesor de Atención", "Supervisor de Atención"]
        case .otro: return ["Otro cargo"]
        }
    }
}
enum Pension: String, CaseIterable { case onp = "ONP", afp = "AFP" }
// El enum identifica las AFP y conserva sus nombres visibles en el formulario.
enum AFP: String, CaseIterable {
    case integra = "AFP Integra", prima = "AFP Prima", profuturo = "AFP Profuturo", habitat = "AFP Habitat"
    // Todas las AFP del enum tienen una entrada en el diccionario de parámetros.
    var tasas: TasasAFP { Parametros.tasasAFP[self]! }
    var comision: Decimal { tasas.comision }
    var porcentaje: String {
        switch self { case .integra: return "1.55%"; case .prima: return "1.60%"; case .profuturo: return "1.69%"; case .habitat: return "1.47%" }
    }
}
// Cada entrada reúne las tasas de una AFP; fondo y seguro reutilizan los valores comunes.
struct TasasAFP {
    let fondo: Decimal = Parametros.fondo
    let comision: Decimal
    let seguro: Decimal = Parametros.seguro
}
// Centralizamos los valores de referencia para que todas las fórmulas usen los mismos parámetros.
enum Parametros {
    static let rmv = Decimal(1230)
    static let onp = Decimal(string: "0.13")!
    static let fondo = Decimal(string: "0.10")!
    static let seguro = Decimal(string: "0.0137")!
    static let topeSeguro = Decimal(string: "12732.70")!
    static let essalud = Decimal(string: "0.09")!
    // La clave es la AFP y el valor contiene sus tasas para los descuentos mensuales.
    static let tasasAFP: [AFP: TasasAFP] = [
        .integra: TasasAFP(comision: Decimal(string: "0.0155")!),
        .prima: TasasAFP(comision: Decimal(string: "0.0160")!),
        .profuturo: TasasAFP(comision: Decimal(string: "0.0169")!),
        .habitat: TasasAFP(comision: Decimal(string: "0.0147")!)
    ]
    static let referencia = "Octubre de 2026"
    static let meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
}
// Los campos numéricos se guardan como texto para permitir su edición antes de validarlos.
struct FormularioBoleta: Equatable {
    var nombre = ""
    var dni = ""
    var area = AreaTrabajo.tecnologia
    var cargo = AreaTrabajo.tecnologia.cargos[0]
    var ingreso = Date()
    var mes = Calendar.current.component(.month, from: Date())
    var anio = max(2026, Calendar.current.component(.year, from: Date()))
    var sueldo = ""
    var dias = "30"
    var hijos = false
    var pension = Pension.onp
    var afp = AFP.integra
    var horas25 = "0"
    var horas35 = "0"
    var adelantos = "0"
    var periodo: String { "\(Parametros.meses[mes - 1]) de \(anio)" }
    // Comparamos mes y año para identificar periodos posteriores al actual.
    var simulacion: Bool {
        let actual = Calendar.current.dateComponents([.year, .month], from: Date())
        return anio * 12 + mes > (actual.year! * 12 + actual.month!)
    }
}
// Un concepto relaciona una descripción con su importe, tanto en la pantalla como en el PDF.
struct Concepto: Identifiable {
    var id: String { nombre }
    let nombre: String
    let importe: Decimal
}
// El resultado conserva una copia de los datos utilizados y los conceptos ya redondeados.
struct ResultadoBoleta {
    let datos: FormularioBoleta
    let remuneraciones: [Concepto]
    let descuentos: [Concepto]
    let totalRemuneraciones: Decimal
    let totalDescuentos: Decimal
    let essalud: Decimal
    // EsSalud no participa en esta resta porque es una aportación del empleador.
    var neto: Decimal { totalRemuneraciones - totalDescuentos }
    var datosTrabajador: [(String, String)] {
        [("Periodo", datos.periodo), ("Trabajador", datos.nombre), ("DNI", datos.dni),
         ("Área", datos.area.rawValue), ("Cargo", datos.cargo),
         ("Fecha de ingreso", datos.ingreso.formatted(.dateTime.day().month(.twoDigits).year().locale(Locale(identifier: "es_PE")))),
         ("Pensiones", datos.pension == .afp ? datos.afp.rawValue : "ONP")]
    }
}
extension Decimal {
    // Decimal evita imprecisiones binarias; cada concepto se redondea a dos decimales antes de sumarlo.
    var redondeado: Decimal {
        var valor = self
        var resultado = Decimal()
        NSDecimalRound(&resultado, &valor, 2, .plain)
        return resultado
    }
    // El formato de presentación añade soles, separador de miles y dos decimales sin alterar el cálculo.
    var soles: String {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2
        return "S/ " + (formato.string(from: NSDecimalNumber(decimal: self)) ?? "0.00")
    }
}
