import Foundation

struct Cultura {
    let nombre: String
    let region: String
    let descripcion: String
    let nombreImagen: String
    let patrimonio: String
    let temas: [TemaCultural]

    static let todas: [Cultura] = [
        Cultura(nombre: "Cultura Inca", region: "Cusco y región andina del Perú.",
                descripcion: "La cultura inca construyó el Tahuantinsuyo, uno de los imperios más extensos de América. Destacó por su organización, arquitectura y conocimientos agrícolas.",
                nombreImagen: "inca", patrimonio: "Machu Picchu",
                temas: TemaCultural.inca),
        Cultura(nombre: "Cultura Nazca", region: "Costa sur del Perú, principalmente Ica.",
                descripcion: "La cultura Nazca destacó por sus misteriosos geoglifos trazados en el desierto, su cerámica policromada y sus sistemas de aprovechamiento del agua.",
                nombreImagen: "nazca", patrimonio: "Líneas de Nazca · El colibrí",
                temas: TemaCultural.nazca),
        Cultura(nombre: "Cultura Moche", region: "Costa norte del Perú.",
                descripcion: "La cultura Moche sobresalió por sus huacos retrato, sus grandes templos de adobe y su avanzada ingeniería hidráulica.",
                nombreImagen: "moche", patrimonio: "Cerámica moche de un guerrero arrodillado",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arte y cerámica", "Legado cultural"].map { TemaCultural(titulo: $0) }),
        Cultura(nombre: "Cultura Chavín", region: "Áncash, sierra norte del Perú.",
                descripcion: "La cultura Chavín fue un importante centro religioso y artístico del antiguo Perú. Destacó por sus templos de piedra y esculturas simbólicas.",
                nombreImagen: "chavin", patrimonio: "Chavín de Huántar",
                temas: ["Descubrimiento", "Origen y desarrollo", "Arquitectura ceremonial", "Arte y religión"].map { TemaCultural(titulo: $0) }),
        Cultura(nombre: "Cultura Paracas", region: "Península de Paracas, Ica.",
                descripcion: "La cultura Paracas destacó por sus extraordinarios mantos textiles, sus prácticas funerarias y sus conocimientos de medicina.",
                nombreImagen: "paracas", patrimonio: "Fragmento de manto · Siglos V–III a. C.",
                temas: ["Descubrimiento", "Origen y desarrollo", "Textilería", "Medicina y prácticas funerarias"].map { TemaCultural(titulo: $0) }),
        Cultura(nombre: "Cultura Chimú", region: "La Libertad, costa norte del Perú.",
                descripcion: "La cultura Chimú desarrolló un poderoso reino en la costa norte. Destacó por la ciudad de Chan Chan, la metalurgia y sus sistemas de irrigación.",
                nombreImagen: "chimu", patrimonio: "Relieves de Chan Chan",
                temas: ["Descubrimiento", "Origen y desarrollo", "Ciudad de Chan Chan", "Arte y metalurgia"].map { TemaCultural(titulo: $0) })
    ]
}

struct DetalleTema {
    let nombreImagen: String
    let descripcion: String
}

struct TemaCultural {
    let titulo: String
    var detalle: DetalleTema? = nil
}

extension TemaCultural {
    static let inca: [TemaCultural] = [
        TemaCultural(titulo: "Descubrimiento", detalle: DetalleTema(
            nombreImagen: "inca_descubrimiento",
            descripcion: """
            Machu Picchu ya era conocido por pobladores locales antes de la expedición de Hiram Bingham de 1911. Con ayuda de habitantes de la zona, el investigador llegó al sitio y documentó sus construcciones. Por ello, su visita debe entenderse como un momento decisivo para su investigación y difusión internacional, no como el primer conocimiento de su existencia.

            Las expediciones posteriores, los registros y las publicaciones despertaron un gran interés por la ciudad inca. Desde entonces, las investigaciones arqueológicas han estudiado sus edificios, terrazas y materiales para comprender cómo se organizaba la vida en este lugar y qué relación mantenía con el poder del Cusco.

            El conocimiento de Machu Picchu sigue ampliándose con nuevos estudios y labores de conservación. Reconocer el papel de las comunidades locales permite contar esta historia de manera más completa y valorar a quienes conocieron y cuidaron su entorno.
            """)),
        TemaCultural(titulo: "Origen y desarrollo", detalle: DetalleTema(
            nombreImagen: "inca_origen",
            descripcion: """
            El poder inca surgió en el valle del Cusco mediante un proceso de alianzas, conflictos y consolidación política. Sus gobernantes integraron conocimientos y prácticas de sociedades andinas anteriores. Durante el siglo XV, especialmente desde el gobierno de Pachacútec, la expansión adquirió una escala mucho mayor.

            El Tahuantinsuyo reunió territorios de distintas regiones de los Andes. Se organizaba en cuatro grandes suyos vinculados con Cusco, su centro político y ceremonial. El Inca encabezaba el gobierno, mientras autoridades y administradores articulaban el poder estatal con los curacas y las comunidades locales.

            La administración se apoyaba en caminos, depósitos y registros mediante quipus. Las prestaciones de trabajo, como la mit’a, contribuían a construir obras, cultivar tierras y sostener actividades estatales. Esta organización integró poblaciones diversas, aunque también implicó conquistas, obligaciones y resistencias.
            """)),
        TemaCultural(titulo: "Arquitectura", detalle: DetalleTema(
            nombreImagen: "inca_arquitectura",
            descripcion: """
            La arquitectura inca destacó por su adaptación al paisaje y por el trabajo especializado de la piedra. En edificios de especial importancia, los bloques eran tallados y ajustados cuidadosamente, a menudo sin mortero. También se emplearon técnicas más sencillas con piedras menos trabajadas y otros materiales según la función de la construcción y los recursos disponibles.

            Los muros con ligera inclinación y los vanos trapezoidales son rasgos frecuentes de sus obras. En Sacsayhuamán sobresalen los enormes bloques ensamblados, mientras que Machu Picchu combina recintos, escalinatas, canales y espacios ceremoniales con la forma de la montaña. Estas construcciones muestran planificación y una notable coordinación del trabajo.

            Los andenes o terrazas agrícolas permitían aprovechar las laderas, retener suelo y manejar el agua. Sus rellenos y sistemas de drenaje ayudaban a estabilizar el terreno. La arquitectura y la ingeniería agrícola formaban parte de una misma manera de habitar y transformar el ambiente andino.
            """)),
        TemaCultural(titulo: "Legado cultural", detalle: DetalleTema(
            nombreImagen: "inca_legado",
            descripcion: """
            Los incas desarrollaron un amplio sistema de administración que utilizaba quipus: conjuntos de cuerdas y nudos empleados para registrar información, especialmente cantidades. Su interpretación estaba a cargo de especialistas. Aunque se investigan posibles usos adicionales, no todos los aspectos de estos registros se comprenden actualmente.

            El Qhapaq Ñan articuló una extensa red de caminos, muchos de ellos construidos sobre rutas anteriores. Facilitaba el desplazamiento de personas, mensajes y bienes entre regiones. Los conocimientos agrícolas, el manejo de distintos pisos ecológicos y los textiles de gran calidad también fueron fundamentales para la economía y la vida social.

            En comunidades andinas continúan lenguas, técnicas textiles, prácticas agrícolas y formas de trabajo colectivo relacionadas con una larga historia en la que participó la sociedad inca. Estas tradiciones han cambiado con el tiempo y dialogan con otras influencias. Su permanencia expresa un patrimonio vivo, diverso y en constante transformación.
            """)),
    ]
    static let nazca: [TemaCultural] = [
        TemaCultural(titulo: "Descubrimiento", detalle: DetalleTema(
            nombreImagen: "nazca_descubrimiento",
            descripcion: """
            El conocimiento arqueológico de Nazca se construyó mediante el estudio de asentamientos, cementerios, cerámicas y geoglifos de la costa sur peruana. Las líneas no eran desconocidas para los habitantes de la región. Las investigaciones modernas aportaron registros y nuevas preguntas sobre su antigüedad y su relación con el paisaje.

            Toribio Mejía Xesspe estudió los trazos del desierto y contribuyó a su interpretación arqueológica. María Reiche dedicó décadas a medir, registrar y proteger las líneas, además de impulsar su difusión. Sus aportes fueron importantes para el estudio y la conservación, sin que ello signifique que fueran las primeras personas en conocerlas.

            Actualmente se combinan recorridos de campo, excavaciones y herramientas de registro a distancia para investigar los geoglifos. El análisis de su relación con caminos, lugares ceremoniales y otros vestigios permite revisar las interpretaciones y comprender mejor la sociedad que los produjo.
            """)),
        TemaCultural(titulo: "Origen y desarrollo", detalle: DetalleTema(
            nombreImagen: "nazca_origen",
            descripcion: """
            La cultura Nazca se desarrolló en la costa sur del Perú, aproximadamente entre los siglos I y VII d. C. Estuvo vinculada con los valles de Nazca y otras cuencas de la región de Ica. En su formación incorporó tradiciones anteriores, entre ellas las relacionadas con Paracas, y desarrolló expresiones artísticas y ceremoniales propias.

            Cahuachi fue uno de sus principales centros ceremoniales. Sus construcciones de adobe y espacios de reunión permiten estudiar las prácticas rituales y los vínculos entre distintas comunidades. La organización política nazca sigue siendo investigada y no debe suponerse que funcionó como un imperio centralizado semejante al inca.

            La vida en un ambiente desértico exigía aprovechar el agua de los valles y los suelos cultivables. La agricultura y las obras hidráulicas fueron esenciales para sostener a la población. Los cambios ambientales y la disponibilidad de agua influyeron en la ocupación del territorio a lo largo del tiempo.
            """)),
        TemaCultural(titulo: "Arte y cerámica", detalle: DetalleTema(
            nombreImagen: "nazca_ceramica",
            descripcion: """
            La cerámica nazca sobresale por su policromía, es decir, por el uso de varios colores sobre una misma pieza. Sus artesanos elaboraron cuencos, vasos y recipientes con distintas formas, entre ellos botellas de doble pico y asa puente. El acabado de las superficies y la distribución de los diseños muestran un trabajo cuidadoso y especializado.

            Las piezas presentan animales, plantas, personas y seres simbólicos que combinan rasgos humanos y de otras criaturas. Los motivos se trazaban con contornos definidos y zonas de color, utilizando engobes y pigmentos antes de la cocción. Los estilos y las representaciones cambiaron a lo largo de la historia nazca.

            Estas imágenes ayudan a investigar los cultivos, la fauna, los rituales y las creencias de sus comunidades. Sin embargo, no todas las escenas pueden leerse como representaciones literales de la vida cotidiana. Su significado se interpreta comparándolas con otros objetos y con el contexto arqueológico en que aparecen.
            """)),
        TemaCultural(titulo: "Líneas de Nazca", detalle: DetalleTema(
            nombreImagen: "nazca_lineas",
            descripcion: """
            Las Líneas de Nazca son geoglifos: grandes trazos y figuras realizados sobre la superficie del desierto. Para producirlos se retiraron piedras superficiales oscuras y se dejó visible el suelo más claro. La aridez favoreció su conservación, aunque son frágiles frente al tránsito y otras alteraciones del terreno.

            El conjunto incluye líneas rectas, figuras geométricas y representaciones de animales, como aves, una araña y un mono. Los diseños corresponden a distintas etapas y no necesariamente tuvieron una única función. Su ejecución muestra planificación y conocimiento del terreno; no requería observarlos desde una aeronave para poder construirlos.

            Las interpretaciones arqueológicas proponen vínculos con recorridos ceremoniales, rituales relacionados con el agua y prácticas sociales o religiosas. También se han planteado alineaciones astronómicas para algunos trazos, pero no existe una explicación astronómica única confirmada para todo el conjunto. La técnica de elaboración puede documentarse, mientras que muchas de sus funciones precisas siguen siendo hipótesis en estudio.
            """)),
    ]
}
