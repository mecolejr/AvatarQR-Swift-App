import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
#if !TESTING
@main
#endif
struct AvatarQRApp: App {
    @StateObject private var preferencesManager = UserPreferencesManager.shared
    @State private var isOnboardingCompleted: Bool
    
    init() {
        _isOnboardingCompleted = State(initialValue: UserPreferencesManager.shared.hasCompletedOnboarding)
    }
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                MainView()
                    .preferredColorScheme(preferencesManager.appTheme.colorScheme)
                    .environmentObject(preferencesManager)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .onDisappear {
                        // Update the preferences manager when onboarding is completed
                        preferencesManager.hasCompletedOnboarding = isOnboardingCompleted
                    }
                    .preferredColorScheme(preferencesManager.appTheme.colorScheme)
                    .environmentObject(preferencesManager)
            }
        }
    }
}

// For older iOS/macOS versions, use ContentView which has better backward compatibility
@available(macOS 10.15, iOS 13.0, macOS 11.0, *)
@available(macOS, deprecated: 11.0)
@available(iOS, deprecated: 14.0)
struct AvatarQRAppLegacy: App {
    @StateObject private var preferencesManager = UserPreferencesManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferencesManager.appTheme.colorScheme)
                .environmentObject(preferencesManager)
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