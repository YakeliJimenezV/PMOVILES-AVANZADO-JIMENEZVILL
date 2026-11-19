import UIKit
import CoreData

class SupervisorViewController: CommerceViewController {
    lazy var supervisorService = SupervisorService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) { SessionManager.shared.currentUser }
}

final class TeamSalesViewController: SupervisorViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet private weak var period: UISegmentedControl!
    @IBOutlet private weak var filters: UIStackView!
    @IBOutlet private weak var allSellers: UIButton!
    @IBOutlet private weak var search: UISearchBar!
    @IBOutlet private weak var table: UITableView!

    private var selectedSeller: NSManagedObjectID?
    private var sales: [TeamSaleItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        search.searchTextField.accessibilityIdentifier = "team.search"
        configureTable(table)
        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { reload() }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { searchBar.resignFirstResponder() }

    @IBAction private func selectAllSellers(_ sender: UIButton) {
        selectedSeller = nil
        reload()
    }

    private func updateFilters(_ sellers: [SellerItem]) {
        for button in filters.arrangedSubviews where button !== allSellers { button.removeFromSuperview() }
        styleSellerButton(allSellers, title: "Todos", selected: selectedSeller == nil)
        for seller in sellers {
            let button = UIButton(type: .system)
            styleSellerButton(button, title: seller.name, selected: seller.id == selectedSeller)
            button.addAction(UIAction { [weak self] _ in
                self?.selectedSeller = seller.id
                self?.reload()
            }, for: .touchUpInside)
            filters.addArrangedSubview(button)
        }
    }

    private func styleSellerButton(_ button: UIButton, title: String, selected: Bool) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = selected ? AuthFormViewController.blue : .white
        configuration.baseForegroundColor = selected ? .white : .secondaryLabel
        configuration.cornerStyle = .capsule
        configuration.contentInsets = .init(top: 5, leading: 12, bottom: 5, trailing: 12)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { original in
            var result = original
            result.font = .systemFont(ofSize: 12, weight: .semibold)
            return result
        }
        button.configuration = configuration
        button.accessibilityTraits = selected ? [.button, .selected] : .button
    }

    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated); reload() }
    @IBAction private func reload() {
        defer { table.refreshControl?.endRefreshing() }
        do {
            let sellers = try supervisorService.sellers()
            if let selectedSeller, !sellers.contains(where: { $0.id == selectedSeller }) { self.selectedSeller = nil }
            updateFilters(sellers)
            sales = try supervisorService.sales(period: SalePeriod.allCases[period.selectedSegmentIndex], sellerID: selectedSeller, search: search.text ?? "")
            CommerceUI.empty(table, text: sales.isEmpty ? "No hay ventas para mostrar." : nil)
        } catch {
            sales = []
            updateFilters([])
            CommerceUI.empty(table, text: error.localizedDescription)
        }
        table.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sales.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSale", for: indexPath) as! SaleHistoryCell
        cell.configure(teamSale: sales[indexPath.row])
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
        performSegue(withIdentifier: "cancelTeamSale", sender: sale)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "cancelTeamSale",
              let dialog = segue.destination as? CancelSaleViewController,
              let sale = sender as? TeamSaleItem else { return }
        dialog.configure(sale: sale, service: supervisorService) { [weak self] in self?.reload() }
    }
}
