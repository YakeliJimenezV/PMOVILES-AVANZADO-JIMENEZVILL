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
    private let clientButton = UIButton(type: .system)
    private let productButton = UIButton(type: .system)
    private let quantityLabel = CommerceUI.label("1", bold: true)
    private let stockLabel = CommerceUI.label("Cantidad", size: 14, bold: true)
    private let minus = UIButton(type: .system)
    private let plus = UIButton(type: .system)
    private let submit = UIButton(type: .system)
    private let errorLabel = CommerceUI.label(size: 13, color: .systemRed)
    private let subtotalLabel = CommerceUI.label()
    private let discountLabel = CommerceUI.label()
    private let taxLabel = CommerceUI.label()
    private let totalLabel = CommerceUI.label(bold: true)
    private let discountTitle = CommerceUI.label("Descuento VIP 10 %")
    private let sellerLabel = CommerceUI.label(size: 13, bold: true, color: .systemBlue)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nueva venta"
        navigationController?.tabBarItem.title = "Ventas"
        // A5 can scroll on compact iPhones and in landscape.
        content.removeFromSuperview()
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(content)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 8), content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            content.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor), content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        let icon = CommerceUI.label("", bold: true, color: .white)
        icon.textAlignment = .center
        icon.backgroundColor = AuthFormViewController.blue
        icon.layer.cornerRadius = 8
        icon.clipsToBounds = true
        icon.widthAnchor.constraint(equalToConstant: 38).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 38).isActive = true
        if let user = service.session { icon.text = String(user.name.split(separator: " ").prefix(2).compactMap(\.first)).uppercased() }
        let sellerInfo = UIStackView(arrangedSubviews: [sellerLabel, CommerceUI.label("Sesión iniciada · la venta se registra a tu nombre", size: 11, color: .systemBlue)])
        sellerInfo.axis = .vertical
        sellerInfo.spacing = 3
        content.addArrangedSubview(CommerceUI.card([CommerceUI.row(icon, sellerInfo)], color: UIColor(red: 0.88, green: 0.93, blue: 1, alpha: 1)))
        configureSelector(clientButton, title: "Seleccionar cliente ›", id: "sale.client", action: #selector(chooseClient))
        configureSelector(productButton, title: "Seleccionar producto ›", id: "sale.product", action: #selector(chooseProduct))
        quantityLabel.textAlignment = .center
        quantityLabel.accessibilityIdentifier = "sale.quantity"
        minus.setTitle("−", for: .normal)
        plus.setTitle("+", for: .normal)
        minus.accessibilityIdentifier = "sale.minus"
        plus.accessibilityIdentifier = "sale.plus"
        minus.accessibilityLabel = "Disminuir cantidad"
        plus.accessibilityLabel = "Aumentar cantidad"
        minus.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        plus.addTarget(self, action: #selector(increase), for: .touchUpInside)
        let controls = UIStackView(arrangedSubviews: [minus, quantityLabel, plus])
        controls.distribution = .fillEqually
        controls.widthAnchor.constraint(equalToConstant: 110).isActive = true
        controls.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let form = CommerceUI.card([
            CommerceUI.row(CommerceUI.label("Cliente", bold: true), clientButton),
            CommerceUI.row(CommerceUI.label("Producto", bold: true), productButton),
            CommerceUI.row(stockLabel, controls)
        ], spacing: 10)
        content.addArrangedSubview(form)
        content.addArrangedSubview(CommerceUI.label("RESUMEN (CALCULADO)", size: 11, color: .secondaryLabel))
        for label in [subtotalLabel, discountLabel, taxLabel, totalLabel] {
            label.textAlignment = .right
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        totalLabel.accessibilityIdentifier = "sale.total"
        content.addArrangedSubview(CommerceUI.card([
            CommerceUI.row(CommerceUI.label("Subtotal"), subtotalLabel),
            CommerceUI.row(discountTitle, discountLabel),
            CommerceUI.row(CommerceUI.label("IGV 18 %"), taxLabel),
            CommerceUI.row(CommerceUI.label("Total", bold: true), totalLabel)
        ], spacing: 18))
        errorLabel.accessibilityIdentifier = "sale.error"
        errorLabel.isHidden = true
        content.addArrangedSubview(errorLabel)
        submit.setTitle("Registrar venta", for: .normal)
        submit.setTitleColor(.white, for: .normal)
        submit.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        submit.backgroundColor = AuthFormViewController.blue
        submit.layer.cornerRadius = 13
        submit.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submit.accessibilityIdentifier = "sale.submit"
        submit.addTarget(self, action: #selector(register), for: .touchUpInside)
        content.addArrangedSubview(submit)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sellerLabel.text = service.session.map { "\($0.name) · \($0.role.rawValue)" }
        updateQuote()
    }
    private func configureSelector(_ button: UIButton, title: String, id: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.contentHorizontalAlignment = .right
        button.accessibilityIdentifier = id
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    @objc private func chooseClient() {
        do {
            let clients = try service.clients()
            let picker = CommercePickerViewController(title: "Seleccionar cliente", rows: clients.map { ($0.name, "\($0.document) · \($0.tier.rawValue)") }) { [weak self] index in
                self?.clientID = clients[index].id
                self?.clientButton.setTitle(clients[index].name + " ›", for: .normal)
                self?.updateQuote()
            }
            present(UINavigationController(rootViewController: picker), animated: true)
        } catch { message(error.localizedDescription) }
    }
    @objc private func chooseProduct() {
        do {
            let products = try service.products()
            let picker = CommercePickerViewController(title: "Seleccionar producto", rows: products.map { ($0.name, "\(Money.text(Money.decimal($0.price))) · Stock: \($0.stock)") }) { [weak self] index in
                guard let self else { return }
                self.productID = products[index].id
                self.availableStock = products[index].stock
                self.quantity = 1
                self.productButton.setTitle(products[index].name + " ›", for: .normal)
                self.updateQuote()
            }
            present(UINavigationController(rootViewController: picker), animated: true)
        } catch { message(error.localizedDescription) }
    }
    @objc private func decrease() { if quantity > 1 { quantity -= 1 }; updateQuote() }
    @objc private func increase() { if quantity < availableStock { quantity += 1 }; updateQuote() }

    private func updateQuote() {
        quantityLabel.text = String(quantity)
        errorLabel.isHidden = true
        submit.isEnabled = false
        [subtotalLabel, discountLabel, taxLabel, totalLabel].forEach { $0.text = "S/ —" }
        do {
            // Refresh stock even before both selectors have been filled.
            if let productID, let product = try service.products().first(where: { $0.id == productID }) {
                availableStock = product.stock
                productButton.setTitle(product.name + " ›", for: .normal)
            }
            stockLabel.text = "Cantidad (stock: \(availableStock))"
            minus.isEnabled = quantity > 1
            plus.isEnabled = quantity < availableStock
            guard let clientID, let productID else { submit.alpha = 0.55; return }
            let quote = try service.quote(clientID: clientID, productID: productID, quantity: quantity)
            clientButton.setTitle(quote.client.name + " ›", for: .normal)
            subtotalLabel.text = Money.text(quote.amounts.subtotal)
            discountTitle.text = quote.amounts.vip ? "Descuento VIP 10 %" : "Descuento"
            discountLabel.text = "− " + Money.text(quote.amounts.discount)
            taxLabel.text = Money.text(quote.amounts.tax)
            totalLabel.text = Money.text(quote.amounts.total)
            submit.isEnabled = !isSubmitting && !completed
        } catch { errorLabel.text = error.localizedDescription; errorLabel.isHidden = false }
        submit.alpha = submit.isEnabled ? 1 : 0.55
    }
    @objc private func register() {
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

private final class CommercePickerViewController: UITableViewController {
    private let rows: [(String, String)]
    private let onSelect: (Int) -> Void
    init(title: String, rows: [(String, String)], onSelect: @escaping (Int) -> Void) {
        self.rows = rows; self.onSelect = onSelect
        super.init(style: .insetGrouped)
        self.title = title
    }
    required init?(coder: NSCoder) { fatalError("Use init(title:rows:onSelect:)") }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        CommerceUI.empty(tableView, text: rows.isEmpty ? "No hay registros. Agrégalos desde su pestaña." : nil)
    }
    @objc private func cancel() { dismiss(animated: true) }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = rows[indexPath.row].0
        cell.detailTextLabel?.text = rows[indexPath.row].1
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        dismiss(animated: true) { self.onSelect(index) }
    }
}
