import UIKit
import CoreData

final class NewSaleViewController: CommerceViewController {
    private var clientID: NSManagedObjectID?
    private var productID: NSManagedObjectID?
    private var quantity: Int64 = 1
    private var availableStock: Int64 = 0
    private var requestID = UUID()
    private var isSubmitting = false
    private var completed = false
    @IBOutlet private weak var clientButton: UIButton!
    @IBOutlet private weak var productButton: UIButton!
    @IBOutlet private weak var minus: UIButton!
    @IBOutlet private weak var plus: UIButton!
    @IBOutlet private weak var submit: UIButton!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var unitPriceLabel: UILabel!
    @IBOutlet private weak var subtotalLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var taxLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var discountTitle: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var sellerLabel: UILabel!
    @IBOutlet private weak var sellerInitials: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = service.session {
            sellerLabel.text = "\(user.name) · \(user.role.rawValue)"
            sellerInitials.text = String(user.name.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        }
        updateQuote()
    }

    @IBAction private func chooseClient(_ sender: UIButton) {
        do {
            let clients = try service.clients()
            performSegue(withIdentifier: "selectSaleParty", sender: PickerContent(
                title: "Seleccionar cliente",
                rows: clients.map { ($0.name, "\($0.document) · \($0.tier.rawValue)") },
                onSelect: { [weak self] index in
                    self?.clientID = clients[index].id
                    self?.clientButton.setTitle(clients[index].name + " ›", for: .normal)
                    self?.updateQuote()
                }))
        } catch { message(error.localizedDescription) }
    }

    @IBAction private func chooseProduct(_ sender: UIButton) {
        do {
            let products = try service.products()
            performSegue(withIdentifier: "selectSaleParty", sender: PickerContent(
                title: "Seleccionar producto",
                rows: products.map { ($0.name, "\(Money.text(Money.decimal($0.price))) · Stock: \($0.stock)") },
                onSelect: { [weak self] index in
                    guard let self else { return }
                    self.productID = products[index].id
                    self.quantity = 1
                    self.updateQuote()
                }))
        } catch { message(error.localizedDescription) }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "selectSaleParty",
              let navigation = segue.destination as? UINavigationController,
              let picker = navigation.topViewController as? CommercePickerViewController,
              let content = sender as? PickerContent else { return }
        picker.content = content
    }

    @IBAction private func decrease(_ sender: UIButton) {
        if quantity > 1 { quantity -= 1 }
        updateQuote()
    }

    @IBAction private func increase(_ sender: UIButton) {
        if quantity < availableStock { quantity += 1 }
        updateQuote()
    }

    private func updateQuote() {
        defer {
            stockLabel.text = "Cantidad (stock: \(availableStock))"
            minus.isEnabled = quantity > 1
            plus.isEnabled = quantity < availableStock
            submit.alpha = submit.isEnabled ? 1 : 0.55
        }
        quantityLabel.text = String(quantity)
        errorLabel.isHidden = true
        submit.isEnabled = false
        for label in [unitPriceLabel, subtotalLabel, discountLabel, taxLabel, totalLabel] {
            label?.text = "S/ —"
        }
        discountTitle.text = "Descuento"
        availableStock = 0
        do {
            if let productID {
                guard let product = try service.products().first(where: { $0.id == productID }) else {
                    self.productID = nil
                    quantity = 1
                    quantityLabel.text = "1"
                    productButton.setTitle("Seleccionar producto ›", for: .normal)
                    throw CommerceError.notFound
                }
                availableStock = product.stock
                unitPriceLabel.text = Money.text(Money.decimal(product.price))
                productButton.setTitle(product.name + " ›", for: .normal)
            }
            guard let clientID, let productID else { return }
            let quote = try service.quote(clientID: clientID, productID: productID, quantity: quantity)
            clientButton.setTitle(quote.client.name + " ›", for: .normal)
            subtotalLabel.text = Money.text(quote.amounts.subtotal)
            discountTitle.text = quote.amounts.vip ? "Descuento VIP 10 %" : "Descuento"
            discountLabel.text = "− " + Money.text(quote.amounts.discount)
            taxLabel.text = Money.text(quote.amounts.tax)
            totalLabel.text = Money.text(quote.amounts.total)
            submit.isEnabled = !isSubmitting && !completed
        } catch {
            errorLabel.text = error.localizedDescription
            errorLabel.isHidden = false
        }
    }
    @IBAction private func register(_ sender: UIButton) {
        guard !isSubmitting, !completed else { return }
        guard let clientID, let productID else { message(CommerceError.missingSelection.localizedDescription); return }
        isSubmitting = true
        submit.isEnabled = false
        do {
            let sale = try service.registerSale(clientID: clientID, productID: productID, quantity: quantity, requestID: requestID)
            completed = true
            message("Venta registrada por \(Money.text(sale.total)).", title: "Venta registrada") { [weak self] in
                guard let self else { return }
                self.clientID = nil; self.productID = nil; self.quantity = 1; self.availableStock = 0
                self.requestID = UUID(); self.completed = false; self.isSubmitting = false
                self.clientButton.setTitle("Seleccionar cliente ›", for: .normal)
                self.productButton.setTitle("Seleccionar producto ›", for: .normal)
                self.updateQuote()
            }
        } catch {
            isSubmitting = false
            updateQuote()
            errorLabel.text = error.localizedDescription
            errorLabel.isHidden = false
        }
    }
}

fileprivate struct PickerContent {
    let title: String
    let rows: [(String, String)]
    let onSelect: (Int) -> Void
}

final class CommercePickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var table: UITableView!
    fileprivate var content: PickerContent?

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        navigationItem.title = content?.title
        CommerceUI.empty(table, text: content?.rows.isEmpty == false ? nil : "No hay registros. Agrégalos desde su pestaña.")
    }

    @IBAction private func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content?.rows.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaleChoice", for: indexPath) as! SaleChoiceCell
        if let row = content?.rows[indexPath.row] {
            cell.configure(name: row.0, detail: row.1)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { self.content?.onSelect(indexPath.row) }
    }
}

final class SaleChoiceCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var detail: UILabel!

    func configure(name: String, detail: String) {
        nameLabel.text = name
        self.detail.text = detail
        isAccessibilityElement = true
        accessibilityLabel = "\(name), \(detail)"
    }
}
