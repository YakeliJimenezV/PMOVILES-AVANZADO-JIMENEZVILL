import UIKit

/// Authentication replaces the window root so Back cannot re-enter the previous session.
final class AuthenticatedRootSegue: UIStoryboardSegue {
    override func perform() {
        guard SessionManager.shared.currentUser != nil, let window = source.view.window else { return }
        window.rootViewController = destination
        window.makeKeyAndVisible()
    }
}

final class RoleTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        tabBar.tintColor = AuthFormViewController.blue
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
