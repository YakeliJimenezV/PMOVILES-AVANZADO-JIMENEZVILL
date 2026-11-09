# Ventas Tecsup

Ventas Tecsup es una aplicación iOS para gestionar productos, clientes y ventas. Desarrollada para el **Grupo A – Caso Ventas**, organiza el trabajo diario del vendedor y ofrece al supervisor una vista del equipo, sus resultados y el inventario.

El objetivo del proyecto es integrar una interfaz con navegación por roles y persistencia local, manteniendo consistentes las ventas, el stock y los reportes.

## Tecnologías

- **Swift** como lenguaje de programación.
- **UIKit** y **Storyboard** para las interfaces y la navegación.
- **Core Data** para almacenar usuarios, productos, clientes y ventas.
- **Auto Layout** para adaptar las interfaces al tamaño del dispositivo.
- Gráfico de ventas dibujado con UIKit, sin dependencias externas.

Los datos permanecen en el dispositivo. La aplicación no requiere un servidor ni instalación de paquetes adicionales.

## Funcionalidades por rol

### Vendedor

- Consultar productos, buscar por nombre y filtrar por categoría.
- Revisar precios y disponibilidad de stock.
- Registrar, editar y buscar clientes por nombre o documento.
- Registrar ventas con el usuario conectado como vendedor.
- Consultar únicamente sus propias ventas, con búsqueda por cliente y filtros Todas, Hoy y Mes.
- Revisar los totales válidos del día y del mes.
- Consultar su cuenta y cerrar sesión.

El vendedor no puede crear, editar o eliminar productos, eliminar clientes ni acceder a las operaciones de supervisión.

### Supervisor

- Registrar, editar, buscar y eliminar productos cuando sus relaciones lo permitan.
- Registrar, editar y consultar clientes; eliminarlos si no tienen ventas asociadas.
- Consultar las ventas del equipo y filtrar por fecha, vendedor y cliente.
- Anular ventas vigentes con motivo obligatorio y restitución de stock.
- Consultar vendido hoy, IGV del mes, ventas de los últimos siete días, ranking mensual de vendedores y productos con stock bajo.
- Consultar su cuenta y cerrar sesión.

## Pantallas y navegación

| Pantalla | Contenido | Acceso |
| --- | --- | --- |
| A1 – Inicio de sesión | Validación de credenciales guardadas en Core Data. | Sin sesión |
| A2 – Crear cuenta | Registro con nombre, usuario único, clave y rol. | Sin sesión |
| A3 – Productos | Listado, búsqueda, categorías, precio y stock. | Ambos roles; gestión exclusiva del Supervisor |
| A4 – Clientes | Registro, edición, búsqueda y clasificación por compras. | Ambos roles; eliminación exclusiva del Supervisor |
| A5 – Nueva venta | Selección de cliente y producto, cantidad y cálculo de importes. | Vendedor |
| A6 – Mis ventas | Ventas del usuario conectado y resúmenes por período. | Vendedor |
| A7 – Ventas del equipo | Consulta del equipo y filtros combinados. | Supervisor |
| A8 – Anular venta | Ventana modal con motivo y confirmación de anulación. | Supervisor, desde A7 |
| A9 – Resumen | Dashboard de ventas, IGV, ranking y stock bajo. | Supervisor |
| Mi cuenta | Iniciales, nombre, usuario, rol y cierre de sesión. | Ambos roles |

La barra del **Vendedor** contiene Productos, Clientes, Ventas, Mis ventas y Cuenta. La del **Supervisor** contiene Resumen, Ventas, Productos, Clientes y Cuenta. La pestaña Ventas abre Nueva venta para el Vendedor y Ventas del equipo para el Supervisor.

## Reglas de negocio

### Clientes

Las compras acumuladas se calculan sumando el total de las ventas **no anuladas** del cliente, incluyendo las registradas por distintos vendedores. La categoría se determina al consultar los datos; no se guarda como un atributo adicional.

| Categoría | Compras acumuladas |
| --- | --- |
| Regular | Menos de S/ 1,000.00 |
| Frecuente | Desde S/ 1,000.00 hasta menos de S/ 5,000.00 |
| VIP | Desde S/ 5,000.00 |

El nombre y documento son obligatorios. No se permiten documentos duplicados, sin distinguir mayúsculas y minúsculas ni espacios en los extremos.

### Ventas e importes

