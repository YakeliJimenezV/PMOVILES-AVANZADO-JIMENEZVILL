import UIKit

final class ClientsViewController: CommerceViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var clients: [ClientItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "clients.add"
        searchBar.searchTextField.accessibilityIdentifier = "clients.search"
        table.rowHeight = UITableView.automaticDimension
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { reload() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            clients = try service.clients(search: searchBar.text ?? "")
            CommerceUI.empty(table, text: clients.isEmpty ? "No hay clientes para mostrar." : nil)
        } catch { clients = []; CommerceUI.empty(table, text: error.localizedDescription) }
        table.reloadData()
    }
    @IBAction private func add(_ sender: UIBarButtonItem) { edit(nil) }

    private func edit(_ client: ClientItem?) {
        view.endEditing(true)
        performSegue(withIdentifier: "editClient", sender: client)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "editClient",
              let navigation = segue.destination as? UINavigationController,
              let editor = navigation.topViewController as? ClientEditorViewController else { return }
        navigation.isModalInPresentation = true
        editor.configure(client: sender as? ClientItem) { [weak self] in self?.reload() }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clients.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        cell.configure(client: clients[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { edit(clients[indexPath.row]) }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard service.canDeleteClients else { return nil }
        let client = clients[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, completion in
            completion(false)
            self?.confirmDelete(client)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    private func confirmDelete(_ client: ClientItem) {
        let alert = UIAlertController(title: "Eliminar cliente", message: "¿Eliminar a \(client.name)? Esta acción no se puede deshacer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
            guard let self else { return }
            do { try self.service.deleteClient(id: client.id); self.reload() }
            catch { self.message(error.localizedDescription, title: "No se pudo eliminar") }
        })
        present(alert, animated: true)
    }
}

final class ClientCell: UITableViewCell {
    @IBOutlet private weak var initials: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var documentLabel: UILabel!
    @IBOutlet private weak var purchasedLabel: UILabel!
    @IBOutlet private weak var tierLabel: UILabel!
    @IBOutlet private weak var tierWidth: NSLayoutConstraint!

    func configure(client: ClientItem) {
        nameLabel.text = client.name
        documentLabel.text = client.document
        let purchased = Money.text(client.purchased)
        purchasedLabel.text = purchased
        tierLabel.text = client.tier.rawValue
        tierWidth.constant = ceil(tierLabel.intrinsicContentSize.width) + 14
        let color = CommerceUI.tierColor(client.tier)
        tierLabel.backgroundColor = color
        initials.backgroundColor = color
        initials.text = String(client.name.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        isAccessibilityElement = true
        accessibilityLabel = "\(client.name), \(client.document), comprado \(purchased), \(client.tier.rawValue)"
        accessibilityHint = "Toca para editar"
    }
}

final class ClientEditorViewController: CommerceViewController, UITextFieldDelegate {
    private var client: ClientItem?
    private var onSave: (() -> Void)?
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var documentField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var formScroll: UIScrollView!

    func configure(client: ClientItem?, onSave: @escaping () -> Void) {
        self.client = client
        self.onSave = onSave
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = client == nil ? "Agregar cliente" : "Editar cliente"
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "client.save"
        formScroll.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        nameField.text = client?.name
        documentField.text = client?.document
    }

    @IBAction private func cancel(_ sender: UIBarButtonItem) { dismiss(animated: true) }
    @IBAction private func save() {
        do {
            try service.saveClient(id: client?.id, name: nameField.text ?? "", document: documentField.text ?? "")
            dismiss(animated: true, completion: onSave)
        } catch { errorLabel.text = error.localizedDescription; errorLabel.isHidden = false }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameField { documentField.becomeFirstResponder() } else { save() }
        return true
    }
}
