import UIKit

final class ClientsViewController: CommerceViewController, UITableViewDataSource, UITableViewDelegate {
    private let table = UITableView()
    private var search: UITextField!
    private var clients: [ClientItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        addButton(action: #selector(add), id: "clients.add")
        search = searchField("Buscar por nombre o documento", id: "clients.search", action: #selector(reload))
        content.addArrangedSubview(search)
        configureTable(table)
        table.dataSource = self
        table.delegate = self
        table.accessibilityIdentifier = "clients.list"
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        content.addArrangedSubview(table)
        let note = CommerceUI.label("Categoría y comprado se calculan con las ventas no anuladas; no se guardan.", size: 12, color: .secondaryLabel)
        note.textAlignment = .center
        table.tableFooterView = note
        note.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 55)
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            clients = try service.clients(search: search.text ?? "")
            CommerceUI.empty(table, text: clients.isEmpty ? "No hay clientes para mostrar." : nil)
        } catch { clients = []; CommerceUI.empty(table, text: error.localizedDescription) }
        table.reloadData()
    }
    @objc private func add() { edit(nil) }
    private func edit(_ client: ClientItem?) {
        view.endEditing(true)
        let editor = ClientEditorViewController(service: service, client: client) { [weak self] in self?.reload() }
        let navigation = UINavigationController(rootViewController: editor)
        navigation.isModalInPresentation = true
        present(navigation, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clients.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommerceRow", for: indexPath) as! CommerceRowCell
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

private final class ClientEditorViewController: UIViewController, UITextFieldDelegate {
    private let service: CommerceService
    private let client: ClientItem?
    private let onSave: () -> Void
    private let nameField = UITextField()
    private let documentField = UITextField()
    private let errorLabel = CommerceUI.label(size: 13, color: .systemRed)
    init(service: CommerceService, client: ClientItem?, onSave: @escaping () -> Void) {
        self.service = service; self.client = client; self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Use init(service:client:onSave:)") }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        title = client == nil ? "Agregar cliente" : "Editar cliente"
        view.backgroundColor = AuthFormViewController.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "client.save"
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24), stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor), stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        for (title, field, id) in [("Nombre", nameField, "client.name"), ("Documento", documentField, "client.document")] {
            field.placeholder = title
            field.font = .preferredFont(forTextStyle: .body)
            field.accessibilityIdentifier = id
            field.accessibilityLabel = title
            field.autocorrectionType = .no
            field.delegate = self
            stack.addArrangedSubview(CommerceUI.card([CommerceUI.label(title.uppercased(), size: 11, color: .secondaryLabel), field]))
        }
        nameField.text = client?.name
        documentField.text = client?.document
        nameField.returnKeyType = .next
        documentField.returnKeyType = .done
        errorLabel.isHidden = true
        errorLabel.accessibilityIdentifier = "client.error"
        stack.addArrangedSubview(errorLabel)
    }
    @objc private func cancel() { dismiss(animated: true) }
    @objc private func save() {
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
