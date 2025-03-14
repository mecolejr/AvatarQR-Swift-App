# AvatarQR Views

This directory contains all the SwiftUI views for the AvatarQR application.

## View Structure

- **ContentView**: The main view of the application, containing the tab navigation.
- **AvatarCustomizationView**: Allows users to customize their avatar's appearance.
- **AvatarPreviewView**: Displays a preview of the current avatar.
- **CameraView**: Provides camera functionality for scanning QR codes.
- **SavedAvatarsView**: Displays a list of saved avatars.
- **AvatarDisplayView**: Displays a single avatar in detail.
- **FacialFeatureSelectionView**: Allows users to select facial features for their avatar.
- **HairstyleSelectionView**: Allows users to select hairstyles for their avatar.
- **AccessorySelectionView**: Allows users to select accessories for their avatar.

## Usage

Each view is designed to be modular and reusable. They all depend on the `AvatarViewModel` for data management.

## Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.3+
- SwiftUI 2.0+ 