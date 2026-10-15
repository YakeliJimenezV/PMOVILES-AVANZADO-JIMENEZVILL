import UIKit

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!

    private let culturas = Cultura.todas

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Culturas"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Crema")
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "Granate")!]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor(named: "Granate")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 170
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CulturaTableViewCell.reuseIdentifier,
                                                      for: indexPath) as? CulturaTableViewCell else {
            preconditionFailure("Revisar la clase de la celda en Main.storyboard")
        }
        cell.configurar(con: culturas[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "mostrarDetalle", sender: culturas[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "mostrarDetalle",
              let detalle = segue.destination as? DetalleCulturaViewController,
              let cultura = sender as? Cultura else { return }
        detalle.cultura = cultura
    }
}
