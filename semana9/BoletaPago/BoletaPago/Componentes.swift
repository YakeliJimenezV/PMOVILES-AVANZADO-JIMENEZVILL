import SwiftUI

enum Estilo {
    static let morado = Color(hex: 0x6545F5)
    static let lila = Color(hex: 0xF0EBFF)
    static let fondo = Color(hex: 0xF8F7FF)
    static let texto = Color(hex: 0x18213A)
    static let verde = Color(hex: 0xDDF8E9)
    static let rosa = Color(hex: 0xFFE4E8)
    static let azul = Color(hex: 0xE2EFFF)
}
extension Color {
    init(hex: UInt32) {
        self.init(.sRGB, red: Double((hex >> 16) & 255) / 255, green: Double((hex >> 8) & 255) / 255, blue: Double(hex & 255) / 255, opacity: 1)
    }
}
//el formulario puede reducir el espaciado sin alterar la boleta.
struct Tarjeta<Content: View>: View {
    let titulo: String
    let icono: String
    var espaciado: CGFloat = 20
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: espaciado) {
            HStack(spacing: 12) {
                Image(systemName: icono).font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Estilo.morado).frame(width: 40, height: 40).background(Estilo.lila, in: RoundedRectangle(cornerRadius: 13))
                Text(titulo).font(.headline)
            }
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Estilo.lila, lineWidth: 1))
        .shadow(color: Estilo.texto.opacity(0.035), radius: 12, y: 5)
    }
}
// se conserva el teclado de cada dato y destacamos solo el campo que se está editando.
struct Campo: View {
    let titulo: String
    let placeholder: String
    @Binding var texto: String
    var teclado: UIKeyboardType = .default
    @FocusState private var tieneFoco: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.subheadline.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            TextField(placeholder, text: $texto)
                .font(.body)
                .keyboardType(teclado).textInputAutocapitalization(teclado == .default ? .words : .never)
                .autocorrectionDisabled().focused($tieneFoco)
                .padding(.horizontal, 13).padding(.vertical, 12)
                .frame(minHeight: 48)
                .background(Estilo.fondo, in: RoundedRectangle(cornerRadius: 13))
                .overlay(RoundedRectangle(cornerRadius: 13)
                    .stroke(tieneFoco ? Estilo.morado.opacity(0.7) : Estilo.lila, lineWidth: tieneFoco ? 1.5 : 1))
                .accessibilityLabel(titulo)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
// El menú mantiene el Picker nativo y sus etiquetas; su presentación permite leer opciones largas.
struct Selector<Selection: Hashable, Content: View>: View {
    let titulo: String
    let valor: String
    @Binding var seleccion: Selection
    @ViewBuilder var opciones: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo).font(.subheadline.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
            Menu {
                Picker(titulo, selection: $seleccion) { opciones }
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    Text(valor).font(.body).multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down").font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Estilo.morado)
                }
                .foregroundStyle(Estilo.texto)
                .padding(.horizontal, 13).padding(.vertical, 12)
                .frame(minHeight: 48)
                .background(Estilo.fondo, in: RoundedRectangle(cornerRadius: 13))
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Estilo.lila, lineWidth: 1))
                .contentShape(RoundedRectangle(cornerRadius: 13))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(titulo).accessibilityValue(valor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
// Dos columnas en el ancho habitual; en espacios reducidos o con texto accesible se apilan.
struct FilaFormulario<Primero: View, Segundo: View>: View {
    @Environment(\.dynamicTypeSize) private var tamanoTexto
    @ViewBuilder var primero: Primero
    @ViewBuilder var segundo: Segundo
    var body: some View {
        ColumnasFormulario(apilar: tamanoTexto.isAccessibilitySize) {
            primero
            segundo
        }
    }
}
// Ajustamos el tamaño de las columnas para que los textos largos se vean completos.
private struct ColumnasFormulario: Layout {
    let apilar: Bool
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let ancho = proposal.width ?? 320
        let vertical = apilar || ancho < 292
        let columna = vertical ? ancho : (ancho - 12) / 2
        let alturas = subviews.map { $0.sizeThatFits(ProposedViewSize(width: columna, height: nil)).height }
        return CGSize(width: ancho, height: vertical ? alturas.reduce(0, +) + 14 : (alturas.max() ?? 0))
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let vertical = apilar || bounds.width < 292
        let columna = vertical ? bounds.width : (bounds.width - 12) / 2
        var y = bounds.minY
        for (indice, vista) in subviews.enumerated() {
            let propuesta = ProposedViewSize(width: columna, height: nil)
            vista.place(at: CGPoint(x: vertical ? bounds.minX : bounds.minX + CGFloat(indice) * (columna + 12), y: y), anchor: .topLeading, proposal: propuesta)
            if vertical { y += vista.sizeThatFits(propuesta).height + 14 }
        }
    }
}