- La cantidad debe ser un entero mayor que cero y no superar el stock disponible.
- El precio se obtiene del producto y queda guardado en la venta como precio unitario histórico.
- **Subtotal:** precio unitario × cantidad.
- **Descuento VIP:** 10 % del subtotal cuando el cliente es VIP al registrar la venta.
- **Base:** subtotal − descuento.
- **IGV:** 18 % de la base después del descuento.
- **Total:** base + IGV.

Los cálculos monetarios utilizan `Decimal` y redondeo a dos decimales. La venta y la disminución de stock se guardan juntas en una única operación de Core Data. El formulario bloquea pulsaciones repetidas durante el registro.

### Stock y anulación

Los productos requieren nombre, categoría, precio mayor que cero y stock entero no negativo. En el listado, el stock se muestra en verde por encima de 10 unidades, naranja de 1 a 10 y rojo en cero. El dashboard alerta específicamente sobre productos con **5 unidades o menos**.

Solo el Supervisor puede anular una venta. Debe indicar un motivo y se devuelve exactamente la cantidad vendida al producto correspondiente. La anulación y la devolución de stock se guardan juntas; una venta no puede anularse dos veces.

La venta anulada conserva su fecha, relaciones, importes y motivo como historial. Permanece visible, pero queda fuera de compras acumuladas, totales válidos, IGV y ranking.

Las relaciones inversas y reglas **Deny** de Core Data impiden eliminar usuarios, productos o clientes con ventas asociadas, incluso si esas ventas están anuladas.

### Cuentas y sesión

El registro requiere un usuario único sin distinguir mayúsculas, clave de al menos seis caracteres y confirmación coincidente. Una cuenta nueva inicia sesión automáticamente con las pestañas de su rol.

La sesión se mantiene en memoria mientras la aplicación está abierta. Cerrar sesión requiere confirmación y regresa a un inicio de sesión limpio, conservando los registros. Al cerrar completamente la aplicación será necesario iniciar sesión nuevamente.

## Abrir y ejecutar en Xcode

### Requisitos

- macOS con **Xcode 26 o posterior**. El proyecto se ha compilado con Xcode 26.3.
- Un simulador de iPhone instalado y compatible con Xcode, o un iPhone con **iOS 16 o posterior**.

### Pasos

1. Descargar el repositorio y abrir la carpeta `semana12/VentasUIKitCoreData`.
2. Abrir **`VentasUIKitCoreData.xcodeproj`**.
3. Seleccionar el esquema **VentasUIKitCoreData** y un iPhone Simulator como destino.
4. Compilar con **⌘B** y ejecutar con **⌘R**.

No se requiere instalar dependencias. Para usar un dispositivo físico, seleccionar un equipo de desarrollo en **Signing & Capabilities** y ajustar el identificador de aplicación si la firma lo requiere.

### Primer uso

La aplicación no incluye cuentas ni productos precargados. Core Data crea su almacenamiento local al iniciar.

1. En Crear cuenta, registrar una cuenta **Supervisor**.
2. Registrar productos y clientes desde sus pestañas.
3. Abrir Cuenta, pulsar Cerrar sesión y confirmar.
4. Crear o iniciar sesión con una cuenta **Vendedor**.
5. Abrir Ventas, elegir cliente y producto, indicar cantidad y registrar.
6. Revisar Mis ventas y, al cambiar nuevamente al Supervisor, consultar Ventas del equipo y Resumen.

### Consultar el modelo Core Data

En el navegador del proyecto, seleccionar `VentasUIKitCoreData.xcdatamodeld`. El editor presenta las entidades **Usuario, Producto, Cliente y Venta**, con sus atributos y relaciones. El paquete incluye el modelo interno y su configuración de versión actual.

## Estructura del proyecto

```text
VentasUIKitCoreData/
├── README.md
├── VentasUIKitCoreData.xcodeproj/
│   └── project.pbxproj
└── VentasUIKitCoreData/
    ├── Account/
    ├── Authentication/
    ├── Commerce/
    ├── Products/
    ├── Supervisor/
    ├── Assets.xcassets/
    ├── Base.lproj/
    ├── VentasUIKitCoreData.xcdatamodeld/
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    ├── ViewController.swift
    ├── PersistenceRepository.swift
    └── Info.plist
```

## Estado actual

La versión base incluye las pantallas **A1–A9**, Mi cuenta, cierre de sesión, persistencia local y un ícono de carrito blanco sobre fondo azul. Mantiene la navegación, los permisos y las reglas de negocio del Grupo A, sin funcionalidades del Grupo B.
