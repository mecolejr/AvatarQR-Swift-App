import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
#if !TESTING
@main
#endif
struct AvatarQRApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Alternative entry point for older macOS versions
#if os(macOS) && compiler(>=5.3)
@available(macOS, deprecated: 11.0)
public struct AvatarQRAppLegacy {
    public static func main() {
        if #available(macOS 11.0, *) {
            AvatarQRApp.main()
        } else {
            NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
        }
    }
}
#endif 