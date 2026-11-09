import UIKit

/// A3 storyboard scene. Queries Core Data whenever search, filter or data changes.
final class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private lazy var service = ProductService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser?.role
    }
    private let searchField = UITextField()
    private let filters = UIStackView()
    private let table = UITableView(frame: .zero, style: .plain)
    private let status = UILabel()
    private var selectedCategory: String?
    private var items: [ProductItem] = [] // Query results only; Core Data remains the source of truth.

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        overrideUserInterfaceStyle = .light
        view.backgroundColor = AuthFormViewController.background
        view.tintColor = AuthFormViewController.blue
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AuthFormViewController.background
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        if service.canManage {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "products.add"
            navigationItem.rightBarButtonItem?.tintColor = AuthFormViewController.blue
            if #available(iOS 26.0, *) { navigationItem.rightBarButtonItem?.hidesSharedBackground = true }
        }
        searchField.placeholder = "Buscar producto"
        searchField.font = .systemFont(ofSize: 15)
        searchField.backgroundColor = UIColor(white: 0.89, alpha: 1)
        searchField.layer.cornerRadius = 10
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
        searchField.delegate = self
        searchField.accessibilityLabel = "Buscar producto por nombre"
        searchField.accessibilityIdentifier = "products.searchField"
        searchField.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let searchIconBox = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 36))
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .secondaryLabel
        searchIcon.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
        searchIconBox.addSubview(searchIcon)
        searchField.leftView = searchIconBox
        searchField.leftViewMode = .always
        searchField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        let categoryScroll = UIScrollView()
        categoryScroll.showsHorizontalScrollIndicator = false
        filters.axis = .horizontal
        filters.spacing = 8
        filters.alignment = .center
        filters.translatesAutoresizingMaskIntoConstraints = false
        categoryScroll.addSubview(filters)
        NSLayoutConstraint.activate([
            filters.leadingAnchor.constraint(equalTo: categoryScroll.contentLayoutGuide.leadingAnchor),
            filters.trailingAnchor.constraint(equalTo: categoryScroll.contentLayoutGuide.trailingAnchor),
            filters.topAnchor.constraint(equalTo: categoryScroll.contentLayoutGuide.topAnchor),
            filters.bottomAnchor.constraint(equalTo: categoryScroll.contentLayoutGuide.bottomAnchor),
            filters.heightAnchor.constraint(equalTo: categoryScroll.frameLayoutGuide.heightAnchor),
            categoryScroll.heightAnchor.constraint(equalToConstant: 44)
        ])
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 68
        table.keyboardDismissMode = .onDrag
        table.accessibilityIdentifier = "products.list"
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        status.textColor = .secondaryLabel
        status.font = .preferredFont(forTextStyle: .footnote)
        status.numberOfLines = 0
        status.textAlignment = .center
        status.accessibilityIdentifier = "products.status"
        let stack = UIStackView(arrangedSubviews: [searchField, categoryScroll, status, table])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }

    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            let categories = try service.categories()
            if let selectedCategory, !categories.contains(selectedCategory) { self.selectedCategory = nil }
            renderFilters(categories)
            items = try service.products(search: searchField.text ?? "", category: selectedCategory)
            status.text = items.isEmpty ? "No hay productos para mostrar." : nil
            status.isHidden = !items.isEmpty
            table.reloadData()
        } catch {
            items = []
            table.reloadData()
            status.text = error.localizedDescription + " Desliza hacia abajo para reintentar."
            status.isHidden = false
        }
    }

    private func renderFilters(_ categories: [String]) {
        filters.arrangedSubviews.forEach { filters.removeArrangedSubview($0); $0.removeFromSuperview() }
        for category in [String?](arrayLiteral: nil) + categories.map(Optional.some) {
            let button = UIButton(type: .system)
            let selected = category == selectedCategory
            var configuration = UIButton.Configuration.filled()
            configuration.title = category ?? "Todos"
            configuration.baseBackgroundColor = selected ? AuthFormViewController.blue : .white
            configuration.baseForegroundColor = selected ? .white : .secondaryLabel
            configuration.cornerStyle = .capsule
            configuration.contentInsets = .init(top: 6, leading: 14, bottom: 6, trailing: 14)
            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var attributes = attributes; attributes.font = .systemFont(ofSize: 13, weight: .semibold); return attributes
            }
            button.configuration = configuration
            button.accessibilityIdentifier = "products.filter.\(category ?? "all")"
            button.accessibilityTraits = selected ? [.button, .selected] : .button
            button.addAction(UIAction { [weak self] _ in self?.selectedCategory = category; self?.reload() }, for: .touchUpInside)
            filters.addArrangedSubview(button)
        }
    }

    @objc private func searchChanged() { reload() }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder(); return true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configure(items[indexPath.row], editable: service.canManage)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard service.canManage else { return }
        edit(items[indexPath.row])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard service.canManage else { return nil }
        let product = items[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, completion in
            completion(false)
            self?.confirmDelete(product)
        }
        let edit = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            completion(false)
            self?.edit(product)
        }
        edit.backgroundColor = AuthFormViewController.blue
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    @objc private func add() { edit(nil) }
    private func edit(_ product: ProductItem?) {
        guard service.canManage else { return }
        let editor = ProductEditorViewController(service: service, product: product) { [weak self] in self?.reload() }
        let navigation = UINavigationController(rootViewController: editor)
        navigation.modalPresentationStyle = .pageSheet
        navigation.isModalInPresentation = true
        present(navigation, animated: true)
    }
    private func confirmDelete(_ product: ProductItem) {
        guard service.canManage else { return }
        let alert = UIAlertController(title: "Eliminar producto", message: "¿Deseas eliminar «\(product.name)»? Esta acción no se puede deshacer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self else { return }
            do { try self.service.delete(id: product.id); self.reload() }
            catch {
                let errorAlert = UIAlertController(title: "No se pudo eliminar", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                self.present(errorAlert, animated: true)
            }
        })
        present(alert, animated: true)
    }
}
