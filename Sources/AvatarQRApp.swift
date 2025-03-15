import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
#if !TESTING
@main
#endif
struct AvatarQRApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

// For older iOS/macOS versions, use ContentView which has better backward compatibility
@available(macOS 10.15, iOS 13.0, macOS 11.0, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14.0)
struct AvatarQRAppLegacy: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Alternative entry point for older macOS versions
#if os(macOS) && compiler(>=5.3)
@available(macOS, deprecated: 11.0)
public struct AvatarQRAppLegacyMain {
    public static func main() {
        if #available(macOS 11.0, *) {
            AvatarQRApp.main()
        } else {
            NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
        }
    }
}
#endif 