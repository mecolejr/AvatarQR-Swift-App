import Foundation
import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
class UserPreferencesManager: ObservableObject {
    // Keys for UserDefaults
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastUsedAvatarId = "lastUsedAvatarId"
        static let appTheme = "appTheme"
    }
    
    // Published properties that will update the UI when changed
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        }
    }
    
    @Published var lastUsedAvatarId: String? {
        didSet {
            UserDefaults.standard.set(lastUsedAvatarId, forKey: Keys.lastUsedAvatarId)
        }
    }
    
    @Published var appTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(appTheme.rawValue, forKey: Keys.appTheme)
        }
    }
    
    // Singleton instance
    static let shared = UserPreferencesManager()
    
    // Private initializer for singleton
    private init() {
        // Load values from UserDefaults
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)
        self.lastUsedAvatarId = UserDefaults.standard.string(forKey: Keys.lastUsedAvatarId)
        
        // Load app theme with a default value
        if let themeRawValue = UserDefaults.standard.string(forKey: Keys.appTheme),
           let theme = AppTheme(rawValue: themeRawValue) {
            self.appTheme = theme
        } else {
            self.appTheme = .system
        }
    }
    
    // Reset all preferences (for testing or user-initiated reset)
    func resetAllPreferences() {
        hasCompletedOnboarding = false
        lastUsedAvatarId = nil
        appTheme = .system
    }
}

// App theme options
@available(macOS 10.15, iOS 13.0, *)
enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
