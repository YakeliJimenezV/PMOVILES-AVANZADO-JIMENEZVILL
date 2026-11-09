import UIKit
import CoreData

class SupervisorViewController: CommerceViewController {
    lazy var supervisorService = SupervisorService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) { SessionManager.shared.currentUser }
}

final class TeamSalesViewController: SupervisorViewController, UITableViewDataSource, UITableViewDelegate {
    private let period = UISegmentedControl(items: SalePeriod.allCases.map(\.rawValue))
    private let filters = UIStackView()
    private var selectedSeller: NSManagedObjectID?
    private var search: UITextField!
    private let table = UITableView()
    private var sales: [TeamSaleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas del equipo"
        navigationController?.tabBarItem.title = "Ventas"
        period.selectedSegmentIndex = 0
        period.accessibilityIdentifier = "team.period"
        period.addTarget(self, action: #selector(reload), for: .valueChanged)
        content.addArrangedSubview(period)
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        filters.axis = .horizontal
        filters.spacing = 8
        filters.alignment = .center
        filters.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(filters)
        NSLayoutConstraint.activate([
            filters.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor), filters.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            filters.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor), filters.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            filters.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor), scroll.heightAnchor.constraint(equalToConstant: 38)
        ])
        content.addArrangedSubview(scroll)
        search = searchField("Buscar por cliente", id: "team.search", action: #selector(reload))
        content.addArrangedSubview(search)
        configureTable(table)
        table.register(TeamSaleCell.self, forCellReuseIdentifier: "TeamSale")
        table.dataSource = self
        table.delegate = self
        table.accessibilityIdentifier = "team.list"
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        content.addArrangedSubview(table)
        let note = CommerceUI.label("El vendedor se lee de la relación de la venta. Toca o desliza una venta vigente para anularla.", size: 12, color: .secondaryLabel)
        note.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 60)
        table.tableFooterView = note
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            let sellers = try supervisorService.sellers()
            if let selectedSeller, !sellers.contains(where: { $0.id == selectedSeller }) { self.selectedSeller = nil }
            filters.arrangedSubviews.forEach { filters.removeArrangedSubview($0); $0.removeFromSuperview() }
            for seller in [SellerItem?](arrayLiteral: nil) + sellers.map(Optional.some) {
                let button = UIButton(type: .system)
                let selected = seller?.id == selectedSeller
                var configuration = UIButton.Configuration.filled()
                configuration.title = seller?.name ?? "Todos"
                configuration.baseBackgroundColor = selected ? AuthFormViewController.blue : .white
                configuration.baseForegroundColor = selected ? .white : .secondaryLabel
                configuration.cornerStyle = .capsule
                configuration.contentInsets = .init(top: 5, leading: 12, bottom: 5, trailing: 12)
                configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { original in
                    var result = original; result.font = .systemFont(ofSize: 12, weight: .semibold); return result
                }
                button.configuration = configuration
                button.accessibilityTraits = selected ? [.button, .selected] : .button
                button.addAction(UIAction { [weak self] _ in self?.selectedSeller = seller?.id; self?.reload() }, for: .touchUpInside)
                filters.addArrangedSubview(button)
            }
            sales = try supervisorService.sales(period: SalePeriod.allCases[period.selectedSegmentIndex], sellerID: selectedSeller, search: search.text ?? "")
            CommerceUI.empty(table, text: sales.isEmpty ? "No hay ventas para mostrar." : nil)
        } catch {
            sales = []
            filters.arrangedSubviews.forEach { filters.removeArrangedSubview($0); $0.removeFromSuperview() }
            CommerceUI.empty(table, text: error.localizedDescription)
        }
        table.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sales.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSale", for: indexPath) as! TeamSaleCell
        cell.configure(sales[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sale = sales[indexPath.row]
        if sale.cancelled { message(sale.reason ?? "Venta anulada", title: "Motivo de anulación") }
        else { showCancellation(sale) }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sale = sales[indexPath.row]
        guard !sale.cancelled, SessionManager.shared.currentUser?.role == .supervisor else { return nil }
        let action = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, completion in completion(false); self?.showCancellation(sale) }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    private func showCancellation(_ sale: TeamSaleItem) {
        guard SessionManager.shared.currentUser?.role == .supervisor else { return }
        view.endEditing(true)
        let dialog = CancelSaleViewController(sale: sale, service: supervisorService) { [weak self] in self?.reload() }
        dialog.modalPresentationStyle = .overFullScreen
        dialog.modalTransitionStyle = .crossDissolve
        present(dialog, animated: true)
    }
}

private final class TeamSaleCell: UITableViewCell {
    private let icon = CommerceUI.label(size: 13, bold: true, color: .white)
    private let name = CommerceUI.label(size: 14, bold: true)
    private let detail = CommerceUI.label(size: 11, color: .secondaryLabel)
    private let total = CommerceUI.label(size: 14, bold: true)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear; selectionStyle = .none
        icon.textAlignment = .center; icon.layer.cornerRadius = 10; icon.clipsToBounds = true
        icon.widthAnchor.constraint(equalToConstant: 36).isActive = true; icon.heightAnchor.constraint(equalToConstant: 36).isActive = true
        name.numberOfLines = 1; name.lineBreakMode = .byTruncatingTail
        let info = UIStackView(arrangedSubviews: [name, detail]); info.axis = .vertical; info.spacing = 3
        info.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        total.textAlignment = .right; total.adjustsFontSizeToFitWidth = true; total.minimumScaleFactor = 0.7
        total.widthAnchor.constraint(lessThanOrEqualToConstant: 110).isActive = true
        total.setContentCompressionResistancePriority(.required, for: .horizontal)
        let row = CommerceUI.row(icon, info); row.addArrangedSubview(total)
        let card = CommerceUI.card([row]); card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2), card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        isAccessibilityElement = true
    }
    required init?(coder: NSCoder) { fatalError("Use registered cell") }
    func configure(_ sale: TeamSaleItem) {
        name.text = sale.client
        name.textColor = sale.cancelled ? .secondaryLabel : .label
        let formatter = DateFormatter(); formatter.dateStyle = .short
        detail.text = "\(sale.seller) · \(sale.product) × \(sale.quantity) · \(formatter.string(from: sale.date))" + (sale.cancelled ? "\nAnulada" : "")
        detail.textColor = sale.cancelled ? .systemRed : .secondaryLabel
        total.text = Money.text(sale.total)
        icon.text = String(sale.client.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        icon.backgroundColor = sale.cancelled ? .systemRed : .systemPurple
        accessibilityLabel = "\(sale.client), \(detail.text ?? ""), \(Money.text(sale.total)), \(sale.cancelled ? "Anulada" : "Vigente")"
        accessibilityHint = sale.cancelled ? "Toca para consultar el motivo" : "Toca o desliza para anular"
    }
}
