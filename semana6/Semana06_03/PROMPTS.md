# Contexto
Ejercicio 4 del laboratorio de Programación en Móviles Avanzado: Calculadora de Venta a Plazos de Electrodoméstico, en el proyecto iOS Semana06_03 con Swift, UIKit y Storyboard, correspondiente a la rama ai-assisted.

# Tarea
Implementar Nueva Venta con cinco UITextField y el botón Calcular, y Resultado con seis UILabel. Calcular subtotal, IGV del 18%, base, intereses, total y cuota mensual. Guardar los resultados en VentaModel y pasar el objeto mediante prepare(for:sender:) con el segue Show showResultado.

# Restricciones
Usar únicamente contenidos vistos hasta semana 6: clases, NSObject, UIViewController, UINavigationController, IBOutlet, UITextField, UILabel, Storyboard y segues. No utilizar SwiftUI, Combine, Codable, persistencia, bases de datos, MVVM ni librerías externas. Trabajar únicamente dentro de Semana06_03, sin cambiar de rama ni hacer commit o push.

# Formato
VentaModel.swift contiene una clase que hereda de NSObject con exactamente seis propiedades Double inicializadas en cero. ViewController.swift lee los campos, aplica las fórmulas y entrega el modelo. ResultadoViewController.swift muestra los seis valores usando String(format: "S/. %.2f", valor). Main.storyboard contiene las dos pantallas y un UINavigationController, con sus conexiones y el segue Show desde Calcular.

# Ejemplo
Electrodoméstico = Televisor
Precio unitario = 3500
Cantidad = 1
Meses = 12
Interés mensual = 1

Subtotal = 3500.00
IGV = 630.00
Base = 4130.00
Intereses = 495.60
Total = 4625.60
Cuota = 385.47

# Reflexión
Al desarrollar el ejercicio con ayuda de IA, se siguió la estructura solicitada para crear el modelo, realizar los cálculos y pasar los datos entre las dos pantallas mediante prepare(for:sender:). Una diferencia fue que los cálculos se realizaron directamente dentro de prepare(for:sender:), aprovechando que el botón Calcular ejecuta el segue hacia la pantalla de resultados.
Para VentaModel se utilizó una class porque permite trabajar con un objeto por referencia y seguir el patrón visto en clase con NSObject. Un struct trabaja por valor y no puede heredar de NSObject, por lo que se mantuvo class para este ejercicio.
