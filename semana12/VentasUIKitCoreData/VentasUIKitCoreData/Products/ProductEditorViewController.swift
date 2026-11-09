import UIKit

final class ProductEditorViewController: UIViewController, UITextFieldDelegate {
    private let service: ProductService
    private let product: ProductItem?
    private let onSave: () -> Void
    private let nameField = UITextField()
    private let categoryField = UITextField()
    private let priceField = UITextField()
    private let stockField = UITextField()
    private let errorLabel = UILabel()

    init(service: ProductService, product: ProductItem?, onSave: @escaping () -> Void) {
        self.service = service
        self.product = product
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Use init(service:product:onSave:)") }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        title = product == nil ? "Agregar producto" : "Editar producto"
        view.backgroundColor = AuthFormViewController.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "product.save"
        navigationItem.rightBarButtonItem?.isEnabled = service.canManage
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        for (title, field, id) in [("Nombre", nameField, "name"), ("Categoría", categoryField, "category"), ("Precio (S/)", priceField, "price"), ("Stock", stockField, "stock")] {
            let label = UILabel()
            label.text = title.uppercased()
            label.font = .systemFont(ofSize: 11, weight: .semibold)
            label.textColor = .secondaryLabel
            field.font = .preferredFont(forTextStyle: .body)
            field.adjustsFontForContentSizeCategory = true
            field.placeholder = title
            field.accessibilityLabel = title
            field.accessibilityIdentifier = "product.\(id)"
            field.delegate = self
            field.returnKeyType = .next
            let box = UIStackView(arrangedSubviews: [label, field])
            box.axis = .vertical
            box.spacing = 6
            box.backgroundColor = .white
            box.layer.cornerRadius = 13
            box.isLayoutMarginsRelativeArrangement = true
            box.directionalLayoutMargins = .init(top: 12, leading: 14, bottom: 12, trailing: 14)
            stack.addArrangedSubview(box)
        }
        priceField.keyboardType = .decimalPad
        stockField.keyboardType = .numberPad
        nameField.autocapitalizationType = .sentences
        categoryField.autocapitalizationType = .words
        nameField.text = product?.name
        categoryField.text = product?.category
        if let product {
            priceField.text = String(product.price)
            stockField.text = String(product.stock)
        }
        errorLabel.textColor = .systemRed
        errorLabel.font = .preferredFont(forTextStyle: .footnote)
        errorLabel.numberOfLines = 0
        errorLabel.accessibilityIdentifier = "product.error"
        errorLabel.isHidden = true
        stack.addArrangedSubview(errorLabel)
        let note = UILabel()
        note.text = "Precio mayor que cero. Stock entero no negativo."
        note.font = .preferredFont(forTextStyle: .footnote)
        note.textColor = .secondaryLabel
        note.numberOfLines = 0
        stack.addArrangedSubview(note)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(systemItem: .flexibleSpace), UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(endEditing))]
        [nameField, categoryField, priceField, stockField].forEach { $0.inputAccessoryView = toolbar }
    }

    @objc private func endEditing() { view.endEditing(true) }
    @objc private func cancel() { dismiss(animated: true) }
    @objc private func save() {
        do {
            let text = (priceField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
            guard let price = Double(text) else { throw ProductError.invalidPrice }
            guard let stock = Int64((stockField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)) else { throw ProductError.invalidStock }
            try service.save(id: product?.id, name: nameField.text ?? "", category: categoryField.text ?? "", price: price, stock: stock)
            dismiss(animated: true, completion: onSave)
        } catch {
            errorLabel.text = error.localizedDescription
            errorLabel.isHidden = false
            UIAccessibility.post(notification: .announcement, argument: errorLabel.text)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields = [nameField, categoryField, priceField, stockField]
        if let index = fields.firstIndex(of: textField), index + 1 < fields.count { fields[index + 1].becomeFirstResponder() }
        else { textField.resignFirstResponder() }
        return true
    }
}
