import UIKit

// ===== EJERCICIO 1: CONDICIONALES =====

// --- Ejemplo resuelto ---
let nota = 15.0
if nota >= 13.0 {
    print("Aprobado con \(nota)")
} else {
    print("Desaprobado con \(nota)")
}

// TODO 1: Validar si una persona es mayor de edad
let edad = 17
if edad >= 18 {
    print("Es mayor de edad")
} else {
    print("Es menor de edad")
}

// TODO 2: Clasificar una nota con else if
let miNota = 16.0
if miNota >= 18.0 {
    print("Excelente")
} else if miNota >= 15.0 {
    print("Bueno")
} else if miNota >= 13.0 {
    print("Aprobado")
} else {
    print("Desaprobado")
}

// TODO 3: Verificar si un número es positivo, negativo o cero
let numero = -5
if numero > 0 {
    print("El número es positivo")
} else if numero < 0 {
    print("El número es negativo")
} else {
    print("El número es cero")
}

// ===== FIX: CORRECCIÓN DE ERRORES =====

// FIX 1: Sintaxis corregida añadiendo apertura/cierre de llaves adecuadamente
let temperatura = 35
if temperatura >= 30 {
    print("Hace calor")
} else if temperatura > 20 {
    print("Clima agradable")
} else {
    print("Hace frío")
}

// FIX 2: Corrección en la interpolación \(compra - saldo) y llaves del bloque else
let saldo = 100.0
let compra = 150.0
if saldo >= compra {
    print("Compra realizada")
} else {
    print("Saldo insuficiente: te faltan \(compra - saldo)")
}

// FIX 3: Reemplazo del carácter erróneo '|' por '&&', apertura de llaves e interpolación limpia
let hora = 25
if hora >= 0 && hora < 12 {
    print("Buenos días")
} else if hora >= 12 && hora < 18 {
    print("Buenas tardes")
} else if hora >= 18 && hora <= 23 {
    print("Buenas noches")
} else {
    print("Hora inválida")
}





// ===== EJERCICIO 2: SWITCH =====

// --- Ejemplo (ya resuelto): ---
let diaSemana = 3
switch diaSemana {
case 1: print("Lunes")
case 2: print("Martes")
case 3: print("Miércoles")
case 4: print("Jueves")
case 5: print("Viernes")
case 6: print("Sábado")
case 7: print("Domingo")
default: print("Día inválido")
}

// --- TODO 4: Clasificar nota numérica a letra ---
let notaSwitch = 16
switch notaSwitch {
case 18...20: print("Excelente")
case 15...17: print("Bueno")
case 13...14: print("Aprobado")
case 11...12: print("Regular")
case 0...10: print("Desaprobado")
default: print("Nota inválida")
}

// --- TODO 5: Calculadora simple con switch ---
let num1 = 20.0
let num2 = 5.0
let operacion = "+"
switch operacion {
case "+": print("Resultado: \(num1 + num2)")
case "-": print("Resultado: \(num1 - num2)")
case "*": print("Resultado: \(num1 * num2)")
case "/":
    if num2 != 0 {
        print("Resultado: \(num1 / num2)")
    } else {
        print("Error: no se puede dividir entre cero")
    }
default: print("Operación no válida")
}

// --- TODO 6: Categoría de producto por precio ---
let precioProducto = 350.0
switch precioProducto {
case 0..<100: print("Económico")
case 100..<500: print("Medio")
case 500..<1000: print("Premium")
default: print("Lujo")
}


// 2.2 — Predicciones

let mes = 2
switch mes {
case 1, 3, 5, 7, 8, 10, 12: print("31 días")
case 4, 6, 9, 11: print("30 días")
case 2: print("28 o 29 días")
default: print("Mes inválido")
} // PREDICT 4: 28 o 29 días

let letra: Character = "a"
switch letra {
case "a", "e", "i", "o", "u": print("Vocal")
default: print("Consonante")
} // PREDICT 5: Vocal





// ===== EJERCICIO 3: FOR-IN =====

// --- Ejemplo (ya resuelto): ---
for i in 1...5 {
    print("Número: \(i)")
}

// --- TODO 7: Tabla de multiplicar del 7 ---
for i in 1...12 {
    print("7 x \(i) = \(7 * i)")
}

// --- TODO 8: Sumatoria del 1 al 100 ---
var suma = 0
for i in 1...100 {
    suma = suma + i
}
print("La suma del 1 al 100 es: \(suma)")

// --- TODO 9: Calcular el factorial de 8 ---
var factorial = 1
for i in 1...8 {
    factorial = factorial * i
}
print("8! = \(factorial)")

// --- TODO 10: Patrón de asteriscos ---
for i in 1...5 {
    print(String(repeating: "*", count: i))
}


// 3.2 — Corregir bucles

// FIX 4: la condición estaba al revés (i % 2 == 1 imprime IMPARES, no pares)
for i in 1...20 {
    if i % 2 == 0 {
        print(i)
    }
}

// FIX 5: el rango 1...10 cuenta hacia ADELANTE; se usa stride para contar en reversa
for i in stride(from: 10, through: 1, by: -1) {
    print(i)
}

// 3.3 — Predicciones

var total = 0
for i in 1...5 {
    total += i
}
print(total) // PREDICT 6: Valor = 15, Iteraciones = 5

var texto = ""
for _ in 1...3 {
    texto += "Hola "
}
print(texto) // PREDICT 7: "Hola Hola Hola "




// ===== EJERCICIO 4: WHILE =====

// --- Ejemplo (ya resuelto): ---
var contador = 5
while contador > 0 {
    print("Cuenta regresiva: \(contador)")
    contador -= 1
}
print("¡Despegue!")

// --- TODO 11: Ahorro mensual ---
var ahorro = 0.0
var meses = 0
let meta = 2000.0
let ahorroMensual = 150.0
while ahorro < meta {
    ahorro += ahorroMensual
    meses += 1
}
print("Necesita \(meses) meses para juntar S/. \(meta)")

// --- TODO 12: División sucesiva ---
var numeroDivision = 1000.0
var divisiones = 0
while numeroDivision >= 1 {
    numeroDivision = numeroDivision / 2
    divisiones += 1
    print("División \(divisiones): \(numeroDivision)")
}
print("Se dividió \(divisiones) veces")

// --- TODO 13: Validar datos con repeat-while ---
let intento1 = 25
let intento2 = -3
let intento3 = 15

var intentoActual = intento1
var esValido = false
var numIntento = 1
repeat {
    if intentoActual >= 0 && intentoActual <= 20 {
        esValido = true
        print("Nota \(intentoActual) válida en intento \(numIntento)")
    } else {
        print("Nota \(intentoActual) inválida, intento \(numIntento)")
        if numIntento == 1 { intentoActual = intento2 }
        if numIntento == 2 { intentoActual = intento3 }
        numIntento += 1
    }
} while !esValido

// 4.3 — Predicciones

var a = 100
while a > 1 {
    a = a / 3
}
print(a) // PREDICT 8: Valor final = 1, Vueltas = 5

var b = 0
repeat {
    b += 1
} while b < 0
print(b) // PREDICT 9: Valor = 1
