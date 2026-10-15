import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let nombreImagen: String
    let patrimonio: String
    let temas: [String]

    static let todas: [Cultura] = [
        Cultura(nombre: "Cultura Inca", region: "Cusco y región andina del Perú.",
                descripcion: "La cultura inca construyó el Tahuantinsuyo, uno de los imperios más extensos de América. Destacó por su organización, arquitectura y conocimientos agrícolas.",
                nombreImagen: "inca", patrimonio: "Machu Picchu",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arquitectura", "Legado cultural"]),
        Cultura(nombre: "Cultura Nazca", region: "Costa sur del Perú, principalmente Ica.",
                descripcion: "La cultura Nazca destacó por sus misteriosos geoglifos trazados en el desierto, su cerámica policromada y sus sistemas de aprovechamiento del agua.",
                nombreImagen: "nazca", patrimonio: "Líneas de Nazca · El colibrí",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arte y cerámica", "Líneas de Nazca"]),
        Cultura(nombre: "Cultura Moche", region: "Costa norte del Perú.",
                descripcion: "La cultura Moche sobresalió por sus huacos retrato, sus grandes templos de adobe y su avanzada ingeniería hidráulica.",
                nombreImagen: "moche", patrimonio: "Cerámica moche de un guerrero arrodillado",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arte y cerámica", "Legado cultural"]),
        Cultura(nombre: "Cultura Chavín", region: "Áncash, sierra norte del Perú.",
                descripcion: "La cultura Chavín fue un importante centro religioso y artístico del antiguo Perú. Destacó por sus templos de piedra y esculturas simbólicas.",
                nombreImagen: "chavin", patrimonio: "Chavín de Huántar",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arquitectura ceremonial", "Arte y religión"]),
        Cultura(nombre: "Cultura Paracas", region: "Península de Paracas, Ica.",
                descripcion: "La cultura Paracas destacó por sus extraordinarios mantos textiles, sus prácticas funerarias y sus conocimientos de medicina.",
                nombreImagen: "paracas", patrimonio: "Fragmento de manto · Siglos V–III a. C.",
                temas: ["Descubrimiento", "Origen y desarrollo", "Textilería", "Medicina y prácticas funerarias"]),
        Cultura(nombre: "Cultura Chimú", region: "La Libertad, costa norte del Perú.",
                descripcion: "La cultura Chimú desarrolló un poderoso reino en la costa norte. Destacó por la ciudad de Chan Chan, la metalurgia y sus sistemas de irrigación.",
                nombreImagen: "chimu", patrimonio: "Relieves de Chan Chan",
                temas: ["Descubrimiento", "Origen y desarrollo", "Ciudad de Chan Chan", "Arte y metalurgia"])
    ]
}
