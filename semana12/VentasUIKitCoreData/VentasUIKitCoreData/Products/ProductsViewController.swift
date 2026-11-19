import UIKit

/// A3 storyboard scene. Queries Core Data whenever search, filter or data changes.
final class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private lazy var service = ProductService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser?.role
    }
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filters: UIStackView!
    @IBOutlet private weak var allCategoriesButton: UIButton!
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var status: UILabel!
    private var selectedCategory: String?
    private var items: [ProductItem] = [] // Query results only; Core Data remains the source of truth.

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "products.add"
        if !service.canManage { navigationItem.rightBarButtonItem = nil }
        searchBar.searchTextField.accessibilityIdentifier = "products.searchField"
        searchBar.searchTextField.accessibilityLabel = "Buscar producto por nombre"
        table.rowHeight = UITableView.automaticDimension
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }

    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            let categories = try service.categories()
            if let selectedCategory, !categories.contains(selectedCategory) { self.selectedCategory = nil }
            renderFilters(categories)
            items = try service.products(search: searchBar.text ?? "", category: selectedCategory)
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
        for button in filters.arrangedSubviews where button !== allCategoriesButton {
            button.removeFromSuperview()
        }
        styleCategory(allCategoriesButton, title: "Todos", selected: selectedCategory == nil)
        for category in categories {
            let button = UIButton(type: .system)
            styleCategory(button, title: category, selected: selectedCategory == category)
            button.accessibilityIdentifier = "products.filter.\(category)"
            button.addAction(UIAction { [weak self] _ in
                self?.selectedCategory = category
                self?.reload()
            }, for: .touchUpInside)
            filters.addArrangedSubview(button)
        }
    }

    private func styleCategory(_ button: UIButton, title: String, selected: Bool) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = selected ? AuthFormViewController.blue : .white
        configuration.baseForegroundColor = selected ? .white : .secondaryLabel
        configuration.cornerStyle = .capsule
        configuration.contentInsets = .init(top: 6, leading: 14, bottom: 6, trailing: 14)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .systemFont(ofSize: 13, weight: .semibold)
            return attributes
        }
        button.configuration = configuration
        button.accessibilityTraits = selected ? [.button, .selected] : .button
    }

    @IBAction private func showAllCategories(_ sender: UIButton) {
        selectedCategory = nil
        reload()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { reload() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
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
    @IBAction private func add(_ sender: UIBarButtonItem) { edit(nil) }

    private func edit(_ product: ProductItem?) {
        guard service.canManage else { return }
        view.endEditing(true)
        performSegue(withIdentifier: "editProduct", sender: product)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editProduct",
              let navigation = segue.destination as? UINavigationController,
              let editor = navigation.topViewController as? ProductEditorViewController else { return }
        navigation.isModalInPresentation = true
        editor.configure(service: service, product: sender as? ProductItem) { [weak self] in self?.reload() }
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
