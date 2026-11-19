import UIKit

final class ProductEditorViewController: UIViewController, UITextFieldDelegate {
    private var service: ProductService!
    private var product: ProductItem?
    private var onSave: (() -> Void)?
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var categoryField: UITextField!
    @IBOutlet private weak var priceField: UITextField!
    @IBOutlet private weak var stockField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var formScroll: UIScrollView!

    func configure(service: ProductService, product: ProductItem?, onSave: @escaping () -> Void) {
        self.service = service
        self.product = product
        self.onSave = onSave
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        title = product == nil ? "Agregar producto" : "Editar producto"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "product.save"
        navigationItem.rightBarButtonItem?.isEnabled = service?.canManage == true
        formScroll.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        nameField.text = product?.name
        categoryField.text = product?.category
        if let product {
            priceField.text = String(product.price)
            stockField.text = String(product.stock)
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [UIBarButtonItem(systemItem: .flexibleSpace), UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(endEditing))]
        let fields: [UITextField] = [nameField, categoryField, priceField, stockField]
        for field in fields { field.inputAccessoryView = toolbar }
    }

    @objc private func endEditing() { view.endEditing(true) }
    @IBAction private func cancel(_ sender: UIBarButtonItem) { dismiss(animated: true) }
    @IBAction private func save(_ sender: UIBarButtonItem) {
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
        let fields: [UITextField] = [nameField, categoryField, priceField, stockField]
        if let index = fields.firstIndex(of: textField), index + 1 < fields.count { fields[index + 1].becomeFirstResponder() }
        else { textField.resignFirstResponder() }
        return true
    }
}
