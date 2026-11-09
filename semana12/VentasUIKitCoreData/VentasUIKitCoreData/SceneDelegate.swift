import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func showAuthenticatedContent() {
        guard SessionManager.shared.currentUser != nil else { return }
        window?.rootViewController = RoleTabBarController()
        window?.makeKeyAndVisible()
    }

    /// Replace the entire protected hierarchy, including old navigation stacks.
    /// Core Data is deliberately untouched: logout only ends the in-memory session.
    func logout() {
        SessionManager.shared.end()
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
