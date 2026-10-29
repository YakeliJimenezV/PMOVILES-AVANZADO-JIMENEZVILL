import SwiftUI
import UIKit

// Identificamos el archivo para presentar la hoja de compartir desde SwiftUI.
struct ArchivoPDF: Identifiable {
    let id = UUID()
    let url: URL
}
// La hoja nativa permite enviar el documento o guardarlo en Archivos.
struct CompartirPDF: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
@MainActor
final class GeneradorPDF {
    static func generar(_ boleta: ResultadoBoleta) throws -> URL {
        
        // Definimos una página vertical; el documento se dibuja con herramientas nativas de iOS.
        let pagina = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pagina)
        let data = renderer.pdfData { contexto in
            func nuevaPagina() {
                contexto.beginPage()
                UIColor.white.setFill()
                contexto.cgContext.fill(pagina)
            }
            nuevaPagina()
            let morado = UIColor(red: 101/255, green: 69/255, blue: 245/255, alpha: 1)
            let oscuro = UIColor(red: 24/255, green: 33/255, blue: 58/255, alpha: 1)
            var y: CGFloat = 36
            // Medimos cada texto para respetar márgenes y alinear las columnas.
            func texto(_ cadena: String, x: CGFloat = 36, ancho: CGFloat = 523, tamano: CGFloat = 11, negrita: Bool = false, color: UIColor = .darkGray, derecha: Bool = false) -> CGFloat {
                let estilo = NSMutableParagraphStyle()
                estilo.alignment = derecha ? .right : .left
                let atributos: [NSAttributedString.Key: Any] = [.font: negrita ? UIFont.boldSystemFont(ofSize: tamano) : UIFont.systemFont(ofSize: tamano), .foregroundColor: color, .paragraphStyle: estilo]
                let alto = max(tamano + 5, (cadena as NSString).boundingRect(with: CGSize(width: ancho, height: 1000), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: atributos, context: nil).height.rounded(.up))
                (cadena as NSString).draw(in: CGRect(x: x, y: y, width: ancho, height: alto), withAttributes: atributos)
                return alto
            }
            // Los conceptos quedan a la izquierda y sus importes a la derecha.
            func fila(_ concepto: Concepto, destacada: Bool = false) {
                let alto = texto(concepto.nombre, ancho: 350, negrita: destacada, color: oscuro)
                _ = texto(concepto.importe.soles, x: 400, ancho: 159, negrita: destacada, color: oscuro, derecha: true)
                y += max(22, alto + 6)
            }
            // Cada sección conserva su color y comienza otra página si no hay espacio suficiente.
            func seccion(_ titulo: String, color: UIColor, filas: [Concepto], total: Concepto? = nil) {
                let altoEstimado = CGFloat(filas.count + (total == nil ? 0 : 1)) * 28 + 45
                if y + altoEstimado > 740 { nuevaPagina(); y = 36 }
                y += 10
                color.setFill()
                UIBezierPath(roundedRect: CGRect(x: 28, y: y - 5, width: 539, height: 28), cornerRadius: 7).fill()
                _ = texto(titulo, tamano: 12, negrita: true, color: oscuro)
                y += 31
                for concepto in filas { fila(concepto) }
                if let total { fila(total, destacada: true) }
            }
            _ = texto("BOLETA DE PAGO", tamano: 23, negrita: true, color: morado)
            y += 34
            _ = texto("Tech Solutions S.A.C.", tamano: 14, negrita: true, color: oscuro)
            y += 23
            _ = texto(boleta.datos.simulacion ? "Boleta de ejemplo · Simulación" : "Boleta de ejemplo", color: morado)
            y += 26
            // Tomamos los datos del resultado calculado, sin volver a realizar operaciones.
            for (etiqueta, valor) in boleta.datosTrabajador {
                _ = texto(etiqueta, ancho: 115, tamano: 10)
                let alto = texto(valor, x: 155, ancho: 404, tamano: 11, negrita: true, color: oscuro)
                y += max(21, alto + 5)
                if y > 700 { nuevaPagina(); y = 36 }
            }
            _ = texto("Parámetros de referencia: \(Parametros.referencia)" + (boleta.datos.pension == .afp ? " · Comisión sobre flujo" : ""), tamano: 9)
            y += 20
            
            // Las tablas reutilizan los mismos importes que aparecen en la boleta de pantalla.
            seccion("REMUNERACIONES", color: UIColor(red: 221/255, green: 248/255, blue: 233/255, alpha: 1), filas: boleta.remuneraciones, total: Concepto(nombre: "Total remuneraciones", importe: boleta.totalRemuneraciones))
            seccion("RETENCIONES / DESCUENTOS", color: UIColor(red: 1, green: 228/255, blue: 232/255, alpha: 1), filas: boleta.descuentos, total: Concepto(nombre: "Total descuentos", importe: boleta.totalDescuentos))
            seccion("APORTACIONES DEL EMPLEADOR", color: UIColor(red: 226/255, green: 239/255, blue: 1, alpha: 1), filas: [Concepto(nombre: "EsSalud (9%)", importe: boleta.essalud)])
            if y + 74 > 806 { nuevaPagina(); y = 36 }
            y += 12
            morado.setFill()
            UIBezierPath(roundedRect: CGRect(x: 28, y: y, width: 539, height: 62), cornerRadius: 12).fill()
            y += 18
            _ = texto("NETO A PAGAR", tamano: 12, negrita: true, color: .white)
            _ = texto(boleta.neto.soles, x: 250, ancho: 299, tamano: 24, negrita: true, color: .white, derecha: true)
        }
        // Guardamos una copia temporal con nombre único para compartirla sin sobrescribir otras boletas.
        let carpeta = FileManager.default.temporaryDirectory.appendingPathComponent("Boletas", isDirectory: true)
        try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)
        let url = carpeta.appendingPathComponent("Boleta-\(boleta.datos.anio)-\(boleta.datos.mes)-\(UUID().uuidString).pdf")
        try data.write(to: url, options: .atomic)
        return url
    }
}
