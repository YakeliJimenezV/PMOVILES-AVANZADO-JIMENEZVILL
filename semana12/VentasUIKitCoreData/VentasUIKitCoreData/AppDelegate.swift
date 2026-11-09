import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VentasUIKitCoreData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                NSLog("No se pudo cargar Core Data: %@", error.description)
            }
        }
        let context = container.viewContext
        context.name = "VentasContext"
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSErrorMergePolicy
        return container
    }()

    lazy var authentication = AuthenticationService(container: persistentContainer)

    lazy var persistence = PersistenceRepository(context: persistentContainer.viewContext)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = persistentContainer
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func saveContext() {
        do {
            try persistence.save()
        } catch {
            // Preserve pending changes so the caller can correct validation errors.
            NSLog("No se pudo guardar Core Data: %@", String(describing: error))
        }
    }
}
