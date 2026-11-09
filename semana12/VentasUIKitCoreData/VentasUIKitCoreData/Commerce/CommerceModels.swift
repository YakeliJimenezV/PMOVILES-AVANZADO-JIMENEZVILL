import CoreData

// Monetary calculations use Decimal; the existing Core Data Double attributes are unchanged.
enum Money {
    static func rounded(_ amount: Decimal) -> Decimal {
        var value = amount, result = Decimal()
        NSDecimalRound(&result, &value, 2, .plain)
        return result
    }
    static func decimal(_ value: Double) -> Decimal { Decimal(string: String(value)) ?? .nan }
    static func double(_ value: Decimal) -> Double { NSDecimalNumber(decimal: value).doubleValue }
    static func text(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_PE")
        formatter.numberStyle = .currency
        formatter.currencyCode = "PEN"
        formatter.currencySymbol = "S/ "
        return formatter.string(from: NSDecimalNumber(decimal: value)) ?? "S/ —"
    }
}

enum ClientTier: String {
    case regular = "Regular", frequent = "Frecuente", vip = "VIP"
    static func classify(_ total: Decimal) -> ClientTier {
        total >= 5000 ? .vip : (total >= 1000 ? .frequent : .regular)
    }
}

struct ClientItem {
    let id: NSManagedObjectID
    let name: String
    let document: String
    let purchased: Decimal
    var tier: ClientTier { ClientTier.classify(purchased) }
}

struct SaleAmounts {
    let subtotal: Decimal
    let discount: Decimal
    let base: Decimal
    let tax: Decimal
    let total: Decimal
    let vip: Bool

    static func calculate(price: Double, quantity: Int64, vip: Bool) throws -> SaleAmounts {
        guard price.isFinite, price > 0, !Money.decimal(price).isNaN else { throw CommerceError.price }
        guard quantity > 0 else { throw CommerceError.quantity }
        let subtotal = Money.rounded(Money.decimal(price) * Decimal(quantity))
        let discount = vip ? Money.rounded(subtotal / 10) : 0
        let base = subtotal - discount
        let tax = Money.rounded(base * Decimal(string: "0.18")!)
        let total = base + tax
        guard !total.isNaN, Money.double(total).isFinite else { throw CommerceError.price }
        return SaleAmounts(subtotal: subtotal, discount: discount, base: base, tax: tax, total: total, vip: vip)
    }
}

struct SaleQuote {
    let client: ClientItem
    let product: ProductItem
    let amounts: SaleAmounts
}

struct SaleItem {
    let id: NSManagedObjectID
    let client: String
    let product: String
    let quantity: Int64
    let date: Date
    let total: Decimal
    let cancelled: Bool
}

struct SaleSummary {
    let total: Decimal
    let count: Int
}

enum SalePeriod: String, CaseIterable {
    case all = "Todas", today = "Hoy", month = "Mes"
    func interval(now: Date, calendar: Calendar) -> DateInterval? {
        switch self {
        case .all: return nil
        case .today: return calendar.dateInterval(of: .day, for: now)
        case .month: return calendar.dateInterval(of: .month, for: now)
        }
    }
}

enum CommerceError: LocalizedError {
    case session, permission, fields, duplicateDocument, associatedSales, missingSelection
    case quantity, stock, price, notFound, persistence, duplicateRequest
    var errorDescription: String? {
        switch self {
        case .session: return "Inicia sesión para continuar."
        case .permission: return "Tu rol no permite realizar esta operación."
        case .fields: return "Completa el nombre y el documento."
        case .duplicateDocument: return "Ya existe un cliente con ese documento."
        case .associatedSales: return "No se puede eliminar el cliente porque tiene ventas asociadas."
        case .missingSelection: return "Selecciona un cliente y un producto."
        case .quantity: return "La cantidad debe ser mayor que cero."
        case .stock: return "No hay stock suficiente para esta cantidad."
        case .price: return "El producto no tiene un precio válido."
        case .notFound: return "El registro ya no está disponible. Actualiza la información."
        case .persistence: return "No se pudieron guardar o consultar los datos. Actualiza e inténtalo nuevamente."
        case .duplicateRequest: return "Esta venta ya fue registrada."
        }
    }
}
