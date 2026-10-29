import Foundation

struct ErrorBoleta: LocalizedError {
    let mensajes: [String]
    var errorDescription: String? { mensajes.joined(separator: "\n") }
}
// validaciones y fórmulas
final class Boleta {
    // se acepta punto o coma decimal y se rechaza entradas inválidas antes de convertirlas a Decimal.
    static func numero(_ texto: String, decimales: Int = 2) -> Decimal? {
        let valor = texto.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
        let patron = decimales == 0 ? "^[0-9]{1,10}$" : "^[0-9]{1,10}(\\.[0-9]{1,\(decimales)})?$"
        guard valor.range(of: patron, options: .regularExpression) != nil else { return nil }
        return Decimal(string: valor, locale: Locale(identifier: "en_US_POSIX"))
    }
    func calcular(_ entrada: FormularioBoleta) throws -> ResultadoBoleta {
        var datos = entrada
        datos.nombre = datos.nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Acumulamos los errores para que el usuario pueda corregirlos en un solo intento.
        var errores: [String] = []
        if datos.nombre.isEmpty { errores.append("Ingrese el nombre completo.") }
        if datos.dni.range(of: "^[0-9]{8}$", options: .regularExpression) == nil { errores.append("El DNI debe tener exactamente 8 dígitos.") }
        let sueldo = Self.numero(datos.sueldo)
        if sueldo == nil || sueldo! <= 0 { errores.append("El sueldo debe ser mayor que cero y tener hasta dos decimales.") }
        let dias = Self.numero(datos.dias, decimales: 0)
        if dias == nil || dias! < 1 || dias! > 30 { errores.append("Ingrese días laborados enteros entre 1 y 30.") }
        let h25 = Self.numero(datos.horas25, decimales: 0)
        let h35 = Self.numero(datos.horas35, decimales: 0)
        if h25 == nil || h35 == nil { errores.append("Las horas extras deben ser números enteros no negativos.") }
        let adelantos = Self.numero(datos.adelantos)
        if adelantos == nil { errores.append("Los adelantos deben ser un importe no negativo con hasta dos decimales.") }
        let calendario = Calendar.current
        let inicio = calendario.date(from: DateComponents(year: datos.anio, month: datos.mes, day: 1))!
        let fin = calendario.date(byAdding: .month, value: 1, to: inicio)!
        if datos.ingreso >= fin { errores.append("La fecha de ingreso no puede ser posterior al periodo de la boleta.") }
        if !datos.area.cargos.contains(datos.cargo) { errores.append("Seleccione un cargo válido para el área.") }
        guard errores.isEmpty else { throw ErrorBoleta(mensajes: errores) }
        // se  utiliza meses de 30 días y jornadas de 8 horas para obtener el valor por hora.
        let hora = sueldo! / 30 / 8
        let remuneraciones = [
            // Prorrateamos únicamente el sueldo según los días trabajados.
            Concepto(nombre: "Sueldo computable", importe: (sueldo! / 30 * dias!).redondeado),
            // La asignación equivale al 10% de la RMV y no se prorratea en este ejercicio.
            Concepto(nombre: "Asignación familiar", importe: datos.hijos ? (Parametros.rmv / 10).redondeado : 0),
            // Aplicamos los recargos de 25% y 35% al valor hora y redondeamos cada concepto.
            Concepto(nombre: "Horas extras 25%", importe: (hora * Decimal(string: "1.25")! * h25!).redondeado),
            Concepto(nombre: "Horas extras 35%", importe: (hora * Decimal(string: "1.35")! * h35!).redondeado)
        ]
        // Sumamos los ingresos ya redondeados para formar la base de los aportes.
        let total = remuneraciones.reduce(Decimal.zero) { $0 + $1.importe }
        let esAFP = datos.pension == .afp
        // Consultamos el diccionario con la AFP seleccionada sin cambiar las fórmulas ni el redondeo.
        let tasasAFP = datos.afp.tasas
        let descuentos = [
            // ONP retiene el 13%; sus descuentos AFP permanecen en cero.
            Concepto(nombre: "ONP (13%)", importe: esAFP ? 0 : (total * Parametros.onp).redondeado),
            
            // En AFP, fondo y comisión sobre flujo se calculan sobre todas las remuneraciones.
            Concepto(nombre: "AFP fondo (10%)", importe: esAFP ? (total * tasasAFP.fondo).redondeado : 0),
            Concepto(nombre: esAFP ? "\(datos.afp.rawValue) · comisión \(datos.afp.porcentaje)" : "AFP comisión", importe: esAFP ? (total * tasasAFP.comision).redondeado : 0),
            
            // Solo el seguro tiene una base limitada por la remuneración máxima asegurable.
            Concepto(nombre: "AFP seguro (1.37%)", importe: esAFP ? (min(total, Parametros.topeSeguro) * tasasAFP.seguro).redondeado : 0),
            
            // El adelanto se registra como descuento, sin reducir la base de remuneraciones.
            Concepto(nombre: "Adelantos", importe: adelantos!.redondeado)
        ]
        // El total incluye pensiones y adelantos; rechazamos un neto negativo.
        let retenciones = descuentos.reduce(Decimal.zero) { $0 + $1.importe }
        guard retenciones <= total else { throw ErrorBoleta(mensajes: ["Los descuentos superan las remuneraciones. Revise el importe de los adelantos."]) }
        
        // EsSalud se calcula aparte al 9% y no se resta del neto a pagar.
        return ResultadoBoleta(datos: datos, remuneraciones: remuneraciones, descuentos: descuentos,
                               totalRemuneraciones: total, totalDescuentos: retenciones, essalud: (total * Parametros.essalud).redondeado)
    }
}