struct CampoFecha: View {
    @Binding var fecha: Date
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Fecha de ingreso").font(.subheadline.weight(.medium))
            DatePicker("Fecha de ingreso", selection: $fecha, displayedComponents: .date)
                .labelsHidden().datePickerStyle(.compact)
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                .padding(.horizontal, 13).padding(.vertical, 2)
                .background(Estilo.fondo, in: RoundedRectangle(cornerRadius: 13))
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Estilo.lila, lineWidth: 1))
                .accessibilityLabel("Fecha de ingreso")
        }
    }
}
struct BotonPrincipal: ButtonStyle {
    var secundario = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 18)
            .foregroundStyle(secundario ? Estilo.morado : .white)
            .background(secundario ? Estilo.lila : Estilo.morado, in: RoundedRectangle(cornerRadius: 17))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
// Estas tablas pertenecen al comprobante y conservan su presentación original.
struct TablaConceptos: View {
    let titulo: String
    let icono: String
    let color: Color
    let filas: [Concepto]
    var total: Concepto? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(titulo, systemImage: icono).font(.headline)
            ForEach(filas) { fila in filaImporte(fila) }
            if let total {
                Divider().overlay(Estilo.texto.opacity(0.1))
                filaImporte(total).fontWeight(.bold)
            }
        }.padding(20).background(color, in: RoundedRectangle(cornerRadius: 22))
    }
    private func filaImporte(_ fila: Concepto) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(fila.nombre).frame(maxWidth: .infinity, alignment: .leading)
            Text(fila.importe.soles).monospacedDigit().fixedSize(horizontal: true, vertical: false)
        }.font(.subheadline)
    }
}
struct VistaBoleta: View {
    let resultado: ResultadoBoleta
    var body: some View {
        VStack(spacing: 16) {
            Tarjeta(titulo: "BOLETA DE PAGO", icono: "doc.text") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tech Solutions S.A.C.").font(.title3.bold())
                    Text("Boleta de ejemplo").font(.subheadline).foregroundStyle(.secondary)
                    if resultado.datos.simulacion { Text("Simulación").font(.caption.bold()).padding(8).background(Estilo.lila, in: Capsule()) }
                }
                ForEach(resultado.datosTrabajador, id: \.0) { etiqueta, valor in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(etiqueta.uppercased()).font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                        Text(valor).font(.subheadline.weight(.medium)).textSelection(.enabled)
                    }
                }
            }
            TablaConceptos(titulo: "Remuneraciones", icono: "plus.circle", color: Estilo.verde, filas: resultado.remuneraciones, total: Concepto(nombre: "Total remuneraciones", importe: resultado.totalRemuneraciones))
            TablaConceptos(titulo: "Retenciones / descuentos", icono: "minus.circle", color: Estilo.rosa, filas: resultado.descuentos, total: Concepto(nombre: "Total descuentos", importe: resultado.totalDescuentos))
            TablaConceptos(titulo: "Aportaciones del empleador", icono: "building.2", color: Estilo.azul, filas: [Concepto(nombre: "EsSalud (9%)", importe: resultado.essalud)])
            VStack(alignment: .leading, spacing: 12) {
                Label("NETO A PAGAR", systemImage: "banknote").font(.subheadline.weight(.semibold)).foregroundStyle(Estilo.lila)
                Text(resultado.neto.soles).font(.system(size: 36, weight: .bold, design: .rounded)).minimumScaleFactor(0.5).lineLimit(1).monospacedDigit()
            }.frame(maxWidth: .infinity, alignment: .leading).padding(24)
                .foregroundStyle(.white).background(LinearGradient(colors: [Estilo.morado, Color(hex: 0x4930BD)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24))
        }
    }
}
