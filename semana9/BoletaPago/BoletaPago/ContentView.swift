import SwiftUI

struct ContentView: View {
    // @State conserva lo escrito y actualiza la pantalla al editar, calcular o limpiar.
    @State private var datos = FormularioBoleta()
    @State private var resultado: ResultadoBoleta?
    @State private var errores: [String] = []
    @State private var archivo: ArchivoPDF?
    @State private var errorPDF: String?
    @FocusState private var campoActivo: Bool
    private var anios: [Int] { Array(2026...(max(2026, Calendar.current.component(.year, from: Date())) + 5)) }

    var body: some View {
        // El lector permite ir al resultado o a los errores dentro de la misma pantalla.
        ScrollViewReader { lector in
            ScrollView {
                VStack(spacing: 20) {
                    encabezado.id("inicio")
                    trabajador
                    mes
                    pensiones
                    adicionales
                    if !errores.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Revisa los datos", systemImage: "exclamationmark.circle.fill").font(.headline)
                            ForEach(errores, id: \.self) { Text("• \($0)").font(.subheadline) }
                        }.foregroundStyle(Color(hex: 0x9D243F)).frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18).background(Estilo.rosa, in: RoundedRectangle(cornerRadius: 18)).id("errores")
                    }
                    Button {
                        campoActivo = false
                        do {
                            // El servicio valida todos los datos antes de devolver importes calculados.
                            let calculado = try Boleta().calcular(datos)
                            withAnimation { resultado = calculado; errores = [] }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeInOut(duration: 0.5)) { lector.scrollTo("resultado", anchor: .top) }
                            }
                        } catch {
                            // Los mensajes explican qué corregir y evitan mostrar una boleta inválida.
                            resultado = nil
                            errores = (error as? ErrorBoleta)?.mensajes ?? [error.localizedDescription]
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { withAnimation { lector.scrollTo("errores", anchor: .center) } }
                        }
                    } label: { Label("Calcular boleta", systemImage: "calculator") }.buttonStyle(BotonPrincipal())
                    Button {
                        campoActivo = false
                        
                        // Recuperamos los valores iniciales y ocultamos el resultado sin salir de la pantalla.
                        withAnimation { datos = FormularioBoleta(); resultado = nil; errores = []; archivo = nil; lector.scrollTo("inicio", anchor: .top) }
                    } label: { Label("Limpiar", systemImage: "arrow.counterclockwise") }.buttonStyle(BotonPrincipal(secundario: true))
                    // La boleta y la exportación aparecen únicamente tras un cálculo válido.
                    if let resultado {
                        VistaBoleta(resultado: resultado).id("resultado").transition(.opacity.combined(with: .move(edge: .bottom)))
                        Button {
                            // El archivo temporal se entrega a la hoja nativa para compartir o guardar.
                            do { archivo = ArchivoPDF(url: try GeneradorPDF.generar(resultado)) }
                            catch { errorPDF = "No se pudo generar el PDF: \(error.localizedDescription)" }
                        } label: { Label("Exportar PDF", systemImage: "square.and.arrow.up") }.buttonStyle(BotonPrincipal())
                    }
                }.padding(20).frame(maxWidth: 640).frame(maxWidth: .infinity)
            }.background(Estilo.fondo).scrollDismissesKeyboard(.interactively)
                .toolbar { ToolbarItemGroup(placement: .keyboard) { Spacer(); Button("Listo") { campoActivo = false } } }
                .sheet(item: $archivo) { archivo in CompartirPDF(url: archivo.url) }
        }.tint(Estilo.morado).foregroundStyle(Estilo.texto)
        
            // Al editar, se retira la boleta anterior para no confundirla con los nuevos datos.
            .onChange(of: datos) { _, _ in resultado = nil; archivo = nil }
            .alert("Exportación PDF", isPresented: Binding(get: { errorPDF != nil }, set: { if !$0 { errorPDF = nil } })) {
                Button("Aceptar", role: .cancel) { errorPDF = nil }
            } message: { Text(errorPDF ?? "") }
            .environment(\.locale, Locale(identifier: "es_PE"))
            .preferredColorScheme(.light)
    }
    private var encabezado: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                Text("TU SUELDO, EN CLARO").font(.caption2.weight(.bold)).tracking(2).foregroundStyle(Estilo.lila)
                Text("Boleta de Pago").font(.system(size: 30, weight: .bold, design: .rounded))
                Text("Del sueldo al neto").font(.subheadline).foregroundStyle(Estilo.lila)
            }
            Spacer(minLength: 0)
            Image(systemName: "doc.text.image").font(.system(size: 30)).padding(14).background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: 18))
        }.foregroundStyle(.white).padding(24).frame(maxWidth: .infinity, alignment: .leading)
            .background(LinearGradient(colors: [Estilo.morado, Color(hex: 0x8065FF)], startPoint: .leading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 27))
    }
    // Cada tarjeta reúne datos relacionados; las filas se adaptan al ancho disponible.
    private var trabajador: some View {
        Tarjeta(titulo: "Datos del trabajador", icono: "person.crop.rectangle", espaciado: 14) {
            Campo(titulo: "Nombre completo", placeholder: "Ingrese su nombre completo", texto: $datos.nombre).focused($campoActivo)
            Campo(titulo: "DNI", placeholder: "Ingrese su DNI", texto: $datos.dni, teclado: .numberPad).focused($campoActivo)
            FilaFormulario {
                Selector(titulo: "Área de trabajo", valor: datos.area.rawValue, seleccion: $datos.area) {
                    ForEach(AreaTrabajo.allCases) { Text($0.rawValue).tag($0) }
                }
                // Al cambiar de área elegimos su primer cargo para evitar combinaciones incompatibles.
                .onChange(of: datos.area) { _, nueva in datos.cargo = nueva.cargos[0] }
            } segundo: {
                Selector(titulo: "Cargo", valor: datos.cargo, seleccion: $datos.cargo) {
                    ForEach(datos.area.cargos, id: \.self) { Text($0).tag($0) }
                }
            }
            CampoFecha(fecha: $datos.ingreso)
        }
    }
    private var mes: some View {
        Tarjeta(titulo: "Datos del mes", icono: "calendar", espaciado: 14) {
            FilaFormulario {
                Selector(titulo: "Mes", valor: Parametros.meses[datos.mes - 1], seleccion: $datos.mes) {
                    ForEach(1...12, id: \.self) { Text(Parametros.meses[$0 - 1]).tag($0) }
                }
            } segundo: {
                Selector(titulo: "Año", valor: String(datos.anio), seleccion: $datos.anio) {
                    ForEach(anios, id: \.self) { Text(String($0)).tag($0) }
                }
            }
            if datos.simulacion { Label("Simulación", systemImage: "sparkles").font(.caption.bold()).foregroundStyle(Estilo.morado).padding(8).background(Estilo.lila, in: Capsule()) }
            FilaFormulario {
                Campo(titulo: "Sueldo básico (S/)", placeholder: "0.00", texto: $datos.sueldo, teclado: .decimalPad).focused($campoActivo)
            } segundo: {
                Campo(titulo: "Días laborados", placeholder: "1 a 30", texto: $datos.dias, teclado: .numberPad).focused($campoActivo)
            }
        }
    }
    private var pensiones: some View {
        Tarjeta(titulo: "Sistema de pensiones", icono: "shield.lefthalf.filled", espaciado: 14) {
            FilaFormulario {
                Selector(titulo: "¿Tiene hijos?", valor: datos.hijos ? "Sí" : "No", seleccion: $datos.hijos) { Text("Sí").tag(true); Text("No").tag(false) }
            } segundo: {
                Selector(titulo: "Sistema de pensiones", valor: datos.pension.rawValue, seleccion: $datos.pension) {
                    ForEach(Pension.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
            }
            // La AFP se muestra solo cuando corresponde; las opciones y tasas se conservan.
            if datos.pension == .afp {
                Selector(titulo: "AFP", valor: datos.afp.rawValue, seleccion: $datos.afp) {
                    ForEach(AFP.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                Text("Comisión sobre flujo · \(datos.afp.porcentaje)").font(.caption).foregroundStyle(Estilo.morado)
            }
            Text("Parámetros de referencia · \(Parametros.referencia)").font(.caption).foregroundStyle(.secondary)
        }
    }
    private var adicionales: some View {
        Tarjeta(titulo: "Ingresos adicionales", icono: "clock.badge.checkmark", espaciado: 14) {
            FilaFormulario {
                Campo(titulo: "Horas extras al 25%", placeholder: "0", texto: $datos.horas25, teclado: .numberPad).focused($campoActivo)
            } segundo: {
                Campo(titulo: "Horas extras al 35%", placeholder: "0", texto: $datos.horas35, teclado: .numberPad).focused($campoActivo)
            }
            Campo(titulo: "Adelantos (S/)", placeholder: "0.00", texto: $datos.adelantos, teclado: .decimalPad).focused($campoActivo)
        }
    }
}

#Preview { ContentView() }
