import UIKit

final class RoleTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        guard let user = SessionManager.shared.currentUser else { return }
        let symbols = ["Productos": "shippingbox", "Clientes": "person.2", "Ventas": "cart",
                       "Mis ventas": "list.bullet.rectangle", "Cuenta": "person.crop.circle", "Resumen": "chart.bar"]
        viewControllers = user.role.tabs.map { title in
            let placeholder: UIViewController
            if title == "Productos" {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsViewController")
            } else if title == "Clientes" {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClientsViewController")
            } else if title == "Ventas" && user.role == .vendedor {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewSaleViewController")
            } else if title == "Mis ventas" && user.role == .vendedor {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MySalesViewController")
            } else if title == "Ventas" && user.role == .supervisor {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TeamSalesViewController")
            } else if title == "Resumen" && user.role == .supervisor {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SupervisorDashboardViewController")
            } else {
                placeholder = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController")
            }
            if title != "Ventas" || user.role != .vendedor { placeholder.title = title }
            let navigation = UINavigationController(rootViewController: placeholder)
            navigation.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: symbols[title] ?? "square"), selectedImage: nil)
            return navigation
        }
        tabBar.tintColor = AuthFormViewController.blue
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}

