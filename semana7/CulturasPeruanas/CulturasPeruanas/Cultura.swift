import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let nombreImagen: String
    let patrimonio: String

    static let todas: [Cultura] = [
        Cultura(nombre: "Cultura Inca", region: "Cusco · Andes del Perú",
                descripcion: "La civilización inca tuvo en Cusco su centro político. En el siglo XV expandió el Tahuantinsuyo por amplios territorios andinos. Su arquitectura en piedra, sus andenes y sus caminos reflejan una notable capacidad de organización e ingeniería. Machu Picchu, construido en el siglo XV, es uno de sus legados más reconocidos.",
                nombreImagen: "inca", patrimonio: "Machu Picchu"),
        Cultura(nombre: "Cultura Nazca", region: "Ica · Costa sur",
                descripcion: "La cultura Nazca se desarrolló en los valles de la costa sur del Perú. Destacó por su cerámica de vivos colores y por los geoglifos trazados en el desierto, entre ellos figuras de animales como el colibrí. El significado exacto de las líneas sigue siendo investigado; se han relacionado con prácticas rituales y con el paisaje.",
                nombreImagen: "nazca", patrimonio: "Líneas de Nazca · El colibrí"),
        Cultura(nombre: "Cultura Moche", region: "La Libertad y Lambayeque · Costa norte",
                descripcion: "Las sociedades moche ocuparon diversos valles de la costa norte durante el primer milenio de nuestra era. Destacaron en la cerámica, especialmente en los retratos y las escenas pintadas, y en el trabajo de los metales. Sus grandes construcciones de adobe, como las huacas del Sol y de la Luna en el valle de Moche, tuvieron funciones ceremoniales y políticas.",
                nombreImagen: "moche", patrimonio: "Cerámica moche de un guerrero arrodillado"),
        Cultura(nombre: "Cultura Chavín", region: "Áncash · Sierra norte",
                descripcion: "Chavín de Huántar fue un importante centro ceremonial de los Andes, ubicado en el actual departamento de Áncash. Sus plazas, galerías y esculturas de piedra muestran una tradición religiosa de amplia influencia. En su arte aparecen seres que combinan rasgos humanos y animales, como felinos, aves y serpientes.",
                nombreImagen: "chavin", patrimonio: "Chavín de Huántar"),
        Cultura(nombre: "Cultura Paracas", region: "Ica · Península de Paracas y valles cercanos",
                descripcion: "La cultura Paracas se desarrolló en la costa sur del Perú antes del auge de Nazca. Es reconocida por sus textiles de algodón y fibras de camélidos, decorados con complejos diseños y colores. Muchos se conservaron en contextos funerarios gracias al clima seco de la región. Sus tejidos permiten conocer aspectos de sus creencias y de su destreza artesanal.",
                nombreImagen: "paracas", patrimonio: "Fragmento de manto · Siglos V–III a. C."),
        Cultura(nombre: "Cultura Chimú", region: "La Libertad · Costa norte",
                descripcion: "El reino Chimú se desarrolló en la costa norte y tuvo como capital a Chan Chan, cerca de la actual ciudad de Trujillo. Sus conjuntos amurallados de adobe y sus relieves reflejan una sociedad organizada y una estrecha relación con el mar. Los chimú destacaron también en la metalurgia. En el siglo XV su territorio fue incorporado al Imperio inca.",
                nombreImagen: "chimu", patrimonio: "Relieves de Chan Chan")
    ]
}
