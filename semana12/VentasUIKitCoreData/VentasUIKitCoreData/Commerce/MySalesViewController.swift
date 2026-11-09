import UIKit

final class MySalesViewController: CommerceViewController, UITableViewDataSource {
    private let table = UITableView()
    private let segment = UISegmentedControl(items: SalePeriod.allCases.map(\.rawValue))
    private var search: UITextField!
    private var sales: [SaleItem] = []
    private let todayAmount = CommerceUI.label(size: 21, bold: true)
    private let monthAmount = CommerceUI.label(size: 21, bold: true)
    private let todayCount = CommerceUI.label(size: 12, color: .secondaryLabel)
    private let monthCount = CommerceUI.label(size: 12, color: .secondaryLabel)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis ventas"
        let today = CommerceUI.card([CommerceUI.label("Hoy", size: 12, color: .secondaryLabel), todayAmount, todayCount], spacing: 4)
        let month = CommerceUI.card([CommerceUI.label("Mes", size: 12, color: .secondaryLabel), monthAmount, monthCount], spacing: 4)
        let cards = UIStackView(arrangedSubviews: [today, month])
        cards.axis = .horizontal
        cards.spacing = 10
        cards.distribution = .fillEqually
        content.addArrangedSubview(cards)
        todayAmount.accessibilityIdentifier = "mysales.todayTotal"
        monthAmount.accessibilityIdentifier = "mysales.monthTotal"
        segment.selectedSegmentIndex = 0
        segment.accessibilityIdentifier = "mysales.period"
        segment.addTarget(self, action: #selector(reload), for: .valueChanged)
        content.addArrangedSubview(segment)
        search = searchField("Buscar por cliente", id: "mysales.search", action: #selector(reload))
        content.addArrangedSubview(search)
        configureTable(table)
        table.dataSource = self
        table.accessibilityIdentifier = "mysales.list"
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        content.addArrangedSubview(table)
        let note = CommerceUI.label("Solo aparecen las ventas de este vendedor. Las anuladas no se suman.", size: 12, color: .secondaryLabel)
        note.textAlignment = .center
        note.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 50)
        table.tableFooterView = note
    }
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @objc private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            let now = Date()
            let today = try service.summary(period: .today, now: now)
            let month = try service.summary(period: .month, now: now)
            todayAmount.text = Money.text(today.total)
            monthAmount.text = Money.text(month.total)
            todayCount.text = "\(today.count) ventas"
            monthCount.text = "\(month.count) ventas"
            sales = try service.mySales(search: search.text ?? "", period: SalePeriod.allCases[segment.selectedSegmentIndex], now: now)
            CommerceUI.empty(table, text: sales.isEmpty ? "No hay ventas para mostrar." : nil)
        } catch {
            sales = []
            todayAmount.text = "S/ —"; monthAmount.text = "S/ —"
            todayCount.text = ""; monthCount.text = ""
            CommerceUI.empty(table, text: error.localizedDescription)
        }
        table.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sales.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommerceRow", for: indexPath) as! CommerceRowCell
        cell.configure(sale: sales[indexPath.row])
        return cell
    }
}
