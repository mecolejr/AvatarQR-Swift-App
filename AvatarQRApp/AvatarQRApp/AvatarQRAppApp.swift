import SwiftUI
import AvatarQRLib

@available(iOS 14.0, *)
struct AvatarQRAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// For iOS versions earlier than 14.0, we need to use UIKit's AppDelegate
#if os(iOS)
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use a UIHostingController as window root view controller
        if #available(iOS 14.0, *) {
            // iOS 14 and above will use the SwiftUI App protocol
            return true
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = UIHostingController(rootView: ContentView())
            self.window = window
            window.makeKeyAndVisible()
            return true
        }
    }
}
#endif 