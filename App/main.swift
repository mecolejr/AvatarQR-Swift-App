import AvatarQRLib
import SwiftUI

// Check if macOS 11.0 or later is available
if #available(macOS 11.0, iOS 14.0, *) {
    AvatarQRApp.main()
} else {
    #if os(macOS)
    // For older macOS versions, use NSApplicationMain
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    #else
    // For older iOS versions, show an error message
    print("This app requires iOS 14.0 or later.")
    exit(1)
    #endif
} 