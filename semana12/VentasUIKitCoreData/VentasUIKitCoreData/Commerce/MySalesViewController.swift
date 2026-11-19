import UIKit

final class MySalesViewController: CommerceViewController, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet private weak var table: UITableView!
    @IBOutlet private weak var segment: UISegmentedControl!
    @IBOutlet private weak var search: UISearchBar!
    @IBOutlet private weak var todayAmount: UILabel!
    @IBOutlet private weak var monthAmount: UILabel!
    @IBOutlet private weak var todayCount: UILabel!
    @IBOutlet private weak var monthCount: UILabel!

    private var sales: [SaleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchTextField.accessibilityIdentifier = "mysales.search"
        configureTable(table)
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { reload() }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @IBAction private func reload() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MySale", for: indexPath) as! SaleHistoryCell
        cell.configure(sale: sales[indexPath.row])
        return cell
    }
}
