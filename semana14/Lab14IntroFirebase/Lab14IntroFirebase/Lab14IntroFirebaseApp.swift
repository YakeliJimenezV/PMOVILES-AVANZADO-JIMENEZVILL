import FirebaseCore
import SwiftUI

@main
struct Lab14IntroFirebaseApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
